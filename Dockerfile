FROM node:19-alpine as builder

COPY ./package.json ./yarn.lock ./

RUN yarn install

COPY . .

RUN yarn build

FROM public.ecr.aws/lambda/nodejs:18

COPY --from=builder /dist .

CMD [ "production.handler" ]
