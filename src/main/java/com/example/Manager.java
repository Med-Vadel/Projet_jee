package com.example;

public class Manager {
    private String managerCode;
    private String managerFirstName;
    private String managerLastName;
    private String managerEmail;
    private String managerMobileno;
    private String managerPassword;
    private String departmentName;
    private String departmentRoles;
    
    public Manager() { }

    public String getManagerCode() {
        return managerCode;
    }
    public void setManagerCode(String managerCode) {
        this.managerCode = managerCode;
    }
    public String getManagerFirstName() {
        return managerFirstName;
    }
    public void setManagerFirstName(String managerFirstName) {
        this.managerFirstName = managerFirstName;
    }
    public String getManagerLastName() {
        return managerLastName;
    }
    public void setManagerLastName(String managerLastName) {
        this.managerLastName = managerLastName;
    }
    public String getManagerEmail() {
        return managerEmail;
    }
    public void setManagerEmail(String managerEmail) {
        this.managerEmail = managerEmail;
    }
    public String getManagerMobileno() {
        return managerMobileno;
    }
    public void setManagerMobileno(String managerMobileno) {
        this.managerMobileno = managerMobileno;
    }
    public String getManagerPassword() {
        return managerPassword;
    }
    public void setManagerPassword(String managerPassword) {
        this.managerPassword = managerPassword;
    }
    public String getDepartmentName() {
        return departmentName;
    }
    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }
    public String getDepartmentRoles() {
        return departmentRoles;
    }
    public void setDepartmentRoles(String departmentRoles) {
        this.departmentRoles = departmentRoles;
    }
}