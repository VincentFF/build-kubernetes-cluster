FROM images.potato.im/pt/base:v1
WORKDIR /data

COPY ./impush /data/impush
COPY ./sql /data/sql
COPY ./apns_key /data/apns_key
COPY ./scripts /data/scripts
RUN chmod +x /data/impush 

RUN chown -R 1999:1999 /data

EXPOSE 13302

USER 1999
ENTRYPOINT ["./impush"]


