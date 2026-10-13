# Oracle SQL Notes — Part 1
## SQL Fundamentals, Conditions, Sorting and Transactions

**Learning Track:** DBMS and Oracle SQL  
**Level:** Beginner to Intermediate  
**Coverage:** Lessons 1–4  
**Purpose:** University Practical Exams, Written Exams and SQL Fundamentals  
**Database:** Oracle SQL

---

## Table of Contents

1. Introduction to DBMS and SQL
2. Creating a Table — `CREATE TABLE`
3. Inserting Records — `INSERT INTO`
4. Retrieving Data — `SELECT`
5. Filtering Records — `WHERE`
6. Comparison Operators
7. Logical Operators — `AND`, `OR`, `NOT`
8. Range Filtering — `BETWEEN`
9. Multiple-Value Filtering — `IN`
10. Pattern Matching — `LIKE`
11. NULL Values — `IS NULL`
12. Sorting Records — `ORDER BY`
13. Modifying Records — `UPDATE`
14. Removing Records — `DELETE`
15. Transactions — `COMMIT` and `ROLLBACK`
16. Important Exam Traps
17. Quick Revision Sheet
18. Practice Questions

---

# 1. Introduction to DBMS and SQL

### 1.1 What is a DBMS?

A **Database Management System (DBMS)** is software used to create, store, retrieve, update and manage data in a database.

Examples include Oracle Database, MySQL, PostgreSQL and Microsoft SQL Server.

### 1.2 What is SQL?

**SQL (Structured Query Language)** is a language used to communicate with relational databases.

It allows us to create tables, insert records, retrieve information and modify stored data.

### 1.3 Basic Terminology

| Term | Meaning |
|---|---|
| Database | An organized collection of data |
| Table | Data arranged in rows and columns |
| Row / Record / Tuple | A single record in a table |
| Column / Attribute | A property of the stored data |
| Query | An instruction given to the database |

### 1.4 Common SQL Command Categories

| Category | Purpose | Examples |
|---|---|---|
| DDL | Defines database structures | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` |
| DML | Manipulates stored data | `INSERT`, `UPDATE`, `DELETE` |
| DQL | Retrieves data | `SELECT` |
| TCL | Controls transactions | `COMMIT`, `ROLLBACK` |
| DCL | Controls permissions | `GRANT`, `REVOKE` |

*Note: SQL classifications can vary slightly between textbooks. For university exams, follow your professor's prescribed classification.*

---

# 2. Creating a Table — CREATE TABLE

The `CREATE TABLE` command creates a new table in a database.

### Syntax

```sql
CREATE TABLE table_name (
    column1 datatype,
    column2 datatype,
    column3 datatype
);
```

### Example

```sql
CREATE TABLE employee (
    empID     VARCHAR2(10),
    empName   VARCHAR2(30),
    empAge    INTEGER,
    empSalary DECIMAL(10,2)
);
```

### Explanation

- `employee` is the table name.
- `empID` stores the employee ID.
- `empName` stores the employee's name.
- `empAge` stores the employee's age.
- `empSalary` stores the employee's salary.
- `VARCHAR2(30)` stores variable-length character data.
- `INTEGER` stores integer values.
- `DECIMAL(10,2)` allows up to 10 digits in total, with 2 digits after the decimal point.

### Display the Table Structure

```sql
DESC employee;
```

`DESC` displays the table's structure, including column names, datatypes and whether NULL values are permitted.

It does not display the table's actual records.

**Oracle note:** `VARCHAR2` is preferred for variable-length character data in Oracle SQL.

---

# 3. Inserting Records — INSERT INTO

The `INSERT INTO` command adds new records to a table.

### Syntax

```sql
INSERT INTO table_name
VALUES (value1, value2, value3, value4);
```

### Example

```sql
INSERT INTO employee
VALUES ('1001', 'Ravi', 21, 8000);

INSERT INTO employee
VALUES ('1002', 'Aadi', 25, 9000);

INSERT INTO employee
VALUES ('1003', 'Ajay', 22, 12000);

INSERT INTO employee
VALUES ('1004', 'Neha', 20, 15000);

INSERT INTO employee
VALUES ('1005', 'Priya', 25, 11000);

