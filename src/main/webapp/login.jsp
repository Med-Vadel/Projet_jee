<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.example.Employee" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion Employé</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="styles.css">
    <style>
        .login-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #f8f9fa;
        }
        .login-box {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
        }
    </style>
</head>
<body>

    <div class="login-container">
        <div class="login-box">
            <h4 class="text-center"><i class="fas fa-user-shield"></i> Connexion Employé</h4>
            <p class="text-center">Système de gestion des congés</p>

            <%  
                String email = request.getParameter("username");
                String password = request.getParameter("password");
                List<Employee> employees = (List<Employee>) session.getAttribute("employees");

                if (request.getMethod().equalsIgnoreCase("POST")) {
                    if (email != null && password != null && !email.isEmpty() && !password.isEmpty()) {
                        
                        boolean isValid = false;
                        if(employees != null) {
                            for(Employee emp : employees) {
                                if(emp.getEmail().equals(email) && emp.getPassword().equals(password)) {
                                    isValid = true;
                                    break;
                                }
                            }
                        }
                        
                        if (isValid) {
            %>
                            <div class="alert alert-success text-center">Connexion réussie !</div>
            <%
                        } else {
            %>
                            <div class="alert alert-danger text-center">Email ou mot de passe incorrect</div>
            <%
                        }
                    } else {
            %>
                        <div class="alert alert-warning text-center">Veuillez saisir l'email et le mot de passe</div>
            <%
                    }
                }
            %>

            <form method="POST" action="login.jsp" name="signin">
                <div class="mb-3">
                    <label for="username" class="form-label">Adresse email</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fa-solid fa-envelope"></i></span>
                        <input type="email" id="username" name="username" class="form-control" required>
                    </div>
                </div>
                
                <div class="mb-3">
                    <label for="password" class="form-label">Mot de passe</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                        <input type="password" id="password" name="password" class="form-control" required>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="rememberMe">
                        <label class="form-check-label" for="rememberMe">Se souvenir</label>
                    </div>
                    <a href="password-recovery.jsp" class="text-decoration-none">Mot de passe oublié ?</a>
                </div>

                <button type="submit" class="btn btn-primary w-100">Se connecter <i class="fa-solid fa-arrow-right"></i></button>

                <div class="text-center mt-3">
                    <a href="AdminLogin.jsp" class="text-muted">Espace administrateur</a>
                </div>
            </form>
        </div>
    </div>

</body>
</html>