-- =====================================================================
-- VBIS-Chapter3-SQL: universitet + bank sxemləri və test məlumatları
-- PostgreSQL üçün. Sorğuları yoxlamaq və screenshot almaq üçün istifadə olunur.
-- İcra: psql -U postgres -d vbis_ch3 -f schema_and_sample_data.sql
-- =====================================================================

DROP TABLE IF EXISTS takes, teaches, advisor, section, student, instructor,
                     course, department, classroom, time_slot CASCADE;
DROP TABLE IF EXISTS depositor, borrower, account, loan, customer, branch CASCADE;

-- ---------------------------- UNIVERSITET ----------------------------
CREATE TABLE classroom (
    building    VARCHAR(15),
    room_number VARCHAR(7),
    capacity    NUMERIC(4,0),
    PRIMARY KEY (building, room_number)
);

CREATE TABLE department (
    dept_name VARCHAR(20) PRIMARY KEY,
    building  VARCHAR(15),
    budget    NUMERIC(12,2) CHECK (budget > 0)
);

CREATE TABLE course (
    course_id VARCHAR(8) PRIMARY KEY,
    title     VARCHAR(50),
    dept_name VARCHAR(20) REFERENCES department(dept_name) ON DELETE SET NULL,
    credits   NUMERIC(2,0) CHECK (credits >= 0)
);

CREATE TABLE instructor (
    ID        VARCHAR(5) PRIMARY KEY,
    name      VARCHAR(20) NOT NULL,
    dept_name VARCHAR(20) REFERENCES department(dept_name) ON DELETE SET NULL,
    salary    NUMERIC(8,2) CHECK (salary > 29000)
);

CREATE TABLE time_slot (
    time_slot_id VARCHAR(4),
    day          VARCHAR(1),
    start_hr     NUMERIC(2) CHECK (start_hr >= 0 AND start_hr < 24),
    start_min    NUMERIC(2) CHECK (start_min >= 0 AND start_min < 60),
    end_hr       NUMERIC(2) CHECK (end_hr >= 0 AND end_hr < 24),
    end_min      NUMERIC(2) CHECK (end_min >= 0 AND end_min < 60),
    PRIMARY KEY (time_slot_id, day, start_hr, start_min)
);

CREATE TABLE section (
    course_id    VARCHAR(8) REFERENCES course(course_id) ON DELETE CASCADE,
    sec_id       VARCHAR(8),
    semester     VARCHAR(6) CHECK (semester IN ('Fall','Winter','Spring','Summer')),
    year         NUMERIC(4,0) CHECK (year > 1701 AND year < 2100),
    building     VARCHAR(15),
    room_number  VARCHAR(7),
    time_slot_id VARCHAR(4),
    PRIMARY KEY (course_id, sec_id, semester, year),
    FOREIGN KEY (building, room_number) REFERENCES classroom(building, room_number)
        ON DELETE SET NULL
);

CREATE TABLE teaches (
    ID        VARCHAR(5) REFERENCES instructor(ID) ON DELETE CASCADE,
    course_id VARCHAR(8),
    sec_id    VARCHAR(8),
    semester  VARCHAR(6),
    year      NUMERIC(4,0),
    PRIMARY KEY (ID, course_id, sec_id, semester, year),
    FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section(course_id, sec_id, semester, year) ON DELETE CASCADE
);

CREATE TABLE student (
    ID        VARCHAR(5) PRIMARY KEY,
    name      VARCHAR(20) NOT NULL,
    dept_name VARCHAR(20) REFERENCES department(dept_name) ON DELETE SET NULL,
    tot_cred  NUMERIC(3,0) CHECK (tot_cred >= 0)
);

CREATE TABLE takes (
    ID        VARCHAR(5) REFERENCES student(ID) ON DELETE CASCADE,
    course_id VARCHAR(8),
    sec_id    VARCHAR(8),
    semester  VARCHAR(6),
    year      NUMERIC(4,0),
    grade     VARCHAR(2),
    PRIMARY KEY (ID, course_id, sec_id, semester, year),
    FOREIGN KEY (course_id, sec_id, semester, year)
        REFERENCES section(course_id, sec_id, semester, year) ON DELETE CASCADE
);

CREATE TABLE advisor (
    s_ID VARCHAR(5) PRIMARY KEY REFERENCES student(ID) ON DELETE CASCADE,
    i_ID VARCHAR(5) REFERENCES instructor(ID) ON DELETE SET NULL
);

INSERT INTO classroom VALUES
 ('Taylor','3128',70), ('Watson','100',30), ('Packard','101',500), ('Painter','514',10);

INSERT INTO department VALUES
 ('Comp. Sci.','Taylor',100000), ('Physics','Watson',70000),
 ('Accounting','Painter',120000), ('Philosophy','Packard',60000),
 ('History','Painter',50000), ('Music','Packard',80000);

