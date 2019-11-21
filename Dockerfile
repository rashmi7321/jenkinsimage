FROM centos:latest
RUN yum -y update \
        && yum install -y \
                java-1.8.0-openjdk-devel \
                git \
                wget \
                initscripts \
                vim \
                sshd \
                net-tools \
                docker \
                tcpdump \
                gem \
                e2fsprogs \
                telnet \
        && yum clean all
ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
ENV JRE_HOME=/usr/lib/jvm/jre
RUN wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo \
    && sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo \
    && wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo \
    && rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key \
    && yum install -y apache-maven jenkins
ENV JENKINS_HOME /var/lib/jenkins/
ENV JENKINS_MIRROR http://mirrors.jenkins-ci.org
RUN mkdir -p $JENKINS_HOME/plugins \
    && curl -sf -o /var/lib/jenkins/jenkins.war -L $JENKINS_MIRROR/war-stable/latest/jenkins.war
ADD ./dockerjenkins.sh /usr/local/bin/dockerjenkins.sh
RUN chmod +x /usr/local/bin/dockerjenkins.sh
VOLUME /var/lib/docker
EXPOSE 8080
EXPOSE 22
ENTRYPOINT [ "/usr/local/bin/dockerjenkins.sh" ]
