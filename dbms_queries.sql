# Oracle SQL Notes — Part 2
## Aggregate Functions, GROUP BY and HAVING

**Database:** Oracle SQL  
**Level:** Basic to Advanced  
**Purpose:** College practicals, viva, written examinations and query practice

---

## Table of Contents

1. Aggregate Functions
2. COUNT() — Counting Rows and Values
3. SUM(), AVG(), MIN() and MAX()
4. DISTINCT and ALL with Aggregate Functions
5. WHERE with Aggregate Functions
6. GROUP BY
7. HAVING
8. WHERE vs HAVING
9. Combining WHERE, GROUP BY and HAVING
10. Common Exam Errors
11. Practice Questions
12. Quick Revision

---

# 1. Aggregate Functions

Aggregate functions perform calculations on a set of rows and return a single result for the selected set.

Common aggregate functions:

| Function | Purpose |
|---|---|
| `COUNT()` | Counts rows or non-NULL values |
| `SUM()` | Calculates the total |
| `AVG()` | Calculates the average |
| `MIN()` | Finds the minimum value |
| `MAX()` | Finds the maximum value |

## Sample Table: EMPLOYEE

Assume the following table already exists and contains these records.

| empID | empName | empAge | empSalary | deptID |
|---:|---|---:|---:|---:|
| 1001 | Ravi | 21 | 8000 | 10 |
| 1002 | Aadi | 25 | 9000 | 20 |
| 1003 | Ajay | 22 | 12000 | 10 |
| 1004 | Neha | 20 | 15000 | 20 |
| 1005 | Priya | 25 | 11000 | 10 |
| 1006 | Meera | 23 | NULL | 30 |

**Important:** `NULL` represents a missing or unknown value. It is not the same as zero.

---

# 2. COUNT()

The `COUNT()` function counts rows or non-NULL values.

### A. COUNT(*)

Counts all rows, including rows containing NULL values.

```sql
SELECT COUNT(*)
FROM employee;
```

**Output:** `6`

### B. COUNT(column_name)

Counts only those rows in which the specified column is not NULL.

```sql
SELECT COUNT(empSalary)
FROM employee;
```

**Output:** `5`

Meera's salary is NULL, so her salary is not counted.

### C. Counting a Different Column

```sql
SELECT COUNT(empAge)
FROM employee;
```

**Output:** `6`

All six employees have a non-NULL age.

### COUNT(*) vs COUNT(column)

| COUNT(*) | COUNT(column_name) |
|---|---|
| Counts all rows | Counts non-NULL values in that column |
| Includes rows containing NULL in other columns | Excludes rows where the specified column is NULL |

---

# 3. SUM(), AVG(), MIN() and MAX()

## A. SUM()

Calculates the sum of non-NULL values.

```sql
SELECT SUM(empSalary)
FROM employee;
```

**Output:** `55000`

Calculation:

`8000 + 9000 + 12000 + 15000 + 11000 = 55000`

## B. AVG()

Calculates the average of non-NULL values.

```sql
SELECT AVG(empSalary)
FROM employee;
```

**Output:** `11000`

Calculation:

`55000 / 5 = 11000`

NULL is not included in the calculation.

## C. MIN()

Returns the minimum non-NULL value.

```sql
SELECT MIN(empSalary)
FROM employee;
```

**Output:** `8000`

## D. MAX()

Returns the maximum non-NULL value.

```sql
SELECT MAX(empSalary)
FROM employee;
```

**Output:** `15000`

### Summary

| Query | Expected result |
|---|---:|
| `COUNT(*)` | 6 |
| `COUNT(empSalary)` | 5 |
| `SUM(empSalary)` | 55000 |
| `AVG(empSalary)` | 11000 |
| `MIN(empSalary)` | 8000 |
| `MAX(empSalary)` | 15000 |

**Exam rule:** Except for `COUNT(*)`, these aggregate functions ignore NULL values. If a group contains no non-NULL values for an aggregate, `SUM`, `AVG`, `MIN` and `MAX` return NULL.

---

# 4. DISTINCT and ALL with Aggregate Functions

## DISTINCT

`DISTINCT` removes duplicate values before the aggregate calculation.

```sql
SELECT COUNT(DISTINCT empAge)
FROM employee;
```

The ages are:

`21, 25, 22, 20, 25, 23`

Distinct ages:

`21, 25, 22, 20, 23`

**Output:** `5`

Another example:

```sql
SELECT SUM(DISTINCT empAge)
FROM employee;
```

**Output:** `111`

Calculation:

`21 + 25 + 22 + 20 + 23 = 111`

## ALL

`ALL` includes duplicate values. It is the default behaviour when neither `DISTINCT` nor `ALL` is specified.

```sql
SELECT SUM(ALL empAge)
FROM employee;
```

**Output:** `136`

Calculation:

`21 + 25 + 22 + 20 + 25 + 23 = 136`

### DISTINCT vs ALL

