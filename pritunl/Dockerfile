FROM ubuntu:20.04

RUN apt-get update -q &&\
    
RUN echo "deb http://repo.pritunl.com/stable/apt focal main" | sudo tee /etc/apt/sources.list.d/pritunl.list

RUN apt --assume-yes install pritunl

RUN echo 'deb http://repo.pritunl.com/stable/apt xenial main' >> /etc/apt/sources.list.d/pritunl.list &&\
    apt-get update -q &&\
    apt-get -y install apt-transport-https &&\
    apt-get update -q &&\
    apt-get install -y locales &&\
        locale-gen en_US en_US.UTF-8 &&\
    dpkg-reconfigure locales &&\
    ln -sf /usr/share/zoneinfo/UTC /etc/localtime
    apt-get update -q &&\
    apt-get install -y software-properties-common python-software-properties &&\
    apt-get install -y iptables &&\
    apt-get clean &&\
    apt-get -y -q autoclean &&\
    apt-get -y -q autoremove

ADD start_pritunl /tmp

EXPOSE 80 443 1194

ENTRYPOINT ["/tmp/start_pritunl"]
