ceict-server-time.sh        ����ʱ����Ƿ����
ceict-server-time-repeat.sh ÿ���̶���ʱ�����Ƿ����
cronfile                    ʱ�̱�
test.sh                     ÿ����ִ�еĽű�����

�Զ����ɵ��ļ���
ceict-server-start.bat      ��¼�״�ʹ��ʱ��
test.data                   ÿ�����Զ�ִ��test.shд��ʱ��
                  
1������ʹ��������ceict-server-time.sh�ű��е�((TIME_DAY=30))���ó�ʹ������

2���ű���ʹ��
    a) ���ű�������/var/lib/asterisk/
       chmod 755 ceict-server-time.sh
       chmod 755 ceict-server-time-repeat.sh
       chmod 755 test.sh     --������
    b) ��/etc/rc.d/rc.local��������������Ա㿪���Զ����У�
       /var/lib/asterisk/ceict-server-time.sh
       /var/lib/asterisk/ceict-server-time-repeat.sh
    c) �´�����ʱ��������ceict-server-start.bat��¼��һ������ʱ��