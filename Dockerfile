FROM debian:buster
RUN mkdir /root/src

COPY src /root/src
WORKDIR /root/src
RUN bash bash.sh
RUN ["chmod", "+x", "/root/src/service.sh"]
ENTRYPOINT [ "/root/src/service.sh" ]
EXPOSE 80 443
