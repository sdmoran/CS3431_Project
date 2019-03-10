DROP VIEW CriticalCases;
DROP VIEW DoctorsLoad;

/* View Problem 1 */
CREATE VIEW CriticalCases AS
SELECT PatientSSN AS Patient_SSN, firstName, lastName, COUNT(Num) AS numberOfAdmissionsToICU FROM
Admission A, Patient P
WHERE A.PatientSSN = P.SSN AND A.Num IN
(SELECT AdmissionNum
FROM StayIn S, RoomService R
WHERE S.RoomNum = R.RoomNum AND Service = 'ICU')
HAVING COUNT(Num) >= 2
GROUP BY PatientSSN, firstName, lastName;

/* View Problem 2 */
CREATE VIEW DoctorsLoad AS
SELECT DoctorID, Gender, 'Overloaded' AS Load
FROM Examine E, Doctor D
WHERE E.DoctorID = D.ID
GROUP BY DoctorID, Gender
HAVING COUNT(AdmissionNum) > 10
UNION ALL
SELECT DoctorID, Gender, 'Underloaded' AS Load
FROM Examine E, Doctor D
WHERE E.DoctorID = D.ID
GROUP BY DoctorID, Gender
HAVING COUNT(AdmissionNum) <= 10;

/* View Problem 3 */
SELECT * FROM CriticalCases
WHERE numberOfAdmissionsToICU > 4;

/* View Problem 4 */
SELECT DoctorID, firstName, lastName, Doctor.Gender
FROM Doctor, DoctorsLoad
WHERE Doctor.ID = DoctorsLoad.DoctorID AND Doctor.Gender = 'Female';

/* View Problem 5 */
SELECT DoctorID, PatientSSN, Comments
FROM Examine E, Admission A, CriticalCases C
WHERE E.AdmissionNum = A.Num AND A.PatientSSN
IN (SELECT PatientSSN FROM CriticalCases)
AND E.DoctorID IN (SELECT DoctorID FROM DoctorsLoad WHERE Load = 'Underloaded');