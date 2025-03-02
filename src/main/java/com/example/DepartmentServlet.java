// DepartmentServlet.java
package com.example;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/DepartmentServlet")
public class DepartmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String RETURN_PAGE = "/Pages/add-employee.jsp";
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<Department> departments = (List<Department>) session.getAttribute("departments");
        if (departments == null) {
            departments = new ArrayList<>();
            // Exemple de données par défaut :
            // Department d = new Department();
            // d.setDepartmentName("Informatique");
            // d.setDepartmentRoles("Développeur, Testeur, Manager");
            // departments.add(d);
        }
        session.setAttribute("departments", departments);
        
        List<String> roles = (List<String>) session.getAttribute("roles");
        if (roles == null) {
            roles = new ArrayList<>();
            roles.add("Administrateur");
            roles.add("Employé");
            roles.add("Responsable");
        }
        session.setAttribute("roles", roles);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher(RETURN_PAGE);
        dispatcher.forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        List<Department> departments = (List<Department>) session.getAttribute("departments");
        if (departments == null) {
            departments = new ArrayList<>();
        }
        try {
            switch(action) {
                case "addDept":
                    Department dept = createDepartment(request);
                    validateDepartmentUniqueness(departments, dept);
                    departments.add(dept);
                    request.setAttribute("msgDept", "Département ajouté avec succès!");
                    break;
                case "editDept":
                    String originalName = request.getParameter("originalDeptName");
                    Department existing = findDepartment(departments, originalName);
                    Department updated = createDepartment(request);
                    validateDeptUpdateUniqueness(originalName, departments, updated);
                    updateDepartment(existing, updated);
                    request.setAttribute("msgDept", "Mise à jour du département réussie!");
                    break;
                case "deleteDept":
                    String name = request.getParameter("departmentName");
                    departments.removeIf(d -> d.getDepartmentName().equals(name));
                    request.setAttribute("msgDept", "Département supprimé avec succès!");
                    break;
                default:
                    throw new Exception("Action non valide");
            }
            session.setAttribute("departments", departments);
        } catch(Exception e) {
            request.setAttribute("errorDept", e.getMessage());
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher(RETURN_PAGE);
        dispatcher.forward(request, response);
    }
    
    private Department createDepartment(HttpServletRequest request) {
        Department dept = new Department();
        dept.setDepartmentName(request.getParameter("departmentName"));
        dept.setDepartmentRoles(request.getParameter("departmentRoles"));
        return dept;
    }
    
    private void updateDepartment(Department existing, Department updated) {
        existing.setDepartmentName(updated.getDepartmentName());
        existing.setDepartmentRoles(updated.getDepartmentRoles());
    }
    
    private void validateDepartmentUniqueness(List<Department> departments, Department newDept) throws Exception {
        boolean exists = departments.stream()
                .anyMatch(d -> d.getDepartmentName().equals(newDept.getDepartmentName()));
        if (exists) {
            throw new Exception("Département existe déjà!");
        }
    }
    
    private Department findDepartment(List<Department> departments, String name) throws Exception {
        return departments.stream()
                .filter(d -> d.getDepartmentName().equals(name))
                .findFirst()
                .orElseThrow(() -> new Exception("Département introuvable!"));
    }
    
    private void validateDeptUpdateUniqueness(String originalName, List<Department> departments, Department updated)
            throws Exception {
        boolean duplicate = departments.stream()
                .filter(d -> !d.getDepartmentName().equals(originalName))
                .anyMatch(d -> d.getDepartmentName().equals(updated.getDepartmentName()));
        if (duplicate) {
            throw new Exception("Nom de département dupliqué!");
        }
    }
}