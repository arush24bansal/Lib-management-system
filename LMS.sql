DROP DATABASE IF EXISTS librarymngsys;
CREATE DATABASE libraryMngSys;
USE libraryMngSys;

/*===================================== CREATE TABLES ================================= */

-- Creating the Authors Table
CREATE TABLE Authors (
	ID int NOT NULL AUTO_INCREMENT,
    First_name varchar(100) NOT NULL, 
	Last_name varchar(100) NOT NULL,
    PRIMARY KEY(ID)
);

-- Create Publisher Table
CREATE TABLE Publishers (
	ID int NOT NULL AUTO_INCREMENT,
    Publisher_name varchar(150) NOT NULL,
    Address varchar(200),
    PRIMARY KEY (ID)
);

-- Creating the Books Table
CREATE TABLE Books (
	ID int NOT NULL AUTO_INCREMENT,
    title varchar(100) NOT NULL,
    Publisher_id int,
    Author_id int,
    PRIMARY KEY (ID),
    FOREIGN KEY (Author_id) REFERENCES Authors(ID),
    FOREIGN KEY (Publisher_id) REFERENCES Publishers(ID)
);

-- Create Members Table
CREATE TABLE members (
	ID int NOT NULL AUTO_INCREMENT,
    First_name varchar(100) NOT NULL,
    Last_name varchar(100) NOT NULL,
    Age int NOT NULL,
    Phone varchar(10) UNIQUE NOT NULL,
	Membership_start_date date NOT NULL,
    PRIMARY KEY (ID),
    CONSTRAINT Age_criteria CHECK (Age > 12),
    CONSTRAINT Phone_validity CHECK (Phone RLIKE'^[0-9]{10}$')
);

-- Create a Issued Books Table
CREATE TABLE Issues (
	Member_id int,
    Book_id int,
    Issue_date date NOT NULL,
    Due_date date NOT NULL,
    Return_date date,
    FOREIGN KEY (Member_id) REFERENCES Members(ID),
    FOREIGN KEY (Book_id) REFERENCES Books(ID),
    CHECK (Due_date > Issue_date)
);

CREATE TRIGGER setDueDate
	BEFORE INSERT ON Issues
    FOR EACH ROW
		SET NEW.Due_date = DATE_ADD(NEW.Issue_date, INTERVAL 15 DAY); 

/*================================ INSERTING VALUES ================================= */

INSERT INTO Authors
	(First_name, Last_name)
    VALUES
    ('Dan', 'Ariely'),
    ('Nicolas', 'Sparks'),
    ('Mahatria', 'Ra'),
    ('Agatha', 'Christie'),
    ('Sam', 'Kean'),
    ('Trevor', 'Noah'),
    ('Fyodor', 'Dostoyevsky'),
    ('Daniel', 'Kahneman'),
    ('Tim', 'Harford'),
    ('Steven', 'Levitt'),
    ('Steve', 'Dubner'),
    ('Lucy', 'Foley'),
    ('Elif', 'Shafak'),
    ('Holly', 'Jackson'), 
    ('Karen', 'McManus'),
    ('Robin', 'Sharma'),
    ('Josephine', 'Tey')
;

INSERT INTO Publishers
	(Publisher_name, Address)
    VALUES
    ('Harper Collins', 'New York'),
    ('Warner Books', 'New York'),
    ('Manjul Publishing', 'Bhopal'),
    ('Back Bay Books', 'New York'),
    ('Spiegel and Grau', 'New York'),
    ('Simon and Schuster', 'London'),
    ('Penguin Books', 'London'),
    ('Abacus', 'Essex'),
    ('William Morrow', 'New York'),
    ('Touchstone', 'Chicago'),
    ('Delacorte', 'New York')
;
    
