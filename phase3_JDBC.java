import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.*;
import java.util.Scanner;

public class Reporting {

	public static void main(String[] args) {
		if(args.length < 2) {
			System.out.println("Please provide username and password!");
			System.out.println("Usage: java Reporting <username> <password> [option]");
			return;
		}

		if(args.length == 2) {
			System.out.println("1 - Report Patients Basic Information");
			System.out.println("2 - Report Doctors Basic Information");
			System.out.println("3 - Report Admissions Information");
			System.out.println("4 - Update Admissions Payment");
			return;
		}

		if(args.length == 3) {
			try {
				Class.forName("oracle.jdbc.driver.OracleDriver");
        	} catch (ClassNotFoundException e) {
            	e.printStackTrace();
            	return;
        	}

	        Connection connection = null;
	        try {
	            connection = DriverManager.getConnection(
	                                                     "jdbc:oracle:thin:@oracle.wpi.edu:1521:orcl", args[0], args[1]);

	        } catch (SQLException e) {
	        	System.out.println("Falied to connect to database. Are username and password valid?");
	            e.printStackTrace();
	            return;
	        }

	        if (connection != null) {
	        	if(args[2].equals("1")) {
	        		patientReporting(connection);
	        	}
	        	if(args[2].equals("2")) {
	        		doctorInfo(connection);
	        	}
	        	if(args[2].equals("3")) {
	        		admissionInfo(connection);
	        	}
	        	if(args[2].equals("4")) {
	        		admissionUpdate(connection);
	        	}
	        	try {
	        		connection.close();
	        	} catch (SQLException e) {
	        		System.out.println("Failed to close conn!");
	        	}
	        }

	        else {
	            System.out.println("Failed to make connection!");
	        }

		}
	}

	public static void patientReporting(Connection conn) {
		try {
		System.out.println("Enter Patient SSN: ");
		Scanner console = new Scanner(System.in);
		String input = console.nextLine();

		PreparedStatement p = conn.prepareStatement("SELECT * FROM PATIENT WHERE SSN = ?");
		p.setString(1, input);
		ResultSet r = p.executeQuery();
		while(r.next()) {
			System.out.println("Patient SSN: " + r.getString("SSN"));
			System.out.println("Patient First Name: " + r.getString("FirstName"));
			System.out.println("Patient Last Name: " + r.getString("LastName"));
			System.out.println("Patient Address: " + r.getString("Address"));
		}
		} catch(SQLException e) {
			System.out.println("Something went wrong :(");
		}
	}

   
   public static void doctorInfo(Connection conn) {
		try {
		System.out.println("Enter Doctor ID: ");
		Scanner console = new Scanner(System.in);
		String input = console.nextLine();

		// I know this is insecure, but for some reason prepared statement doesn't work here.
		// PreparedStatement p = conn.prepareStatement("SELECT * FROM DOCTOR WHERE ID = ?");
		// p.setString(1, input);

		Statement s = conn.createStatement();

		//ResultSet r = s.executeQuery("SELECT * FROM DOCTOR WHERE ID = '23129424'");
		ResultSet r = s.executeQuery("SELECT * FROM DOCTOR WHERE ID = '" + input + "'");
		//ResultSet r = p.executeQuery();
		while(r.next()) {
			System.out.println("Doctor ID: " + r.getString("ID"));
			System.out.println("Doctor First Name: " + r.getString("FirstName"));
			System.out.println("Doctor Last Name: " + r.getString("LastName"));
			System.out.println("Doctor Gender: " + r.getString("Gender"));
		}
		s.close();
		r.close();
		} catch(SQLException e) {
			System.out.println("Something went wrong :(");
			e.printStackTrace();
		}
	}

	public static void admissionInfo(Connection conn) {
		try {
			System.out.println("Enter Admission Number: ");
			Scanner console = new Scanner(System.in);
			String input = console.nextLine();

			PreparedStatement p = conn.prepareStatement("SELECT * FROM Admission WHERE Num = ?");
			PreparedStatement p1 = conn.prepareStatement("SELECT * FROM StayIn WHERE AdmissionNum = ?");
			Statement s = conn.createStatement();
			p.setString(1, input);

			ResultSet r = p.executeQuery();
			while(r.next()) {
				String num = r.getString("Num");
				System.out.println("Admission Number: " + num);
				System.out.println("Patient SSN: " + r.getString("PatientSSN"));
				System.out.println("Admission date (start date): " + r.getString("AdmissionDate"));
				System.out.println("Total payment: " + r.getString("TotalPayment"));
				System.out.println("Rooms: ");
				//p.close();
				p1.setString(1, num);
				ResultSet r1 = p1.executeQuery();
				while(r1.next()) {
					System.out.print("	RoomNum: " + r1.getString("RoomNum"));
					System.out.print("	FromDate: " + r1.getString("StartDate"));
					System.out.print("	ToDate: " + r1.getString("EndDate") + "\n");
				}
				System.out.println("Doctors examined the patient in this admission: ");
				ResultSet r2 = s.executeQuery("SELECT DISTINCT * FROM Examine WHERE AdmissionNum = '" + num + "'");
				while(r2.next()) {
					System.out.println("Doctor ID: " + r2.getString("DoctorID"));
				}			
			}

		} catch(SQLException e) {
			System.out.println("Something went wrong :(");
			e.printStackTrace();
		}
	}

	public static void admissionUpdate(Connection conn) {
		try {
			System.out.println("Enter Admission Number: ");
			Scanner console = new Scanner(System.in);
			String num = console.nextLine();
			System.out.println("Enter the new total payment: ");
			Double payment = console.nextDouble();

			Statement s = conn.createStatement();
			s.executeUpdate("UPDATE Admission SET TotalPayment = '" + payment +"' WHERE Num = '" + num + "'");
			System.out.println("Executed update!");
			s.close();

		} catch(SQLException e) {
			System.out.println("Something went wrong :(");
			e.printStackTrace();
		}
	}
}
