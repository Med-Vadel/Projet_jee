package com.example;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/EvaluateEmployeeServlet")
public class EvaluateEmployeeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        // إذا كان action غير موجود، إعادة التوجيه مباشرة إلى لوحة تحكم المدير
        if (action == null) {
            response.sendRedirect("Pages/managerDashboard.jsp");
            return;
        }
        
        try {
            // الحصول على المدير الحالي للحصول على managerCode
            Manager currentManager = (Manager) session.getAttribute("currentManager");
            String mgrCode = (currentManager != null) ? currentManager.getManagerCode() : "";
            
            // جلب أو تهيئة قائمة التقييمات من الجلسة
            List<Evaluation> evaluations = (List<Evaluation>) session.getAttribute("evaluations");
            if (evaluations == null) {
                evaluations = new ArrayList<>();
            }
            
            switch(action) {
                case "add":
                    // قراءة بيانات التقييم من النموذج
                    String empCode = request.getParameter("empcode");
                    int techSkill = Integer.parseInt(request.getParameter("techSkill"));
                    int workQuality = Integer.parseInt(request.getParameter("workQuality"));
                    int teamwork = Integer.parseInt(request.getParameter("teamwork"));
                    int communication = Integer.parseInt(request.getParameter("communication"));
                    int deadlineRespect = Integer.parseInt(request.getParameter("deadlineRespect"));
                    String generalComment = request.getParameter("generalComment");
                    
                    boolean updated = false;
                    // البحث عن تقييم موجود لنفس الموظف من نفس المدير وتحديثه
                    for (Evaluation eval : evaluations) {
                        if (eval.getEmpCode().equals(empCode) && eval.getManagerCode().equals(mgrCode)) {
                            eval.setTechSkill(techSkill);
                            eval.setWorkQuality(workQuality);
                            eval.setTeamwork(teamwork);
                            eval.setCommunication(communication);
                            eval.setDeadlineRespect(deadlineRespect);
                            eval.setGeneralComment(generalComment);
                            updated = true;
                            break;
                        }
                    }
                    if (!updated) {
                        Evaluation evaluation = new Evaluation(empCode, techSkill, workQuality, teamwork,
                                                               communication, deadlineRespect, generalComment, mgrCode);
                        evaluations.add(evaluation);
                    }
                    session.setAttribute("evaluations", evaluations);
                    response.sendRedirect("Pages/managerDashboard.jsp?success=true");
                    break;
                case "deleteEval":
                    // حذف تقييم من المدير الحالي
                    String empCodeToDelete = request.getParameter("empcode");
                    evaluations.removeIf(eval -> eval.getEmpCode().equals(empCodeToDelete)
                                              && eval.getManagerCode().equals(mgrCode));
                    session.setAttribute("evaluations", evaluations);
                    response.sendRedirect("Pages/managerDashboard.jsp?deleteSuccess=true");
                    break;
                default:
                    throw new Exception("Action non valide");
            }
        } catch(Exception e) {
            throw new ServletException("Erreur dans EvaluateEmployeeServlet : " + e.getMessage(), e);
        }
    }
}