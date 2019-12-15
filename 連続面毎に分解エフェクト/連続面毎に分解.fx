// �j�Ђ��Z���t�V���h�E�𗎂Ƃ��Œ�A���t�@�l�i�t�F�[�h���̂݁j
#define SHADOW_THRESHOLD 0.1

// ���Ԓ�~�B1�ɂ���ƃG�t�F�N�g�̎��Ԃ������Ői�܂Ȃ��Ȃ�܂��B��~��t�Đ��p�ł��B
// 1�ɂ��ĕ���J�nF�𓮂����Ύ��Ԃ𑀍�ł��܂��B
// 1�t���[����1���}�C�i�X�����ɓ������΋t�Đ����ł��܂��B
#define TIME_STOP 0

// �Ռ������𒆐S����̌����łȂ��Œ�����ɁB
// 1�ɂ���Ɓu�Ռ����x�v��XYZ���W�̕����x�N�g���ɕς��܂��B
#define PARALLEL_IMPACT 0


// �e�l�ւ̗���
// ������1�{����̍ő卷���ɂȂ�܂��B0.2����0.8�`1.2�{�ɁA0.7����0.3�`1.7�{�ɏ�Z����܂�

// �Ռ����x�����_���l
#define IMPACT_RND 0.3

// ��]���x�����_���l
#define ROTATE_RND 0.3

// ̪��ފJ�nF�����_���l
#define FADESTART_RND 0.04

// ̪��ފ���F�����_���l
#define FADESPAN_RND 0.3

// �Ռ����������_���l
#define IMPACT_DIR_RND 0.5

// �g�U���������_���l
#define SPREAD_DIR_RND 0.2

// ����J�nF�����_���l�B�����_���Œx���ő�t���[�����ł��B
#define BREAKSTART_RND 0





// ���������̓G�t�F�N�g�����ɋ����̂���l�����G���Ă݂Ă�������

////////////////////////////////////////////////////////////////////////////////////////////////
// �p�����[�^�錾

// ���@�ϊ��s��
float4x4 WorldViewProjMatrix      : WORLDVIEWPROJECTION;
float4x4 WorldMatrix              : WORLD;
float4x4 ViewMatrix               : VIEW;
float4x4 LightWorldViewProjMatrix : WORLDVIEWPROJECTION < string Object = "Light"; >;

float3   LightDirection    : DIRECTION < string Object = "Light"; >;
float3   CameraPosition    : POSITION  < string Object = "Camera"; >;

// �}�e���A���F
float4   MaterialDiffuse   : DIFFUSE  < string Object = "Geometry"; >;
float3   MaterialAmbient   : AMBIENT  < string Object = "Geometry"; >;
float3   MaterialEmmisive  : EMISSIVE < string Object = "Geometry"; >;
float3   MaterialSpecular  : SPECULAR < string Object = "Geometry"; >;
float    SpecularPower     : SPECULARPOWER < string Object = "Geometry"; >;
float3   MaterialToon      : TOONCOLOR;
float4   EdgeColor         : EDGECOLOR;
// ���C�g�F
float3   LightDiffuse      : DIFFUSE   < string Object = "Light"; >;
float3   LightAmbient      : AMBIENT   < string Object = "Light"; >;
float3   LightSpecular     : SPECULAR  < string Object = "Light"; >;
static float4 DiffuseColor  = MaterialDiffuse  * float4(LightDiffuse, 1.0f);
static float3 AmbientColor  = saturate(MaterialAmbient  * LightAmbient + MaterialEmmisive);
static float3 SpecularColor = MaterialSpecular * LightSpecular;

bool     parthf;   // �p�[�X�y�N�e�B�u�t���O
bool     transp;   // �������t���O
bool	 spadd;    // �X�t�B�A�}�b�v���Z�����t���O
#define SKII1    1500
#define SKII2    8000
#define Toon     3

// �I�u�W�F�N�g�̃e�N�X�`��
texture ObjectTexture: MATERIALTEXTURE;
sampler ObjTexSampler = sampler_state {
    texture = <ObjectTexture>;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};