| DISTINCT | ALL |
|---|---|
| Removes duplicate values | Includes duplicate values |
| `COUNT(DISTINCT empAge)` returns 5 | `COUNT(ALL empAge)` returns 6 |
| Useful when unique values are needed | Useful when all values must be considered |

---

# 5. WHERE with Aggregate Functions

`WHERE` filters individual rows before an aggregate calculation is performed.

### Example 1: Average salary of employees aged 22 or above

```sql
SELECT AVG(empSalary)
FROM employee
WHERE empAge >= 22;
```

Selected employees:

| empName | empAge | empSalary |
|---|---:|---:|
| Aadi | 25 | 9000 |
| Ajay | 22 | 12000 |
| Priya | 25 | 11000 |
| Meera | 23 | NULL |

Average:

`(9000 + 12000 + 11000) / 3 = 10666.67`

**Expected output:** Approximately `10666.67`

### Example 2: Count employees earning more than 10000

```sql
SELECT COUNT(*), COUNT(empSalary), AVG(empSalary)
FROM employee
WHERE empSalary > 10000;
```

Selected employees: Ajay, Neha and Priya.

| COUNT(*) | COUNT(empSalary) | AVG(empSalary) |
|---:|---:|---:|
| 3 | 3 | 12666.67 |

**Important:** A condition such as `WHERE COUNT(*) > 2` is invalid in an ordinary grouped query. Use `HAVING` to filter aggregate results.

---

# 6. GROUP BY

`GROUP BY` combines rows having the same value in one or more columns into groups.

It is useful for questions containing phrases such as:

- Count employees in each department.
- Find the average salary of every department.
- Calculate total sales for each product.
- Find the maximum marks in each class.

## Syntax

```sql
SELECT column_name, aggregate_function(column_name)
FROM table_name
GROUP BY column_name;
```

## Example 1: Count employees in each department

```sql
SELECT deptID, COUNT(*)
FROM employee
GROUP BY deptID;
```

**Expected output:**

| deptID | COUNT(*) |
|---:|---:|
| 10 | 3 |
| 20 | 2 |
| 30 | 1 |

Department 10 has three employees, department 20 has two, and department 30 has one.

## Example 2: Average salary of each department

```sql
SELECT deptID, AVG(empSalary)
FROM employee
GROUP BY deptID;
```

**Expected output:**

| deptID | AVG(empSalary) |
|---:|---:|
| 10 | 10333.33 |
| 20 | 12000 |
| 30 | NULL |

Department 30 has no non-NULL salary values, so its average is NULL.

## Example 3: Total salary of each department

```sql
SELECT deptID, SUM(empSalary)
FROM employee
GROUP BY deptID;
```

**Expected output:**

| deptID | SUM(empSalary) |
|---:|---:|
| 10 | 31000 |
| 20 | 24000 |
| 30 | NULL |

## Example 4: Maximum salary in each department

```sql
SELECT deptID, MAX(empSalary)
FROM employee
GROUP BY deptID;
```

**Expected output:**

| deptID | MAX(empSalary) |
|---:|---:|
| 10 | 12000 |
| 20 | 15000 |
| 30 | NULL |

## Important GROUP BY Rule

In Oracle SQL, a selected column must generally be:

1. Included in the `GROUP BY` clause, or
2. Used inside an aggregate function.

For example, this query is invalid:

```sql
SELECT deptID, empName, COUNT(*)
FROM employee
GROUP BY deptID;
```

`empName` is neither grouped nor aggregated.

A valid version is:

```sql
SELECT deptID, COUNT(*)
FROM employee
GROUP BY deptID;
```

---

# 7. HAVING

`HAVING` filters groups after `GROUP BY` has formed them.

## Syntax

```sql
SELECT column_name, aggregate_function(column_name)
FROM table_name
GROUP BY column_name
HAVING aggregate_condition;
```

## Example 1: Departments having more than two employees

```sql
SELECT deptID, COUNT(*)
FROM employee
GROUP BY deptID
HAVING COUNT(*) > 2;
```

**Expected output:**

| deptID | COUNT(*) |
|---:|---:|
| 10 | 3 |

Only department 10 satisfies the condition.

## Example 2: Departments with an average salary above 10000

```sql
SELECT deptID, AVG(empSalary)
FROM employee
GROUP BY deptID
HAVING AVG(empSalary) > 10000;
```

**Expected output:**

| deptID | AVG(empSalary) |
|---:|---:|
| 10 | 10333.33 |
| 20 | 12000 |

Department 30 does not satisfy the condition because its average salary is NULL.

## Example 3: Departments with total salary above 25000

```sql
SELECT deptID, SUM(empSalary)
FROM employee
GROUP BY deptID
HAVING SUM(empSalary) > 25000;
```

**Expected output:**

| deptID | SUM(empSalary) |
|---:|---:|
| 10 | 31000 |

Department 20 has a total salary of 24000, so it is excluded.

---

# 8. WHERE vs HAVING

This is one of the most important differences for examinations and viva.

