package com.example;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AddEmployeeServlet")
public class AddEmployeeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DEFAULT_RETURN_PAGE = "/Pages/add-employee.jsp";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        List<Employee> employees = initializeEmployees(session);

        try {
            processRequest(action, request, employees);
            session.setAttribute("employees", employees);
        } catch (ValidationException e) {
            request.setAttribute("error", e.getMessage());
        }

        forwardToSourcePage(request, response);
    }

    private List<Employee> initializeEmployees(HttpSession session) {
        @SuppressWarnings("unchecked")
        List<Employee> employees = (List<Employee>) session.getAttribute("employees");
        return employees != null ? employees : new ArrayList<>();
    }

    private void processRequest(String action, HttpServletRequest request, List<Employee> employees)
            throws ValidationException {
        switch (action) {
            case "delete":
                handleDelete(request, employees);
                break;
            case "add":
                handleAdd(request, employees);
                break;
            case "edit":
                handleEdit(request, employees);
                break;
            default:
                throw new ValidationException("Action non valide");
        }
    }

    private void handleAdd(HttpServletRequest request, List<Employee> employees) throws ValidationException {
        validatePasswordMatch(request);

        Employee emp = createEmployee(request);
        validateEmployeeUniqueness(employees, emp);

        employees.add(emp);
        request.setAttribute("msg", "Employé ajouté avec succès!");
    }

    private void handleEdit(HttpServletRequest request, List<Employee> employees) throws ValidationException {
        String originalCode = request.getParameter("originalEmpcode");
        Employee existing = findEmployee(employees, originalCode);

        Employee updated = createEmployee(request);
        validateUpdateUniqueness(originalCode, employees, updated);

        updatePartialFields(existing, updated);
        request.setAttribute("msg", "Mise à jour réussie!");
    }

    // هنا قمنا بتحديث كل الحقول لتحديث شامل
    private void updatePartialFields(Employee existing, Employee updated) {
        existing.setEmpcode(updated.getEmpcode());
        existing.setFirstName(updated.getFirstName());
        existing.setLastName(updated.getLastName());
        existing.setEmail(updated.getEmail());
        existing.setDepartment(updated.getDepartment());
        existing.setRole(updated.getRole());
        existing.setGender(updated.getGender());
        existing.setDob(updated.getDob());
        existing.setMobileno(updated.getMobileno());
        existing.setCountry(updated.getCountry());
        existing.setCity(updated.getCity());
        existing.setAddress(updated.getAddress());
        existing.setPassword(updated.getPassword());
    }

    private void handleDelete(HttpServletRequest request, List<Employee> employees) {
        String code = request.getParameter("empcode");
        employees.removeIf(e -> e.getEmpcode().equals(code));
    }

    // Helper methods
    private void validatePasswordMatch(HttpServletRequest request) throws ValidationException {
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirmpassword");

        if (!password.equals(confirm)) {
            throw new ValidationException("Les mots de passe ne correspondent pas!");
        }
    }

    private Employee createEmployee(HttpServletRequest request) {
        Employee emp = new Employee();
        emp.setEmpcode(request.getParameter("empcode"));
        emp.setFirstName(request.getParameter("firstName"));
        emp.setLastName(request.getParameter("lastName"));
        emp.setEmail(request.getParameter("email"));
        emp.setDepartment(request.getParameter("department"));
        emp.setRole(request.getParameter("role"));
        emp.setGender(request.getParameter("gender"));
        emp.setDob(request.getParameter("dob"));
        emp.setMobileno(request.getParameter("mobileno"));
        emp.setCountry(request.getParameter("country"));
        emp.setAddress(request.getParameter("address"));
        emp.setCity(request.getParameter("city"));
        emp.setPassword(request.getParameter("password"));
        return emp;
    }

    private void validateEmployeeUniqueness(List<Employee> employees, Employee newEmp) throws ValidationException {
        boolean exists = employees.stream()
                .anyMatch(e -> e.getEmpcode().equals(newEmp.getEmpcode()) || e.getEmail().equals(newEmp.getEmail()));

        if (exists) {
            throw new ValidationException("Employé existe déjà!");
        }
    }

    private Employee findEmployee(List<Employee> employees, String code) throws ValidationException {
        return employees.stream()
                .filter(e -> e.getEmpcode().equals(code))
                .findFirst()
                .orElseThrow(() -> new ValidationException("Employé introuvable!"));
    }

    private void validateUpdateUniqueness(String originalCode, List<Employee> employees, Employee updated)
            throws ValidationException {
        boolean duplicate = employees.stream()
                .filter(e -> !e.getEmpcode().equals(originalCode))
                .anyMatch(e -> e.getEmpcode().equals(updated.getEmpcode()) || e.getEmail().equals(updated.getEmail()));

        if (duplicate) {
            throw new ValidationException("Données dupliquées!");
        }
    }

    private void forwardToSourcePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String referer = request.getHeader("referer");
        String returnPage = DEFAULT_RETURN_PAGE;

        if (referer != null) {
            String contextPath = request.getContextPath();
            returnPage = referer.substring(referer.indexOf(contextPath) + contextPath.length());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher(returnPage);
        dispatcher.forward(request, response);
    }

    private static class ValidationException extends Exception {
        public ValidationException(String message) {
            super(message);
        }
    }
}