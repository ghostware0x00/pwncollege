

## HTTP 

- Its a stateless protocol i.e. it will treat each request from the client as a new one without maintaining or storing any session or data of the user.
- **Problem**: After we login and sent further requests it will treat them as new ones since it doesn't remember you are logged it because http is a stateless protocol.


## HTTP Cookies

#### Solution to HTTP's stateless behavior

- Using HTTP headers for maintaining state.
	- The server sets **cookie** as a response with the header. **Set-Cookie**
	- The client includes the cookie in future requests with the header: **Cookie** 
	
- **Cookie** Headers help keep state information.


#### Authed: Login Request

```
POST /login HTTP/1.0
Host: account.example.com
Content-Length: 32
Content-Type: application/x=www-form-urlencoded

username=Connor&password=pass123
```

- The user **Connor** is trying to login to a server using his credentials `username = Connor` `password = pass123`, so a **POST** request to the server is made.


#### Authed: Login Response

- **Set-Cookie** header added to the HTTP response.
- The state maintenance will be done through **cookies** for further requests.

```
HTTP/1.0 302 Moved Temporarily
Location: http://account.example.com/
Set-Cookie: authed=Connor
```


#### Authed: Redirect Login Response

```
HTTP/1.0 200 OK
Content-Type: text/html; charset=UTF-8
Content-Length: 39
Connection: close
<html><body>Hello, Connor!</body></html>
```

