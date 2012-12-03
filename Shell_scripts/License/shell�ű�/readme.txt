ceict-server-time.sh        启动时检查是否过期
ceict-server-time-repeat.sh 每隔固定的时间检查是否过期
cronfile                    时程表
test.sh                     每分钟执行的脚本测试

自动生成的文件：
ceict-server-start.bat      记录首次使用时间
test.data                   每分钟自动执行test.sh写入时间
                  
1、设置使用天数：ceict-server-time.sh脚本中的((TIME_DAY=30))设置成使用天数

2、脚本的使用
    a) 将脚本拷贝到/var/lib/asterisk/
       chmod 755 ceict-server-time.sh
       chmod 755 ceict-server-time-repeat.sh
       chmod 755 test.sh     --测试用
    b) 在/etc/rc.d/rc.local中添加下面两行以便开机自动运行：
       /var/lib/asterisk/ceict-server-time.sh
       /var/lib/asterisk/ceict-server-time-repeat.sh
    c) 下次重启时，会生成ceict-server-start.bat记录第一次运行时间