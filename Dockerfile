FROM node:19-alpine3.16
USER node
WORKDIR /server
COPY ./webapp.js .
EXPOSE 80
CMD ["/usr/local/bin/node", "webapp"]
