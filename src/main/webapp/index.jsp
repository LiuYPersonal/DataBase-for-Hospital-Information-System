<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import=java.util.ArrayList %>
<%@ page import=com.hos_info.models.* %>
<%@ page isELIgnored="false"%>
<html>
<head>
	<style>
		table {
		    font-family: arial, sans-serif;
		    border-collapse: collapse;
		    width: 100%;
		}
		
		td, th {
		    border: 1px solid #dddddd;
		    text-align: left;
		    padding: 8px;
		}
		
		tr:nth-child(even) {
		    background-color: #dddddd;
		}
	</style>
</head>
<body>
	<div>
		<h2>Query info</h2>
		<div>
			<form action="totalCost" method="post">
				<input type="text" placeholder="Patient name">
				<button type="submit">Get total cost</button>
			</form>
		</div>
	</div>
	<div>
		<h2>Hospital Info</h2>
		<div>
			<h3>Doctors on Duty</h3>
			<% ArrayList<String> doctors = (ArrayList<String>) request.getAttribute("doctors");
				for(String name : doctors) {
				    out.println("<li> "+name+" </li>");
				}
			%>
		</div>
		<div>
			<h3>Surgeons on Duty</h3>
			<% ArrayList<String> surgeons = (ArrayList<String>) request.getAttribute("surgeons"); 
				for(String name : surgeons) {
				    out.println("<li> "+name+" </li>");
				}
			%>
		</div>
		<div>
			<h3>List of Patients</h3>
			<table>
				<tr>
					<th>Patient Name</th>
					<th>Admission Date</th>
					<th>Patient Type</th>
				</tr>
				<tr>
				<% ArrayList<Patient> patients = (ArrayList<Patient>) request.getAttribute("patients"); 
					for(Patient p : patients) {
					    out.println("<th> "+ p.getPatientName() +" </th>");
					    out.println("<th> "+ p.getGeneralWardAdmissionDate() +" </th>");
					    out.println("<th> "+ p.getPatientType() +" </th>");
					}
				%>
				</tr>
			</table>
		</div>
		<div>
			<h3>Schedule valid</h3>
			<%
				for(Patient p : patients) {
				    out.println("<p> "+ request.getAttribute("schedule")  +" </p>");
				}
			%>			
		</div>
	</div>
</body>
</html>
