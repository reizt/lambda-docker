FROM node:19-alpine

WORKDIR /usr/src/app

COPY lambda.js ./

CMD [ "lambda.handler" ]
