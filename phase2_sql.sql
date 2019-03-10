/* Floris van Rossum and Sam Moran */
/* CS3431 Project Part 2 */

/* ======================================== PART 1 ======================================== */

DROP TABLE StayIn;
DROP TABLE Examine;
DROP TABLE Admission;
DROP TABLE Doctor;
DROP TABLE Patient;
DROP TABLE RoomAccess;
DROP TABLE RoomService;
Drop Table Equipment;
DROP TABLE Room;
Drop table EquipmentType;
DROP TABLE Employee; 


CREATE TABLE Employee(
        ID CHAR(20) PRIMARY KEY,
        FirstName CHAR(20) NOT NULL,
        LastName CHAR(20) NOT NULL,
        Salary INTEGER,
        JobTitle CHAR(40),
        OfficeNum INTEGER,
        Rank CHAR(1),
        SupervisorID CHAR(20) REFERENCES Employee(ID),
        CONSTRAINT rank_chk CHECK (rank in ('0', '1', '2')),
        CONSTRAINT office_chk CHECK (OfficeNum >= 0));

CREATE TABLE EquipmentType(
        ID CHAR(20) PRIMARY KEY,
        Description CHAR(100),
        Model CHAR(40),
        Instructions CHAR(500),
        NumUnits INTEGER
        CONSTRAINT units_chk CHECK(NumUnits > 0));

CREATE TABLE Room(
        Num INTEGER PRIMARY KEY,
        Occupied CHAR(1),
        CONSTRAINT occupied_chk CHECK(Occupied in ('0', '1')),
        CONSTRAINT num_chk CHECK(Num > 0));

CREATE TABLE Equipment(
        SerialNum CHAR(30) PRIMARY KEY,
        TypeID CHAR(20) REFERENCES EquipmentType(ID),
        PurchaseYear CHAR(4),
        LastInspection TIMESTAMP,
        RoomNum INTEGER REFERENCES Room(Num));

CREATE TABLE RoomService(
        RoomNum INTEGER REFERENCES Room(Num),
        Service CHAR(40) UNIQUE);

CREATE TABLE RoomAccess(
        RoomNum INTEGER REFERENCES Room(Num),
        EmployeeID CHAR(20) REFERENCES Employee(ID));

CREATE TABLE Patient(
        SSN CHAR(9) PRIMARY KEY,
        FirstName CHAR(20) NOT NULL,
        LastName CHAR(20) NOT NULL,
        Address CHAR(40),
        TelNum CHAR(10));

CREATE TABLE DOCTOR(
        ID CHAR(20) PRIMARY KEY,
        Gender CHAR(6),
        Specialty CHAR(20),
        FirstName CHAR(20) NOT NULL,
        LastName CHAR(20) NOT NULL,
        CONSTRAINT gender_chk CHECK(Gender in ('Male', 'Female')));

CREATE TABLE Admission(
        Num INTEGER PRIMARY KEY,
        AdmissionDate DATE NOT NULL,
        LeaveDate DATE,
        TotalPayment NUMBER,
        InsurancePayment NUMBER,
        PatientSSN REFERENCES Patient(SSN),
        FutureVisit DATE,
        CONSTRAINT insurance_chk CHECK(InsurancePayment <= 1 AND InsurancePayment >= 0),
        CONSTRAINT leave_chk CHECK (LeaveDate >= AdmissionDate),
        CONSTRAINT future_chk CHECK(FutureVisit >= LeaveDate));

CREATE TABLE Examine(
        DoctorID REFERENCES Doctor(ID),
        AdmissionNum REFERENCES Admission(Num),
        Comments CHAR(100));

CREATE TABLE StayIn(
        AdmissionNum REFERENCES Admission(Num),
        RoomNum REFERENCES Room(Num),
        StartDate DATE UNIQUE NOT NULL,
        EndDate DATE);

/* ======================================== PART 3 ======================================== */

