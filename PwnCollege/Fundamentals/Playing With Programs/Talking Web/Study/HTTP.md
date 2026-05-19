

## HTTP

- Hyper Text Transfer Protocol (HTTP).
- Protocol used for the communication and transfer of message between devices.
- HTTP is later upgraded to current HTTPS (more encrypted).


## HTTP Status Codes

- `1xx`
	- Informational  -> not used, but reserved for future use.

- `2xx`
	- Success -> action was successfully received, understood and accepted.

- `3xx`
	- Redirection -> Further action must be taken to complete the request.

- `4xx`
	- Client Error -> The request contains bad syntax or cannot be fulfilled.

- `5xx`
	- Server Error -> The server failed to fulfilled a valid request.



## Full HTTP Request: GET 

**Example**

```
GET /greet HTTP/1.0
Host: hello.example.com
```


## Full HTTP Response: GET

**Example**

```
HTTP/1.0 200 OK
Content-Type: text/html; charset=UTF-8
Content-Length: 39
<html><body>Hello, World!</body></html>
```

### Head
- Contains the metadata of the response.
- Must not contain the body of the response.
- Example -> **Content-Type: text/html, charset=UTF-8Content-Length: 39**


#### GET
- Retrieves information from the target site or link or webpage.
- Does not make any modification to the target website.


#### POST

- Makes modification to the target website.
- So further **get** requests of the particular info will display the modified data made by the **post** request.
- For example: when a user submits a form, that new data gets registered to the destination server. During such a situation **POST** request is made.