| WHERE | HAVING |
|---|---|
| Filters individual rows | Filters groups |
| Applied before grouping | Applied after grouping |
| Commonly filters ordinary column values | Commonly filters aggregate results |
| Example: `WHERE empSalary > 10000` | Example: `HAVING AVG(empSalary) > 10000` |

### Easy way to remember

- **WHERE:** Which rows should be considered?
- **GROUP BY:** How should those rows be grouped?
- **HAVING:** Which groups should remain?

---

# 9. Combining WHERE, GROUP BY and HAVING

Question:

Find the average salary of each department after excluding employees earning 8000 or less. Display only departments whose resulting average salary exceeds 10000.

```sql
SELECT deptID, AVG(empSalary)
FROM employee
WHERE empSalary > 8000
GROUP BY deptID
HAVING AVG(empSalary) > 10000;
```

### Execution steps

**Step 1 — WHERE**

The employee earning 8000 is excluded. Meera's NULL salary also does not satisfy `empSalary > 8000`.

Remaining employees:

| empName | empSalary | deptID |
|---|---:|---:|
| Aadi | 9000 | 20 |
| Ajay | 12000 | 10 |
| Neha | 15000 | 20 |
| Priya | 11000 | 10 |

**Step 2 — GROUP BY**

Group the remaining employees by department.

**Step 3 — AVG**

- Department 10: `(12000 + 11000) / 2 = 11500`
- Department 20: `(9000 + 15000) / 2 = 12000`

**Step 4 — HAVING**

Both departments have an average above 10000.

**Final output:**

| deptID | AVG(empSalary) |
|---:|---:|
| 10 | 11500 |
| 20 | 12000 |

### Correct clause order

```sql
SELECT ...
FROM ...
WHERE ...
GROUP BY ...
HAVING ...
ORDER BY ...;
```

Not every query requires all these clauses.

---

# 10. Common Exam Errors

### Error 1: Using aggregate functions in WHERE

Incorrect:

```sql
SELECT deptID, COUNT(*)
FROM employee
WHERE COUNT(*) > 2
GROUP BY deptID;
```

Correct:

```sql
SELECT deptID, COUNT(*)
FROM employee
GROUP BY deptID
HAVING COUNT(*) > 2;
```

### Error 2: Selecting an ungrouped column

Incorrect:

```sql
SELECT deptID, empName, COUNT(*)
FROM employee
GROUP BY deptID;
```

Correct:

```sql
SELECT deptID, COUNT(*)
FROM employee
GROUP BY deptID;
```

### Error 3: Confusing total rows with non-NULL values

```sql
SELECT COUNT(*), COUNT(empSalary)
FROM employee;
```

Results: `6` and `5`, respectively.

### Error 4: Forgetting that WHERE changes the average

Without filtering:

```sql
SELECT AVG(empSalary)
FROM employee;
```

Result: `11000`

After filtering:

```sql
SELECT AVG(empSalary)
FROM employee
WHERE empSalary > 8000;
```

Result: `11750`

The second query averages four salaries: 9000, 12000, 15000 and 11000.

---

# 11. Practice Questions

Use the EMPLOYEE table from the beginning of these notes.

## Basic

**Q1.** Display the total number of employees.

**Q2.** Display the average salary of all employees.

**Q3.** Find the highest salary.

**Q4.** Count the distinct employee ages.

## Intermediate

**Q5.** Display the number of employees in each department.

**Q6.** Display the minimum salary in each department.

**Q7.** Display departments having more than one employee.

**Q8.** Display departments whose average salary is greater than 11000.

## Advanced

**Q9.** Display department-wise employee counts for employees whose salary exceeds 10000.

**Q10.** Display departments with at least two employees whose salaries exceed 10000.

**Q11.** Explain why the following query is invalid:

```sql
SELECT deptID, empName, AVG(empSalary)
FROM employee
GROUP BY deptID;
```

**Q12.** Predict the output:

```sql
SELECT deptID, COUNT(*), COUNT(empSalary)
FROM employee
GROUP BY deptID
HAVING COUNT(*) >= 2;
```

---

# 12. Quick Revision

| Requirement | SQL concept |
|---|---|
| Count all rows | `COUNT(*)` |
| Count non-NULL values | `COUNT(column_name)` |
| Calculate a total | `SUM()` |
| Calculate an average | `AVG()` |
| Find the smallest value | `MIN()` |
| Find the largest value | `MAX()` |
| Remove duplicate values before aggregation | `DISTINCT` |
| Group similar rows | `GROUP BY` |
| Filter rows before grouping | `WHERE` |
| Filter groups after grouping | `HAVING` |

## Final Memory Trick

**WHERE → GROUP BY → HAVING**

1. Filter individual rows.
2. Create groups.
3. Filter groups using conditions.

These clauses are frequently combined with aggregate functions in practical examinations.

---

**End of Part 2**

**Next topic:** Oracle-specific features — `ROWID`, `DUAL`, `LOWER()` and `UPPER()`.
