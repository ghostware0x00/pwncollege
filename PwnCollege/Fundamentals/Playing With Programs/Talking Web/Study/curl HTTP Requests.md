

## Sending HTTP requests

```bash
curl <target_ip>/<domain_name>
```

- sends http requests using `curl` command.
- returns response from the server.
- running against a normal website will return the website's source code.


## Sending POST requests

```bash
curl -X POST <target_ip>/<domain_name>
```

- sends post requests using `curl` command.


## Changing Headers


### Changing User-Agent

```bash
curl -H 'User-Agent: <user_agent_name>' <target_ip>/<domain_name>
```

- user agent is the web browser or the software which generated the request (here: `curl`).
- `curl` can be used to make it seem the request was by something else.


### Setting Cookie

```bash
curl --cookie '<name>=<value>' <target_ip>/<domain_name>
```

- `name` = cookie name(as you please)
- `value` = cookie value 



