



# # PopMenu

##   Data Modeling

Please find below the data modeling for the database:

![image](https://github.com/user-attachments/assets/c8ab5f83-72c1-4bf7-8e37-75b68f78dab6)


## Running server

* To start the server, simply execute the command below:

  ```
    docker-compose build
    docker-compose up
    docker exec -it pop_menu_web_1 rails db:create
    docker exec -it pop_menu_web_1 rails db:migrate
  ```

## Running tests

* To run the project tests:

  ```
    docker exec -it pop_menu_web_1 bundle exec rspec ./*
  ```
## Swagger
If you need any details about any of the endpoints, you will find them in the docs through the  `/api-docs/index.html` endpoint.
