<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panneau de connexion administrateur</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<div class="login-container">
    <div class="login-box">
        <h4 class="text-center">
            <i class="fa-solid fa-shield-halved text-primary me-2"></i>
            Panneau de connexion administrateur
        </h4>
        
        <%
            // المتغير session متاح ضمنياً في صفحات JSP
            String adminUsername = request.getParameter("adminUsername");
            String adminPassword = request.getParameter("adminPassword");

            if ("POST".equalsIgnoreCase(request.getMethod())) {
                if (adminUsername != null && adminPassword != null && !adminUsername.isEmpty() && !adminPassword.isEmpty()) {
                    if (adminUsername.equals("admin") && adminPassword.equals("admin")) {
                        // استخدام الجلسة الضمنية لتعيين الخاصية
                        session.setAttribute("currentManager", "admin");
                        response.sendRedirect("Pages/add-employee.jsp");
                    } else {
        %>
                        <div class="alert alert-danger text-center">Nom d'utilisateur ou mot de passe incorrect.</div>
        <%
                    }
                } else {
        %>
                    <div class="alert alert-warning text-center">Veuillez entrer le nom d'utilisateur et le mot de passe.</div>
        <%
                }
            }
        %>

        <form method="POST" name="adminSignin">
            <div class="mb-3">
                <label for="adminUsername" class="form-label">Nom d'utilisateur</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                    <input type="text" id="adminUsername" name="adminUsername" class="form-control" required>
                </div>
            </div>
            
            <div class="mb-3">
                <label for="adminPassword" class="form-label">Mot de passe</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                    <input type="password" id="adminPassword" name="adminPassword" class="form-control" required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary w-100">Se connecter <i class="fa-solid fa-arrow-right"></i></button>

            <div class="text-center mt-3">
                <a href="login.jsp" class="text-muted">Espace employé</a>
            </div>    
            <div class="text-center mt-3">
                <a href="managerLogin.jsp" class="text-muted">Zone de gestion des départements</a>
            </div>  
        </form>
    </div>
</div>

</body>
</html>