INSERT INTO employee
VALUES ('1006', 'Meera', 23, NULL);
```

### Important Rules

1. Values must follow the table's column order when column names are omitted.
2. Character values should be enclosed in single quotes.
3. Numeric values are normally written without quotes.
4. Use `NULL` for a missing or unknown value.
5. The number and datatypes of the supplied values must be compatible with the table definition.

### Recommended Method: Specify Column Names

```sql
INSERT INTO employee
    (empID, empName, empAge, empSalary)
VALUES
    ('1007', 'Karan', 24, 10000);
```

Specifying column names makes the statement easier to understand and safer if the table's column order changes.

---

# 4. Retrieving Data — SELECT

The `SELECT` command retrieves data from a table.

### 4.1 Display All Columns

```sql
SELECT *
FROM employee;
```

The `*` symbol means all columns.

### 4.2 Display Specific Columns

```sql
SELECT empName
FROM employee;
```

This returns only the employee names.

```sql
SELECT empName, empSalary
FROM employee;
```

This returns only employee names and salaries.

### 4.3 Remove Duplicate Results — DISTINCT

```sql
SELECT DISTINCT empAge
FROM employee;
```

`DISTINCT` returns unique age values rather than repeating the same age.

For example, if the ages are `21, 25, 22, 20, 25, 23`, the unique values are `21, 25, 22, 20, 23`.

The order is not guaranteed unless `ORDER BY` is specified.

### Important Difference

```sql
SELECT empAge
FROM employee;
```

Returns all age values, including duplicates.

```sql
SELECT DISTINCT empAge
FROM employee;
```

Returns only unique age values.

---

# 5. Filtering Records — WHERE

The `WHERE` clause filters rows according to a specified condition.

### Syntax

```sql
SELECT column_names
FROM table_name
WHERE condition;
```

### Example: Employees earning more than 10,000

```sql
SELECT *
FROM employee
WHERE empSalary > 10000;
```

Expected employee names: Ajay, Neha and Priya.

Meera is not returned because her salary is NULL, so the comparison does not evaluate to TRUE.

### Example: Employees aged 25

```sql
SELECT empName, empAge
FROM employee
WHERE empAge = 25;
```

Expected result:

| empName | empAge |
|---|---:|
| Aadi | 25 |
| Priya | 25 |

The `WHERE` clause returns rows for which its condition evaluates to TRUE.

---

# 6. Comparison Operators

| Operator | Meaning | Example |
|---|---|---|
| `=` | Equal to | `empAge = 25` |
| `>` | Greater than | `empSalary > 10000` |
| `<` | Less than | `empAge < 22` |
| `>=` | Greater than or equal to | `empAge >= 22` |
| `<=` | Less than or equal to | `empSalary <= 9000` |
| `<>` | Not equal to | `empAge <> 25` |

### Example: Not equal to 25

```sql
SELECT empName, empAge
FROM employee
WHERE empAge <> 25;
```

This returns employees whose ages are not 25, excluding rows where the age is NULL.

---

# 7. Logical Operators — AND, OR and NOT

Logical operators combine or reverse conditions.

## 7.1 AND

`AND` returns TRUE only when both conditions are TRUE.

```sql
SELECT *
FROM employee
WHERE empAge = 25
  AND empSalary > 10000;
```

Expected result: Priya.

Aadi's age is 25, but his salary is only 9,000. Therefore, he does not satisfy both conditions.

### Truth Table for AND

| Condition 1 | Condition 2 | Result |
|---|---|---|
| TRUE | TRUE | TRUE |
| TRUE | FALSE | FALSE |
| FALSE | TRUE | FALSE |
| FALSE | FALSE | FALSE |

## 7.2 OR

`OR` returns TRUE when at least one condition is TRUE.

```sql
SELECT *
FROM employee
WHERE empAge = 25
   OR empSalary = 15000;
```

Expected employee names: Aadi, Neha and Priya.

Aadi qualifies because his age is 25. Neha qualifies because her salary is 15,000.

### Truth Table for OR

| Condition 1 | Condition 2 | Result |
|---|---|---|
| TRUE | TRUE | TRUE |
| TRUE | FALSE | TRUE |
| FALSE | TRUE | TRUE |
| FALSE | FALSE | FALSE |

**Remember:** With `OR`, one TRUE condition is sufficient.

## 7.3 NOT

`NOT` reverses a condition's logical result.

```sql
SELECT empName, empAge
FROM employee
WHERE NOT (empAge = 25);
```

This returns employees whose ages are not 25, excluding NULL ages.

Equivalent condition:

```sql
WHERE empAge <> 25;
```

## 7.4 Combining AND and OR

```sql
SELECT *
FROM employee
WHERE empAge = 25
   OR (empSalary > 10000 AND empAge < 22);
