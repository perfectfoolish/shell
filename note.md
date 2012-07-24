Learning shell begin with TLCL shorted for <<The Linux Command Line>> and translated by Peter and billie, a good book for beginning and helping me to be a shell thumb!


# dpkg
this is how to check what files are installed

    dpkg -L tig

# apt
this is how to remove a pkg

    sudo apt-get remove tig

this is how to remove a pkg including its conf files

    sudo apt-get purge tig

# happygrep
how to full text search

#查看内核
dpkg --get-selections | grep linux-image
sudo apt-get remove kernelname

# zless
zless 可以显示由gzip 压缩的文本文件的内容

