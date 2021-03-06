#!/bin/bash

echo "This script will install the UKMON LIVE software on your Pi."
echo " "
echo "You will need the location code you agreed with UKMON, "
echo "and the access key and secret provided by UKMON."
echo "if you already contribute from a PC these can be found in"
if [ "LIVE" == "ARCHIVE" ] ; then 
  echo "%LOCALAPPDATA%\ukmon\ukmonarchiver.ini. "
else
  echo "%LOCALAPPDATA%\AUTH_ukmonlivewatcher.ini. "
  echo "The short string is the Key and the long one the Secret."
fi
echo "Please enter the (encrypted) values exactly as seen"
echo ""
echo "If you don't have these keys press crtl-c and come back after getting them".
echo "nb: its best to copy/paste the keys from email to avoid typos."
echo " " 

read -p "continue? " yn
if [ $yn == "n" ] ; then
  exit 0
fi

echo "Installing the AWS CLI...."
sudo apt-get install -y awscli

mkdir ~/ukmon
echo "Installing the package...."
ARCHIVE=`awk '/^__ARCHIVE_BELOW__/ {print NR + 1; exit 0; }' $0`
tail -n+$ARCHIVE $0 | tar xzv -C ~/ukmon

CREDFILE=~/ukmon/.livecreds

if [ -f $CREDFILE ] ; then
  read -p "Credentials already exist; overwrite? (yn) " yn
  if [[ "$yn" == "y" || "$yn" == "Y" ]] ; then 
    redocreds=1
  else
    redocreds=0
  fi
else
  redocreds=1
fi

if [ $redocreds -eq 1 ] ; then 
  while true; do
    read -p "Location: " loc
    read -p "Access Key: " key
    read -p "Secret: " sec 
    echo "you entered: "
    echo $loc
    echo $key
    echo $sec
    read -p " is this correct? (yn) " yn
    if [[ "$yn" == "y" || "$yn" == "Y" ]] ; then 
      break 
    fi
  done 
    
  echo "Creating credentials...."
  echo "export AWS_ACCESS_KEY_ID=`/home/pi/ukmon/.ukmondec $key k`" > $CREDFILE
  echo "export AWS_SECRET_ACCESS_KEY=`/home/pi/ukmon/.ukmondec $sec s`" >> $CREDFILE
  if [ "LIVE" == "ARCHIVE" ] ; then 
    echo "export AWS_DEFAULT_REGION=eu-west-2" >> $CREDFILE
  else
    echo "export AWS_DEFAULT_REGION=eu-west-1" >> $CREDFILE
  fi
  echo "export loc=$loc" >> $CREDFILE
  chmod 0600 $CREDFILE
fi 
if [ "LIVE" == "ARCHIVE" ] ; then 
  crontab -l | grep archToUkMon.sh
  if [ $? == 1 ] ; then
    crontab -l > /tmp/tmpct
    echo "Scheduling job..."
    echo "0 11 * * * /home/pi/ukmon/archToUkMon.sh >> /home/pi/ukmon/archiver.log 2>&1" >> /tmp/tmpct
    crontab /tmp/tmpct
    \rm -f /tmp/tmpct
  fi 
  echo "archToUkMon will run at 11am each day"
else
  crontab -l | grep liveMonitor.sh > /dev/null
  if [ $? == 1 ] ; then
    echo "Scheduling job..."
    crontab -l > /tmp/tmpct
    echo "@reboot sleep 3600 && /home/pi/ukmon/liveMonitor.sh >> /home/pi/ukmon/monitor.log 2>&1" >> /tmp/tmpct
    crontab /tmp/tmpct
    \rm -f /tmp/tmpct
  fi 
  echo "liveMonitor will start after next reboot"
fi
echo ""
echo "done"
exit 0

