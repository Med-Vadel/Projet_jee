package com.example;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(
    name = "DeleteEmployeeServlet",
    urlPatterns = {"/DeleteEmployeeServlet"}
)
public class DeleteEmployeeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String empcode = request.getParameter("empcode");
        HttpSession session = request.getSession();
        
        List<Employee> employees = (List<Employee>) session.getAttribute("employees");
        
        if (employees != null && empcode != null) {
            employees.removeIf(e -> e.getEmpcode().equals(empcode));
            session.setAttribute("employees", employees);
        }
        
        response.sendRedirect(request.getContextPath() + "/Pages/add-employee.jsp");
    }
}