INSERT INTO Books
	(Title, Author_id, Publisher_id)
    VALUES
    ('Freakonomics', 11, 9),
	('Superfreakonomics', 11, 9),
	('Predictaby Irrational', 1, 1),
	('The undercover Economist', 9, 8),
	('Thinking Fast and Slow', 8, 7),
	('Most and More', 3, 3),
	('The ABC Murders', 4, 1),
	('The Notebook', 2, 2),
	('Hickory Dickory Dock', 4, 1),
	('The mysterious Afffairs at Styles', 4, 1),
	('And then there were none', 4, 1),
	('Poirot Investigates', 4, 1),
	('The disappearing spoon', 5, 4),
	('Murder on the links', 4, 1),
	('Born a crime', 6, 5),
	('Crime and Punishment', 7, 6),
	('The murder of Roger Ackroyd', 4, 1),
	('The Big Four', 4, 1),
	('The mystery of the blue train', 4, 1),
	('The forty rules of love', 13, 7),
	('daughter of time', 17, 10),
	('The monk who sold his ferrari', 16, 1),
	('One of us is lying', 15, 11),
	('A good girls guide to murder', 14, 7),
	('The guest List', 12, 1)
;

INSERT INTO Members
	(First_name, Last_name, Age, Phone, Membership_start_date)
    VALUES
    ('Arush', 'Bansal', 23, '9909907558', str_to_date('24-11-2022', '%d-%m-%Y')),
    ('Sankalp', 'Sharma', 25, '9876543210', str_to_date('26-01-2022', '%d-%m-%Y')),
    ('Shubham', 'Maheshwari', 26, '1234567890', str_to_date('26-01-2022', '%d-%m-%Y')),
    ('Rishab', 'Jain', 28, '9876556789', str_to_date('30-06-2022', '%d-%m-%Y')),
    ('Vishesh', 'Dogra', 22, '1234554321', str_to_date('11-12-2022', '%d-%m-%Y')),
    ('Deepti', 'Bansal', 53, '9765432109', str_to_date('18-04-2022', '%d-%m-%Y')),
    ('Aayushi', 'Biyani', 21, '9090909090', str_to_date('23-01-2022', '%d-%m-%Y')),
    ('Sanyam', 'Kokra', 28, '9123456780', str_to_date('13-02-2022', '%d-%m-%Y')),
    ('Kushal', 'Saraf', 17, '9988776655', str_to_date('05-02-2022', '%d-%m-%Y'))
;

