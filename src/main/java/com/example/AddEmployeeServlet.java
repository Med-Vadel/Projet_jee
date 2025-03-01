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

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        // معالجة الحذف
        if ("delete".equals(action)) {
            handleDelete(request, session);
            redirect(response, request);
            return;
        }
        
        List<Employee> employees = (List<Employee>) session.getAttribute("employees");
        if (employees == null) {
            employees = new ArrayList<>();
        }

        // معالجة الإضافة
        if ("add".equals(action)) {
            handleAdd(request, response, employees, session);
            return;
        }
        
        // معالجة التعديل
        if ("edit".equals(action)) {
            handleEdit(request, response, employees, session);
            return;
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response, 
                          List<Employee> employees, HttpSession session)
            throws ServletException, IOException {
        
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmpassword");
        
        if (!password.equals(confirmPassword)) {
            setErrorAndForward(request, response, "كلمة المرور غير متطابقة!");
            return;
        }
        
        Employee emp = createEmployee(request);
        
        if (isEmployeeExists(employees, emp)) {
            setErrorAndForward(request, response, "الموظف مسجل مسبقاً!");
            return;
        }

        employees.add(emp);
        session.setAttribute("employees", employees);
        setMessageAndRedirect(request, response, "تم الإضافة بنجاح!");
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response,
                           List<Employee> employees, HttpSession session)
            throws ServletException, IOException {
        
        String originalEmpcode = request.getParameter("originalEmpcode");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");
        
        // التحقق من كلمة المرور الجديدة
        if (newPassword != null && !newPassword.isEmpty() && !newPassword.equals(confirmNewPassword)) {
            setErrorAndForward(request, response, "كلمة المرور الجديدة غير متطابقة!");
            return;
        }
        
        Employee existingEmp = employees.stream()
                .filter(e -> e.getEmpcode().equals(originalEmpcode))
                .findFirst()
                .orElse(null);
        
        if (existingEmp == null) {
            setErrorAndForward(request, response, "الموظف غير موجود!");
            return;
        }
        
        // التحقق من التكرار بعد التعديل
        Employee updatedEmp = createEmployee(request);
        if (isDuplicateAfterEdit(employees, originalEmpcode, updatedEmp)) {
            setErrorAndForward(request, response, "بيانات جديدة مكررة!");
            return;
        }
        
        // التحديث
        updateEmployee(existingEmp, updatedEmp, newPassword);
        setMessageAndRedirect(request, response, "تم التحديث بنجاح!");
    }

    private void updateEmployee(Employee existing, Employee updated, String newPassword) {
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
        existing.setAddress(updated.getAddress());
        existing.setCity(updated.getCity());
        
        if (newPassword != null && !newPassword.isEmpty()) {
            existing.setPassword(newPassword);
        }
    }

    private boolean isDuplicateAfterEdit(List<Employee> employees, String originalCode, Employee updated) {
        return employees.stream()
                .filter(e -> !e.getEmpcode().equals(originalCode))
                .anyMatch(e -> 
                    e.getEmpcode().equals(updated.getEmpcode()) || 
                    e.getEmail().equals(updated.getEmail()));
    }

    private void handleDelete(HttpServletRequest request, HttpSession session) {
        String empcode = request.getParameter("empcode");
        List<Employee> employees = (List<Employee>) session.getAttribute("employees");
        
        if (employees != null) {
            employees.removeIf(e -> e.getEmpcode().equals(empcode));
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

    private boolean isEmployeeExists(List<Employee> employees, Employee newEmp) {
        return employees.stream().anyMatch(e -> 
            e.getEmpcode().equals(newEmp.getEmpcode()) || 
            e.getEmail().equals(newEmp.getEmail()));
    }

    private void setErrorAndForward(HttpServletRequest request, HttpServletResponse response, String error)
            throws ServletException, IOException {
        request.setAttribute("error", error);
        request.getRequestDispatcher("/Pages/add-employee.jsp").forward(request, response);
    }

    private void setMessageAndRedirect(HttpServletRequest request, HttpServletResponse response, String msg)
            throws IOException {
        request.getSession().setAttribute("msg", msg);
        response.sendRedirect(request.getContextPath() + "/Pages/add-employee.jsp");
    }

    private void redirect(HttpServletResponse response, HttpServletRequest request)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/Pages/add-employee.jsp");
    }
}