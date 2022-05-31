CREATE DATABASE UniversityDB;

USE universityDB;
CREATE TABLE Products(
    id INT AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    price DECIMAL(8,2) NOT NULL,
    descr VARCHAR(2000),

    CONSTRAINT PK_Products PRIMARY KEY(id)
);

CREATE TABLE Jobs(
    id VARCHAR(10),
    title VARCHAR(35) NOT NULL,
    min_salary DECIMAL(8, 2),
    max_salary DECIMAL(8, 2),

    CONSTRAINT PK_Jobs PRIMARY KEY(id)
);

CREATE TABLE Regions(
    id SMALLINT AUTO_INCREMENT,
    name VARCHAR(25),

    CONSTRAINT PK_Regions PRIMARY KEY(id)
);

CREATE TABLE Countries(
    id CHAR(2),
    name VARCHAR(40),
    region_id SMALLINT,

    CONSTRAINT PK_Countries PRIMARY KEY(id),
    CONSTRAINT FK_Countries_Regions FOREIGN KEY(region_id)
    REFERENCES Regions(id)
);

CREATE TABLE Customers(
    id INT(6) AUTO_INCREMENT,
    country_id CHAR(2) NOT NULL,
    fname VARCHAR(20) NOT NULL,
    lname VARCHAR(20) NOT NULL,
    address TEXT,
    email VARCHAR(30),

    CONSTRAINT PK_Customers PRIMARY KEY(id),
    CONSTRAINT FK_Customers_Countries FOREIGN KEY (country_id)
    REFERENCES Countries(id)
);

CREATE TABLE Departments(
    id INT AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL,
    manager_id INT,
    country_id CHAR(2),
    city VARCHAR (30),
    state VARCHAR(25),
    address VARCHAR(40),
    postal_code VARCHAR(12),

    CONSTRAINT PK_Departments PRIMARY KEY(id),
    CONSTRAINT FK_Departments_Countries FOREIGN KEY(country_id)
    REFERENCES Countries(id)
);

CREATE TABLE Employees(
    id INT AUTO_INCREMENT,
    fname VARCHAR(20) NOT NULL,
    lname VARCHAR(20) NOT NULL,
    email VARCHAR(25) NOT NULL UNIQUE,
    phone VARCHAR(20),
    hire_date DATETIME NOT NULL,
    salary DECIMAL(8,2),
    job_id VARCHAR(10) NOT NULL,
    manager_id INT,
    department_id INT,

    CONSTRAINT PK_Employees PRIMARY KEY (id),
    CONSTRAINT FK_Employees_Employees FOREIGN KEY (manager_id)
    REFERENCES Employees(id),
    CONSTRAINT FK_Employees_Jobs FOREIGN KEY (job_id)
    REFERENCES Jobs(id),
    CONSTRAINT FK_Employees_Departments FOREIGN KEY (department_id)
    REFERENCES Departments(id)
);

ALTER TABLE departments
    ADD CONSTRAINT FK_Departments_Employees FOREIGN KEY (manager_id)
    REFERENCES Employees(id);

CREATE TABLE Orders(
    id INT AUTO_INCREMENT,
    order_date DATETIME NOT NULL,
    customer_id INT(6) NOT NULL,
    employee_id INT NOT NULL,
    ship_address VARCHAR(150),

    CONSTRAINT PK_Orders PRIMARY KEY (id),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (customer_id)
    REFERENCES Customers(id),
    CONSTRAINT FK_Orders_Employees FOREIGN KEY (employee_id)
    REFERENCES Employees(id)
);

CREATE TABLE Orders_Items(
    order_id INT,
    product_id INT,
    unit_price DECIMAL(8,2) NOT NULL,
    quantity INT NOT NULL,

    CONSTRAINT PK_Orders_Items PRIMARY KEY(order_id, product_id),
    CONSTRAINT FK_Orders_Items_Orders FOREIGN KEY (order_id)
    REFERENCES Orders(id),
    CONSTRAINT FK_Orders_Items_Products FOREIGN KEY (product_id)
    REFERENCES Products(id)
);

