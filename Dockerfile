FROM ubuntu:precise

RUN apt-get update
RUN apt-get install -y apache2 libapache2-mod-php5 curl build-essential libpq-dev php5-pgsql
RUN curl -L -o pgpool-II-3.4.0.tar.gz http://www.pgpool.net/download.php?f=pgpool-II-3.4.0.tar.gz
RUN tar zxvf pgpool-II-3.4.0.tar.gz
WORKDIR /pgpool-II-3.4.0
RUN ./configure
RUN make
RUN make install
RUN ldconfig
RUN rm -rf /pgpool-II-3.4.0
RUN rm /pgpool-II-3.4.0.tar.gz
WORKDIR /var/www
RUN rm index.html
RUN curl -L -o pgpoolAdmin-3.4.0.tar.gz  http://www.pgpool.net/download.php?f=pgpoolAdmin-3.4.0.tar.gz
RUN tar --strip-components=1 -zxvf pgpoolAdmin-3.4.0.tar.gz
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV PG_REPL_USER docker
ENV PG_REPL_PASS docker
ENV PCP_USER docker
ENV PCP_PASS docker
ADD ./pgmgt.conf.php /var/www/conf/
ADD ./pool_hba.conf /usr/local/etc/
ADD ./pgpool.conf /usr/local/etc/
ADD setup.sh /var/www/
RUN sh ./setup.sh
EXPOSE 80
EXPOSE 9999
ENTRYPOINT ["/usr/sbin/apache2"]
CMD ["-D", "FOREGROUND"]