```

The parentheses make the intended logic clear.

In SQL, `AND` has higher precedence than `OR`. Without parentheses, the expression is interpreted as:

```sql
WHERE empAge = 25
   OR (empSalary > 10000 AND empAge < 22);
```

**Exam tip:** Use parentheses whenever mixed logical conditions may be confusing.

---

# 8. Range Filtering — BETWEEN

`BETWEEN` checks whether a value lies within a range. Both endpoints are included.

### Syntax

```sql
SELECT column_names
FROM table_name
WHERE column_name BETWEEN lower_value AND upper_value;
```

### Example

```sql
SELECT empName, empSalary
FROM employee
WHERE empSalary BETWEEN 8000 AND 12000;
```

Expected employee names: Ravi, Aadi, Ajay and Priya.

### Equivalent Condition

```sql
SELECT empName, empSalary
FROM employee
WHERE empSalary >= 8000
  AND empSalary <= 12000;
```

### NOT BETWEEN

```sql
SELECT empName, empSalary
FROM employee
WHERE empSalary NOT BETWEEN 8000 AND 12000;
```

Expected employee: Neha.

Rows with NULL salaries do not satisfy this condition either.

**Exam point:** `BETWEEN 8000 AND 12000` includes both 8000 and 12000.

---

# 9. Multiple-Value Filtering — IN

`IN` checks whether a value matches any value in a specified list.

### Example

```sql
SELECT empName, empAge
FROM employee
WHERE empAge IN (20, 22, 25);
```

Expected employee names: Aadi, Ajay, Neha and Priya.

### Equivalent Using OR

```sql
SELECT empName, empAge
FROM employee
WHERE empAge = 20
   OR empAge = 22
   OR empAge = 25;
```

### NOT IN

```sql
SELECT empName, empAge
FROM employee
WHERE empAge NOT IN (20, 22, 25);
```

Expected employee names: Ravi and Meera.

**Important:** NULL inside a `NOT IN` list can cause unexpected results because SQL uses three-valued logic. Handle NULL values carefully, especially when `NOT IN` contains a subquery.

---

# 10. Pattern Matching — LIKE

`LIKE` matches character data against a specified pattern.

### Wildcard Symbols

| Symbol | Meaning |
|---|---|
| `%` | Zero or more characters |
| `_` | Exactly one character |

## 10.1 Names Starting with A

```sql
SELECT empName
FROM employee
WHERE empName LIKE 'A%';
```

Expected results: Aadi, Ajay.

## 10.2 Names Ending with a

```sql
SELECT empName
FROM employee
WHERE empName LIKE '%a';
```

Expected results: Neha, Priya.

## 10.3 Names Containing j

```sql
SELECT empName
FROM employee
WHERE empName LIKE '%j%';
```

Expected result: Ajay.

## 10.4 Exactly Four Characters

```sql
SELECT empName
FROM employee
WHERE empName LIKE '____';
```

Expected results: Ravi, Aadi, Ajay, Neha.

## 10.5 A Followed by Exactly Three Characters

```sql
SELECT empName
FROM employee
WHERE empName LIKE 'A___';
```

Expected results: Aadi, Ajay.

### Important Exam Points

- `%` can match zero characters as well as multiple characters.
- `_` represents exactly one character.
- `LIKE 'A%'` means starts with A.
- `LIKE '%A'` means ends with A.
- `LIKE '%A%'` means contains A.
- Oracle `LIKE` matching is generally case-sensitive under ordinary binary comparison settings.
- `*` is not the standard wildcard used by SQL `LIKE`.

---

# 11. NULL Values — IS NULL and IS NOT NULL

`NULL` represents missing, unknown or unavailable data. It is not equivalent to zero, an empty string or an ordinary value.

Our example includes Meera, whose salary is NULL.

## 11.1 Find Missing Salaries

```sql
SELECT empName
FROM employee
WHERE empSalary IS NULL;
```

Expected result: Meera.

## 11.2 Find Entered Salaries

```sql
SELECT empName
FROM employee
WHERE empSalary IS NOT NULL;
```

Expected employees: Ravi, Aadi, Ajay, Neha and Priya.

### Incorrect and Correct Syntax

Incorrect:

```sql
WHERE empSalary = NULL;
```

Incorrect:

```sql
WHERE empSalary <> NULL;
```

Correct:

```sql
WHERE empSalary IS NULL;
```

Correct:

```sql
WHERE empSalary IS NOT NULL;
```

**Exam point:** Ordinary comparisons involving NULL usually evaluate to UNKNOWN rather than TRUE or FALSE. `WHERE` retains only rows for which the condition evaluates to TRUE.

---

# 12. Sorting Records — ORDER BY

`ORDER BY` sorts query results according to one or more columns.

## 12.1 Ascending Order — ASC

```sql
SELECT empName, empSalary
FROM employee
ORDER BY empSalary ASC NULLS LAST;
```

This sorts salaries from lowest to highest and places NULL salaries last.

Expected order:

| empName | empSalary |
|---|---:|
| Ravi | 8000 |
| Aadi | 9000 |
| Priya | 11000 |
| Ajay | 12000 |
| Neha | 15000 |
| Meera | NULL |

`ASC` is the default sort direction.

## 12.2 Descending Order — DESC

```sql
SELECT empName, empSalary
FROM employee
ORDER BY empSalary DESC NULLS LAST;
```

This sorts salaries from highest to lowest, with NULL values last.

## 12.3 Sorting by Multiple Columns

```sql
SELECT empName, empAge, empSalary
FROM employee
ORDER BY empAge ASC, empSalary DESC;
```

SQL sorts by age first. When two employees have the same age, it sorts those rows by salary in descending order.

### Important Points

- `ASC` means ascending.
- `DESC` means descending.
- Multiple sort keys are evaluated from left to right.
- Use `NULLS FIRST` or `NULLS LAST` when you need explicit NULL placement in Oracle.
- Without `ORDER BY`, result order is not guaranteed.

---

# 13. Modifying Records — UPDATE

`UPDATE` modifies existing records in a table.

### Syntax

```sql
UPDATE table_name
SET column_name = value
WHERE condition;
```

## 13.1 Update One Employee's Salary

```sql
UPDATE employee
SET empSalary = 10000
WHERE empID = '1001';
```

Only Ravi's salary is changed.

## 13.2 Update Multiple Columns

```sql
UPDATE employee
SET empAge = 22,
    empSalary = 13000
