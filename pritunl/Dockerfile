FROM ubuntu:16.04

RUN echo 'deb http://repo.pritunl.com/stable/apt xenial main' >> /etc/apt/sources.list.d/pritunl.list &&\
    apt-get update -q &&\
    apt-get -y install apt-transport-https &&\
    apt-get update -q &&\
    apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 &&\
    apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A &&\
    apt-get install -y locales &&\
        locale-gen en_US en_US.UTF-8 &&\
    dpkg-reconfigure locales &&\
    ln -sf /usr/share/zoneinfo/UTC /etc/localtime &&\
    apt-get update -q &&\
    apt-get install -y software-properties-common python-software-properties &&\
    apt-get install -y pritunl &&\
    apt-get install -y iptables &&\
    apt-get clean &&\
    apt-get -y -q autoclean &&\
    apt-get -y -q autoremove

ADD start_pritunl /tmp

EXPOSE 80 443 1194

ENTRYPOINT ["/tmp/start_pritunl"]
