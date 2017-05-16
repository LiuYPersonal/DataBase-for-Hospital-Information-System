package com.hos_info.servlets;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hos_info.models.Patient;

public class totalcostServlet extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	protected Connection connection = null;
	
	@Override
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {	
		
		CallableStatement cStmt;
		boolean hadResults;
		String name = (String) req.getAttribute("name");
		try {
	             Statement stmt = connection.createStatement();
	             ResultSet rs = stmt.executeQuery("SELECT Patient_type from patient_input where patient_name="+name+
	            		 "order by General_ward_admission_date DESC limit 1");
	     		 String patientType = rs.getString("Patient_type");
	     		 
	             stmt = connection.createStatement();
	             rs = stmt.executeQuery("SELECT G_Admission_Date from general_ward where patient_name="+name+
	            		 "order by G_Admission_Date DESC limit 1");
	     		 Date g_date = rs.getDate("G_Admission_Date");
	             
	     		 stmt = connection.createStatement();
	             rs = stmt.executeQuery("SELECT S_Admission_Date from screening_ward where patient_name="+name+
	            		 "order by S_Admission_Date DESC limit 1");
	     		 Date s_date = rs.getDate("S_Admission_Date");
	     		 
	     		 stmt = connection.createStatement();
	             rs = stmt.executeQuery("SELECT Pre_admission_Date from pre_surgery_ward where patient_name="+name+
	            		 "order by Pre_admission_Date DESC limit 1");
	     		 Date pre_date = rs.getDate("Pre_admission_Date");

	     		 stmt = connection.createStatement();
	             rs = stmt.executeQuery("SELECT Post_Admission_date, Discharge_Date, Scount from post_surgery_ward where patient_name="+name+
	            		 "order by Post_Admission_date DESC limit 1");
	     		 Date post_date = rs.getDate("Post_Admission_date");
	     		 Date dis_date = rs.getDate("Discharge_Date");
	     		 int s_count= rs.getShort("Scount");
	     		 
	 			cStmt = connection.prepareCall("{call fun_totalcost(?,?,?,?,?,?,?,?)}");
	 			cStmt.setString(1, patientType);
	 			cStmt.setDate(2, g_date);
	 			cStmt.setDate(3, s_date);
	 			cStmt.setDate(4, pre_date);
	 			cStmt.setDate(5, post_date);
	 			cStmt.setDate(6, dis_date);
	 			cStmt.setInt(7, s_count);
				hadResults = cStmt.execute();
				if(hadResults){
					rs = cStmt.getResultSet();
					req.setAttribute("totalCost", rs.getString("total_cost"));
				}
				req.getRequestDispatcher("/WEB-INF/views/totalcost.jsp").forward(req, resp);
	     		 
	        } catch (SQLException se) {
	            se.printStackTrace();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	}

}
