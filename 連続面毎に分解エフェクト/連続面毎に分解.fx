// 破片がセルフシャドウを落とす最低アルファ値（フェード時のみ）
#define SHADOW_THRESHOLD 0.1

// 時間停止。1にするとエフェクトの時間が自動で進まなくなります。停止や逆再生用です。
// 1にして崩壊開始Fを動かせば時間を操作できます。
// 1フレームに1ずつマイナス方向に動かせば逆再生ができます。
#define TIME_STOP 0

// 衝撃方向を中心からの向きでなく固定方向に。
// 1にすると「衝撃速度」がXYZ座標の方向ベクトルに変わります。
#define PARALLEL_IMPACT 0


// 各値への乱数
// 数字は1倍からの最大差分になります。0.2だと0.8～1.2倍に、0.7だと0.3～1.7倍に乗算されます

// 衝撃速度ランダム値
#define IMPACT_RND 0.3

// 回転速度ランダム値
#define ROTATE_RND 0.3

// ﾌｪｰﾄﾞ開始Fランダム値
#define FADESTART_RND 0.04

// ﾌｪｰﾄﾞ期間Fランダム値
#define FADESPAN_RND 0.3

// 衝撃方向ランダム値
#define IMPACT_DIR_RND 0.5

// 拡散方向ランダム値
#define SPREAD_DIR_RND 0.2

// 崩壊開始Fランダム値。ランダムで遅れる最大フレーム数です。
#define BREAKSTART_RND 0





// ここから先はエフェクト改造に興味のある人だけ触ってみてください

////////////////////////////////////////////////////////////////////////////////////////////////
// パラメータ宣言

// 座法変換行列
float4x4 WorldViewProjMatrix      : WORLDVIEWPROJECTION;
float4x4 WorldMatrix              : WORLD;
float4x4 ViewMatrix               : VIEW;
float4x4 LightWorldViewProjMatrix : WORLDVIEWPROJECTION < string Object = "Light"; >;

float3   LightDirection    : DIRECTION < string Object = "Light"; >;
float3   CameraPosition    : POSITION  < string Object = "Camera"; >;

// マテリアル色
float4   MaterialDiffuse   : DIFFUSE  < string Object = "Geometry"; >;
float3   MaterialAmbient   : AMBIENT  < string Object = "Geometry"; >;
float3   MaterialEmmisive  : EMISSIVE < string Object = "Geometry"; >;
float3   MaterialSpecular  : SPECULAR < string Object = "Geometry"; >;
float    SpecularPower     : SPECULARPOWER < string Object = "Geometry"; >;
float3   MaterialToon      : TOONCOLOR;
float4   EdgeColor         : EDGECOLOR;
// ライト色
float3   LightDiffuse      : DIFFUSE   < string Object = "Light"; >;
float3   LightAmbient      : AMBIENT   < string Object = "Light"; >;
float3   LightSpecular     : SPECULAR  < string Object = "Light"; >;
static float4 DiffuseColor  = MaterialDiffuse  * float4(LightDiffuse, 1.0f);
static float3 AmbientColor  = saturate(MaterialAmbient  * LightAmbient + MaterialEmmisive);
static float3 SpecularColor = MaterialSpecular * LightSpecular;

bool     parthf;   // パースペクティブフラグ
bool     transp;   // 半透明フラグ
bool	 spadd;    // スフィアマップ加算合成フラグ
#define SKII1    1500
#define SKII2    8000
#define Toon     3

// オブジェクトのテクスチャ
texture ObjectTexture: MATERIALTEXTURE;
sampler ObjTexSampler = sampler_state {
    texture = <ObjectTexture>;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};

// スフィアマップのテクスチャ
texture ObjectSphereMap: MATERIALSPHEREMAP;
sampler ObjSphareSampler = sampler_state {
    texture = <ObjectSphereMap>;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};

// MMD本来のsamplerを上書きしないための記述です。削除不可。
sampler MMDSamp0 : register(s0);
sampler MMDSamp1 : register(s1);
sampler MMDSamp2 : register(s2);




////////////////////////////////////////////////////////////////////////////////////////////////
// 追加のパラメータ宣言

#define BREAK_STATE CULLMODE = NONE;\

#if(TIME_STOP)
float Time =0;
#else
float Time : TIME <bool SyncInEditMode=true;>;
#endif


