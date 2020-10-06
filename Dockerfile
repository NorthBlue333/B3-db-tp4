FROM mysql
ARG MYSQL_ROOT_PASSWORD=root
RUN apt-get update && \
    apt-get install apt-file cron logrotate bzip2 -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /backups/databases && \
    echo "0 17 * * 1 root mysqldump -u root -p$MYSQL_ROOT_PASSWORD --all-databases | gzip > /backups/databases/databases_cron_`date +'\%m-\%d-\%Y'`.sql.gz" >> /etc/crontab && \
    service cron start && \
    touch /backups/databases/databases.sql && \
    ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime && echo "Europe/Paris" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata
COPY ./logrotate.conf /etc/logrotate.d/databases
RUN chmod 644 /etc/logrotate.d/databases
CMD ["mysqld"]
