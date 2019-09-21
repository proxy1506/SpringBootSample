#Dockerfile to build reviews and ratings docker image
FROM centos:7.3.1611

ENV     JDK_VERSION="jdk-8u161-linux-x64.rpm" \
        java_version=jdk1.8.0_161 \
        jdkpath=/usr/java \
        JDK_INSTALLER=/tmp/devops/docker-addons/jdk_installer \
        JAVA_OPTS="-server -Xmx512m -XX:+UseG1GC"
				
RUN 	mkdir -p /etc/selinux/targeted/contexts/ && echo '<busconfig><selinux></selinux></busconfig>' > /etc/selinux/targeted/contexts/dbus_contexts

RUN 	yum -y --nogpgcheck install wget which && \
        wget https://storage.googleapis.com/devops_docker_vol/jdk_installer/jdk-8u161-linux-x64.rpm && \
		yum -y localinstall jdk-8u161-linux-x64.rpm && \
		rm -f jdk-8u161-linux-x64.rpm && \
        alternatives --install /usr/bin/java java /usr/java/$java_version/bin/java 100 && \
        alternatives --install /usr/bin/jar jar /usr/java/$java_version/bin/java 100 &&  \
        alternatives --install /usr/bin/javac javac /usr/java/$java_version/bin/java 100 &&  \
        alternatives --set java /usr/java/$java_version/bin/java && \
        echo export JAVA_HOME=$jdkpath/$java_version >> /etc/profile && \
		wget https://storage.googleapis.com/devops_docker_vol/fuse/gcsfuse.repo -O /etc/yum.repos.d/gcsfuse.repo && yum -y install gcsfuse && mkdir -p /var/log/logback && \
		wget https://storage.googleapis.com/devops_docker_vol/certificates/cacerts -O /usr/java/jdk1.8.0_161/jre/lib/security/cacerts && \
		yum -y remove wget && rm -rf /tmp/devops && yum clean all && rm -rf /var/cache/yum/* && \
		cd /tmp && rm -rf devops && rm -rf myproject-0.0.1-SNAPSHOT.jar

COPY    target/myproject-0.0.1-SNAPSHOT.jar /tmp
        

VOLUME	["/sys/fs/cgroup"]
VOLUME  ["/usr/java/jdk1.8.0_141"]
EXPOSE 	8888:8080
CMD 	["/bin/bash"] 

ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /tmp/myproject-0.0.1-SNAPSHOT.jar" ]
