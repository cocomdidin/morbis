


# ------------------------------------------------------------------------------
# Dockerfile to build basic Oracle Linux container images
# Based on Oracle Linux Debian
# ------------------------------------------------------------------------------

# Set the base image to Oracle Linux Debian
FROM debian:jessie as oracledb

# File Author / Maintainer
# Use LABEL rather than deprecated MAINTAINER

LABEL maintainer="https://hub.docker.com/u/fajarneta"

# End

ENV ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server
ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib
ENV PATH=$ORACLE_HOME/bin:$PATH
ENV ORACLE_SID=XE
ENV TZ=Asia/Jakarta

ADD ./build/env/oracledb/oracle-xe_10.2.0.1-1.1_i386.debaa /
ADD ./build/env/oracledb/oracle-xe_10.2.0.1-1.1_i386.debab /
ADD ./build/env/oracledb/oracle-xe_10.2.0.1-1.1_i386.debac /

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y \
       bc:i386 \
       libaio1:i386 \
       libc6:i386 \
       net-tools \
       openssh-server && \
    apt-get clean

RUN mkdir /var/run/sshd && \
    echo 'root:admin' | chpasswd && \
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    cat /oracle-xe_10.2.0.1-1.1_i386.deba* > /oracle-xe_10.2.0.1-1.1_i386.deb && \
    dpkg -i /oracle-xe_10.2.0.1-1.1_i386.deb && \
    rm /oracle-xe_10.2.0.1-1.1_i386.deb* && \
    printf 8080\\n1521\\noracle\\noracle\\ny\\n | /etc/init.d/oracle-xe configure && \
    echo 'export ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server' >> /etc/bash.bashrc && \
    echo 'export LD_LIBRARY_PATH=$ORACLE_HOME/lib' >> /etc/bash.bashrc && \
    echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/bash.bashrc && \
    echo 'export ORACLE_SID=XE' >> /etc/bash.bashrc

RUN cd /home/ && mkdir database

EXPOSE 1521 22 8080

CMD sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" /usr/lib/oracle/xe/app/oracle/product/10.2.0/server/network/admin/listener.ora; \
    sed -i -E "s/HOST = [^)]+/HOST = $HOSTNAME/g" /usr/lib/oracle/xe/app/oracle/product/10.2.0/server/network/admin/tnsnames.ora; \
    service oracle-xe start; \
    su -c "$ORACLE_HOME/bin/lsnrctl start" oracle; \
    echo "alter system disable restricted session;" | sqlplus -s SYSTEM/oracle; \
    echo "EXEC DBMS_XDB.SETLISTENERLOCALACCESS(FALSE);" | sqlplus -s SYSTEM/oracle; \
    echo "ALTER DATABASE DATAFILE '/usr/lib/oracle/xe/oradata/XE/system.dbf' AUTOEXTEND ON NEXT 1M MAXSIZE 4096M;" | sqlplus -s SYSTEM/oracle; \
    /usr/sbin/sshd -D
