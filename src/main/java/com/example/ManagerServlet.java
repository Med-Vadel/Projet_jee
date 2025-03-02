package com.example;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/ManagerServlet")
public class ManagerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String RETURN_PAGE = "/Pages/add-employee.jsp";

    // لدعم GET مع معالجة الإجراءات (مثل الحذف)
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if(request.getParameter("action") != null) {
            doPost(request, response);
            return;
        }
        loadSessionData(request);
        RequestDispatcher dispatcher = request.getRequestDispatcher(RETURN_PAGE);
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String action = request.getParameter("action");

        List<Manager> managers = (List<Manager>) session.getAttribute("managers");
        if (managers == null) {
            managers = new ArrayList<>();
        }

        try {
            switch(action) {
                case "addManager":
                    validateManagerPasswordMatch(request);
                    Manager mgr = createManager(request);
                    validateManagerUniqueness(managers, mgr);
                    managers.add(mgr);
                    updateDepartmentsAndRolesFromManagers(session, managers);
                    request.setAttribute("msgDept", "Manager ajouté avec succès!");
                    break;
                case "editManager":
                    String originalCode = request.getParameter("originalManagerCode");
                    Manager existingMgr = findManager(managers, originalCode);
                    Manager updatedMgr = createManager(request);
                    validateManagerUpdateUniqueness(originalCode, managers, updatedMgr);
                    updateManager(existingMgr, updatedMgr);
                    updateDepartmentsAndRolesFromManagers(session, managers);
                    request.setAttribute("msgDept", "Mise à jour du manager réussie!");
                    break;
                case "deleteManager":
                    String code = request.getParameter("managerCode");
                    managers.removeIf(m -> m.getManagerCode().equals(code));
                    updateDepartmentsAndRolesFromManagers(session, managers);
                    request.setAttribute("msgDept", "Manager supprimé avec succès!");
                    break;
                case "addDept":
                    List<Department> departments = (List<Department>) session.getAttribute("departments");
                    if (departments == null) {
                        departments = new ArrayList<>();
                    }
                    Department dept = createDepartment(request);
                    validateDepartmentUniqueness(departments, dept);
                    departments.add(dept);
                    session.setAttribute("departments", departments);
                    request.setAttribute("msgDept", "Département ajouté avec succès!");
                    break;
                case "editDept":
                    List<Department> departmentsEdit = (List<Department>) session.getAttribute("departments");
                    if (departmentsEdit == null) {
                        departmentsEdit = new ArrayList<>();
                    }
                    String originalName = request.getParameter("originalDeptName");
                    Department existingDept = findDepartment(departmentsEdit, originalName);
                    Department updatedDept = createDepartment(request);
                    validateDeptUpdateUniqueness(originalName, departmentsEdit, updatedDept);
                    updateDepartment(existingDept, updatedDept);
                    session.setAttribute("departments", departmentsEdit);
                    request.setAttribute("msgDept", "Mise à jour du département réussie!");
                    break;
                case "deleteDept":
                    List<Department> departmentsDelete = (List<Department>) session.getAttribute("departments");
                    if (departmentsDelete == null) {
                        departmentsDelete = new ArrayList<>();
                    }
                    String name = request.getParameter("departmentName");
                    departmentsDelete.removeIf(d -> d.getDepartmentName().equals(name));
                    session.setAttribute("departments", departmentsDelete);
                    request.setAttribute("msgDept", "Département supprimé avec succès!");
                    break;
                default:
                    throw new Exception("Action non valide");
            }
            session.setAttribute("managers", managers);
        } catch(Exception e) {
            request.setAttribute("errorDept", e.getMessage());
        }
        loadSessionData(request);
        RequestDispatcher dispatcher = request.getRequestDispatcher(RETURN_PAGE);
        dispatcher.forward(request, response);
    }
    
    // دالة لتحميل بيانات الأقسام والأدوار من قائمة المديرين وتحديث الـ session
    private void updateDepartmentsAndRolesFromManagers(HttpSession session, List<Manager> managers) {
        Set<Department> deptSet = new HashSet<>();
        Set<String> roleSet = new HashSet<>();
        if (managers != null) {
            for (Manager m : managers) {
                if (m.getDepartmentName() != null && !m.getDepartmentName().isEmpty()) {
                    Department d = new Department();
                    d.setDepartmentName(m.getDepartmentName());
                    d.setDepartmentRoles(m.getDepartmentRoles());
                    deptSet.add(d);
                    if (m.getDepartmentRoles() != null) {
                        String[] roles = m.getDepartmentRoles().split(",");
                        for (String role : roles) {
                            roleSet.add(role.trim());
                        }
                    }
                }
            }
        }
        List<Department> departments = new ArrayList<>(deptSet);
        List<String> roles = new ArrayList<>(roleSet);
        session.setAttribute("departments", departments);
        session.setAttribute("roles", roles);
    }
    
    // دالة لتحميل بيانات المديرين والأقسام والأدوار إلى الـ session (دالة مساعدة)
    private void loadSessionData(HttpServletRequest request) {
        HttpSession session = request.getSession();
        List<Manager> managers = (List<Manager>) session.getAttribute("managers");
        updateDepartmentsAndRolesFromManagers(session, managers);
    }
    
    // --- عمليات Manager ---
    private Manager createManager(HttpServletRequest request) {
        Manager mgr = new Manager();
        mgr.setManagerCode(request.getParameter("managerCode"));
        mgr.setManagerFirstName(request.getParameter("managerFirstName"));
        mgr.setManagerLastName(request.getParameter("managerLastName"));
        mgr.setManagerEmail(request.getParameter("managerEmail"));
        mgr.setManagerMobileno(request.getParameter("managerMobileno"));
        mgr.setManagerPassword(request.getParameter("managerPassword"));
        mgr.setDepartmentName(request.getParameter("departmentName"));
        mgr.setDepartmentRoles(request.getParameter("departmentRoles"));
        return mgr;
    }

    private void updateManager(Manager existing, Manager updated) {
        existing.setManagerCode(updated.getManagerCode());
        existing.setManagerFirstName(updated.getManagerFirstName());
        existing.setManagerLastName(updated.getManagerLastName());
        existing.setManagerEmail(updated.getManagerEmail());
        existing.setManagerMobileno(updated.getManagerMobileno());
        existing.setManagerPassword(updated.getManagerPassword());
        existing.setDepartmentName(updated.getDepartmentName());
        existing.setDepartmentRoles(updated.getDepartmentRoles());
    }

    private void validateManagerPasswordMatch(HttpServletRequest request) throws Exception {
        String password = request.getParameter("managerPassword");
        String confirm = request.getParameter("managerConfirmPassword");
        if (!password.equals(confirm)) {
            throw new Exception("Les mots de passe du manager ne correspondent pas!");
        }
    }

    private void validateManagerUniqueness(List<Manager> managers, Manager newMgr) throws Exception {
        boolean exists = managers.stream()
                .anyMatch(m -> m.getManagerCode().equals(newMgr.getManagerCode()) || m.getManagerEmail().equals(newMgr.getManagerEmail()));
        if (exists) {
            throw new Exception("Manager existe déjà!");
        }
    }

    private Manager findManager(List<Manager> managers, String code) throws Exception {
        return managers.stream()
                .filter(m -> m.getManagerCode().equals(code))
                .findFirst()
                .orElseThrow(() -> new Exception("Manager introuvable!"));
    }

    private void validateManagerUpdateUniqueness(String originalCode, List<Manager> managers, Manager updated)
            throws Exception {
        boolean duplicate = managers.stream()
                .filter(m -> !m.getManagerCode().equals(originalCode))
                .anyMatch(m -> m.getManagerCode().equals(updated.getManagerCode()) || m.getManagerEmail().equals(updated.getManagerEmail()));
        if (duplicate) {
            throw new Exception("Données du manager dupliquées!");
        }
    }

    // --- عمليات Department ضمن ManagerServlet ---
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