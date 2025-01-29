FROM node:22-alpine AS base
WORKDIR /app
COPY . .

FROM base AS build
RUN yarn install --frozen-lockfile
RUN yarn build

FROM base AS prod-deps
RUN yarn install --frozen-lockfile --production

FROM base
COPY --from=prod-deps /app/node_modules /app/node_modules
COPY --from=build /app/dist /app/dist
EXPOSE 3000
CMD [ "yarn", "prod" ]
