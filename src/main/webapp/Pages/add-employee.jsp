<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.example.Employee" %>
<!DOCTYPE html>
<html dir="ltr" lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Système de gestion des employés</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --main-color: #2c3e50;
            --secondary-color: #34495e;
        }
        body { background-color: #f8f9fa; }
        .form-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
            margin: 2rem auto;
            padding: 2rem;
            max-width: 800px;
        }
        .required::after {
            content: "*";
            color: red;
            margin-left: 3px;
        }
        .action-btns { min-width: 120px; }
        table th { background-color: var(--main-color) !important; color: white; }
        .modal-header { direction: ltr; }
    </style>
</head>
<body>
    <div class="container py-5">
        <!-- Formulaire d'ajout -->
        <div class="form-container">
            <h2 class="text-center mb-4"><i class="fas fa-user-plus"></i> Ajouter un employé</h2>
            
            <!-- Messages d'alerte -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show">
                    ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>
            
            <% if (request.getAttribute("msg") != null) { %>
                <div class="alert alert-success alert-dismissible fade show">
                    ${msg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <% } %>

            <!-- Formulaire -->
            <form method="POST" action="${pageContext.request.contextPath}/AddEmployeeServlet">
                <input type="hidden" name="action" value="add">
                <div class="row g-3">
                    
                    <!-- Colonne gauche -->
                    <div class="col-md-6">
                        <label class="form-label required">Numéro employé</label>
                        <input type="text" class="form-control" name="empcode" required value="${param.empcode}">
                        
                        <label class="form-label required mt-3">Prénom</label>
                        <input type="text" class="form-control" name="firstName" required value="${param.firstName}">
                        
                        <label class="form-label required mt-3">Département</label>
                        <input type="text" class="form-control" name="department" required value="${param.department}">
                        
                        <label class="form-label required mt-3">Rôle</label>
                        <input type="text" class="form-control" name="role" required value="${param.role}">
                    </div>

                    <!-- Colonne droite -->
                    <div class="col-md-6">
                        <label class="form-label required">Nom</label>
                        <input type="text" class="form-control" name="lastName" required value="${param.lastName}">
                        
                        <label class="form-label required mt-3">Téléphone</label>
                        <input type="tel" class="form-control" name="mobileno" 
                               pattern="[234]\d{7}" 
                               title="Doit commencer par 2/3/4 et avoir 8 chiffres"
                               required value="${param.mobileno}">
                        
                        <label class="form-label required mt-3">Genre</label>
                        <select class="form-select" name="gender" required>
                            <option value="Homme" ${param.gender == 'Homme' ? 'selected' : ''}>Homme</option>
                            <option value="Femme" ${param.gender == 'Femme' ? 'selected' : ''}>Femme</option>
                        </select>
                    </div>

                    <!-- Informations supplémentaires -->
                    <div class="col-12">
                        <label class="form-label required">Email</label>
                        <input type="email" class="form-control" name="email" required value="${param.email}">
                        
                        <label class="form-label mt-3">Date de naissance</label>
                        <input type="date" class="form-control" name="dob" value="${param.dob}">
                        
                        <label class="form-label required mt-3">Adresse</label>
                        <input type="text" class="form-control" name="address" required value="${param.address}">
                        
                        <div class="row mt-3">
                            <div class="col-md-6">
                                <label class="form-label required">Ville</label>
                                <input type="text" class="form-control" name="city" required value="${param.city}">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label required">Pays</label>
                                <input type="text" class="form-control" name="country" required value="${param.country}">
                            </div>
                        </div>
                    </div>

                    <!-- Mots de passe -->
                    <div class="col-md-6">
                        <label class="form-label required">Mot de passe</label>
                        <input type="password" class="form-control" name="password" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label required">Confirmation</label>
                        <input type="password" class="form-control" name="confirmpassword" required>
                    </div>

                    <!-- Bouton de soumission -->
                    <div class="col-12 text-center mt-4">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-user-plus"></i> Ajouter employé
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Tableau des employés -->
        <div class="mt-5">
            <h3 class="mb-4"><i class="fas fa-users"></i> Liste des employés</h3>
            
            <% List<Employee> employees = (List<Employee>) session.getAttribute("employees"); %>
            <% if (employees != null && !employees.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table table-hover table-bordered">
                        <thead class="table-dark">
                            <tr>
                                <th>#</th>
                                <th>Nom complet</th>
                                <th>Rôle</th>
                                <th>Département</th>
                                <th>Téléphone</th>
                                <th>Email</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Employee emp : employees) { %>
                            <tr>
                                <td><%= emp.getEmpcode() %></td>
                                <td><%= emp.getFirstName() %> <%= emp.getLastName() %></td>
                                <td><%= emp.getRole() %></td>
                                <td><%= emp.getDepartment() %></td>
                                <td><%= emp.getMobileno() %></td>
                                <td><%= emp.getEmail() %></td>
                                <td class="action-btns">
                                    <button class="btn btn-warning btn-sm edit-btn" 
                                        data-empcode="<%= emp.getEmpcode() %>"
                                        data-firstname="<%= emp.getFirstName() %>"
                                        data-lastname="<%= emp.getLastName() %>"
                                        data-email="<%= emp.getEmail() %>"
                                        data-department="<%= emp.getDepartment() %>"
                                        data-role="<%= emp.getRole() %>"
                                        data-gender="<%= emp.getGender() %>"
                                        data-dob="<%= emp.getDob() %>"
                                        data-mobileno="<%= emp.getMobileno() %>"
                                        data-country="<%= emp.getCountry() %>"
                                        data-city="<%= emp.getCity() %>"
                                        data-address="<%= emp.getAddress() %>">
                                        <i class="fas fa-edit"></i> Modifier
                                    </button>
                                    <button class="btn btn-danger btn-sm" 
                                        onclick="confirmDelete('<%= emp.getEmpcode() %>')">
                                        <i class="fas fa-trash"></i> Supprimer
                                    </button>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="alert alert-info">
                    Aucun employé enregistré
                </div>
            <% } %>
        </div>
    </div>

    <!-- Modal d'édition -->
    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-warning">
                    <h5 class="modal-title"><i class="fas fa-edit"></i> Modifier employé</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST" action="${pageContext.request.contextPath}/AddEmployeeServlet">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="originalEmpcode" id="originalEmpcode">
                        
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Numéro employé</label>
                                <input type="text" class="form-control" name="empcode" id="editEmpcode" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Prénom</label>
                                <input type="text" class="form-control" name="firstName" id="editFirstName" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Nom</label>
                                <input type="text" class="form-control" name="lastName" id="editLastName" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="email" id="editEmail" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Département</label>
                                <input type="text" class="form-control" name="department" id="editDepartment" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Rôle</label>
                                <input type="text" class="form-control" name="role" id="editRole" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Genre</label>
                                <select class="form-select" name="gender" id="editGender" required>
                                    <option value="Homme">Homme</option>
                                    <option value="Femme">Femme</option>
                                </select>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Date de naissance</label>
                                <input type="date" class="form-control" name="dob" id="editDob">
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Téléphone</label>
                                <input type="tel" class="form-control" name="mobileno" id="editMobileno" 
                                       pattern="[234]\d{7}" 
                                       title="Doit commencer par 2/3/4 et avoir 8 chiffres" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Pays</label>
                                <input type="text" class="form-control" name="country" id="editCountry" required>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">Ville</label>
                                <input type="text" class="form-control" name="city" id="editCity" required>
                            </div>
                            
                            <div class="col-12">
                                <label class="form-label">Adresse</label>
                                <input type="text" class="form-control" name="address" id="editAddress" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Mot de passe</label>
                                <input type="password" class="form-control" name="password" id="editPassword" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><i class="fas fa-times"></i> Annuler</button>
                        <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Enregistrer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts JavaScript -->
    <script>
    // Gestion suppression
    function confirmDelete(empcode) {
        if (confirm('Voulez-vous vraiment supprimer cet employé ?')) {
            window.location = '${pageContext.request.contextPath}/DeleteEmployeeServlet?empcode=' + empcode;
        }
    }

    // Gestion édition
    document.querySelectorAll('.edit-btn').forEach(button => {
        button.addEventListener('click', function() {
            const emp = {
                empcode: this.dataset.empcode,
                firstName: this.dataset.firstname,
                lastName: this.dataset.lastname,
                email: this.dataset.email,
                department: this.dataset.department,
                role: this.dataset.role,
                gender: this.dataset.gender,
                dob: this.dataset.dob,
                mobileno: this.dataset.mobileno,
                country: this.dataset.country,
                city: this.dataset.city,
                address: this.dataset.address,     
                password: this.dataset.password
            };

            document.getElementById('originalEmpcode').value = emp.empcode;
            document.getElementById('editEmpcode').value = emp.empcode;
            document.getElementById('editFirstName').value = emp.firstName;
            document.getElementById('editLastName').value = emp.lastName;
            document.getElementById('editEmail').value = emp.email;
            document.getElementById('editDepartment').value = emp.department;
            document.getElementById('editRole').value = emp.role;
            document.getElementById('editGender').value = emp.gender;
            document.getElementById('editDob').value = emp.dob;
            document.getElementById('editMobileno').value = emp.mobileno;
            document.getElementById('editCountry').value = emp.country;
            document.getElementById('editCity').value = emp.city;
            document.getElementById('editAddress').value = emp.address;
            document.getElementById('editPassword').value = emp.password;

            new bootstrap.Modal(document.getElementById('editModal')).show();
        });
    });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>