WHERE empID = '1001';
```

This updates both age and salary for Ravi.

## 13.3 UPDATE Without WHERE

```sql
UPDATE employee
SET empSalary = 10000;
```

**Warning:** This updates every row in the table, including rows whose salary was previously NULL.

### Best Practice

Before running an update, check the target rows:

```sql
SELECT *
FROM employee
WHERE empID = '1001';
```

Then execute the intended `UPDATE`.

---

# 14. Removing Records — DELETE

`DELETE` removes rows from a table.

## 14.1 Delete One Employee

```sql
DELETE FROM employee
WHERE empID = '1001';
```

Only the row matching the employee ID is deleted.

## 14.2 Delete All Rows

```sql
DELETE FROM employee;
```

This deletes every row but preserves the table structure.

### DELETE vs DROP

| Command | Effect |
|---|---|
| `DELETE FROM employee WHERE ...` | Deletes matching rows |
| `DELETE FROM employee` | Deletes all rows |
| `DROP TABLE employee` | Removes the table object and its structure |
| `TRUNCATE TABLE employee` | Removes all rows using a DDL operation |

`TRUNCATE` is covered separately in a later lesson.

### Critical Warning

An `UPDATE` or `DELETE` without a `WHERE` clause may affect every row.

Always verify the condition before executing the command.

---

# 15. Transactions — COMMIT and ROLLBACK

Transactions help manage changes made to data.

## 15.1 COMMIT

`COMMIT` saves the current transaction's changes.

```sql
UPDATE employee
SET empSalary = 10000
WHERE empID = '1001';

COMMIT;
```

After a successful commit, the change cannot be undone using an ordinary `ROLLBACK` in the same transaction.

## 15.2 ROLLBACK

`ROLLBACK` undoes uncommitted changes in the current transaction.

```sql
UPDATE employee
SET empSalary = 5000
WHERE empID = '1001';

