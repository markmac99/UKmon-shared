#!/bin/bash

echo "This script will install the UKMON ARCHIVE software on your Pi."
echo " "
echo "You will need the location code you agreed with UKMON, "
echo "and the access key and secret provided by UKMON."
echo "if you already contribute from a PC these can be found in"
if [ "ARCHIVE" == "ARCHIVE" ] ; then 
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

CREDFILE=~/ukmon/.archcreds

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
  if [ "ARCHIVE" == "ARCHIVE" ] ; then 
    echo "export AWS_DEFAULT_REGION=eu-west-2" >> $CREDFILE
  else
    echo "export AWS_DEFAULT_REGION=eu-west-1" >> $CREDFILE
  fi
  echo "export loc=$loc" >> $CREDFILE
  chmod 0600 $CREDFILE
fi 
if [ "ARCHIVE" == "ARCHIVE" ] ; then 
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
� ﱵ_ �Yp�u�@�)���9�Fb;~	��jƤHJ�E�,I����p<�3A �;HD�D��6nG)����S���h:�)�6�f"�N���;դ����$�\ZIkf��jF#���;��D�I9����}��}�����ۅ����܁��\6���-�(PwW�=G���$ֹ��3��Ǻ	�$�QB��ƜZ*���PJ���q�$�?Jw�/2%g#S������"J�S���\.	�6DEJ��T�'�Qi(�) ��S�&D�  �R{䌤F�tF��4t�N}"�&�h���\OR�9LeA 4JQ���A��n$�'�E�*�L�%@2��dGқ��=�LN���H��@�<�E��Z>Փ<$�P��;"��AkP��{�+rV���'�Iz�i���� ꤡ����?N�ji)K��T��j1+޴/ �0��Դ �	�Ph($͋�BJ�����&�gg5�����J2����YީH��5s�D�+eT	Ʀ;>���rv�j9���ߔP�N��_�����@r��LF? p�݊C��$������N��Otw���w�
yؔ�}RQ�e��;��]����wv��gW�>�����@����4nd���}��*�H�h8b�:2���'���� ذyI������j@��RE�͂�\ �
�e�ɴg���y��3 �3�"EIഥ�|&'�$�
�(�*���*� Go�r��8��8sYM��i��Ƹ�Y��Cp<�'���ⱥ��X@G��5@J�����Dҹ9)���8)G5�����&X+���{�<�X��f�h�Zi�j,#	�D��� �tWPUbG'L�4a�v��s�� :-+�fwX�#L�.�@,�F�jU�:�s��=��BF�4�Ǿ�~m��������~��I:=�g)�D�f����i�61�I�қiD�U�xS��{��L��{������f �ԣK��1�/��[�����Xw|GB��%�c��8�bѮX����txpd�qU�E�%Ƚ��H�[��C`:H��"(�_��~���p�<Fj����']!�C�F���t�'�Bb\[3�S�Q���Υ��P� ��E���1�����a�i����� �6ٯ���z���>H��<ɤB8b�C�2����p'1�����?`������o� �/�'3M�T��N=���_~����/��َ<������,�ӂ}<����َ虣��o��}�S����z�˟�#���-�����hǇ�=��i�C���с?��������?���������kO`fD�W��1�O��H3�
��h&��&���Dx~�8�s��	��A~���gU�T���I���B���M�b>���.b�;��)b�H0� ��:0M�M%��(�HY2'ͩ�ڰ�a
��Y�����w��#û��x8a�ѭ�u9��Տk�g�Á���F;�6�H~Yބz��@����(��ֽ�r;� �b�-��Bvb���	��zn��!��MGέzCe���m������|fX���˾��-�y�l�,/�ʧm咭���|�V~�V>b+�cy��BK+�/m��%{H��{�T��R��BN�[���߫T����]��� �C���*���]��'d|录�o��嫍���01��F2�������2��Y� ����t_}��A�s��b_ki酻�\��oa	��vc�v>�i[/ȣ��c|Gε��\��f�UĢ�Q?���q��mM��V�fS�O*o'�u���'C�7<�]��]�����:J+MQ��@�粏�����n��E?���=�H��R�Hi)	�s��� lC}ju`�Q������� NoOƗV+�߭�F}�E��l/?��hi��=��-��ϭ����6S�����ul��r�a��M�Pf��q�P?���װ��_F��|���6����������蛯��%������O�� Cm�n��8{��3��� ����������6���L����`�]0����@s����]�K+�%�����-�!���^~���}܊>	X�=z׾�&��E����SV|0>����pL,bn��>�>�zׅ��L~�1���e�f��@�z�yi����0G0'����ܨ`�����r`��n?����mF�n���t�Mlo�.�΁���2gظ�=���:�Pk���֝�:_|ξ��	)�|��1�S�$�l�8k�_y���ch�^���l�1��ø]����5�[<ێ�}�h�)o�9�����d'+�n���1v_|�+��7H��4�<U;UnL_l;�ؘ��#�%׉�R����<u��36�LzK+\輪=ѯ�7��&�o#��m�dr��Je`WO���4$�W�p�s	#��G㿎[_�rO.,�4���w�0���k�ð'NW�t��#'8�L����B|�%��e�+ơ��w�� �����Z%w�L�_ϸ8=�� <�r�Aj6��;lg�����C�ŋ���;!]qszyr���H&[��Z��[��
��θ�3n+��i)h�@#0�wJv�xf�w\P�S�������x(�PJ��Y���*�G�'B��X���a��]�� v���&n#�um�l���ܝ�6n+������	��9M��\SX�6K2>��I8�Ӥp���&��L��*���)�siAM�p��},�&9()����0<�)�8V�g4�"��&���i`@��~H�o|4�h+ʩy����"�I�%/(�Pd-��c��#��"��Lᔪ��������)h�"O4�iק�q�s���*��<_�Yz��{��B�g�1\όg�/s���=_��Mz�V�7���*�^Oz=&�\]�o��W��&=������*�n<kU�E�W�|����M^�U��1��yG���9���kV��0}-&��U�6=��[�����a�ۉ���V"�|aL?j�<d�:�_��o�y�>���9�C�MV�߷�.C_�&G|o��f��X��6��:���E�M�'��?�G�v[�x���o�aߣ6���x�tC��Fl���'m�g�f�36� �曝[uyGuo��I�����?kk�8g��8�k���B>�Y<�>���[ɋ�e��U�z�����������Z_�?�罵�Z����t��5���v�.�x�z@��j�f��������?q��8�����g��Y�7����Z7���������Gm<ʓ6�����ѭ�D�[Ǯ~�rY�'��7����)@q��gj�mDuY��f����o�����.6����������5��%��?rY�O���|Ԩ�}n���[a�����l}���9䂃Wݵ�w[�#�?��&��5���ܵ����}�g�㴛}e�����?;�Y����������7}m����y��t3�����菏3��9�B�����"��=��h�p�S$(�b�ɠN2��$����_��,jU4U+LO�E�����#��<O�g>^��E|�S�:U<���3�ܔ��SZNQy�0O \�g$MJ��F�x+��!�R�D���Tan�Mlom��A%,��D�L��M@�=�}�����|�ԇd�k��?���}�����ِ�{G��7�?�g���$?ٷ{d�7_E���QMe<Đ��(2�?%=�4��콳��z���E������ٙ1q������5x�#h�����O�9>-dS`7���`�`J��UJO���Nѣ��s����^ik4�a���������b���!��t�!�q�s�:���kq��0Q梸��#������F�>ڟ��ފ��T�7R��'�ݐ68��	��L2������<�����7����*�3Nr����Ä�=4���qp���6��7��v� �%g\�~��o@2��x_yu��ui��;5��� �^b�6c���6ux�Ys���}�?e�vv��f�{ĵ�p�[���{=ĸ����36��rā�����+P�k�^�s6��ĸ�����X���K���{ц�8p��/3\�(1Sd�'nr����a��o�dvܷ	�o���o���C��b���kn����/�0~�7���;ı���M��6}?�[��v}�~h�a6Բ�|�m�E���>s�_5����p�0� t����-�v�k%5!����Ǚsf�E���A�ʏ������%�#����/Yu�S��T�:թNu�S��T�:թNu�S��T�:թNu�S��T�:թN��� ���* P  