/* 10 patients
10 Doctors
10 Rooms, 3 rooms have two or more services
3 Equipment Types,
3 Equipment Units of each type,
5 Patients have two or more admissions
10 Regular employees, 4 division managers, and 2 general managers */

/* Patient Population */
INSERT INTO Patient VALUES ('111223333', 'Henry', 'Goddard', '100 
Institute Road', '2022221312');

INSERT INTO Patient VALUES ('232134532', 'Robert', 'Serber', '121 Dean 
Street', '2405002131');

INSERT INTO Patient VALUES ('923921239', 'Ernest', 'Lawrence', '213 
Highland 
Street', '1232442134');

INSERT INTO Patient VALUES ('299245745', 'Enrico', 'Fermi', '123 Pile 
Street', '2132223142');

INSERT INTO Patient VALUES ('213125443', 'Niels', 'Bohr', '231 Denmark 
Street', '1236549786');

INSERT INTO Patient VALUES ('541529857', 'Albert', 'Einstein', '859 
Manhattan Way', '9872345998');

INSERT INTO Patient VALUES ('823954687', 'Marie', 'Curie', '12 Radium 
Circle', '5932435832');

INSERT INTO Patient VALUES ('123214412', 'Arthur', 'Compton', '45 
Scattered Field', '4520998030');

INSERT INTO Patient VALUES ('302919392', 'Stephen', 'Hawking', '23 
Blackhole Lane', '2440104359');

INSERT INTO Patient VALUES ('495943245', 'Robert', 'Oppenheimer', '21 Los 
Alamos Drive', '2310440320');

/* Doctor Population */
INSERT INTO Doctor VALUES ('82318231', 'Male', 'Cardiologist', 'Alex', 
'Hard');

INSERT INTO Doctor VALUES ('23129424', 'Male', 'Allergist', 'Sam', 
'Moran');

INSERT INTO Doctor VALUES ('21421312', 'Female', 'Dermatologist', 'Jane', 
'Jemison');

INSERT INTO Doctor VALUES ('64364366', 'Female', 'Hospitalist', 'Drewpy', 
'Robert');

INSERT INTO Doctor VALUES ('45621345', 'Male', 'Internist', 'Floris', 'van 
Rossum');

INSERT INTO Doctor VALUES ('13254363', 'Female', 'Oncologist', 'Nikki', 
'Roschewsk');

INSERT INTO Doctor VALUES ('83153416', 'Male', 'Pediatrician', 'Chris', 
'Tracy');

INSERT INTO Doctor VALUES ('43163265', 'Female', 'Pulmonologist', 'Mara', 
'Paul');

INSERT INTO Doctor VALUES ('23265255', 'Female', 'Radiologist', 'Maddi', 
'Farms');

INSERT INTO Doctor VALUES ('76576583', 'Male', 'Urologist', 'Bailey', 
'Joseph');

/* Room Population */
INSERT INTO Room VALUES ('111', '1');
INSERT INTO Room VALUES ('123', '0');
INSERT INTO Room VALUES ('231', '1');
INSERT INTO Room VALUES ('002', '0');
INSERT INTO Room VALUES ('023', '1');
INSERT INTO Room VALUES ('232', '0');
INSERT INTO Room VALUES ('421', '1');
INSERT INTO Room VALUES ('133', '0');
INSERT INTO Room VALUES ('532', '1');
INSERT INTO Room VALUES ('124', '0');

/* RoomService Population */
INSERT INTO RoomService VALUES ('111', 'Surgery 1');
INSERT INTO RoomService VALUES ('111', 'ICU 1');
INSERT INTO RoomService VALUES ('123', 'Maternity Ward 1');
INSERT INTO RoomService VALUES ('231', 'Radiology Department');
INSERT INTO RoomService VALUES ('002', 'Consulting Room');
INSERT INTO RoomService VALUES ('023', 'Patient Room 2');
INSERT INTO RoomService VALUES ('232', 'Multipurpose Room');
INSERT INTO RoomService VALUES ('421', 'Patient Room 1');
INSERT INTO RoomService VALUES ('421', 'ICU 2');
INSERT INTO RoomService VALUES ('133', 'Neonatal Care');
INSERT INTO RoomService VALUES ('133', 'Maternal Department');
INSERT INTO RoomService VALUES ('532', 'Pediatric Care');
INSERT INTO RoomService VALUES ('124', 'Psychiatric Ward');
INSERT INTO RoomService VALUES ('124', 'Endoscopy Unit');


/* Equipment Types */
INSERT INTO EquipmentType VALUES ('342123', 'X-Ray Slicer Scanner', 'CAT 
Scanner', 'Turn on and scan', 6);

INSERT INTO EquipmentType VALUES ('534643', 'Used for beaming particles', 
'Particle Accelerator', 'Turn on and beam', 3);

INSERT INTO EquipmentType VALUES ('455325', 'Surgical Robot', 'DaVinci 
Surgical Robot', 'Turn on and operate', 5);

/* Equipment */
INSERT INTO Equipment VALUES ('A01-02X', '342123', '2010', 
TIMESTAMP '2012-10-29 12:00:13.20', '532');
INSERT INTO Equipment VALUES ('3A14', '342123', '2011', 
TIMESTAMP '2013-09-21 15:21:23.89', '124');
INSERT INTO Equipment VALUES ('3A15', '342123', '2004', 
TIMESTAMP '2015-05-12 14:21:12.45', '133');

INSERT INTO Equipment VALUES ('12Bsd', '534643', '2010', 
TIMESTAMP '2014-02-12 11:11:15.25', '023');
INSERT INTO Equipment VALUES ('13ds2', '534643', '2014', 
TIMESTAMP '2017-01-12 17:21:11.45', '111');
INSERT INTO Equipment VALUES ('13sdf', '534643', '2016', 
TIMESTAMP '2019-01-12 12:26:22.45', '023');

INSERT INTO Equipment VALUES ('12231', '455325', '2012', 
TIMESTAMP '2015-03-11 21:21:45.75', '002');
INSERT INTO Equipment VALUES ('12611', '455325', '2017', 
TIMESTAMP '2014-02-12 11:11:15.25', '421');
INSERT INTO Equipment VALUES ('12634', '455325', '2018', 
TIMESTAMP '2014-02-12 11:11:15.25', '111');

/* Admitted Patients*/
INSERT INTO Admission VALUES (0000000001, DATE '2016-01-01', DATE '2016-01-03',
89123.64, 0.25, '111223333', DATE '2016-02-01');

INSERT INTO Admission VALUES (0000000002, DATE '2016-02-01', DATE '2016-02-02',
10652.12, 0.24, '111223333', DATE '2016-03-01');

INSERT INTO Admission VALUES (0000000003, DATE '2016-01-01', DATE '2016-01-03',
1235.60, 0.97, '232134532', DATE '2016-02-01');

INSERT INTO Admission VALUES (0000000004, DATE '2016-02-01', DATE '2016-02-02',
12.0, 0.77, '232134532', DATE '2016-03-01');

INSERT INTO Admission VALUES (0000000005, DATE '2016-01-01', DATE 
'2016-01-03',
1023.64, 0.27, '923921239', DATE '2016-02-01');

INSERT INTO Admission VALUES (0000000006, DATE '2016-02-01', DATE '2016-02-02',
1452.74, 0.58, '923921239', DATE '2016-04-01');

INSERT INTO Admission VALUES (0000000007, DATE '2016-01-01', DATE 
'2016-01-03',
152.64, 0.29, '299245745', DATE '2016-02-01');

INSERT INTO Admission VALUES (0000000008, DATE '2016-02-01', DATE '2016-02-02',
102352.64, 0.64, '299245745', DATE '2016-03-01');

INSERT INTO Admission VALUES (0000000009, DATE '2016-01-01', DATE '2016-01-03',
12.64, 0.23, '213125443', DATE '2016-02-01');

INSERT INTO Admission VALUES (00000000010, DATE '2016-02-01', DATE '2016-02-02',
652.89, 0.48, '213125443', NULL);

/* General Managers */
insert into Employee values ('10', 'Ashton', 'Featherstonehaugh', 50078, 
'Sales Associate', 198, 2, NULL);
insert into Employee values ('EMP000016', 'Artemus', 'Brass', 68100, 'Internal Auditor', 354, 2, NULL);

/* Division Managers */
insert into Employee values ('EMP000011', 'Berky', 'Artiss', 87061, 'Sales 
Associate', 259, 1, '10');
insert into Employee values ('EMP000012', 'Symon', 'Willoway', 71181, 
'Help Desk Technician', 431, 1, '10');
insert into Employee values ('EMP000013', 'Claudette', 'Sabattier', 90821, 'Recruiter', 330, 1, 'EMP000016');
insert into Employee values ('EMP000014', 'Giorgia', 'Malyon', 91971, 'Senior Financial Analyst', 484, 1, 'EMP000016');

/* Regular Employees */
insert into Employee values ('EMP000001', 'Chance', 'ODoherty', 68720, 'Payment Adjustment Coordinator', 149, 0, 'EMP000011');
insert into Employee values ('EMP000002', 'Valle', 'Vasovic', 64709, 'Geologist II', 462, 0, 'EMP000011');
insert into Employee values ('EMP000003', 'Verine', 'Childrens', 65692, 'Mechanical Systems Engineer', 103, 0, 'EMP000011');
insert into Employee values ('EMP000004', 'Bette-ann', 'Bonnet', 60346, 'Environmental Specialist', 411, 0, 'EMP000012');
insert into Employee values ('EMP000005', 'Reinaldo', 'Gianelli', 98764, 'Executive Secretary', 470, 0, 'EMP000012');
insert into Employee values ('EMP000006', 'Jennifer', 'Sparey', 99039, 'Compensation Analyst', 381, 0, 'EMP000013');
insert into Employee values ('EMP000007', 'Joseito', 'Postill', 98874, 'Speech Pathologist', 183, 0, 'EMP000013');
insert into Employee values ('EMP000008', 'Lilia', 'Parkinson', 72243, 'Research Associate', 112, 0, 'EMP000014');
insert into Employee values ('EMP000009', 'Peyton', 'Doog', 63760, 'Dental Hygienist', 213, 0, 'EMP000014');
insert into Employee values ('EMP000010', 'Rani', 'Brindle', 93447, 'Structural Analysis Engineer', 457, 0, 'EMP000014');

/* Room Access */ 
INSERT INTO RoomAccess VALUES ('111', 'EMP000011'); 
INSERT INTO RoomAccess VALUES ('123', 'EMP000011');
INSERT INTO RoomAccess VALUES ('123', 'EMP000012');

/* Examinations */
INSERT INTO Examine VALUES ('21421312', '0000000001', 'A comment');
INSERT INTO Examine VALUES ('21421312', '0000000001', 'A second 
comment');
INSERT INTO Examine VALUES ('21421312', '0000000002', 'A comment');
INSERT INTO Examine VALUES ('13254363', '0000000002', 'A comment');
INSERT INTO Examine VALUES ('76576583', '0000000002', 'Another comment');
INSERT INTO Examine VALUES ('76576583', '0000000001', 'Another second 
comment');

/* ======================================== PART 2 ======================================== */

/* Q1 */ 
/* Select Occupied Rooms, return room number */
SELECT Num AS OccupiedRooms 
FROM Room 
WHERE Occupied = 1; 


/* Q2 */ 
/* Select employee ID, names, salary for specific ID */
SELECT ID, FirstName, LastName, Salary 
FROM Employee 
WHERE SupervisorID = '10'; 


/* Q3 */ 
/* Return Patient SSN and total insurance payment */
SELECT PatientSSN, SUM(InsurancePayment * TotalPayment) 
FROM Admission 
GROUP BY PatientSSN;

/* Q4 */ 
/* Return total visits by every patient, including patients with 0 visits 
*/
SELECT SSN, FirstName, LastName, COUNT(Num) AS Visits 
FROM Patient P, Admission A 
WHERE P.SSN = A.PatientSSN 
GROUP BY SSN, FirstName, LastName
UNION
SELECT SSN, FirstName, LastName, 0 AS Visits
FROM Patient
WHERE SSN NOT IN (SELECT PatientSSN FROM Admission);

/* Q5 */ 
/* Return room numbers with a specific equipent serial number */
SELECT Num 
FROM Room R, Equipment E 
WHERE E.RoomNum = R.Num AND E.SerialNum = 'A01-02X';

 
/* Q6 */ 
/* Return the employee who has access to the largest number of rooms */
SELECT EmployeeID, COUNT(RoomNum) AS CNT 
FROM Employee E, RoomAccess R 
WHERE E.ID = R.EmployeeID 
GROUP BY ID 
HAVING COUNT(RoomNum) =
        (SELECT MAX(CNT) AS MAX
        FROM (SELECT COUNT(RoomNum) AS CNT
                FROM RoomAccess
                GROUP BY EmployeeID)
        ); 


/* Q7 */
/* Create a temporary table holding the counts of all the positions in the 
hospital */

DROP TABLE temp;

CREATE GLOBAL TEMPORARY TABLE temp (
        Rank CHAR(20),
        Count INTEGER); 

INSERT INTO temp
SELECT 'Regular employees', Count(ID)
FROM Employee
WHERE Rank = '0'
GROUP BY Rank
UNION ALL
SELECT 'Division managers', Count(ID)
FROM Employee
WHERE Rank = '1'
GROUP BY RANK
UNION ALL
SELECT 'General managers', Count(ID)
FROM Employee
WHERE Rank = '2'
GROUP BY RANK;

SELECT Rank AS Type, Count FROM temp;

/* Q8 */
/* Select all the patients who have scheduled a future visit and display that future visit, provided it isn't null.
        Only checks the MOST RECENT visit date.  */
SELECT SSN, FirstName, LastName, FutureVisit
FROM Patient P, Admission A
WHERE P.SSN = A.PatientSSN AND FutureVisit IS NOT NULL
AND AdmissionDate =
(SELECT MAX(AdmissionDate) AS MAX 
FROM Admission
WHERE PatientSSN = P.SSN);

/* Q9 */
/* Find the ID, Model and Number of units of all equipment of which there 
are more than 2 */
SELECT ID, Model, NumUnits AS Quantity
FROM EquipmentType
WHERE NumUnits >= 3;

/* Q10 */
/* Return the Future visit date of a specific Patient */
SELECT FutureVisit
FROM Admission
WHERE PatientSSN = '111223333'
AND AdmissionDate = 
        (SELECT MAX(AdmissionDate) AS MAX
        FROM Admission
        WHERE PatientSSN = '111223333');

/* Q11 */
/* Return the DoctorID of a doctor who has examined a specific patient 
more than two times */
SELECT DoctorID
FROM Examine E, Admission A
WHERE E.AdmissionNum = A.Num AND A.PatientSSN = '111223333'
GROUP BY DoctorID
HAVING COUNT(A.PatientSSN) > 2;


/* Q12 */
/* Return a specific ID of equipment type which was purchased in two 
specific years */
SELECT DISTINCT ID
FROM 
(SELECT TypeID
FROM Equipment
WHERE PurchaseYear = 2010
INTERSECT
SELECT TypeID
FROM Equipment
WHERE PurchaseYear = 2011) E,
EquipmentType T
WHERE T.ID = E.TypeID;