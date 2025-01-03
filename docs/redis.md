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


In your Redis configuration file, the lines:

```
save 900 1
save 300 10
save 60 10000
```

define the conditions under which Redis will automatically save its data to disk. This is crucial for data persistence, meaning that if Redis restarts, it can recover its data from the saved file instead of starting with an empty database.

Here's how these lines work:

* **`save <seconds> <changes>`:** This directive specifies that Redis should save a snapshot of its current dataset to disk (in a file named `dump.rdb` by default) if at least `changes` number of keys have been modified within the last `seconds`.

* **Breakdown:**
    - `save 900 1`: Save the dataset if at least 1 key has been modified within the last 900 seconds (15 minutes).
    - `save 300 10`: Save the dataset if at least 10 keys have been modified within the last 300 seconds (5 minutes).
    - `save 60 10000`: Save the dataset if at least 10,000 keys have been modified within the last 60 seconds (1 minute).

**Why these settings?**

These settings provide a balance between:

* **Data Persistence:** Ensuring that data is saved frequently to prevent data loss in case of a crash or restart.
* **Performance:** Avoiding excessive disk I/O operations, which can impact Redis' performance.

**Important Notes:**

* These are default settings and can be adjusted based on your specific needs and workload.
* Consider enabling AOF (Append Only File) in addition to RDB for enhanced data durability. AOF continuously appends all write operations to a file, providing a more granular and up-to-date recovery mechanism.

By understanding these configurations, you can fine-tune Redis's persistence behavior to suit the specific requirements of your application.
