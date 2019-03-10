/* 1 */
CREATE OR REPLACE TRIGGER DoctorComment
BEFORE INSERT ON Examine
FOR EACH ROW
DECLARE
	str VARCHAR(100);
	CURSOR c IS
	SELECT AdmissionNum AS Num
		FROM StayIn S, RoomService R
		WHERE S.RoomNum = R.RoomNum AND Service = 'ICU';
BEGIN
	FOR record in c
	Loop
		IF record.Num = :NEW.AdmissionNum AND :NEW.Comments IS NULL Then
				RAISE_APPLICATION_ERROR(-20004, 'Must write a comment!');
				EXIT;
		END IF;
	END LOOP;
END;
/

/* Testing trigger requirement 1 */
/*INSERT INTO Admission VALUES (0000000107, DATE '2016-01-01', DATE 
'2016-01-05', 1240.2, 0.7, 111223333, DATE '2017-01-01'); 
INSERT INTO Room VALUES (116, '1');
INSERT INTO RoomService VALUES ('116', 'ICU');
INSERT INTO StayIn VALUES (0000000107, 116, DATE '2016-01-01', DATE 
'2016-01-02');
INSERT INTO Examine VALUES ('21421312', '0000000001', NULL);*/

/* 2 */
CREATE OR REPLACE TRIGGER set_insurance
BEFORE INSERT ON Admission
FOR EACH ROW
BEGIN
	:NEW.InsurancePayment := 0.65;
END;
/


/* 3 & 4 */

CREATE OR REPLACE TRIGGER EmployerCheck
BEFORE INSERT OR UPDATE ON Employee
FOR EACH ROW
DECLARE
rankvar INTEGER;
BEGIN

IF :new.SupervisorID IS NULL AND :new.Rank != 2 THEN
	RAISE_APPLICATION_ERROR(-20004, 'Cannot insert record:
Supervisor missing');
END IF;

SELECT Rank INTO rankvar 
FROM Employee
WHERE :new.SupervisorID = ID;

IF rankvar != 1 AND :new.Rank = 0 THEN
	RAISE_APPLICATION_ERROR(-20004, 'Cannot insert record: Invalid supervisor rank');
END IF;

IF rankvar != 2 AND :new.Rank = 1 THEN
	RAISE_APPLICATION_ERROR(-20004, 'Cannot insert record: Invalid supervisor rank');
END IF;

END;
/

/* Testing Trigger Requirement 3 & 4 */
/*
INSERT INTO Employee VALUES ('EMP002012', 'Wrong', 'Employee', 13213, 'Some title', 231, 0, 'EMP000001');
*/

/* 5 */
CREATE OR REPLACE TRIGGER EmergencyCheck
BEFORE INSERT OR UPDATE ON StayIn
FOR EACH ROW
DECLARE
emergencydate DATE;
BEGIN

SELECT AdmissionDate INTO emergencydate
FROM RoomService RS, Admission A
WHERE RS.RoomNum = :NEW.RoomNum AND :NEW.AdmissionNum = A.Num AND 
RS.Service = 'Emergency';

UPDATE Admission 
SET Admission.FutureVisit = ADD_MONTHS(emergencydate, 2)
WHERE :NEW.AdmissionNum = Admission.Num;
END;
/


/* Testing Trigger Requirement 5 */
/*
INSERT INTO Admission VALUES (0000000103, DATE '2016-01-01', DATE 
'2016-01-03', 1235.60, 0.97, '232134532', DATE '2016-02-01');

SELECT AdmissionDate
FROM Admission
WHERE Num = 0000000103;

INSERT INTO Room VALUES (126, '1');
INSERT INTO RoomService VALUES (126, 'Emergency');

INSERT INTO StayIn VALUES (0000000103, 126, DATE '2016-01-01', DATE 
'2016-01-03');

SELECT FutureVisit
FROM Admission
WHERE Num = 0000000103;
*/

/* 6 */
CREATE OR REPLACE TRIGGER EquipmentCheck
BEFORE INSERT OR UPDATE ON Equipment
FOR EACH ROW
DECLARE
equipmentCT CHAR(20);
equipmentUS CHAR(20);
BEGIN

SELECT ID INTO equipmentCT
FROM EquipmentType
WHERE Model = 'CT Scanner';

SELECT ID INTO equipmentUS
FROM EquipmentType
WHERE Model = 'Ultrasound';

IF :NEW.TypeID = equipmentCT OR :NEW.TypeID = equipmentUS THEN
IF :NEW.PurchaseYear IS NULL THEN
	RAISE_APPLICATION_ERROR(-20004, 'Cannot insert record: Purchase Year Cannot be NULL for this type!');
END IF;
IF :NEW.PurchaseYear < 2007 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Cannot insert record: PurchaseYear must be after 2006');
END IF;

END IF;

/*
IF :NEW.TypeID = equipmentCT OR :NEW.TypeID = equipmentUS AND
:NEW.PurchaseYear < 2007 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Cannot insert record: Purchase
Year must be after 2006');
END IF;


END;
/

/* Testing trigger requirement 6 */
/*
INSERT INTO EquipmentType VALUES ('342126', 'CT Scanner', 'CT Scanner', 'Turn on and scan', 6);

INSERT INTO EquipmentType VALUES ('342128', 'Ultrasound', 'Ultrasound', 
'Turn on and sound', 6);

INSERT INTO Equipment VALUES ('A01-02Y', '342128', '2010', 
TIMESTAMP '2012-10-29 12:00:13.20', '532');

INSERT INTO Equipment VALUES ('A01-02Z', '342128', '2005',
TIMESTAMP '2012-10-29 12:00:13.20', '532');
*/


set serveroutput on;

/* 7 */
CREATE OR REPLACE TRIGGER report_info
AFTER INSERT OR UPDATE ON Admission
FOR EACH ROW
DECLARE
	first CHAR(20);
	last CHAR(20);
	add CHAR(40);
	CURSOR c1 IS SELECT DoctorID, Comments FROM Examine ORDER BY DoctorID;
BEGIN
	IF :New.LeaveDate IS NOT NULL THEN
		SELECT firstName INTO first FROM Patient WHERE SSN = :new.PatientSSN;
		SELECT lastName into last FROM Patient WHERE SSN = :new.PatientSSN;
		SELECT Address into add FROM Patient WHERE SSN = :new.PatientSSN;
		dbms_output.put_line('Patient: ' || first || ' ' || last);
		dbms_output.put_line('Address: ' || add);
		FOR record IN c1
		LOOP
			dbms_output.put_line('DoctorID: ' || record.DoctorID );
			dbms_output.put_line('Comments: ' || record.Comments);
		END LOOP;
	END IF;
END;
/