ROLLBACK;
```

If the salary was 10000 before the update and the update was not committed, the rollback restores the previous committed value.

### Transaction Example

Suppose Ravi's committed salary is 8000.

1. Execute an update setting his salary to 10000.
2. If you execute `COMMIT`, the salary change is saved.
3. If you execute `ROLLBACK` instead, the uncommitted change is undone.

### Important Oracle Note

Oracle performs implicit commits around DDL statements such as `CREATE TABLE`, `ALTER TABLE` and `DROP TABLE`. Therefore, do not assume that every SQL operation can be undone with `ROLLBACK`.

**Remember:**
- `COMMIT` — save transaction changes.
- `ROLLBACK` — undo uncommitted transaction changes.

---

# 16. Important Exam Traps

1. `CREATE TABLE` creates a table; `INSERT INTO` adds records.
2. `SELECT *` retrieves all columns.
3. `DISTINCT` removes duplicate result rows.
4. `WHERE` filters rows.
5. `AND` requires all conditions to be TRUE.
6. `OR` requires at least one condition to be TRUE.
7. `NOT` reverses a condition's logical result.
8. `BETWEEN` includes both endpoints.
9. `IN` checks membership in a list.
10. `LIKE` uses `%` and `_`, not `*`.
11. Use `IS NULL`, not `= NULL`.
12. `ORDER BY ASC` sorts ascending; `DESC` sorts descending.
13. Multiple sort keys are evaluated from left to right.
14. `UPDATE` without `WHERE` affects all rows.
15. `DELETE` without `WHERE` deletes all rows.
16. `DELETE` removes rows; `DROP TABLE` removes the table object.
17. `COMMIT` saves changes; `ROLLBACK` undoes uncommitted changes.
18. Oracle DDL operations can implicitly commit transactions.
19. Without `ORDER BY`, query output order is not guaranteed.
20. SQL comparisons involving NULL can evaluate to UNKNOWN.

---

# 17. Quick Revision Sheet

| Requirement | SQL Pattern |
|---|---|
| Create a table | `CREATE TABLE ...` |
| Insert a record | `INSERT INTO ... VALUES ...` |
| Retrieve all columns | `SELECT * FROM ...` |
| Retrieve selected columns | `SELECT col1, col2 FROM ...` |
| Filter rows | `WHERE condition` |
| Greater than | `column > value` |
| Combine all conditions | `AND` |
| Combine alternative conditions | `OR` |
| Reverse a condition | `NOT` |
| Check a range | `BETWEEN low AND high` |
| Match values from a list | `IN (...)` |
| Match a text pattern | `LIKE 'A%'` |
| Find missing values | `IS NULL` |
| Find non-missing values | `IS NOT NULL` |
| Sort ascending | `ORDER BY column ASC` |
| Sort descending | `ORDER BY column DESC` |
| Modify records | `UPDATE ... SET ... WHERE ...` |
| Remove selected rows | `DELETE FROM ... WHERE ...` |
| Save transaction | `COMMIT` |
| Undo uncommitted changes | `ROLLBACK` |

---

# 18. Practice Questions

Attempt these questions without looking at the answers first.

### Basic Level

**Q1.** Write a query to display all columns from the `employee` table.

**Q2.** Display only employee names and salaries.

**Q3.** Display employees whose age is greater than 21.

**Q4.** Display employees whose salary is between 9000 and 12000, including both endpoints.

**Q5.** Display employees whose names begin with A.

### Intermediate Level

**Q6.** Display employees whose age is 20 or 25.

**Q7.** Display employees whose salary is greater than 9000 and age is less than 25.

**Q8.** Display employees whose names contain the letter `a`.

**Q9.** Display all employees in descending salary order, placing NULL salaries last.

**Q10.** Increase Ravi's salary to 10000.

### Tougher Exam-Level Questions

**Q11.** Predict the output of the following query:

```sql
SELECT empName
FROM employee
WHERE empAge > 22
   OR empSalary > 12000;
```

**Q12.** Explain the difference between these conditions:

```sql
WHERE empAge BETWEEN 20 AND 25;
```

```sql
WHERE empAge > 20 AND empAge < 25;
```

**Q13.** Why is this query incorrect for finding missing salaries?

```sql
SELECT *
FROM employee
WHERE empSalary = NULL;
```

**Q14.** What happens if the following query is executed?

```sql
DELETE FROM employee;
```

**Q15.** Explain the difference between `COMMIT` and `ROLLBACK` in Oracle.

---

## Learning Progress

