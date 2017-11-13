To start the application, enter the following commands in the terminal in the application directory:

## Run application:
`docker-compose build && docker-compose up`
## Create database:
`docker-compose run web rake db:create && rake db:migrate && rake db:seed`

After that, the test data application will be available at `localhost:3000`

# Test accounts:
`admin@test.com/12345678`

`client@test.com/12345678`