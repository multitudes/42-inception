# Redis

Its main purpose is to store data in memory, which makes it a lot faster than traditional databases. It is also a key-value store, which means that it stores data in a dictionary-like structure, where each key is associated with a value. This makes it a great tool for caching, as it can store data in memory and retrieve it quickly.

In this part of the project, we will build a whole container for Redis, and we will also use it to cache the requests made to the API. This will make our application a lot faster, as it will not need to make requests to the database every time a user makes a request to the API.

The standard port for Redis is 6379, and we will use it in our application. We will need to update our docker-compose file appropriately, and we will also need to update our application to use Redis as a cache.



To make sure Redis is working properly, you can use the `redis-cli` to connect to the Redis server and check if it is working properly. You can also use the `MONITOR` command to check the server's status.


```bash
docker exec -it redis redis-cli

MONITOR -
```

Then, go to your wordpress website and edit or add anything: posts, comments, themes, etc. There will appear all sorts of logs in your terminal. 
