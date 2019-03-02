#!/bin/bash

if [ ! -x "/usr/bin/wget" ];then
    echo "Please install wget!"
    exit 1
fi

systemctl stop firewalld && systemctl disable firewalld

sed -i "/^SELINUX/s/enforcing/disabled/" /etc/selinux/config

setenforce 0

mkdir -p /etc/yum.repos.d/bak
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak

wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

yum install epel-release -y

yum clean all && yum makecache

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

yum install ntp ntpdate -y

systemctl restart ntpd && systemctl enable ntpd && systemctl status ntpd
