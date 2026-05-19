
## Challenge Information

```
This challenge will be the start of your SQL journey. In this challenge, and throughout this module, we'll use a SQL engine called [SQLite](https://sqlite.org/). SQLite is an extremely lightweight SQL engine that, rather than using a complex SQL server process to host databases, simply interacts with database files directly. This makes it very convenient to prototype applications on, and we use it for almost all our SQL needs in the challenges on pwn.college, but you wouldn't want to use it for, say, a production website... In the challenge file (`/challenge/sql`), you'll notice our use of SQLite via the TemporaryDB class. Feel free to ignore the inner workings of that class --- we simply use it as a wrapper to execute SQL queries and get results. Focus on the rest of the code!

Run the sql script to enter the database and run your query.
```

## 1. `SQL Queries`

```sql
SELECT * FROM payloads
```

## 2. `Filtering SQL`

```sql
SELECT * FROM dataset WHERE flag_tag=1337
```

## 3. `Choosing Columns`

```sql
SELECT datum FROM resources WHERE flag_tag=1337
```

## 4. `Exclusionary Filtering`

```sql
SELECT datum FROM fragments WHERE flag_tag BETWEEN 1337 AND 313371337
```

## 5. `Filtering Strings`

```sql
SELECT flag FROM payloads WHERE flag_tag='yep'
```

## 6. `Filtering on Expressions`

```sql
SELECT content FROM secrets WHERE substr(content, 1, 11) = 'pwn.college'
```

## 7. `SELECTing Expressions`

```sql
SELECT 
SUBSTR(payload, 13, 5), 
SUBSTR(payload, 18, 5),
SUBSTR(payload, 23, 5), 
SUBSTR(payload, 28, 5), 
SUBSTR(payload, 33, 5), 
SUBSTR(payload, 38, 5), 
SUBSTR(payload, 43, 5), 
SUBSTR(payload, 48, 5), 
SUBSTR(payload, 53, 5), 
SUBSTR(payload, 58, 5) 
FROM notes
```

## 8. `Composite Conditions`

```sql
SELECT entry FROM payloads WHERE flag_tag=1337 AND entry LIKE 'pwn.college%'
```

## 9. `Reaching Your LIMITs`

```sql
SELECT item FROM resources WHERE item LIKE 'pwn.college%' LIMIT 1
```

## 10. `Querying Metadata`

The `sqlite_master` table is a special **system table** in an SQLite database that acts as a data dictionary, storing the **metadata and schema information** for all database objects.

### Getting target Table name

```sql
SELECT name FROM sqlite_master WHERE TYPE='table'
```

### Getting the Flag

```sql
SELECT detail FROM <tablename>
```

The table name gets randomized in each SQL session i.e. each time the `./sql` is run. So your table name might be different so its important to run the above 2 queries in a single SQL session.
