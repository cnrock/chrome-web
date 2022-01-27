# Pull base image.
FROM tekfik/os:centos7-systemd
MAINTAINER <Jie.Wan - wanjie.info> webmaster@wanjie.info

COPY system /etc/systemd/system/
COPY yum/google-chrome.repo /etc/yum.repos.d/

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; yum -y update all; \
    yum -y install tigervnc-server-minimal novnc google-chrome-stable alsa-firmware alsa-lib alsa-tools-firmware; \
    yum -y groupinstall chinese-support; \
    yum -y groupinstall Fonts; \
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8; \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
    yum -y clean all; rm -rf /var/tmp/* /tmp/* /var/cache/yum/*
ENV LANG zh_CN.utf8
RUN /sbin/useradd app;cd /etc/systemd/system/multi-user.target.wants; \
    ln -sf /etc/systemd/system/tgvnc.service tgvnc.service; \
    ln -sf /etc/systemd/system/chrome.service chrome.service; \
    ln -sf /etc/systemd/system/novnc.service novnc.service;\
    cd /usr/share/novnc; rm -rf index.html

COPY index.html /usr/share/novnc

# Define working directory.
WORKDIR /tmp

# Metadata.
LABEL \
      org.label-schema.name="chrome" \
      org.label-schema.description="Docker container for Google-Chrome" \
      org.label-schema.version="Centos7.7"

#EXPOSE 3000

CMD ["/usr/sbin/init"]