/* Инсерт заявки */
INSERT INTO Jobs (id, title, min_salary, max_salary)
            VALUES("net_dev", ".NET Full Stack Dev", 2500, 10000),
            ("react_full", "React Software Developer", 1200, 4500),
            ("java_back", "Java Backend Engineer", 2300, 9000),
            ("py_dev", "Python Developer", 1100, 6000),
            ("php_back", "PHP Backend Engineer", 1200, 4000);

INSERT INTO regions (name)
            VALUES("Balkans"), ("Arab peninsula"), ("Eastern Europe"),
            ("Central Asia"), ("Atlantic ocean"), ("Western Europe"),
            ("Eurasia");

INSERT INTO countries(id, name, region_id)
            VALUES("bg", "Bulgaria", (SELECT id FROM regions WHERE name = "Balkans")),
             ("uk", "United Kingdom", (SELECT id FROM regions WHERE name = "Atlantic ocean")),
             ("ue", "UAE", (SELECT id FROM regions WHERE name = "Arab peninsula")), 
             ("is", "Israel", (SELECT id FROM regions WHERE name = "Arab peninsula")), 
             ("al", "Albania", (SELECT id FROM regions WHERE name = "Balkans")), 
             ("ts", "Tajikistan", (SELECT id FROM regions WHERE name = "Central Asia")), 
             ("ru", "Russia", (SELECT id FROM regions WHERE name = "Eurasia")), 
             ("md", "Moldova", (SELECT id FROM regions WHERE name = "Eastern Europe")), 
             ("sw", "Switzerland", (SELECT id FROM regions WHERE name = "Western Europe"));

INSERT INTO departments (name, country_id, city, state)
                VALUES("Research department", (SELECT id FROM countries WHERE name = "Israel"), "Acre", "Northern District"),
                ("Data managment department", (SELECT id FROM  countries WHERE name = "Tajikistan"), "Khujand", "Sughd"),
                ("Backend department", (SELECT id FROM countries WHERE name = "Bulgaria"), "Plovdiv", "Plovdiv"),
                ("Frontend department", (SELECT id FROM countries WHERE name = "Moldova"), "Leova", "Leova district"),
                ("Marketing department", (SELECT id FROM  countries WHERE name = "Albania"), "Tirana", "Tirana"),
                ("Accounting department", (SELECT  id FROM countries WHERE  name = "Switzerland"), "Bern", "Bern");


INSERT INTO Employees (fname, lname, email, phone, hire_date, salary, job_id, department_id)
                VALUES("stamat", "ignatov", "stamat_ignatov@gmail.com", "088 888 8888", 
                        "2009-01-04 00:00:00", 8000, "java_back", 3),
                    ("dimitri", "ruskov", "dim_ruskov@gmail.com", "0872551854", 
                        "2016-07-06 00:00:00", 4000, "net_dev", 5);

INSERT INTO Employees (fname, lname, email, phone, hire_date, salary, job_id, department_id, manager_id)                    
                VALUES("vladimir", "molotov", "vlad_molotov@gmail.com", "08733255255", 
                        "2019-01-01 00:00:00", 1700, "react_full", 4, 1),
                    ("petar", "kirilov", "petar_kirilov@gmail.com", "87332552552", 
                        "2018-09-09 00:00:00", 4200, "php_back", 3, 1),
                    ("Joe", "Biden", "joe_biden@gmail.com", "0883411987", 
                        "2014-11-08 00:00:00", 2000, "py_dev", 2, 2);

