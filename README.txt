====================================
   Scale.fx �Ή��� Ray-MMD (rev.5)

        by iori_komatsu
====================================

����� Ray-MMD �ɑ΂��Ĉȉ��̃G�t�F�N�g��ǉ��������̂ł��B

* Scale
    * �j��P���� Scale.fx �� Ray-MMD �ɑΉ����������̂ł��B
    * ScaleControl ���g���ă��f�����g��E�k���ł��܂��B
* Fracture
    * �킽�莁�Ƃǂ��P���́u�A���ʖ��ɕ����G�t�F�N�g�v�� Ray-MMD �ɑΉ����������̂ł��B
    * �A���ʖ��ɕ����G�t�F�N�g�Ƃ́A�ȉ��̓���ŏЉ��Ă���G�t�F�N�g�ł��B
      https://www.nicovideo.jp/watch/sm19453784
* VolumeticCloud
    * �_�I�u�W�F�N�g��z�u�ł���G�t�F�N�g�ł��B


[Scale] Scale�G�t�F�N�g�̎g����
-------------------------------

�܂��A���ʂ� Ray-MMD ���Z�b�g�A�b�v���Ă��������B

���ɁA�T�C�Y��ύX���������f���̃G�t�F�N�g���蓖�Ă� scale.fx �Ή��̂��̂ɕύX���܂��B
�Ⴆ�΁AMaterialMap �^�u�� material_2.0.fx �� material_2.0_scale.fx �ɕύX���Ă��������B
Main �^�u�� main.fx �� main_scale.fx �ɕύX���Ă��������B
���l�ɂ��� SSAOMap �� PSSM1�`4 �����蓖�Ă�ύX���Ă��������B

�Ō�� Scale_v005/ScaleControl.pmd ��MMD�ɓǂݍ��߂΃Z�b�g�A�b�v�͊����ł��B
ScaleControl �̕\���Ń��f�����g��E�k���ł��܂��B

����: Scale_v005/Scale.fx �͎g�p���܂���B


[Scale] �}�e���A���̉������@
----------------------------

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


[Fracture] �A���ʖ��ɕ����G�t�F�N�g�̎g����
-------------------------------------------

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


[Fracture] �����G�t�F�N�g�p�}�e���A���̍���
---------------------------------------------

_fracture �ł̃}�e���A���͍ł���{�ƂȂ� material_2.0_fracture.fx �������p�ӂ���Ă��܂��B
����ȊO�̃}�e���A���𗘗p�������ꍇ�� _fracture �Ń}�e���A���������ō쐬����K�v������܂��B
�����͈ȉ��̒ʂ�ł�:

1. �}�e���A���� .fx �t�@�C�����R�s�[���܂��B
2. �R�s�[�����t�@�C���̐擪�Ɉȉ��̂Q�s�����������ĕۑ����܂��B
   ������ (Fracture.fxsub�ւ̑��΃p�X) �̕����͂��� .fx �t�@�C������ Shader/Fracture.fxsub �ւ̑��΃p�X�ɒu�������Ă��������B

    #include "(Fracture.fxsub�ւ̑��΃p�X)"
    #define FRACTURE_ENABLED 1


[Cloud] �_�G�t�F�N�g�̎g����
----------------------------

ray-mmd/Cloud �t�H���_�̉��� README ���䗗���������B


Copyright
---------

���̃G�t�F�N�g�͈ȉ��̃G�t�F�N�g�����ς���эĔz�z���Ă��܂��B
�f���炵���G�t�F�N�g�̍쐬����эĔz�z�̋���������������҂̕��X�Ɋ��ӂ������܂��B

* Ray-MMD (by Rui��): https://github.com/ray-cast/ray-mmd
* Scale.fx (by �j��P��): https://harigane.at.webry.info/201010/article_1.html
* �A���ʖ��ɕ����G�t�F�N�g (by �킽�莁, �ǂ��P��): https://www.nicovideo.jp/watch/sm19453784


���p����
-------

Ray-MMD �{�̂���ю����C�����������Ɋւ��Ă� MIT License �̉��ɔz�z����Ă��܂��B


�X�V����
-------

* 2020-05-18 rev.5
    * �_�G�t�F�N�g��ǉ����܂����B
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
