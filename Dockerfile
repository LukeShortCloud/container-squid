FROM centos:8.1.1911

LABEL maintainer="ekultails@gmail.com"

COPY entrypoint.sh /sbin/entrypoint.sh

RUN yum install -y squid && yum clean all && chmod 755 /sbin/entrypoint.sh

EXPOSE 3128/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]
