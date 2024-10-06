FROM MYSQL:8.0
ENV MYSQL_ROOT_PASSWORD=ExpenseApp@1\
    MYSQL_USER=expense\
    MYSQL_PASSWORD=ExpenseApp@1\
    MYSQL_DATABASE=transactions
COPY script/*.sql /docker-entrypoint-initdb.d/
-