

## Encoding

- Converts string to bytes
- Used when transmitting data to another device using sockets and sockets can transmit data in only raw bytes so encoding is required.

```bash
<string_variable>.encode()
```


## Decoding

- Converts bytes to string 
- Used to convert the data to human readable format upon receiving since raw bytes are difficult to read.

```bash
<string_variable>.decode()
```



## Converting from Hex to Bytes

Lets say our bytes variable => **hello**

#### Bytes format

```python
>>> hello=b'hello world'
>>> type(hello)
<class 'bytes'>
```

#### Hex format

```python
>>> hex_form=hello.hex()
>>> hex_form
'68656c6c6f20776f726c64'
```


Now lets say we only have the above **hex** format of the data then how to convert to bytes???

#### hex ---> bytes

```python
>>> bytes.fromhex(hex_form)
b'hello world'
>>> bytes_data=bytes.fromhex(hex_form)
>>> type(bytes_data)
<class 'bytes'>
```









