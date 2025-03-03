package com.example;

public class Evaluation {
    private String empCode;
    private int techSkill;
    private int workQuality;
    private int teamwork;
    private int communication;
    private int deadlineRespect;
    private String generalComment;
    private String managerCode;
    public Evaluation(String empCode, int techSkill, int workQuality, int teamwork,
                      int communication, int deadlineRespect, String generalComment, String managerCode) {
        this.empCode = empCode;
        this.techSkill = techSkill;
        this.workQuality = workQuality;
        this.teamwork = teamwork;
        this.communication = communication;
        this.deadlineRespect = deadlineRespect;
        this.generalComment = generalComment;
        this.managerCode = managerCode;
    }

    // Getters
    public String getEmpCode() {
        return empCode;
    }
    public int getTechSkill() {
        return techSkill;
    }
    public int getWorkQuality() {
        return workQuality;
    }
    public int getTeamwork() {
        return teamwork;
    }
    public int getCommunication() {
        return communication;
    }
    public int getDeadlineRespect() {
        return deadlineRespect;
    }
    public String getGeneralComment() {
        return generalComment;
    }
    public String getManagerCode() {
        return managerCode;
    }

    // Setters
    public void setTechSkill(int techSkill) {
        this.techSkill = techSkill;
    }
    public void setWorkQuality(int workQuality) {
        this.workQuality = workQuality;
    }
    public void setTeamwork(int teamwork) {
        this.teamwork = teamwork;
    }
    public void setCommunication(int communication) {
        this.communication = communication;
    }
    public void setDeadlineRespect(int deadlineRespect) {
        this.deadlineRespect = deadlineRespect;
    }
    public void setGeneralComment(String generalComment) {
        this.generalComment = generalComment;
    }
}