// �X�t�B�A�}�b�v�̃e�N�X�`��
texture ObjectSphereMap: MATERIALSPHEREMAP;
sampler ObjSphareSampler = sampler_state {
    texture = <ObjectSphereMap>;
    MINFILTER = LINEAR;
    MAGFILTER = LINEAR;
};

// MMD�{����sampler���㏑�����Ȃ����߂̋L�q�ł��B�폜�s�B
sampler MMDSamp0 : register(s0);
sampler MMDSamp1 : register(s1);
sampler MMDSamp2 : register(s2);




////////////////////////////////////////////////////////////////////////////////////////////////
// �ǉ��̃p�����[�^�錾

#define BREAK_STATE CULLMODE = NONE;\

#if(TIME_STOP)
float Time =0;
#else
float Time : TIME <bool SyncInEditMode=true;>;
#endif


// �_p1�����_����̃x�N�g��v������r�x��]
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


//�����e�N�X�`��
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

// �����̔{��
float rndrate(float rnd,float coif){
 return 1.0f+((rnd-0.5f)*2.0f*coif);
}


// �R���g���[���[�ǂݍ���
float4x4 CenterMatrix   : CONTROLOBJECT < string name = "(self)"; string item = "���f���e"; >;
float3 BreakCenter_b    : CONTROLOBJECT < string name = "(self)"; string item = "���󒆐S"; >;
float3 BreakSpeed_b     : CONTROLOBJECT < string name = "(self)"; string item = "���󑬓x"; >;

float3 SpreadSpeed_b    : CONTROLOBJECT < string name = "(self)"; string item = "�g�U���x"; >;
float3 ImpactSpeed_b    : CONTROLOBJECT < string name = "(self)"; string item = "�Ռ����x"; >;
float3 RotateSpeed_b    : CONTROLOBJECT < string name = "(self)"; string item = "��]���x"; >;
float3 RotateStart_b    : CONTROLOBJECT < string name = "(self)"; string item = "������]��"; >;

float3 Gravity_b        : CONTROLOBJECT < string name = "(self)"; string item = "�d���޸��"; >;
float3 BreakFrame_b     : CONTROLOBJECT < string name = "(self)"; string item = "����J�nF"; >;
float3 FadeStartFrame_b : CONTROLOBJECT < string name = "(self)"; string item = "̪��ފJ�nF"; >;
float3 FadeSpanFrame_b  : CONTROLOBJECT < string name = "(self)"; string item = "̪��ފ���F"; >;




///////////////////////////////////////////////////////////////////////////////////////////////
// �I�u�W�F�N�g�`��i�Z���t�V���h�E���ʁj

// �V���h�E�o�b�t�@�̃T���v���B"register(s0)"�Ȃ̂�MMD��s0���g���Ă��邩��
sampler DefSampler : register(s0);

struct BufferShadow_OUTPUT {
    float4 Pos      : POSITION;     // �ˉe�ϊ����W
    float4 ZCalcTex : TEXCOORD0;    // Z�l
    float2 Tex      : TEXCOORD1;    // �e�N�X�`��
    float3 Normal   : TEXCOORD2;    // �@��
    float3 Eye      : TEXCOORD3;    // �J�����Ƃ̑��Έʒu
    float2 SpTex    : TEXCOORD4;	 // �X�t�B�A�}�b�v�e�N�X�`�����W
    float4 Color    : COLOR0;       // �f�B�t���[�Y�F
};

