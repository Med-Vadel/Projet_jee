<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.example.Employee" %>

<%
    Employee emp = (Employee) session.getAttribute("currentEmployee");
    if (emp == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil Employé</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        .readonly-field { 
            background-color: #f8f9fa !important;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="card shadow-lg">
            <div class="card-header bg-primary text-white">
                <h3 class="mb-0"><i class="fas fa-id-card"></i> Profil de l'employé</h3>
            </div>

            <div class="card-body">
                <% if (session.getAttribute("msg") != null) { %>
                    <div class="alert alert-success"><%= session.getAttribute("msg") %></div>
                    <% session.removeAttribute("msg"); %>
                <% } %>

                <!-- Informations non modifiables -->
                <div class="mb-4">
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Code employé</label>
                            <input type="text" class="form-control readonly-field" 
                                   value="<%= emp.getEmpcode() %>" readonly>
                        </div>
                        
                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Nom complet</label>
                            <input type="text" class="form-control readonly-field" 
                                   value="<%= emp.getFirstName() %> <%= emp.getLastName() %>" readonly>
                        </div>
                        
                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Département</label>
                            <input type="text" class="form-control readonly-field" 
                                   value="<%= emp.getDepartment() %>" readonly>
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Email</label>
                            <input type="email" class="form-control readonly-field" 
                                   value="<%= emp.getEmail() %>" readonly>
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Rôle</label>
                            <input type="text" class="form-control readonly-field" 
                                   value="<%= emp.getRole() %>" readonly>
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Pays</label>
                            <input type="text" class="form-control readonly-field" 
                                   value="<%= emp.getCountry() %>" readonly>
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Date de naissance</label>
                            <input type="text" class="form-control readonly-field" 
                                   value="<%= emp.getDob() %>" readonly>
                        </div>
                    </div>
                </div>

                <!-- Formulaire de modification -->
                <form method="POST" action="../AddEmployeeServlet">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="originalEmpcode" value="<%= emp.getEmpcode() %>">

                    <!-- Champs cachés -->
                    <input type="hidden" name="empcode" value="<%= emp.getEmpcode() %>">
                    <input type="hidden" name="firstName" value="<%= emp.getFirstName() %>">
                    <input type="hidden" name="lastName" value="<%= emp.getLastName() %>">
                    <input type="hidden" name="email" value="<%= emp.getEmail() %>">
                    <input type="hidden" name="department" value="<%= emp.getDepartment() %>">
                    <input type="hidden" name="role" value="<%= emp.getRole() %>">
                    <input type="hidden" name="gender" value="<%= emp.getGender() %>">
                    <input type="hidden" name="dob" value="<%= emp.getDob() %>">
                    <input type="hidden" name="country" value="<%= emp.getCountry() %>">
                    <input type="hidden" name="password" value="<%= emp.getPassword() %>">

                    <!-- Champs modifiables -->
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Téléphone</label>
                            <input type="tel" name="mobileno" class="form-control" 
                                   value="<%= emp.getMobileno() %>" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Ville</label>
                            <input type="text" name="city" class="form-control" 
                                   value="<%= emp.getCity() %>" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold">Adresse</label>
                            <input type="text" name="address" class="form-control" 
                                   value="<%= emp.getAddress() %>" required>
                        </div>
                    </div>

                    <div class="d-grid gap-2 mt-4">
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-save me-2"></i>Enregistrer
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>