INSERT INTO Issues
	(Book_id, Member_id, Issue_date, Return_date)
    VALUES
    (2, 1, str_to_date('02-01-2022', '%d-%m-%Y'), str_to_date('19-01-2022', '%d-%m-%Y')),
    (21, 3, str_to_date('05-01-2022', '%d-%m-%Y'), str_to_date('12-01-2022', '%d-%m-%Y')),
    (23, 9, str_to_date('08-01-2022', '%d-%m-%Y'), str_to_date('15-01-2022', '%d-%m-%Y')),
    (14, 7, str_to_date('09-01-2022', '%d-%m-%Y'), str_to_date('25-01-2022', '%d-%m-%Y')),
    (16, 3, str_to_date('12-01-2022', '%d-%m-%Y'), str_to_date('23-01-2022', '%d-%m-%Y')),
    (18, 6, str_to_date('15-01-2022', '%d-%m-%Y'), str_to_date('25-01-2022', '%d-%m-%Y')),
    (8, 2, str_to_date('18-01-2022', '%d-%m-%Y'), str_to_date('28-01-2022', '%d-%m-%Y')),
    (7, 4, str_to_date('19-01-2022', '%d-%m-%Y'), str_to_date('07-02-2022', '%d-%m-%Y')),
    (6, 1, str_to_date('24-01-2022', '%d-%m-%Y'), str_to_date('08-02-2022', '%d-%m-%Y')),
    (3, 5, str_to_date('27-01-2022', '%d-%m-%Y'), str_to_date('08-02-2022', '%d-%m-%Y')),
    (12, 8, str_to_date('05-02-2022', '%d-%m-%Y'), str_to_date('17-02-2022', '%d-%m-%Y')),
    (14, 3, str_to_date('07-02-2022', '%d-%m-%Y'), str_to_date('24-02-2022', '%d-%m-%Y')),
    (24, 2, str_to_date('08-02-2022', '%d-%m-%Y'), str_to_date('15-02-2022', '%d-%m-%Y')),
    (23, 9, str_to_date('08-02-2022', '%d-%m-%Y'), str_to_date('17-02-2022', '%d-%m-%Y')),
    (1, 7, str_to_date('10-02-2022', '%d-%m-%Y'), str_to_date('22-02-2022', '%d-%m-%Y')),
    (18, 6, str_to_date('14-02-2022', '%d-%m-%Y'), str_to_date('26-02-2022', '%d-%m-%Y')),
    (17, 4, str_to_date('16-02-2022', '%d-%m-%Y'), str_to_date('28-02-2022', '%d-%m-%Y')),
    (11, 5, str_to_date('19-02-2022', '%d-%m-%Y'), str_to_date('28-02-2022', '%d-%m-%Y')),
    (4, 9, str_to_date('19-02-2022', '%d-%m-%Y'), str_to_date('01-03-2022', '%d-%m-%Y')),
    (12, 8, str_to_date('20-02-2022', '%d-%m-%Y'), str_to_date('03-02-2022', '%d-%m-%Y')),
    (10, 1, str_to_date('25-02-2022', '%d-%m-%Y'), str_to_date('09-03-2022', '%d-%m-%Y')),
    (5, 4, str_to_date('28-02-2022', '%d-%m-%Y'), str_to_date('10-03-2022', '%d-%m-%Y')),
    (9, 3, str_to_date('03-03-2022', '%d-%m-%Y'), str_to_date('19-03-2022', '%d-%m-%Y')),
    (18, 1, str_to_date('09-03-2022', '%d-%m-%Y'), str_to_date('17-03-2022', '%d-%m-%Y')),
    (13, 2, str_to_date('12-03-2022', '%d-%m-%Y'), str_to_date('24-03-2022', '%d-%m-%Y')),
    (19, 6, str_to_date('12-03-2022', '%d-%m-%Y'), str_to_date('28-03-2022', '%d-%m-%Y')),
    (2, 7, str_to_date('14-03-2022', '%d-%m-%Y'), str_to_date('26-03-2022', '%d-%m-%Y')),
    (25, 9, str_to_date('16-03-2022', '%d-%m-%Y'), str_to_date('28-03-2022', '%d-%m-%Y')),
    (24, 5, str_to_date('18-03-2022', '%d-%m-%Y'), str_to_date('30-03-2022', '%d-%m-%Y')),
    (20, 4, str_to_date('19-03-2022', '%d-%m-%Y'), str_to_date('31-03-2022', '%d-%m-%Y')),
    (8, 2, str_to_date('24-03-2022', '%d-%m-%Y'), str_to_date('08-04-2022', '%d-%m-%Y')),
    (5, 1, str_to_date('25-03-2022', '%d-%m-%Y'), str_to_date('06-04-2022', '%d-%m-%Y')),
    (1, 3, str_to_date('29-03-2022', '%d-%m-%Y'), str_to_date('15-04-2022', '%d-%m-%Y')),
    (14, 8, str_to_date('31-03-2022', '%d-%m-%Y'), str_to_date('14-04-2022', '%d-%m-%Y')),
    (17, 4, str_to_date('01-04-2022', '%d-%m-%Y'), str_to_date('16-04-2022', '%d-%m-%Y')),
    (19, 6, str_to_date('05-04-2022', '%d-%m-%Y'), str_to_date('18-04-2022', '%d-%m-%Y')),
    (21, 1, str_to_date('08-04-2022', '%d-%m-%Y'), str_to_date('18-04-2022', '%d-%m-%Y')),
    (7, 7, str_to_date('12-04-2022', '%d-%m-%Y'), str_to_date('20-04-2022', '%d-%m-%Y')),
    (5, 5, str_to_date('15-04-2022', '%d-%m-%Y'), str_to_date('28-04-2022', '%d-%m-%Y')),
    (18, 8, str_to_date('18-04-2022', '%d-%m-%Y'), str_to_date('30-04-2022', '%d-%m-%Y')),
    (25, 6, str_to_date('26-04-2022', '%d-%m-%Y'), NULL),
    (1, 9, str_to_date('28-04-2022', '%d-%m-%Y'), str_to_date('09-05-2022', '%d-%m-%Y')),
    (2, 2, str_to_date('02-05-2022', '%d-%m-%Y'), NULL),
    (6, 5, str_to_date('05-05-2022', '%d-%m-%Y'), NULL),
    (10, 3, str_to_date('09-05-2022', '%d-%m-%Y'), NULL)
;