// 点p1を原点からのベクトルvを軸にr度回転
float3 RotateRoundVector(float3 p1, float3 v, float r){
	float4x4 RotateMatrix = {
		v.x*v.x*(1-cos(r))+cos(r), v.x*v.y*(1-cos(r))-v.z*sin(r), v.z*v.x*(1-cos(r))+v.y*sin(r), 0,
		v.x*v.y*(1-cos(r))+v.z*sin(r), v.y*v.y*(1-cos(r))+cos(r), v.y*v.z*(1-cos(r))-v.x*sin(r), 0,
		v.z*v.x*(1-cos(r))-v.y*sin(r), v.y*v.z*(1-cos(r))+v.x*sin(r), v.z*v.z*(1-cos(r))+cos(r), 0,
		0,0,0,1
	};
	float3 p2 = mul( float4(p1,1), RotateMatrix );
	return p2;
}


//乱数テクスチャ
texture2D rndtex <
    string ResourceName = "random256x256.bmp";
>;
sampler rndsamp : register(s3) = sampler_state {
    texture = <rndtex>;
    FILTER = NONE;
	ADDRESSU = WRAP;
	ADDRESSV = WRAP;
};

#define RND_COEF 1/11

// 乱数の倍率
float rndrate(float rnd,float coif){
 return 1.0f+((rnd-0.5f)*2.0f*coif);
}


// コントローラー読み込み
float4x4 CenterMatrix   : CONTROLOBJECT < string name = "(self)"; string item = "モデル親"; >;
float3 BreakCenter_b    : CONTROLOBJECT < string name = "(self)"; string item = "崩壊中心"; >;
float3 BreakSpeed_b     : CONTROLOBJECT < string name = "(self)"; string item = "崩壊速度"; >;

float3 SpreadSpeed_b    : CONTROLOBJECT < string name = "(self)"; string item = "拡散速度"; >;
float3 ImpactSpeed_b    : CONTROLOBJECT < string name = "(self)"; string item = "衝撃速度"; >;
float3 RotateSpeed_b    : CONTROLOBJECT < string name = "(self)"; string item = "回転速度"; >;
float3 RotateStart_b    : CONTROLOBJECT < string name = "(self)"; string item = "初期回転量"; >;

float3 Gravity_b        : CONTROLOBJECT < string name = "(self)"; string item = "重力ﾍﾞｸﾄﾙ"; >;
float3 BreakFrame_b     : CONTROLOBJECT < string name = "(self)"; string item = "崩壊開始F"; >;
float3 FadeStartFrame_b : CONTROLOBJECT < string name = "(self)"; string item = "ﾌｪｰﾄﾞ開始F"; >;
float3 FadeSpanFrame_b  : CONTROLOBJECT < string name = "(self)"; string item = "ﾌｪｰﾄﾞ期間F"; >;




///////////////////////////////////////////////////////////////////////////////////////////////
// オブジェクト描画（セルフシャドウ共通）

// シャドウバッファのサンプラ。"register(s0)"なのはMMDがs0を使っているから
sampler DefSampler : register(s0);

struct BufferShadow_OUTPUT {
    float4 Pos      : POSITION;     // 射影変換座標
    float4 ZCalcTex : TEXCOORD0;    // Z値
    float2 Tex      : TEXCOORD1;    // テクスチャ
    float3 Normal   : TEXCOORD2;    // 法線
    float3 Eye      : TEXCOORD3;    // カメラとの相対位置
    float2 SpTex    : TEXCOORD4;	 // スフィアマップテクスチャ座標
    float4 Color    : COLOR0;       // ディフューズ色
};