INSERT INTO customers (country_id, fname, lname, address, email)
                VALUES((SELECT id FROM  countries WHERE name = "Albania"), "Ardit", "Daniel", "Tirana 22", "ardit@gmail.com"),
                ((SELECT id FROM  countries WHERE name = "Albania"), "Daniel", "Ardit", "Tirana 20", "daniel@gmail.com"),
                ((SELECT id FROM  countries WHERE name = "Bulgaria"), "Boiko", "Borisov", "Bankia 43", "boiko_borisov@gmail.com"),
                ((SELECT id FROM  countries WHERE name = "Bulgaria"), "Dimitar", "Dimitrov", "Montana 32", "dimitar_dimitrov@gmail.com"),
                ((SELECT id FROM  countries WHERE name = "Israel"), "David", "Binski", "Jerusalim 1", "david_binski@gmail.com"),
                ((SELECT id FROM  countries WHERE name = "Moldova"), "Yuriy", "Sereedar", "Kishinow 123", "yiriy123@gmail.com"),
                ((SELECT id FROM  countries WHERE name = "Russia"), "Boris", "Ignatinko", "Moscow 220", "ignatinko_boris@gmail.com"),
                ((SELECT id FROM  countries WHERE name = "Russia"), "Roman","Aleksiev" , "Novosibirsk 11", "roman_aleksiev@gmail.com"),
                ((SELECT id FROM  countries WHERE name = "Tajikistan"), "Firuz", "Jamshed", "Dushanbe 1", "firuz_jamshed@gmail.com");

INSERT INTO products (name, price)
                VALUES("to-do app", 5000), ("online_store", 7000),
                 ("web_tool", 9000), ("mobile_game", 6500), 
                 ("mb_platform", 8000);

INSERT INTO orders (order_date, customer_id, employee_id, ship_address)
            VALUES ("2020-09-06 13:07:00", 
                (SELECT id FROM customers WHERE fname = "Boiko" AND lname = "Borisov"),
                (SELECT id FROM employees WHERE fname = "dimitri" AND lname = "ruskov"),
                (SELECT address FROM customers WHERE fname = "Boiko" AND lname = "Borisov")),
                
                ("2020-12-06 11:12:02", 
                (SELECT id FROM customers WHERE fname = "David" AND lname = "Binski"),
                (SELECT id FROM employees WHERE fname = "vladimir" AND lname = "molotov"),
                (SELECT address FROM customers WHERE fname = "David" AND lname = "Binski")),
                
                ("2021-01-02 16:07:01", 
                (SELECT id FROM customers WHERE fname = "David" AND lname = "Binski"),
                (SELECT id FROM employees WHERE fname = "Joe" AND lname = "Biden"),
                (SELECT address FROM customers WHERE fname = "David" AND lname = "Binski")),
                
                ("2020-03-03 03:17:02", 
                (SELECT id FROM customers WHERE fname = "Roman" AND lname = "Aleksiev"),
                (SELECT id FROM employees WHERE fname = "petar" AND lname = "kirilov"),
                (SELECT address FROM customers WHERE fname = "Roman" AND lname = "Aleksiev")),
                
                ("2020-03-03 03:17:02", 
                (SELECT id FROM customers WHERE fname = "Ardit" AND lname = "Daniel"),
                (SELECT id FROM employees WHERE fname = "petar" AND lname = "kirilov"),
                (SELECT address FROM customers WHERE fname = "Ardit" AND lname = "Daniel"));

INSERT INTO orders_items (order_id, product_id, unit_price, quantity)
            VALUES(6, 4, (SELECT price FROM products WHERE id = 4), 2),
            (6, 3, (SELECT price FROM products WHERE id = 4), 2),
            (7, 2, (SELECT price FROM products WHERE id = 2), 3),
            (9, 2, (SELECT price FROM products WHERE id = 2), 1),
            (10, 3, (SELECT price FROM products WHERE id = 3), 5);


/* QUERIES */
/*1*/
SELECT COUNT(id), SUM(salary) 
    FROM employees;

/*2*/
SELECT name, AVG(salary)
FROM departments
LEFT JOIN employees
ON departments.id = employees.department_id
GROUP BY name;

/*3*/
SELECT m.fname, m.lname, COUNT(e.id)
FROM employees AS m
LEFT JOIN employees as e
ON m.id = e.manager_id
GROUP BY m.id;

/*4*/
SELECT title, COUNT(fname), AVG(salary)
FROM jobs
LEFT JOIN employees
ON jobs.id = employees.job_id
GROUP BY title;

