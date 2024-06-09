import os
import sqlite3

PATH_INIT_QUERY = "./queries/init_db.sql"


def init_database() -> None:
    """create two tables `empleado` y `vacaciones` and loads dummy info on both tables"""
    con = sqlite3.connect("test_sql.db")
    cur = con.cursor()
    try:
        full_path = os.path.join(os.getcwd(), PATH_INIT_QUERY)
        with open(full_path) as file:
            multi_statement_query = file.read()
        for query in multi_statement_query.split(";"):
            cur.execute(query)
    except sqlite3.OperationalError as error:
        print(f"Error ocurred {error}")
    finally:
        con.commit()
        con.close()


if __name__ == "__main__":
    init_database()