INSERT INTO course VALUES
 ('CS-101','Intro. to Computer Science','Comp. Sci.',4),
 ('CS-190','Game Design','Comp. Sci.',4),
 ('CS-315','Robotics','Comp. Sci.',3),
 ('PHY-101','Physical Principles','Physics',4),
 ('ACC-201','Financial Accounting','Accounting',3),
 ('HIS-351','World History','History',3),
 ('MU-199','Music Video Production','Music',3),
 ('PHI-101','Introduction to Logic','Philosophy',3);

INSERT INTO instructor VALUES
 ('10101','Srinivasan','Comp. Sci.',65000), ('45565','Katz','Comp. Sci.',75000),
 ('83821','Brandt','Comp. Sci.',92000),     ('22222','Einstein','Physics',95000),
 ('33456','Gold','Physics',87000),          ('98345','Kim','Accounting',80000),
 ('15151','Mozart','Music',40000),          ('32343','El Said','History',60000),
 ('58583','Califieri','History',62000),     ('76766','Crick','Philosophy',72000);

INSERT INTO time_slot VALUES
 ('A','M',8,0,8,50), ('A','W',8,0,8,50), ('B','M',9,0,9,50),
 ('C','M',11,0,11,50), ('D','T',13,0,13,50), ('E','T',14,30,15,45),
 ('F','M',16,0,16,50);

INSERT INTO section VALUES
 ('CS-101','1','Fall',2016,'Taylor','3128','A'),
 ('CS-101','1','Fall',2017,'Taylor','3128','A'),
 ('CS-101','1','Spring',2018,'Taylor','3128','D'),
 ('CS-190','1','Spring',2017,'Taylor','3128','E'),
 ('CS-190','1','Spring',2018,'Taylor','3128','E'),
 ('CS-315','1','Spring',2017,'Watson','100','C'),
 ('CS-315','1','Spring',2018,'Watson','100','C'),
 ('PHY-101','1','Fall',2017,'Watson','100','B'),
 ('ACC-201','1','Fall',2017,'Painter','514','B'),
 ('HIS-351','1','Spring',2018,'Painter','514','C'),
 ('MU-199','1','Spring',2018,'Packard','101','F'),
 ('PHI-101','1','Fall',2017,'Packard','101','A');

INSERT INTO teaches VALUES
 ('10101','CS-101','1','Fall',2016), ('10101','CS-101','1','Fall',2017), ('10101','CS-101','1','Spring',2018),
 ('45565','CS-190','1','Spring',2017), ('45565','CS-190','1','Spring',2018),
 ('45565','CS-315','1','Spring',2017), ('45565','CS-315','1','Spring',2018),
 ('83821','CS-101','1','Fall',2016), ('83821','CS-190','1','Spring',2017), ('83821','CS-315','1','Spring',2017),
 ('22222','PHY-101','1','Fall',2017),
 ('98345','ACC-201','1','Fall',2017),
 ('15151','MU-199','1','Spring',2018),
 ('32343','HIS-351','1','Spring',2018),
 ('76766','PHI-101','1','Fall',2017);

INSERT INTO student VALUES
 ('00128','Zhang','Comp. Sci.',102), ('12345','Shankar','Comp. Sci.',32),
 ('19991','Brandt','History',80),    ('23121','Chavez','Accounting',110),
 ('44553','Peltier','Physics',56),   ('54321','Williams','Comp. Sci.',54),
 ('55739','Sanchez','Music',38),     ('76653','Aoi','Accounting',60),
 ('98765','Bourikas','Accounting',98), ('70557','Snow','Physics',0);

INSERT INTO takes VALUES
 -- Zhang: CS-101 x3, CS-190 x2, CS-315 x2
 ('00128','CS-101','1','Fall',2016,'F'), ('00128','CS-101','1','Fall',2017,'C'), ('00128','CS-101','1','Spring',2018,'B'),
 ('00128','CS-190','1','Spring',2017,'D'), ('00128','CS-190','1','Spring',2018,'A-'),
 ('00128','CS-315','1','Spring',2017,'B'), ('00128','CS-315','1','Spring',2018,'A'),
 ('12345','CS-101','1','Fall',2016,'C'), ('12345','CS-101','1','Fall',2017,'B'),
 ('54321','CS-101','1','Fall',2017,'A-'), ('54321','CS-190','1','Spring',2018,'B+'),
 ('19991','HIS-351','1','Spring',2018,'B'),
 ('23121','ACC-201','1','Fall',2017,'C+'),
 ('76653','ACC-201','1','Fall',2017,'A'),
 ('44553','PHY-101','1','Fall',2017,'B-'), ('44553','PHI-101','1','Fall',2017,'B'),
 ('55739','MU-199','1','Spring',2018,NULL);

INSERT INTO advisor VALUES
 ('00128','45565'), ('12345','10101'), ('23121','22222'), ('44553','22222'),
 ('76653','98345'), ('98765','33456'), ('54321','83821'), ('55739','15151'),
 ('19991','32343');

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
