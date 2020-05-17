====================================
   Scale.fx 対応版 Ray-MMD (rev.5)

        by iori_komatsu
====================================

これは Ray-MMD に対して以下のエフェクトを追加したものです。

* Scale
    * 針金P氏の Scale.fx を Ray-MMD に対応させたものです。
    * ScaleControl を使ってモデルを拡大・縮小できます。
* Fracture
    * わたり氏とどるるP氏の「連続面毎に分解エフェクト」を Ray-MMD に対応させたものです。
    * 連続面毎に分解エフェクトとは、以下の動画で紹介されているエフェクトです。
      https://www.nicovideo.jp/watch/sm19453784
* VolumeticCloud
    * 雲オブジェクトを配置できるエフェクトです。


[Scale] Scaleエフェクトの使い方
-------------------------------

まず、普通に Ray-MMD をセットアップしてください。

次に、サイズを変更したいモデルのエフェクト割り当てを scale.fx 対応のものに変更します。
例えば、MaterialMap タブの material_2.0.fx は material_2.0_scale.fx に変更してください。
Main タブの main.fx は main_scale.fx に変更してください。
同様にして SSAOMap や PSSM1～4 も割り当てを変更してください。

最後に Scale_v005/ScaleControl.pmd をMMDに読み込めばセットアップは完了です。
ScaleControl の表情操作でモデルを拡大・縮小できます。

注意: Scale_v005/Scale.fx は使用しません。


[Scale] マテリアルの改造方法
----------------------------

Ray-MMD と一緒に配布されているマテリアルに関しては _scale 版が予め用意されています。
しかし、それ以外のエフェクトに関しては利用者が _scale 版を作成する必要があります。
_scale 版を作成する手順は以下の通りです。

1. マテリアルの .fx ファイルをコピーします。
2. コピーしたファイルの先頭に以下の２行を書き加えて保存します。
   ただし (Scale.fxsubへの相対パス) の部分はその .fx ファイルから Shader/Scale.fxsub への相対パスに置き換えてください。

    #include "(Scale.fxsubへの相対パス)"
    #define SCALING_ENABLED 1

例えば、元のマテリアルのパスが (ray-mmdのディレクトリ)/Materials/Hair/material_hair.fx だとすると、追加すべき２行は以下のようになります。

    #include "../../shader/Scale.fxsub"
    #define SCALING_ENABLED 1


[Fracture] 連続面毎に分解エフェクトの使い方
-------------------------------------------

まず、「連続面毎に分解エフェクト」フォルダの下の ReadMe の１～４にしたがってモデルをセットアップしてください。
５番はやらなくていいです。

また Ray-MMD も通常通りセットアップしてください。

次に、サイズを変更したいモデルのエフェクト割り当てを fracture.fx 対応のものに変更します。
例えば、MaterialMap タブの material_2.0.fx は material_2.0_fracture.fx に変更してください。
Main タブの main.fx は main_fracture.fx に変更してください。
同様にして SSAOMap や PSSM1～4 も割り当てを変更してください。

これでセットアップは終わりです。

※ "連続面毎に分解.fx" を割り当てる必要はありません。
※ 本家の分解エフェクトには破片をフェードアウトさせる機能がありますが、このエフェクトでは対応していません。


[Fracture] 分解エフェクト用マテリアルの作り方
---------------------------------------------

_fracture 版のマテリアルは最も基本となる material_2.0_fracture.fx だけが用意されています。
これ以外のマテリアルを利用したい場合は _fracture 版マテリアルを自分で作成する必要があります。
作り方は以下の通りです:

1. マテリアルの .fx ファイルをコピーします。
2. コピーしたファイルの先頭に以下の２行を書き加えて保存します。
   ただし (Fracture.fxsubへの相対パス) の部分はその .fx ファイルから Shader/Fracture.fxsub への相対パスに置き換えてください。

    #include "(Fracture.fxsubへの相対パス)"
    #define FRACTURE_ENABLED 1


[Cloud] 雲エフェクトの使い方
----------------------------

ray-mmd/Cloud フォルダの下の README を御覧ください。


Copyright
---------

このエフェクトは以下のエフェクトを改変および再配布しています。
素晴らしいエフェクトの作成および再配布の許可をくださった作者の方々に感謝いたします。

* Ray-MMD (by Rui氏): https://github.com/ray-cast/ray-mmd
* Scale.fx (by 針金P氏): https://harigane.at.webry.info/201010/article_1.html
* 連続面毎に分解エフェクト (by わたり氏, どるるP氏): https://www.nicovideo.jp/watch/sm19453784


利用条件
-------

Ray-MMD 本体および私が修正した部分に関しては MIT License の下に配布されています。


更新履歴
-------

* 2020-05-18 rev.5
    * 雲エフェクトを追加しました。
* 2019-12-15 rev.4
    * 連続面毎に分解エフェクトを同梱しました。
    * Fracture.fx に軽微な修正を行いました。これはレンダリング結果を影響を与えません。
* 2019-12-08 rev.3
    * 分解エフェクトで法線ベクトルが正しく計算されないバグを修正しました。
* 2019-12-07 rev.2
    * 分解エフェクトの機能を実装しました。
    * 同梱する ray-mmd のバージョンを master ブランチの最新版にしました。
      また、Extensions を同梱するようにしました。
* 2019-11-10 rev.1
    * 公開