// 頂点シェーダ
BufferShadow_OUTPUT BufferShadow_VS(float4 Pos : POSITION, float3 Normal : NORMAL, float2 Tex : TEXCOORD0, uniform bool useTexture, uniform bool useSphereMap, uniform bool useToon, float4 FaceCenter : TEXCOORD1 )
{
    BufferShadow_OUTPUT Out = (BufferShadow_OUTPUT)0;
	
	float4 Color;
    Color.rgb = AmbientColor;
    Color.a = DiffuseColor.a;
	
// エフェクトでの頂点位置
    Pos = mul( Pos, CenterMatrix );
    Normal = mul( Normal, CenterMatrix );
	
	if( FaceCenter.w>0 ){ //プラグイン実行済みのフラグ
	    FaceCenter.xyz = mul( float4(FaceCenter.xyz,1), CenterMatrix );
		
	// 破壊用の変数
		float u = (FaceCenter.x+FaceCenter.z+FaceCenter.w)*RND_COEF;
		float v = (FaceCenter.x+FaceCenter.y+FaceCenter.w)*RND_COEF;
		float4 rnd1 = tex2Dlod(rndsamp, float4( u, v, 0, 1 ));
		float4 rnd2 = tex2Dlod(rndsamp, float4( u+0.5, v+0.5, 0, 1 ));
		
#if(PARALLEL_IMPACT)
		float3 BreakVector = ImpactSpeed_b *rndrate(rnd1.x,IMPACT_RND);
#else
		float3 BreakVector = normalize( normalize( FaceCenter.xyz -BreakCenter_b ) +(rnd2.xyz-0.5)*2*IMPACT_DIR_RND ) *ImpactSpeed_b.x *rndrate(rnd1.x,IMPACT_RND);
#endif
			
		float3 SpreadVector = BreakVector;
		
		float StartFlame = ( BreakFrame_b.x +(BREAKSTART_RND*rnd2.z) ) /30;
		float Delay;
		float DelayDist = distance(FaceCenter.xyz,BreakCenter_b);
		if(BreakSpeed_b.x!=0){ Delay = DelayDist / BreakSpeed_b.x; }
		else{ Delay=0; }
		float CurrentTime = max( 0, Time -Delay -StartFlame );
		
		float3 RotateVector = normalize( rnd2.xyz-0.5 );
		float RoteteStart = radians(RotateStart_b.x) *(CurrentTime>0);
		float RotateSpeed = radians(RotateSpeed_b.x) *rndrate(rnd1.z,ROTATE_RND);
		
		float FadeStart = FadeStartFrame_b.x /30 *rndrate(rnd2.x,FADESTART_RND);
		float FadeSpan = 1 / ( (FadeSpanFrame_b.x+0.0001) /30 ) *rndrate(rnd2.y,FADESPAN_RND);
		
	    //回転
		Pos.xyz -= FaceCenter.xyz;
		Pos.xyz = RotateRoundVector ( Pos.xyz, RotateVector, CurrentTime *RotateSpeed +RoteteStart );
		Normal = RotateRoundVector ( Normal, RotateVector, CurrentTime *RotateSpeed +RoteteStart );
		Pos.xyz += FaceCenter.xyz;
		//拡散
		Pos.xyz += ( SpreadVector +BreakVector ) *CurrentTime;
		//重力
		Pos.xyz += pow( CurrentTime, 2 ) *Gravity_b/2;
		//ﾌｪｰﾄﾞ
		if(FadeStart>0||FadeSpanFrame_b.x>0) { Color.a = min( Color.a, Color.a -(CurrentTime-FadeStart)*FadeSpan ); }
	}
	
    Out.Pos = mul( Pos, WorldViewProjMatrix );
    Out.Eye = CameraPosition - mul( Pos, WorldMatrix );
    Out.Normal = normalize( mul( Normal, (float3x3)WorldMatrix ) );
    Out.Tex = Tex;
    Out.ZCalcTex = mul( Pos, LightWorldViewProjMatrix );
    
    if ( !useToon ) {
        Color.rgb += max(0,dot( Out.Normal, -LightDirection )) * DiffuseColor.rgb;
    }
    if ( useSphereMap ) {
        float2 NormalWV = mul( Out.Normal, (float3x3)ViewMatrix );
        Out.SpTex.x = NormalWV.x * 0.5f + 0.5f;
        Out.SpTex.y = NormalWV.y * -0.5f + 0.5f;
    }
    
    Out.Color = saturate( Color );
	
    return Out;
}



// ピクセルシェーダ
float4 Basic_PS(BufferShadow_OUTPUT IN, uniform bool useTexture, uniform bool useSphereMap, uniform bool useToon) : COLOR0
{
    // スペキュラ色計算
    float3 HalfVector = normalize( normalize(IN.Eye) + -LightDirection );
    float3 Specular = pow( max(0,dot( HalfVector, normalize(IN.Normal) )), SpecularPower ) * SpecularColor;
    
    float4 Color = IN.Color;
    if ( useTexture ) {
        // テクスチャ適用
        Color *= tex2D( ObjTexSampler, IN.Tex );
    }
    if ( useSphereMap ) {
        // スフィアマップ適用
        if(spadd) Color.rgb += tex2D(ObjSphareSampler,IN.SpTex).rgb;
        else      Color.rgb *= tex2D(ObjSphareSampler,IN.SpTex);
    }
    
    if ( useToon ) {
        // トゥーン適用
        float LightNormal = dot( IN.Normal, -LightDirection );
        Color.rgb *= lerp(MaterialToon, float3(1,1,1), saturate(LightNormal * 16 + 0.5));
    }
    
    // スペキュラ適用
    Color.rgb += Specular;
    
    return Color;
}





