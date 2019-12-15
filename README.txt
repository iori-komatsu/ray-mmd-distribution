====================================
   Scale.fx �Ή��� Ray-MMD (rev.4)

        by iori_komatsu
====================================

Scale.fx �̋@�\��g�ݍ��� Ray-MMD �ł��B
ScaleControl ���g���ă��f�����g��E�k���ł��܂��B

���̃G�t�F�N�g�͈ȉ��̂Q�̃G�t�F�N�g�� iori_komatsu ���ύX����эĔz�z�������̂ł��B

* Ray-MMD (by Ray-MMD Developers): https://github.com/ray-cast/ray-mmd
* Scale.fx (by �j��P): https://harigane.at.webry.info/201010/article_1.html

�܂��Arev.2 ����́A�킽�莁�Ƃǂ��P���́u�A���ʖ��ɕ����G�t�F�N�g�v�����삷��悤�ɂȂ��Ă��܂��B
�A���ʖ��ɕ����G�t�F�N�g�Ƃ́A�ȉ��̓���ŏЉ��Ă���G�t�F�N�g�ł��B
https://www.nicovideo.jp/watch/sm19453784


�g����
------

�܂��A���ʂ� Ray-MMD ���Z�b�g�A�b�v���Ă��������B

���ɁA�T�C�Y��ύX���������f���̃G�t�F�N�g���蓖�Ă� scale.fx �Ή��̂��̂ɕύX���܂��B
�Ⴆ�΁AMaterialMap �^�u�� material_2.0.fx �� material_2.0_scale.fx �ɕύX���Ă��������B
Main �^�u�� main.fx �� main_scale.fx �ɕύX���Ă��������B
���l�ɂ��� SSAOMap �� PSSM1�`4 �����蓖�Ă�ύX���Ă��������B

�Ō�� Scale_v005/ScaleControl.pmd ��MMD�ɓǂݍ��߂΃Z�b�g�A�b�v�͊����ł��B
ScaleControl �̕\���Ń��f�����g��E�k���ł��܂��B

����: Scale_v005/Scale.fx �͎g�p���܂���B


�}�e���A���̉������@
--------------------

Ray-MMD �ƈꏏ�ɔz�z����Ă���}�e���A���Ɋւ��Ă� _scale �ł��\�ߗp�ӂ���Ă��܂��B
�������A����ȊO�̃G�t�F�N�g�Ɋւ��Ă͗��p�҂� _scale �ł��쐬����K�v������܂��B
_scale �ł��쐬����菇�͈ȉ��̒ʂ�ł��B

1. �}�e���A���� .fx �t�@�C�����R�s�[���܂��B
2. �R�s�[�����t�@�C���̐擪�Ɉȉ��̂Q�s�����������ĕۑ����܂��B
   ������ (Scale.fxsub�ւ̑��΃p�X) �̕����͂��� .fx �t�@�C������ Shader/Scale.fxsub �ւ̑��΃p�X�ɒu�������Ă��������B

#include "(Scale.fxsub�ւ̑��΃p�X)"
#define SCALING_ENABLED 1

�Ⴆ�΁A���̃}�e���A���̃p�X�� (ray-mmd�̃f�B���N�g��)/Materials/Hair/material_hair.fx ���Ƃ���ƁA�ǉ����ׂ��Q�s�͈ȉ��̂悤�ɂȂ�܂��B

#include "../../shader/Scale.fxsub"
#define SCALING_ENABLED 1


�A���ʖ��ɕ����G�t�F�N�g�̎g����
--------------------------------

�܂��A�u�A���ʖ��ɕ����G�t�F�N�g�v�t�H���_�̉��� ReadMe �̂P�`�S�ɂ��������ă��f�����Z�b�g�A�b�v���Ă��������B
�T�Ԃ͂��Ȃ��Ă����ł��B

�܂� Ray-MMD ���ʏ�ʂ�Z�b�g�A�b�v���Ă��������B

���ɁA�T�C�Y��ύX���������f���̃G�t�F�N�g���蓖�Ă� fracture.fx �Ή��̂��̂ɕύX���܂��B
�Ⴆ�΁AMaterialMap �^�u�� material_2.0.fx �� material_2.0_fracture.fx �ɕύX���Ă��������B
Main �^�u�� main.fx �� main_fracture.fx �ɕύX���Ă��������B
���l�ɂ��� SSAOMap �� PSSM1�`4 �����蓖�Ă�ύX���Ă��������B

����ŃZ�b�g�A�b�v�͏I���ł��B

�� "�A���ʖ��ɕ���.fx" �����蓖�Ă�K�v�͂���܂���B
�� �{�Ƃ̕����G�t�F�N�g�ɂ͔j�Ђ��t�F�[�h�A�E�g������@�\������܂����A���̃G�t�F�N�g�ł͑Ή����Ă��܂���B


�����G�t�F�N�g�p�}�e���A���̍���
----------------------------------

_fracture �ł̃}�e���A���͍ł���{�ƂȂ� material_2.0_fracture.fx �������p�ӂ���Ă��܂��B
����ȊO�̃}�e���A���𗘗p�������ꍇ�� _fracture �Ń}�e���A���������ō쐬����K�v������܂��B
�����͈ȉ��̒ʂ�ł�:

1. �}�e���A���� .fx �t�@�C�����R�s�[���܂��B
2. �R�s�[�����t�@�C���̐擪�Ɉȉ��̂Q�s�����������ĕۑ����܂��B
   ������ (Fracture.fxsub�ւ̑��΃p�X) �̕����͂��� .fx �t�@�C������ Shader/Fracture.fxsub �ւ̑��΃p�X�ɒu�������Ă��������B

#include "(Fracture.fxsub�ւ̑��΃p�X)"
#define FRACTURE_ENABLED 1


���p����
--------

Ray-MMD �{�̂���ю����C�����������Ɋւ��Ă� MIT License �̉��ɔz�z����Ă��܂��B


�X�V����
-------

* 2019-12-15 rev.4
    * �A���ʖ��ɕ����G�t�F�N�g�𓯍����܂����B
    * Fracture.fx �Ɍy���ȏC�����s���܂����B����̓����_�����O���ʂ��e����^���܂���B
* 2019-12-08 rev.3
    * �����G�t�F�N�g�Ŗ@���x�N�g�����������v�Z����Ȃ��o�O���C�����܂����B
* 2019-12-07 rev.2
    * �����G�t�F�N�g�̋@�\���������܂����B
    * �������� ray-mmd �̃o�[�W������ master �u�����`�̍ŐV�łɂ��܂����B
      �܂��AExtensions �𓯍�����悤�ɂ��܂����B
* 2019-11-10 rev.1
    * ���J
