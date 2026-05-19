
- Its another data format. 
- It ranges from (0-9 and A-F)
		i.e `0 1 2 3 4 5 6 7 8 9 A B C D E F`
	
	- **A = 10**
	- **B = 11**
	- **C = 12**
	- **D = 13**
	- **E = 14**
	- **F = 15**


### Conversion of Binary to Hexadecimal

 ![Binary to Hex](https://youtu.be/tSLKOKGQq0Y?si=UbRRtmURgzdQSncl)

- Make the binary data into 8-bit form or 1 byte
- Then group the bits from right to left in groups of 4
- Like we convert binary to decimal using power of 2 ... use the same method to convert this but only the `1s`
- If any value is coming more than 9 then match with `A B C D E F` of hex codes and assign them accordingly.

----
### Hex Encoding

- Converts binary data to hex format
#### Pros

- easy to read

#### Cons

- double the size of the data i.e. each hex digit is a byte.


```bash
xxd -ps <file_name>
```

----

### Hex Decoding

- Converts hex data to binary


```bash
xxd -ps -r <file_name>
```