///////////////////////////////////////////////////////////////////////////////////////////////
// セルフシャドウ用Z値プロット

struct VS_ZValuePlot_OUTPUT {
    float4 Pos : POSITION;              // 射影変換座標
    float4 ShadowMapTex : TEXCOORD0;    // Zバッファテクスチャ
};


// 頂点シェーダ
VS_ZValuePlot_OUTPUT ZValuePlot_VS( float4 Pos : POSITION, float4 FaceCenter : TEXCOORD1 )
{
    VS_ZValuePlot_OUTPUT Out = (VS_ZValuePlot_OUTPUT)0;
	
	float4 Color;
    Color.rgb = AmbientColor;
    Color.a = DiffuseColor.a;
	
// エフェクトでの頂点位置
    Pos = mul( Pos, CenterMatrix );
	
	if( FaceCenter.w>0 ){ //プラグイン実行済みのフラグ
	    FaceCenter.xyz = mul( float4(FaceCenter.xyz,1), CenterMatrix );
		
	// 破壊用の変数
		float u = (FaceCenter.x+FaceCenter.z+FaceCenter.w)*RND_COEF;
		float v = (FaceCenter.x+FaceCenter.y+FaceCenter.w)*RND_COEF;
		float4 rnd1 = tex2Dlod(rndsamp, float4( u, v, 0, 1 ));
		float4 rnd2 = tex2Dlod(rndsamp, float4( u+0.5, v+0.5, 0, 1 ));
		
#if(PARALLEL_IMPACT)
		float3 BreakVector = ImpactSpeed_b *rndrate(rnd1.x,IMPACT_RND);
#else
		float3 BreakVector = normalize( normalize( FaceCenter.xyz -BreakCenter_b ) +(rnd2.xyz-0.5)*2*IMPACT_DIR_RND ) *ImpactSpeed_b.x *rndrate(rnd1.x,IMPACT_RND);
#endif
			
		float3 SpreadVector = BreakVector;
		
		float StartFlame = ( BreakFrame_b.x +(BREAKSTART_RND*rnd2.z) ) /30;
		float Delay;
		float DelayDist = distance(FaceCenter.xyz,BreakCenter_b);
		if(BreakSpeed_b.x!=0){ Delay = DelayDist / BreakSpeed_b.x; }
		else{ Delay=0; }
		float CurrentTime = max( 0, Time -Delay -StartFlame );
		
		float3 RotateVector = normalize( rnd2.xyz-0.5 );
		float RoteteStart = radians(RotateStart_b.x) *(CurrentTime>0);
		float RotateSpeed = radians(RotateSpeed_b.x) *rndrate(rnd1.z,ROTATE_RND);
		
		float FadeStart = FadeStartFrame_b.x /30 *rndrate(rnd2.x,FADESTART_RND);
		float FadeSpan = 1 / ( (FadeSpanFrame_b.x+0.0001) /30 ) *rndrate(rnd2.y,FADESPAN_RND);
		
	    //回転
		Pos.xyz -= FaceCenter.xyz;
		Pos.xyz = RotateRoundVector ( Pos.xyz, RotateVector, CurrentTime *RotateSpeed +RoteteStart );
		Pos.xyz += FaceCenter.xyz;
		//拡散
		Pos.xyz += ( SpreadVector +BreakVector ) *CurrentTime;
		//重力
		Pos.xyz += pow( CurrentTime, 2 ) *Gravity_b/2;
		//ﾌｪｰﾄﾞ
		if(FadeStart>0||FadeSpanFrame_b.x>0) { Color.a = min( Color.a, Color.a -(CurrentTime-FadeStart)*FadeSpan ); }
	}
    
    if(Color.a<SHADOW_THRESHOLD){Pos.y-=999999;}
    Out.Pos = mul( Pos, LightWorldViewProjMatrix );
    Out.ShadowMapTex = Out.Pos;
	
    return Out;
}


