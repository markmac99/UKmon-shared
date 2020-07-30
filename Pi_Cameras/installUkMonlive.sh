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
� �"_ �:��u=���w2+i1R�f�����I�w:��$]t�T�������A�;[3���,!���H��b�GG>�rUd'�Ue���vR���T(ʾ;i��N��(.J���{vfG�1�Je[��~�^�~�u���=W��hی�nf�ʓk���z���L�t%�%��d*ER=�dGOO:t�TWG����>U,[5)%e��tW��M�nMT,31��ZiW�|(���zɦK��B���ա}!
I��*����P�z��c���~(���?,� �� �L��C�R�`�ҽڸ�� k�[-j�u��4��ڸZ(@�����r�i��T��i/�͊F
;���~9S���w�)��JjQm,-Ko��������݆�n[�|����l�XF˨�n&���L���҂11��TEi��w��4�����.�Z��Dc�w{1��6z�g��fk�I�R����LZA�]s3���%ćZ�������ڛ�`lӝ�bֱx��玼|4�6�@^���X��+�%�e[7JVhoǦ.%�[{�̌�5����h4EuǢ����b5%W���ҋ�^�s�t�].�"c+&iu�Ļ�><�<c��
eK*�ӕi���aF��n���h4���fX���9;�5JZgqȘp�6�m�	+t%%����υ�4g�kբ��
��.��/�Tt�vTl�,�]�2:�"���6�,�V36Y`��_�)�-M ����ر�m¶��JV�� ,��3?0����jy�h,�N��^Y^X�(rw�?�.���wV�mu�E�9�F�Q0!gV��1��ά����^d4�L;�ɐ�mJzFJ��\P�!@q#�LM;�^��\�(6��e�ֲ����~����*��I����{`�L����W	?~�|�Su�nz��2��������f�� dWL��,�0�)���U��5��[@tt��gV�։[��1.�&X.� r͔u�u��w�F��[@JXв���>y�Y�Tfs힪�9��e��姬?+X1V͎�x�?bH�����UtT/jFņm�j��5�2��Wa�_�}�k���F�D�/��&c\����Nv�������;�����_wOO���q$��aT��}�Q1�\r��8����e-�N:�A�3}�
�(T���d���.����j{�
Ė���B�E:=4�;C�L�d�~������� ��j�2xKF����"*W�|���@��Sv����l�`�7�v&?8h[���I�Hy"T6����*:�#�*��U�[�� �ʖ����80r��X-:�l	�Ǳ,�p��X(k_�1�/ӻs,�Q0������)���v:dR1�-`�b� �����ڱP���.z���E}L�ci`�8���7׻-�/kP���"���ÁPq�3�	�-���;Z�\�y�O�>)[�6��LD�M�wY�m;��nID���HD�SXݲcP�MF�u����@�#4�y �4�mݔ��!Ú�b%&dX���*�C)B!u/��W�GlhZ��]b�w�1%."�_�u����;;/��;::��/ٝ����b�?M��1�����G3-���ʩxR�Z)c`��+�����=BwWr�����3�vJ��d:�+㞔�.�+��(�l��Q��^w"� Ŷ�L�^��wQJ�4g�Ç�n���m�j���Q�����n�>��� g%c�;e���{�В)�z��Y8��ⰼdvg�;���ײ:�3r�����5KTY@�lA��+w"!o�Q
:pg!Sc��LP��ZG��>����80+�bQ+�X��fԌ�T�1E��Qf�#����^{�U;ǎ:��Ns%�kd`%�+�j	��*Zf�L��X��a�^������U�\�\�-XvĻ˵��Y�.f��vx¦LS��1��.b
��4�:-���դ8;��Z��q��?Փ��d�gO�#ž�$�R���q����%I��rA��&�tB��M��D�t���BV"��l�B��@��I�fȝ,K,3��	|qf�e��&R#�C����E�[y[���p���E| ~���,����ˑqX�,��	�MܯT��B���aȉ�>�(d!x+U&c�Y���� �XH~��]¦�/����_�+����Ͻ>��{���z�;[��N?�P`��w��XG�ֆc�{n�s�~fe���%����6|�������_��3+�{���~���r|�{o�� �������_����?������kL`&2�B˧��ut����لn�	;�m�`��Qu��E� ���.E!�}{���n��Z�f���j긮TJ{�RVɔ�J�L����X��)O|�'{ȏrŶ�:n�6�! E�hi6pÎB����ȽJG���;�u〒�w
��7���W?�����]�M�"�?�~�=(�"����� �Q(?)�%,�;��5X>�%,�N,�#d-�-�ϰ\LH�0rK_��!?n9t�l�L��4s����#3-���z�:���G�¯<9w����N������>��?�?�?���'�~|�4��>���%tz���<$V�|���r��F�UےǪ?����9ȯ���.��e�#�X5�<2���;!;Of>!����;4KϢ�@�� ��L3A���|>1;vn0[G�ǪQ���c3�K�g��屙�"��߰�_l����2���(����߭|i��ȟ$�bt`�[�N�������u ���F[9�%�v��ߙ��6&��H�xL�nI�JX?��
�׊j0|x&��'ϐ�T%2=;��� �!NJ>>�<�O ��'BVT�<:֟�=;?��5�ȏ�^��a��ǐ69=�M��#O�<{�Ǒ���d�. 38�w�>9���Ȇ8�=�:B�:��7�ޓ�C� �pR�]D�E]D�9���o�ӳ}���ØX����u�P�a3�~��_lr��~����G�6������`��ϲ�j��Z=|��s�5ӧ����O�be+��s^��K�&�k�÷�?�2�c0��f�����,�$QyK�~��p�h�������*�%t��W�e8?r�z�yiO��t�������X ���$h%��/wd{���2�(w0<={�ed_�C�]>K[����l}Rku x���<��o;	m�؜��W�>�h��P���H�*�[��o�#�r
eemo8��>M�� ��1P��/���p,��$�es�m0珀������<�e>,��k�oA t~ �6)O����6��Y4|d�yL��M�����C�A�����O�4o�#}ӧ��/�5%�Y����x�aз5������oڳO���d���\��������C���}��{� ��c��O:���0��I��"I��nƳ�>���$o�x��q�
�㻛� x����¼q�L�_O$ӽ0�ro@n����?����-�ǋ��ȍ��%V?%�Ap$�墼0?o��y(�/�q��A7���u�	HC�畲7A<��ޱS���Z���u�t,��\V_[I��S��w�R�y���a��."��Eݤ��EZ,�˚�K���`�t�ts`Ep�$K$nMmuJ��eީ��2��[��o���	M�*�����%ʫV�ĳS%��K����U(�3���J�`�	�mm~s  ��?j �����ЌR񪞝$q-����SQMS��=��#�	��` c�pܲH\�.q��m��xņ�v��)�zAq���|��5�G�Gkp+_���6�����嬷 ����kp+���Ŭ<_��{M_������X�j^�J��+��`~�9W�yD�A^��H��[��^�ʕ58�JZ��n���Os~m|#+���vV����7����+�wg5����G��~���q�G?�������3ؑo�þ��"���{��������6^+�߬��)������g<����A\�K`�_��k|���{���\ءbQ���<���G=����N��f��7?;nb��5�!��������������k��[N�$��0ӿ&�M�ςr��Y�z��������pS�����E������0�K�����џ
���kؿ�>R�g�[Ʌ�tD|���埤��C|�^��󳜼#��[���3����w�K��Q^�<lc�?�?�W�~ML�%d�{첻����?)����;�a�O���P�o'V���`?M���3z���|�[����߷|��������Y��?K�ΣF�>���_
��>��#+���ë>�
��7t�#�?��-yI�G|�_	���O �����ǋA�?�J���g|���}��y�����o�π������T�u��O��y��T'2��j�$�$,�s	�����AƴSq�D�$�~4�t`�Qe���Vr���k	���eWr�x�(�};���#��B�g>�.*|���M��5���1������V&	�K�fk���d�sa"ō���)�"4%[)���RܠM�:T�r�h�\)����ٿm��y�&|�d*9�:.Y�lz`{�����lH�{�vl�Rv�lUF�7mV��ŌUa�_�A�G��1��4� ��U�������;���K��Tr�6����j�3#(�g|���?��#�k��e(y���񍵎v� ��%�biY�Ժ�Hh�/��=�#,����fC����ͥ�9U�QG��0�kC��t� �i�7���⵸^`�(gQ\�M���M�G��\ǆi{�	��e�S�o2�.:uN�U��t��	�cNr�W�C���2����7���]�G%޶�C��=�
~x�x�f�6"��˯~� �KN��گǯCv��x_y:��y7�wj��=�8���ی�ǣ��6�ߜ���W�t	�����=ҵy���8����������K:~'䐏��:<_��p������a��f��[[=�w���}&��|/x�0<w	��s��a�|S�����^���8/���t�'��q-�o������bH��k.A�C1.�a�H/Aw�p�!���~wt�О?����1�ƿ�z�a����-m����/�����9��Qw��#�&f� ���~���i?���.�#�����9sқ0���A|�w�.�����	�"�%����������������������o�ri�� P  