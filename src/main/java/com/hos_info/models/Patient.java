package com.hos_info.models;

import java.util.Date;

public class Patient {
	
	private String patientName;
	private Date generalWardAdmissionDate;
	private String patientType;
	
	public Patient(String name, Date date, String type){
		this.patientName=name;
		this.generalWardAdmissionDate=date;
		this.patientType=type;
	}
	
    public String getPatientName() {
        return this.patientName;
    }

    public void setPatientName(String name) {
        this.patientName = name;
    }

    public Date getGeneralWardAdmissionDate() {
        return this.generalWardAdmissionDate;
    }
    public void setGeneralWardAdmissionDate(Date date) {
        this.generalWardAdmissionDate=date;
    }
    public String getPatientType() {
        return this.patientType;
    }
    public void setPatientType(String type) {
        this.patientType=type;
    }
}
