====================================
   Scale.fx 対応版 Ray-MMD (rev.2)

        by iori_komatsu
====================================

Scale.fx の機能を組み込んだ Ray-MMD です。
ScaleControl を使ってモデルを拡大・縮小できます。

このエフェクトは以下の２つのエフェクトを iori_komatsu が変更および再配布したものです。

* Ray-MMD (by Ray-MMD Developers): https://github.com/ray-cast/ray-mmd
* Scale.fx (by 針金P): https://harigane.at.webry.info/201010/article_1.html

また、rev.2 からはどるるP氏の「連続面毎に分解エフェクト」が動作するようになっています。


使い方
------

まず、普通に Ray-MMD をセットアップしてください。

次に、サイズを変更したいモデルのエフェクト割り当てを scale.fx 対応のものに変更します。
例えば、MaterialMap タブの material_2.0.fx は material_2.0_scale.fx に変更してください。
Main タブの main.fx は main_scale.fx に変更してください。
同様にして SSAOMap や PSSM1～4 も割り当てを変更してください。

最後に ScaleControl.pmd を MMD に読み込めば、セットアップは完了です。
ScaleControl の表情操作でモデルを拡大・縮小できます。


マテリアルの改造方法
--------------------

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


連続面毎に分解エフェクトの使い方
--------------------------------

まず、本家の分解エフェクトをダウンロードして、その説明にしたがってモデルをセットアップしてください。
https://www.nicovideo.jp/watch/sm19453784

あとは scale.fxの場合と同様です。
Main, MaterialMap, SSAOMap, PSSM1～4 のタブで分解エフェクトを適用したいモデルに対して "_fracture.fx" で終わるエフェクトを割り当ててください。

※ 本家の分解エフェクトには破片をフェードアウトさせる機能がありますが、このエフェクトでは対応していません。


分解エフェクト用マテリアルの作り方
----------------------------------

_fracture 版のマテリアルは最も基本となる material_2.0_fracture.fx だけが用意されています。
これ以外のマテリアルを利用したい場合は _fracture 版マテリアルを自分で作成する必要があります。
作り方は以下の通りです:

1. マテリアルの .fx ファイルをコピーします。
2. コピーしたファイルの先頭に以下の２行を書き加えて保存します。
   ただし (Fracture.fxsubへの相対パス) の部分はその .fx ファイルから Shader/Fracture.fxsub への相対パスに置き換えてください。

#include "(Fracture.fxsubへの相対パス)"
#define FRACTURE_ENABLED 1


利用条件
--------

Ray-MMD 本体および私が修正した部分に関しては MIT License の下に配布されています。


更新履歴
-------

* 2019-12-07 rev.2
    * 分解エフェクトの機能を実装しました。
    * 同梱する ray-mmd のバージョンを master ブランチの最新版にしました。
      また、Extensions を同梱するようにしました。
* 2019-11-10 rev.1
    * 公開
