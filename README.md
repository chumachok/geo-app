# Geo App
## Overview
Geo app contains implementation of simple api for performing CRUD operations on geo location data. IP Stack API is used as the source of geo location data. The app responses follow JSON API specification implemented via jsonapi-serializer gem. The application uses posgresql as the data storage. A large portion of application's logic is covered with unit tests, however additional data for verifying app functionality is provided inside testing_data directory.

## Running Unit Tests
docker compose build
docker-compose up
docker compose exec geo-api bash
RAILS_ENV=test bundle exec rspec

### testing_data Directory
## Videos
Contains demo video using REST client and running automation tests.

## Curls
To make testing easier a few curl commands are provided in requests directory.
