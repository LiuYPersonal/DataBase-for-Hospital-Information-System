package com.hos_info.servlets;
import javax.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;

import java.util.ArrayList;
import java.util.List;

import com.hos_info.models.*;
public class mainServlets extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	protected Connection connection = null;
	
	protected Connection getConnection(){ 
	    
		try {
	        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/", "root", "root");
	 
	    } catch (SQLException e) {
	    	
	        e.printStackTrace();
	    }
		return connection;
	}
	
	protected void dataBaseSetUp(){
		//populate all the tables using procedures
		CallableStatement cStmt;
		boolean hadResults;
		try {
			cStmt = connection.prepareCall("{call populate_db()}");
			hadResults = cStmt.execute();
			if(!hadResults){
				return;
			}
			cStmt = connection.prepareCall("{call populate_dr_schedule()}");
			hadResults = cStmt.execute();
			if(!hadResults){
				return;
			}
			cStmt = connection.prepareCall("{call populate_surgeon_schedule()}");
			hadResults = cStmt.execute();
			if(!hadResults){
				return;
			}

	    } catch (SQLException e ) {
	        e.printStackTrace();
	    }
	}
	
	@Override
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {	
		
		try {
			Statement stmt = connection.createStatement();
			ResultSet rs = stmt.executeQuery("SELECT * FROM Patient_input ORDER BY General_ward_admission_date DESC limit 20");
		   List<Patient> patients = new ArrayList<Patient>();
		   // Extract data from result set
		   while (rs.next()) {
		       //Retrieve by column name
		   String patientName = rs.getString("Patient_Name");
		   Date date = rs.getDate("General_ward_admission_date");
		   String patientType = rs.getString("Patient_Type");
		   // Add item
		       patients.add(new Patient(patientName, date, patientType));
		   }
		   req.setAttribute("patients", patients);
		   rs = stmt.executeQuery("SELECT distinct name FROM DR_Schedule");
			   List<String> doctors = new ArrayList<String>();
			   // Extract data from result set
			   while (rs.next()) {
			       //Retrieve by column name
				   String drName = rs.getString("Name");
			       doctors.add(drName);
			   }
		   req.setAttribute("doctors", doctors);
		   rs = stmt.executeQuery("SELECT distinct name FROM surgeon_schedule");
		   List<String> surgeons = new ArrayList<String>();
		   // Extract data from result set
		   while (rs.next()) {
		       //Retrieve by column name
			   String sgName = rs.getString("Name");
		       surgeons.add(sgName);
		   }
		   req.setAttribute("surgeons", surgeons);
		   
		   CallableStatement cStmt = connection.prepareCall("{call fun_schedule_verify(?)}");
		   boolean hadResults = cStmt.execute();
			if(hadResults){
				rs = cStmt.getResultSet();
				req.setAttribute("schedule", rs.getString(1));
			}
		   req.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(req, resp);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
}