// ���_�V�F�[�_
BufferShadow_OUTPUT BufferShadow_VS(float4 Pos : POSITION, float3 Normal : NORMAL, float2 Tex : TEXCOORD0, uniform bool useTexture, uniform bool useSphereMap, uniform bool useToon, float4 FaceCenter : TEXCOORD1 )
{
    BufferShadow_OUTPUT Out = (BufferShadow_OUTPUT)0;
	
	float4 Color;
    Color.rgb = AmbientColor;
    Color.a = DiffuseColor.a;
	
// �G�t�F�N�g�ł̒��_�ʒu
    Pos = mul( Pos, CenterMatrix );
    Normal = mul( Normal, CenterMatrix );
	
	if( FaceCenter.w>0 ){ //�v���O�C�����s�ς݂̃t���O
	    FaceCenter.xyz = mul( float4(FaceCenter.xyz,1), CenterMatrix );
		
	// �j��p�̕ϐ�
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
		
	    //��]
		Pos.xyz -= FaceCenter.xyz;
		Pos.xyz = RotateRoundVector ( Pos.xyz, RotateVector, CurrentTime *RotateSpeed +RoteteStart );
		Normal = RotateRoundVector ( Normal, RotateVector, CurrentTime *RotateSpeed +RoteteStart );
		Pos.xyz += FaceCenter.xyz;
		//�g�U
		Pos.xyz += ( SpreadVector +BreakVector ) *CurrentTime;
		//�d��
		Pos.xyz += pow( CurrentTime, 2 ) *Gravity_b/2;
		//̪���
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



// �s�N�Z���V�F�[�_
float4 Basic_PS(BufferShadow_OUTPUT IN, uniform bool useTexture, uniform bool useSphereMap, uniform bool useToon) : COLOR0
{
    // �X�y�L�����F�v�Z
    float3 HalfVector = normalize( normalize(IN.Eye) + -LightDirection );
    float3 Specular = pow( max(0,dot( HalfVector, normalize(IN.Normal) )), SpecularPower ) * SpecularColor;
    
    float4 Color = IN.Color;
    if ( useTexture ) {
        // �e�N�X�`���K�p
        Color *= tex2D( ObjTexSampler, IN.Tex );
    }
    if ( useSphereMap ) {
        // �X�t�B�A�}�b�v�K�p
        if(spadd) Color.rgb += tex2D(ObjSphareSampler,IN.SpTex).rgb;
        else      Color.rgb *= tex2D(ObjSphareSampler,IN.SpTex);
    }
    
    if ( useToon ) {
        // �g�D�[���K�p
        float LightNormal = dot( IN.Normal, -LightDirection );
        Color.rgb *= lerp(MaterialToon, float3(1,1,1), saturate(LightNormal * 16 + 0.5));
    }
    
    // �X�y�L�����K�p
    Color.rgb += Specular;
    
    return Color;
}





///////////////////////////////////////////////////////////////////////////////////////////////
// �Z���t�V���h�E�pZ�l�v���b�g

struct VS_ZValuePlot_OUTPUT {
    float4 Pos : POSITION;              // �ˉe�ϊ����W
    float4 ShadowMapTex : TEXCOORD0;    // Z�o�b�t�@�e�N�X�`��
};


// ���_�V�F�[�_
VS_ZValuePlot_OUTPUT ZValuePlot_VS( float4 Pos : POSITION, float4 FaceCenter : TEXCOORD1 )
{
    VS_ZValuePlot_OUTPUT Out = (VS_ZValuePlot_OUTPUT)0;
	
	float4 Color;
    Color.rgb = AmbientColor;
    Color.a = DiffuseColor.a;
	
// �G�t�F�N�g�ł̒��_�ʒu
    Pos = mul( Pos, CenterMatrix );
	
	if( FaceCenter.w>0 ){ //�v���O�C�����s�ς݂̃t���O
	    FaceCenter.xyz = mul( float4(FaceCenter.xyz,1), CenterMatrix );
		
	// �j��p�̕ϐ�
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
		
	    //��]
		Pos.xyz -= FaceCenter.xyz;
		Pos.xyz = RotateRoundVector ( Pos.xyz, RotateVector, CurrentTime *RotateSpeed +RoteteStart );
		Pos.xyz += FaceCenter.xyz;
		//�g�U
		Pos.xyz += ( SpreadVector +BreakVector ) *CurrentTime;
		//�d��
		Pos.xyz += pow( CurrentTime, 2 ) *Gravity_b/2;
		//̪���
		if(FadeStart>0||FadeSpanFrame_b.x>0) { Color.a = min( Color.a, Color.a -(CurrentTime-FadeStart)*FadeSpan ); }
	}
    
    if(Color.a<SHADOW_THRESHOLD){Pos.y-=999999;}
    Out.Pos = mul( Pos, LightWorldViewProjMatrix );
    Out.ShadowMapTex = Out.Pos;
	
    return Out;
}


// �s�N�Z���V�F�[�_
float4 ZValuePlot_PS( float4 ShadowMapTex : TEXCOORD0 ) : COLOR
{
    // R�F������Z�l���L�^����
    return float4(ShadowMapTex.z/ShadowMapTex.w,0,0,1);
}

// Z�l�v���b�g�p�e�N�j�b�N
technique ZplotTec < string MMDPass = "zplot"; > {
    pass ZValuePlot {
		BREAK_STATE
        AlphaBlendEnable = FALSE;
        VertexShader = compile vs_3_0 ZValuePlot_VS();
        PixelShader  = compile ps_3_0 ZValuePlot_PS();
    }
}





///////////////////////////////////////////////////////////////////////////////////////////////
// �s�N�Z���V�F�[�_�i�Z���t�V���h�E�p�j
float4 BufferShadow_PS(BufferShadow_OUTPUT IN, uniform bool useTexture, uniform bool useSphereMap, uniform bool useToon) : COLOR
{
    // �X�y�L�����F�v�Z
    float3 HalfVector = normalize( normalize(IN.Eye) + -LightDirection );
    float3 Specular = pow( max(0,dot( HalfVector, normalize(IN.Normal) )), SpecularPower ) * SpecularColor;
    
    float4 Color = IN.Color;
    float4 ShadowColor = float4(AmbientColor, Color.a);  // �e�̐F
    if ( useTexture ) {
        // �e�N�X�`���K�p
        float4 TexColor = tex2D( ObjTexSampler, IN.Tex );
        Color *= TexColor;
        ShadowColor *= TexColor;
    }
    if ( useSphereMap ) {
        // �X�t�B�A�}�b�v�K�p
        float4 TexColor = tex2D(ObjSphareSampler,IN.SpTex);
        if(spadd) {
            Color.rgb += TexColor.rgb;
            ShadowColor.rgb += TexColor.rgb;
        } else {
            Color.rgb *= TexColor;
            ShadowColor.rgb *= TexColor;
        }
    }
    // �X�y�L�����K�p
    Color.rgb += Specular;
    
    // �e�N�X�`�����W�ɕϊ�
    IN.ZCalcTex /= IN.ZCalcTex.w;
    float2 TransTexCoord;
    TransTexCoord.x = (1.0f + IN.ZCalcTex.x)*0.5f;
    TransTexCoord.y = (1.0f - IN.ZCalcTex.y)*0.5f;
    
    if( any( saturate(TransTexCoord) != TransTexCoord ) ) {
        // �V���h�E�o�b�t�@�O
        return Color;
    } else {
        float comp;
        if(parthf) {
            // �Z���t�V���h�E mode2
            comp=1-saturate(max(IN.ZCalcTex.z-tex2D(DefSampler,TransTexCoord).r , 0.0f)*SKII2*TransTexCoord.y-0.3f);
        } else {
            // �Z���t�V���h�E mode1
            comp=1-saturate(max(IN.ZCalcTex.z-tex2D(DefSampler,TransTexCoord).r , 0.0f)*SKII1-0.3f);
        }
        if ( useToon ) {
            // �g�D�[���K�p
            comp = min(saturate(dot(IN.Normal,-LightDirection)*Toon),comp);
            ShadowColor.rgb *= MaterialToon;
        }
        
        float4 ans = lerp(ShadowColor, Color, comp);
        if( transp ) ans.a = 0.5f;
        return ans;
    }
}





///////////////////////////////////////////////////////////////////////////////////////////////
// �e�N�j�b�N

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

// �֊s�`��p�e�N�j�b�N
technique EdgeTec < string MMDPass = "edge"; > {}
// �e�`��p�e�N�j�b�N
technique ShadowTec < string MMDPass = "shadow"; > {}

