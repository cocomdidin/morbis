FROM python:3
ENV PYTHONUNBUFFERED=1

RUN apt-get update
RUN apt-get -y upgrade

# Install libaio1
RUN apt-get -y install libaio1 

# Install the Oracle Instant Client
ADD ./build/env/oracle/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb /tmp
ADD ./build/env/oracle/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb /tmp
ADD ./build/env/oracle/oracle-instantclient12.1-sqlplus_12.1.0.2.0-2_amd64.deb /tmp
RUN dpkg -i /tmp/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient12.1-sqlplus_12.1.0.2.0-2_amd64.deb
RUN rm -rf /tmp/oracle-instantclient12.1-*.deb

# Set up the Oracle environment variables
ENV LD_LIBRARY_PATH /usr/lib/oracle/12.1/client64/lib/
ENV ORACLE_HOME /usr/lib/oracle/12.1/client64/lib/

WORKDIR /code
COPY ./backend/requirements.txt /code/
RUN pip install -r requirements.txt
COPY ./backend /code/