// ピクセルシェーダ
float4 ZValuePlot_PS( float4 ShadowMapTex : TEXCOORD0 ) : COLOR
{
    // R色成分にZ値を記録する
    return float4(ShadowMapTex.z/ShadowMapTex.w,0,0,1);
}

// Z値プロット用テクニック
technique ZplotTec < string MMDPass = "zplot"; > {
    pass ZValuePlot {
		BREAK_STATE
        AlphaBlendEnable = FALSE;
        VertexShader = compile vs_3_0 ZValuePlot_VS();
        PixelShader  = compile ps_3_0 ZValuePlot_PS();
    }
}





///////////////////////////////////////////////////////////////////////////////////////////////
// ピクセルシェーダ（セルフシャドウ用）
float4 BufferShadow_PS(BufferShadow_OUTPUT IN, uniform bool useTexture, uniform bool useSphereMap, uniform bool useToon) : COLOR
{
    // スペキュラ色計算
    float3 HalfVector = normalize( normalize(IN.Eye) + -LightDirection );
    float3 Specular = pow( max(0,dot( HalfVector, normalize(IN.Normal) )), SpecularPower ) * SpecularColor;
    
    float4 Color = IN.Color;
    float4 ShadowColor = float4(AmbientColor, Color.a);  // 影の色
    if ( useTexture ) {
        // テクスチャ適用
        float4 TexColor = tex2D( ObjTexSampler, IN.Tex );
        Color *= TexColor;
        ShadowColor *= TexColor;
    }
    if ( useSphereMap ) {
        // スフィアマップ適用
        float4 TexColor = tex2D(ObjSphareSampler,IN.SpTex);
        if(spadd) {
            Color.rgb += TexColor.rgb;
            ShadowColor.rgb += TexColor.rgb;
        } else {
            Color.rgb *= TexColor;
            ShadowColor.rgb *= TexColor;
        }
    }
    // スペキュラ適用
    Color.rgb += Specular;
    
    // テクスチャ座標に変換
    IN.ZCalcTex /= IN.ZCalcTex.w;
    float2 TransTexCoord;
    TransTexCoord.x = (1.0f + IN.ZCalcTex.x)*0.5f;
    TransTexCoord.y = (1.0f - IN.ZCalcTex.y)*0.5f;
    
    if( any( saturate(TransTexCoord) != TransTexCoord ) ) {
        // シャドウバッファ外
        return Color;
    } else {
        float comp;
        if(parthf) {
            // セルフシャドウ mode2
            comp=1-saturate(max(IN.ZCalcTex.z-tex2D(DefSampler,TransTexCoord).r , 0.0f)*SKII2*TransTexCoord.y-0.3f);
        } else {
            // セルフシャドウ mode1
            comp=1-saturate(max(IN.ZCalcTex.z-tex2D(DefSampler,TransTexCoord).r , 0.0f)*SKII1-0.3f);
        }
        if ( useToon ) {
            // トゥーン適用
            comp = min(saturate(dot(IN.Normal,-LightDirection)*Toon),comp);
            ShadowColor.rgb *= MaterialToon;
        }
        
        float4 ans = lerp(ShadowColor, Color, comp);
        if( transp ) ans.a = 0.5f;
        return ans;
    }
}





///////////////////////////////////////////////////////////////////////////////////////////////
// テクニック

bool use_texture;
bool use_spheremap;
bool use_toon;

technique MainTec0 < string MMDPass = "object"; > {
    pass DrawObject {
		BREAK_STATE
        VertexShader = compile vs_3_0 BufferShadow_VS(use_texture, use_spheremap, use_toon);
        PixelShader  = compile ps_3_0 Basic_PS(use_texture, use_spheremap, use_toon);
    }
}

technique MainTec1 < string MMDPass = "object_ss"; > {
    pass DrawObject {
		BREAK_STATE
        VertexShader = compile vs_3_0 BufferShadow_VS(use_texture, use_spheremap, use_toon);
        PixelShader  = compile ps_3_0 BufferShadow_PS(use_texture, use_spheremap, use_toon);
    }
}

// 輪郭描画用テクニック
technique EdgeTec < string MMDPass = "edge"; > {}
// 影描画用テクニック
technique ShadowTec < string MMDPass = "shadow"; > {}

