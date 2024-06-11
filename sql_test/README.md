# technical sql test

Output code execution: 
```
Answer to technical test:
1. Select employees with salary greater than 4M
loading query...
query loaded
connecting to database...
executing query...
query executed
connection with database closed
name       last_name          salary
---------  -----------  ------------
ANDRES     GARCIA       5,500,000.00
MARGARITA  CORRALES     4,500,000.00

2. Count employees by sex
loading query...
query loaded
connecting to database...
executing query...
query executed
connection with database closed
sex          quantity
---------  ----------
FEMENINO            2
MASCULINO           3

3. Employees that have not requested holidays
loading query...
query loaded
connecting to database...
executing query...
query executed
connection with database closed
name       last_name
---------  -----------
PEPE       MARTINEZ
MARGARITA  CORRALES

4. Employees with more than one requested holiday
loading query...
query loaded
connecting to database...
executing query...
query executed
connection with database closed
name    last_name      times_requested
------  -----------  -----------------
ANDRES  GARCIA                       3
LAURA   PEREZ                        2

5. Average salary employees
loading query...
query loaded
connecting to database...
executing query...
query executed
connection with database closed
  avg_salary
------------
3,960,000.00

6. Avg days requested by employees
loading query...
query loaded
connecting to database...
executing query...
query executed
connection with database closed
name       last_name      avg_days_requested
---------  -----------  --------------------
JUAN       PELAEZ                      14
ANDRES     GARCIA                      11.33
LAURA      PEREZ                        8
PEPE       MARTINEZ                     0
MARGARITA  CORRALES                     0

7. Employee with most days requested
loading query...
query loaded
connecting to database...
executing query...
query executed
connection with database closed
name    last_name      sum_days_requested
------  -----------  --------------------
ANDRES  GARCIA                         34

8. Summary days requested
loading query...
query loaded
connecting to database...
executing query...
query executed
connection with database closed
name       last_name      days_approved    days_rejected
---------  -----------  ---------------  ---------------
JUAN       PELAEZ                    14                0
ANDRES     GARCIA                    20               14
LAURA      PEREZ                     16                0
PEPE       MARTINEZ                   0                0
MARGARITA  CORRALES                   0                0
```