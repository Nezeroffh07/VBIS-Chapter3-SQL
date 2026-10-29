-- Bank sxemi + test məlumatları (PostgreSQL)
DROP TABLE IF EXISTS depositor, borrower, account, loan, customer, branch CASCADE;

-- ------------------------------ BANK ---------------------------------
CREATE TABLE branch (
    branch_name VARCHAR(20) PRIMARY KEY,
    branch_city VARCHAR(20),
    assets      NUMERIC(14,2)
);
CREATE TABLE customer (
    ID              VARCHAR(5) PRIMARY KEY,
    customer_name   VARCHAR(20),
    customer_street VARCHAR(30),
    customer_city   VARCHAR(20)
);
CREATE TABLE loan (
    loan_number VARCHAR(10) PRIMARY KEY,
    branch_name VARCHAR(20) REFERENCES branch(branch_name),
    amount      NUMERIC(12,2)
);
CREATE TABLE borrower (
    ID          VARCHAR(5) REFERENCES customer(ID),
    loan_number VARCHAR(10) REFERENCES loan(loan_number),
    PRIMARY KEY (ID, loan_number)
);
CREATE TABLE account (
    account_number VARCHAR(10) PRIMARY KEY,
    branch_name    VARCHAR(20) REFERENCES branch(branch_name),
    balance        NUMERIC(12,2)
);
CREATE TABLE depositor (
    ID             VARCHAR(5) REFERENCES customer(ID),
    account_number VARCHAR(10) REFERENCES account(account_number),
    PRIMARY KEY (ID, account_number)
);

INSERT INTO branch VALUES
 ('Brighton','Brooklyn',7100000), ('Downtown','Brooklyn',9000000),
 ('Mianus','Horseneck',400000),   ('North Town','Rye',3700000),
 ('Perryridge','Horseneck',1700000), ('Pownal','Bennington',300000),
 ('Redwood','Palo Alto',2100000), ('Round Hill','Horseneck',8000000);

INSERT INTO customer VALUES
 ('10001','Johnson','Alma','Palo Alto'), ('10002','Smith','North','Rye'),
 ('10003','Hayes','Main','Harrison'),    ('10004','Jones','Main','Harrison'),
 ('10005','Lindsay','Park','Pittsfield');

INSERT INTO account VALUES
 ('A-101','Downtown',500), ('A-102','Perryridge',400), ('A-201','Brighton',900),
 ('A-215','Mianus',700),   ('A-217','Brighton',750),   ('A-222','Redwood',700),
 ('A-305','Round Hill',350);

INSERT INTO depositor VALUES
 ('10001','A-101'), ('10001','A-201'),   -- Johnson: Downtown + Brighton (ikisi də Brooklyn)
 ('10003','A-102'), ('10002','A-215'), ('10004','A-217'), ('10005','A-305');

INSERT INTO loan VALUES
 ('L-11','Round Hill',900), ('L-14','Downtown',1500), ('L-15','Perryridge',1500),
 ('L-16','Perryridge',1300), ('L-17','Downtown',1000), ('L-23','Redwood',2000),
 ('L-93','Mianus',500);

INSERT INTO borrower VALUES
 ('10004','L-14'), ('10002','L-11'), ('10003','L-15'), ('10005','L-23');