/*5*/
SELECT name, COUNT(fname) as  employees_count, COUNT(employees.manager_id)
FROM departments
LEFT JOIN employees
ON departments.id = employees.department_id
GROUP BY name;


/*6*/
SELECT countries.name, COUNT(departments.id)
FROM countries
RIGHT  JOIN departments
ON countries.id = departments.country_id
GROUP BY (countries.name);

/*7*/
SELECT name, COUNT(employees.id)
FROM departments
LEFT JOIN employees
ON departments.id = employees.department_id
GROUP BY name
ORDER BY AVG(salary) DESC
LIMIT 3;

/*8*/
SELECT name, COUNT(emp.id)
FROM departments
LEFT JOIN employees as emp
ON departments.id = emp.department_id AND departments.manager_id != emp.id
GROUP BY departments.name
ORDER BY AVG(emp.salary) DESC
LIMIT 3;

/*9*/
SELECT countries.name AS Country, fname, lname, address, COUNT(fname)
FROM customers
INNER JOIN countries
ON customers.country_id = countries.id
GROUP BY countries.id
ORDER BY fname, lname DESC
LIMIT 10;

/*FUNCTIONS AND PROCEDURES*/

/*1 заявка - за добавяне на регион*/
CREATE PROCEDURE insert_regions(IN name varchar(25))
   BEGIN
    INSERT INTO regions(name) VALUES(Name);
   END;
CALL insert_regions("Africa");

/*2 заявка - за въвеждане на customers*/
CREATE PROCEDURE insert_customer(IN first_name VARCHAR(20), IN last_name VARCHAR(20), IN country_name varchar(25))
   BEGIN
   INSERT INTO customers(fname, lname, country_id)
        VALUES (first_name, last_name, (SELECT id FROM countries WHERE name = country_name));
   END;
CALL insert_customer("George", "Stone", "Tajikistan");

/*3 заявка - за въвеждане на служители*/
CREATE PROCEDURE insert_employee(IN first_name VARCHAR(20), IN last_name VARCHAR(20),
                emp_email VARCHAR(25), emp_hire_date DATETIME, job_name VARCHAR(35), 
                department_name VARCHAR(30))
    BEGIN 
    INSERT INTO employees (fname, lname, email, hire_date, job_id, department_id)
        VALUES(first_name, last_name, emp_email, emP_hire_date,
        (SELECT id FROM jobs WHERE title = job_name),
        (SELECT id FROM departments WHERE name = department_name) );
    END;
CALL insert_employee("Boiko", "Antonov", "boiko_ant@gmail.com", "2020-12-06 11:12:02",
                    "Java Backend Engineer", "Backend department");

/*4 функция - за колко поръчки има даден клиент*/
DROP FUNCTION  universitydb.get_orders;
CREATE FUNCTION get_orders(customer_fname VARCHAR(20), customer_lname VARCHAR(20))
    RETURNS INT
    
    BEGIN
        RETURN (
            SELECT COUNT(orders.id)
            FROM orders
            WHERE customer_id = (SELECT id FROM customers AS c2 WHERE c2.fname = customer_fname AND
                            c2.lname = customer_lname)
            GROUP BY orders.customer_id
            );
    END;
SELECT universitydb.get_orders("Ardit", "Daniel") AS "Ardit`s orders";

/*5 функция - средна цена на поръчките за всяка държава*/
CREATE FUNCTION get_avg_price (country_name VARCHAR(25))
    RETURNS DECIMAL(8,2)

    BEGIN 
        RETURN(
            SELECT AVG(ord.price)
            FROM customers
            INNER JOIN (SELECT id, customer_id, SUM(unit_price*quantity) AS price
                FROM orders
                INNER JOIN orders_items
                WHERE orders.id = orders_items.order_id
                GROUP BY id) AS ord
            WHERE customers.country_id = (SELECT id FROM countries WHERE name=country_NAME) 
                AND customers.id = ord.customer_id);
        
    END;

SELECT get_avg_price("Bulgaria");

/*TRIGGERS*/