__ARCHIVE_BELOW__
� _ �;l�u�GJ���}�蘶�z��ؖ����'�:�EJ�(�%��Nl,���xk��^w�$�%E���N�Bn�&i�@t?�Q��6��X�Ӧ)j�jFCR>Wv�ZE�������V�d'���x9��}�73o��E�n�J����C/kդU"W������`-�����[��]]�ތD�R�G����,Qj`�I)�j�����i�9���lüS���'-I8�R���/�:I��>�IYwW�f�����T� �)V)]G�LM�i�R��(�{����(���KY�fڼz�gŇ��*�*=,F����P@��ղ��m�a�!5gi6�Ǻ�����%͢
-j�����Z�~��q�ǒ!��E���YS��@a�T��W4�VV�S��x��+�����J���S��EͶ���b�l�DF�+Ղf��D�>|�?�eczZ5�8��6)L/fM�4�v?���z
��}�2��\Lgn�y��ڪaRE/Pݰ�ݤ�Gq�k>����լ���"gy*�0��O�C1�X��KG�G����0XR�hިTp�ʚ�R�jk�nE��ql�$�ޕ�"sb�`��K�q�j�G)��M$<#�;��;$����\���/���:���#	��/�Ą��r5 �:��J����0���4�O3�x���<kX%�hG��FqG�iw�`sض�O[�+(g;�[����J���V-���V��w��|y�SX$X��f�fŰl`5��+�w-�3�"��31�o^��͖&��S�vB�M�V�*[I��?�%�̾�he �VI�=��0��ݖťm��t?,�s�"<��|g�VGY�{n$raM!�s�����@LM/�UV�*�J��n�ѵ��5���*`�C��N2��62��mfnG;E`�6A����f�UYO� 7Ӵ����6��4���+�UN��r�P��z��*���G!�;��	�f+&Ȯ�*�Y�%`�u��+)<z�TU�-�0���3+:�6��M��p, �se�z�G�S'8m|�-�%,h��M�
�<o(�\���{&�I1tz�)��
�����	���=�(��e��*�Q�a۲E��+s��es
,w�����>�D�z�XJ(��&c\��'�v������4�����^��}����{�e�L8���6�k#o������1(p�T E+X��z|v�J��TA=��k�[f��-E2+�thR�E��S5��jY� �J�h���j�4�`	8	�����I`�nEc"�N��
Q�õ��"Z��%������ܮ����m�T �k2����뱎N��)��.P6�Z�������F���ܗ	~�2�+��T���(�(PQ��_�LE���]SQ�2��Sܗp�T ǈ]��M��v�Rh+���D/�P_ӗ�8-y��J@�]і�t�8����u-�Fu�P1�'~�`���
�-y������Afq�0C��+m^�J�3�������h�O��ͣ���Ԟ}{'w�����:6w��T%�ь��?9DBC����bstdG
Ҋ<��6���a�W��j�*� ��jC��gI��J]Lǌ����A�]�10��vw_2�wuua�O�Jݽ==}�3�u=�e�6\qUӂ+ZV��i��z���1+�Nl鶭�-���d�2�ɆY�2R�H�Y��w�����HY6�HKYw� Ŷ�H��{L���I"-��Co/X��G�bCk`R�JZ��#��hV=k;�-��LV��@O����aU���I��ٝ1+vAc1o�b(@�j�ز�GU��)�ՃY�	y'�R�@
�9K5�|�{�N`/�w�*���8p��JE�ml�uD5�J^e&�rEfH�4��|����>��b����@B��|��Ӣnp�lH༪6��� ���g6���M=�>6O���$ڒrd|`��\��z�]�^G�ƤtE���"�^W&lzG���Pи�"� �\�3u���z�F�AJ����n�n]������H=��]]��]����GR����f��[h&�c�oN��o>ɔ�f���/������y�Xgx|AwH�bQS���
�e蜜=�[yS����wS�b��uH��2Ps��T��]��+F�3>HJ)���yC�5��n�E]w��4���.6] �˂�V
��P�&BJǇv��eS%�������$�'�K�*f��i��2?��o%s����u:�+�����A�^����r��	�:U+p�m�V�0m$�b�:l��&q3�H|�cc����ڏsΞ�@yLS��Ğ�8^���X�8!MLȻ��Gvd��`U$�Q�S�H��H�$a|h2 �rQa%^V䎡�������Α}{���.'nY��h�|ܛ��(������R_���o_w��%���t��}=����� !����*�n�߸�Z�2���;�Z�W߇��~T`_'����|���f��>&�e�q~�`����)�l'�[��a/o#tl������x;~�������㘀��� ��~�a�����K��\�\�˹^�I(f�TLZF��8�1G�{�;>���w8>@�K3S�637��k�����V���?jq�]>�Pd���s����8��g�����'nj�����_:r�?W���^�ڛ�QX�[m��S!8����os�75D�|����!����!��!��C0�9���e=/ydr���:�Yp0N�,�:���*��iq2��C����Ayܡ,+��Z��̊��4���􂜯V�)��y��X����	��b�7I�f[D��i�h���Z�T�!��
��:�98(w%{��ё�r&������FB���V̙��w�ۑ��>�s�X:4�&���X!�� 
�'`!ű��u/�@�k�����֍��lĺ��7ҏ5��֟x;E��ێ�9�:�h�Νj�<wr���_4^�4�ۓ���\x��/6���@��@{6��J��T��D�}<О���ٳdn�lk�o�Dg�[)�C��K��/%+ȩƊ������W!vn�u�w�S���ɹ}��	?�s�)�_�y�@�,Z4k	�L�-'�����V/��'�/c+"���ةF����������|l�۱��H��������O���?Ӊ:i�/����}��I�)F޾���̹9�ٕ����h��h;�Ov%�n=���W�,�H{�#�2f϶�y�jX?����ךFK��\�۰�>1G��������~�m�qB����<h�����$�	�1~2>nq��l�G�.��0��cH���o����^ O�9w��ՙ��t�/�3�w�!=c���8��m��M�#�k�c�/=�����w�:���ás�Y�w�j���[�ݷ:\�ĺhh��Nh�@���9>s�'8���O����7�?���(�JK���ݯ~�;��jot���v/D6̞EZ�=�I��>�;V�i<�e1�D���oOܹ{�t���`�j�1�����h�@�9������cyȮ�p]D�4��`�/�:������KgfMc���$�^����O��&�V ��zw�n�]�Xg��n����s�W��.�������\cR{cd���<�n�;}1	|���˄̞�:�uHh��$�tm<�Ă�os�������]� O��3vG`������p,��$ݽ����0珀������E�7�|��/�		�{���Iuv~t�Tct�Tc��ɹec'�O�s�����S��%�VNϿ����ֱ��?{V���Bk��@^�w#�ƶ�dr�ǋ�w �����{>����\���/a����ӧ�ۯ���1<K�.,��t���a,/.�3��L�?<[1����K�F�篘��!<���
��:��\X4��<��"��^s���kw��[g�
~��"<_��Gn�����C�y�d�S_X\4NC�"��g���?���%�PF��+}���fz�bUs�����d&!�?UPsk����b����7� �,�"���\�K�/on��U����VᶖN�v�Ț���(��U��Jj��u�m��*Iꆭ&��$leځ��Z2W� ��
�A%�*�d���<^�&�8?v42�L��t�Q-�8 d�I[���E  e����$��$���M�0C�jIfo��SVLS�sN��H�d�(-
 ��YI:�.p��m�Z�fCN�t�v�z-�-k̃��W=�g��xp+�_�`~���a~�r�[��է=����=�FV�������Յ۽��������j����oz0���`����+Y�����V��1�W�z�w��z0߭q���oc�.�d���N���E� ��wV+����?_���	���?؇��!������~,4�o[���V �8��<��{�3�o���ז��+D?�7D���_ �#����x���o,��Cx���.�˚�5��?��v�_��>��츝��z���L
>7&�� �a��]��үӓ��������~O�����]O����aH��/o�[�����χ��h3|ރc�OC�#��%�<_���z@�O�U�/���ޝ��?�뇄�&�g5yG��� ��B���G��.�~G}��p�� ��� �6��ke��D6��.��������������T�9��M�NbE���
�S=D�+��0�}9����P�?�������fH�D���2��>jx�����������>
�Bx%[-��ʹ�����|�@^t��!�/�4��� ������[���3��[���������W����wy�����[�x�
�C�O���q:�O)f�y�����R1�U*�t�[� o�R� ��+WG���J�,R�rQ�:Ru�jږ]+�y"��ˣ#��L�g>ٮ�y|���]�\0�鲑S�r�����f�Kղj���t�{i"�ϾdH��:a�\�U*u`	@���9��*�|�J�r1�Ic�����C{w�3$3�m7I)yǃ{��6cس!�w���>0*����'�����bު1�/� �ɣ+L��E �Ǧ�RLGX ��;���K��Rz�:�����U��'P����D~mF6?��ːK�^ �񍵉vd4]�Yj�yj]b$t
�ʗ~�����6I`�����}CzެWm�����!ao������g�<At��GIq���
ې
~��FTS�B��XP�B4�$�@ �w�����%��%�\��s���y�x\d@J.��mq�`�(]�w���ޮiHv���z�g@�b��N%�E٩�X�\fO����}��D�s����3hU�aM��C;ă�xb��7R��s�&9b��.����.�c��jd��hɼ�����3t�%�{3ڏ}.�P}3n�������$�=����%�wڊ�`��NQP?���hq��e`x8�r~f2ީ�!o�(���wF�z����*o߹�!W𮄗�z��'�x7&�N;����25�� a9��/����=�����q���J2v��������x��x�;���6ʇ�!�J���+�O|��}��³����
<H ��j�0��t1�E)�2o�6��9S�xbx�X��>���f!���k�#���r8���p8����D P  