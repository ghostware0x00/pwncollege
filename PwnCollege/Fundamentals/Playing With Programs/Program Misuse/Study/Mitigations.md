

## SETUID Mitigations

- If RUID !=0 then the privileges could be dropped.
- Like if RUID !=0 then EUID = RUID and RUID !=0.
- To stop this we use the below command.

```bash
sh -p
```

- `sh -p` executes the program without making modifications to the RUID.


