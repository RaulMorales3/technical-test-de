import os
import sqlite3
from collections import namedtuple
from typing import Any, List, Tuple

from tabulate import tabulate

from init_db import init_database

DATABASE = "test_sql.db"
SALARY_TO_FILTER_BY = 4_000_000  # Queries paths
FILTER_BY_SALARY = "./queries/filter_employees_by_salary.sql"
COUNT_BY_SEX = "./queries/count_by_sex.sql"
NO_HOLIDAYS_EMPLOYEES = "./queries/employees_with_no_holidays_requested.sql"
TIMES_REQUESTED_HOLIDAYS = "./queries/requested_holidays.sql"
AVG_SALARY = "./queries/avg_salary_employees.sql"
AVG_HOLIDAYS = "./queries/avg_holidays_per_employee.sql"
EMPLOYEE_WITH_MOST_DAYS_REQUESTED = (
    "./queries/employee_with_most_holidays_requested.sql"
)
SUMMARY_HOLIDAYS = "./queries/summary_holidays.sql"


def load_query(*, query_path: str) -> str:
    """load query string from a path inside the folder

    Args:
        query_path (str): path to query

    Returns:
        str: query read from file
    """
    try:
        print("loading query...")
        full_path_query = os.path.join(os.getcwd(), query_path)
        with open(full_path_query) as file:
            query = file.read()
        print("query loaded")
        return query
    except FileNotFoundError:
        print(f"file {query_path} not found.")


def execute_query(*, query: str, params: Tuple = ()) -> List[Any]:
    """Execute read query, not suitable for other CRUD operations since it does
    not commit to database the changes, also better not used with large results
    since it loads all results on memory

    Args:
        query (str): query to execute
        params (Tuple, optional): query params. Defaults to ().

    Returns:
        List[Any]: All select results.
    """
    try:
        print("connecting to database...")
        con = sqlite3.connect(DATABASE)
        cur = con.cursor()
        print("executing query...")
        res = cur.execute(query, params)
        print("query executed")
        return res.fetchall()
    except sqlite3.OperationalError as error:
        print(f"error when reading transaction {error}")
    finally:
        con.close()
        print("connection with database closed")


def filter_employees_by_salary(salary: int) -> None:
    """filter employees by a greater salary that the parameter passed and prints
    them as a table

    Args:
        salary (int):
    """
    query = load_query(query_path=FILTER_BY_SALARY)
    employee = namedtuple("Employee", ["name", "last_name", "salary"])
    res = execute_query(query=query, params=(salary,))
    employees = [employee(*row) for row in res]
    print(tabulate(employees, headers=employee._fields, floatfmt=",.2f"))


def count_employees_by_sex() -> None:
    """groups employees by sex and prints how many are in each category as a table"""
    query = load_query(query_path=COUNT_BY_SEX)
    result = namedtuple("Result", ["sex", "quantity"])
    res = execute_query(query=query)
    employees_by_sex = [result(*row) for row in res]
    print(tabulate(employees_by_sex, headers=result._fields))


def employees_with_no_holidays_requested() -> None:
    """Finds employees that have never requested holidays and prints them as a table"""
    query = load_query(query_path=NO_HOLIDAYS_EMPLOYEES)
    employee = namedtuple("Employee", ["name", "last_name"])
    res = execute_query(query=query)
    employees = [employee(*row) for row in res]
    print(tabulate(employees, headers=employee._fields))


def employees_requested_holidays(threshold: int = 1) -> None:
    """Find employees that have requested holidays, can be filter out by how many
    times they have request holidays, by default find the ones that have requested
    more than once

    Args:
        threshold (int, optional): control the filter lower limit. Defaults to 1.
    """
    query = load_query(query_path=TIMES_REQUESTED_HOLIDAYS)
    employee = namedtuple("Employee", ["name", "last_name", "times_requested"])
    res = execute_query(query=query, params=(threshold,))
    employees = [employee(*row) for row in res]
    print(tabulate(employees, headers=employee._fields))


def avg_salary() -> None:
    """Finds the employees' average salary and prints it as a table"""
    query = load_query(query_path=AVG_SALARY)
    response = namedtuple("Response", ["avg_salary"])
    res = execute_query(query=query)
    avg_salary = [response(*row) for row in res]
    print(tabulate(avg_salary, headers=response._fields, floatfmt=",.2f"))


def avg_days_requested_by_employee() -> None:
    """
    Find average days requested by employee, only shows the ones that have requested
    and prints them as a table
    """
    query = load_query(query_path=AVG_HOLIDAYS)
    employee = namedtuple("Employee", ["name", "last_name", "avg_days_requested"])
    res = execute_query(query=query)
    employees = [employee(*row) for row in res]
    print(tabulate(employees, headers=employee._fields))


def employee_with_most_days_requested() -> None:
    """
    Find the employee that have requested more holidays days and prints it
    and how many days has requested as a table
    """
    query = load_query(query_path=EMPLOYEE_WITH_MOST_DAYS_REQUESTED)
    employee = namedtuple("Employee", ["name", "last_name", "sum_days_requested"])
    res = execute_query(query=query)
    employees = [employee(*row) for row in res]
    print(tabulate(employees, headers=employee._fields))


def summary_holidays() -> None:
    """
    Summary of holidays requested by employee prints name, last name days
    approved and days rejected as a table
    """
    query = load_query(query_path=SUMMARY_HOLIDAYS)
    employee = namedtuple(
        "Employee", ["name", "last_name", "days_approved", "days_rejected"]
    )
    res = execute_query(query=query)
    employees = [employee(*row) for row in res]
    print(tabulate(employees, headers=employee._fields))


def main():
    init_database()
    print("Answer to technical test:")
    print("1. Select employees with salary greater than 4M")
    filter_employees_by_salary(SALARY_TO_FILTER_BY)
    print()
    print("2. Count employees by sex")
    count_employees_by_sex()
    print()
    print("3. Employees that have not requested holidays")
    employees_with_no_holidays_requested()
    print()
    print("4. Employees with more than one requested holiday")
    employees_requested_holidays()
    print()
    print("5. Average salary employees")
    avg_salary()
    print()
    print("6. Avg days requested by employees")
    avg_days_requested_by_employee()
    print()
    print("7. Employee with most days requested")
    employee_with_most_days_requested()
    print()
    print("8. Summary days requested")
    summary_holidays()


if __name__ == "__main__":
    main()
