# NestJS API

## Installation

```bash
yarn install
```

## Running the app

```bash
# development
$ yarn run start

# watch mode
$ yarn run start:dev

# production mode
$ yarn run start:prod
```

## Test

```bash
# unit tests
$ yarn run test

# e2e tests
$ yarn run test:e2e

# test coverage
$ yarn run test:cov
```

## Prisma

Create and apply migration

```bash
npx prisma migrate dev --name init
```

Generate prisma client

```bash
npx prisma generate
```

## Environment Variables

The following environment variables need to be set for the project to function properly.

| Environment Variable | Required | Description                                         |
|----------------------|----------|-----------------------------------------------------|
| `DB_URL`             | YES      | The connection URL for the database. This is used by Prisma to connect and manage the database. |
