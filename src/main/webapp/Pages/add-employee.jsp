<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.example.Employee, com.example.Manager, com.example.Department" %>
<!DOCTYPE html>
<html dir="ltr" lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="referrer" content="no-referrer" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Système de gestion des employés</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    :root {
      --main-color: #1abc9c;
      --secondary-color: #16a085;
    }
    body {
      background-color: #ecf0f1;
    }
    .form-container {
      background: #fff;
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
    table th {
      background-color: var(--main-color) !important;
      color: #fff;
    }
    .nav-tabs .nav-link.active {
      background-color: var(--main-color);
      color: #fff;
    }
    .nav-tabs .nav-link {
      color: var(--secondary-color);
    }
    .modal-header {
      background-color: var(--secondary-color);
      color: #fff;
      direction: ltr;
    }
  </style>
</head>
<body>
  <div class="container py-5">
    <%-- التأكد من تحميل بيانات الأقسام والأدوار من ManagerServlet في الـ session --%>
    <%
      if(session.getAttribute("departments") == null || session.getAttribute("roles") == null){
          response.sendRedirect(request.getContextPath() + "/ManagerServlet");
          return;
      }
    %>
    <!-- Navigation via Tabs -->
    <ul class="nav nav-tabs mb-4" id="gestionTabs" role="tablist">
      <li class="nav-item" role="presentation">
        <button class="nav-link active" id="employe-tab" data-bs-toggle="tab" data-bs-target="#employe" type="button" role="tab" aria-controls="employe" aria-selected="true">
          <i class="fas fa-user-plus"></i> Ajouter un employé
        </button>
      </li>
      <li class="nav-item" role="presentation">
        <button class="nav-link" id="manager-tab" data-bs-toggle="tab" data-bs-target="#manager" type="button" role="tab" aria-controls="manager" aria-selected="false">
          <i class="fas fa-building"></i> Gestion des départements & managers
        </button>
      </li>
    </ul>

    <div class="tab-content" id="gestionTabsContent">
      <!-- Onglet Employés -->
      <div class="tab-pane fade show active" id="employe" role="tabpanel" aria-labelledby="employe-tab">
        <div class="form-container">
          <h2 class="text-center mb-4"><i class="fas fa-user-plus"></i> Ajouter un employé</h2>
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
          <form method="POST" action="${pageContext.request.contextPath}/AddEmployeeServlet">
            <input type="hidden" name="action" value="add">
            <div class="row g-3">
              <!-- Colonne gauche -->
              <div class="col-md-6">
                <label class="form-label required">Numéro de sécurité sociale  </label>
                <input type="text" class="form-control" name="empcode" required value="${param.empcode}">
                <label class="form-label required">Prénom</label>
                <input type="text" class="form-control" name="lastName" required value="${param.lastName}">
                <label class="form-label required mt-3">Département</label>
                <select class="form-select" name="department" required>
                  <option value="">Sélectionnez un département</option>
                  <%{
                      List<Department> deptList = (List<Department>) session.getAttribute("departments");
                      if(deptList != null) {
                        for(Department d : deptList) {
                  %>
                  <option value="<%= d.getDepartmentName() %>" <%= (request.getParameter("department") != null && request.getParameter("department").equals(d.getDepartmentName())) ? "selected" : "" %>>
                    <%= d.getDepartmentName() %>
                  </option>
                  <%       }
                      }
                  } %>
                </select>
                <label class="form-label required mt-3">Rôle</label>
                <select class="form-select" name="role" required>
                  <option value="">Sélectionnez un rôle</option>
                  <%{
                      List<String> roles = (List<String>) session.getAttribute("roles");
                      if(roles != null) {
                        for(String r : roles) {
                  %>
                  <option value="<%= r %>" <%= (request.getParameter("role") != null && request.getParameter("role").equals(r)) ? "selected" : "" %>>
                    <%= r %>
                  </option>
                  <%       }
                      }
                  } %>
                </select>
              </div>
              <!-- Colonne droite -->
              <div class="col-md-6">
              <label class="form-label required mt-3">Nom</label>
                <input type="text" class="form-control" name="firstName" required value="${param.firstName}">
                <label class="form-label required mt-3">Téléphone</label>
                <input type="tel" class="form-control" name="mobileno" pattern="[234]\d{7}" title="Doit commencer par 2/3/4 et avoir 8 chiffres" required value="${param.mobileno}">
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
        <div class="mt-5">
          <h3 class="mb-4"><i class="fas fa-users"></i> Liste des employés</h3>
          <% List<Employee> employees = (List<Employee>) session.getAttribute("employees"); %>
          <% if (employees != null && !employees.isEmpty()) { %>
            <div class="table-responsive">
              <table class="table table-hover table-bordered">
                <thead class="table-dark">
                  <tr>
                    <th>Numéro de sécurité sociale </th>
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
                          data-address="<%= emp.getAddress() %>"
                          data-password="<%= emp.getPassword() %>">
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
      
      <!-- Onglet pour la Gestion des départements & managers -->
      <div class="tab-pane fade" id="manager" role="tabpanel" aria-labelledby="manager-tab">
        <div class="form-container">
          <h2 class="text-center mb-4">
            <i class="fas fa-building"></i> Gestion des départements & managers
          </h2>
          <% if (request.getAttribute("errorDept") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show">
              ${errorDept}
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          <% } %>
          <% if (request.getAttribute("msgDept") != null) { %>
            <div class="alert alert-success alert-dismissible fade show">
              ${msgDept}
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          <% } %>
          <form method="POST" action="${pageContext.request.contextPath}/ManagerServlet">
            <input type="hidden" name="action" value="addManager">
            <div class="row g-3">
              <div class="col-12">
                <h4>Informations sur le manager</h4>
              </div>
              <div class="col-md-4">
                <label class="form-label required">Code Manager</label>
                <input type="text" class="form-control" name="managerCode" required value="${param.managerCode}">
              </div>
              <div class="col-md-4">
                <label class="form-label required">Nom</label>
                <input type="text" class="form-control" name="managerFirstName" required value="${param.managerFirstName}">
              </div>
              <div class="col-md-4">
                <label class="form-label required">Prénom</label>
                <input type="text" class="form-control" name="managerLastName" required value="${param.managerLastName}">
              </div>
              <div class="col-md-6">
                <label class="form-label required">Email</label>
                <input type="email" class="form-control" name="managerEmail" required value="${param.managerEmail}">
              </div>
              <div class="col-md-6">
                <label class="form-label required">Téléphone</label>
                <input type="tel" class="form-control" name="managerMobileno" pattern="[234]\d{7}" title="Doit commencer par 2/3/4 et avoir 8 chiffres" required value="${param.managerMobileno}">
              </div>
              <div class="col-12 mt-4">
                <h4>Informations sur le département</h4>
              </div>
              <div class="col-md-6">
                <label class="form-label required">Nom du département</label>
                <input type="text" class="form-control" name="departmentName" required value="${param.departmentName}">
              </div>
              <div class="col-md-6">
                <label class="form-label required">Liste des rôles</label>
                <input type="text" class="form-control" name="departmentRoles" required placeholder="Séparez les rôles par une virgule" value="${param.departmentRoles}">
              </div>
              <div class="col-md-6">
                <label class="form-label required">Mot de passe</label>
                <input type="password" class="form-control" name="managerPassword" required>
              </div>
              <div class="col-md-6">
                <label class="form-label required">Confirmation</label>
                <input type="password" class="form-control" name="managerConfirmPassword" required>
              </div>
              <div class="col-12 text-center mt-4">
                <button type="submit" class="btn btn-primary btn-lg">
                  <i class="fas fa-save"></i> Enregistrer
                </button>
              </div>
            </div>
          </form>
          
        </div>
        <div class="mt-5">
            <h3 class="mb-4"><i class="fas fa-user-tie"></i> Liste des managers</h3>
            <% List<Manager> managers = (List<Manager>) session.getAttribute("managers"); %>
            <% if (managers != null && !managers.isEmpty()) { %>
              <div class="table-responsive">
                <table class="table table-hover table-bordered">
                  <thead class="table-dark">
                    <tr>
                      <th>Code</th>
                      <th>Nom complet</th>
                      <th>Email</th>
                      <th>Téléphone</th>
                      <th>Département</th>
                      <th>Rôles</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <% for (Manager mgr : managers) { %>
                      <tr>
                        <td><%= mgr.getManagerCode() %></td>
                        <td><%= mgr.getManagerFirstName() %> <%= mgr.getManagerLastName() %></td>
                        <td><%= mgr.getManagerEmail() %></td>
                        <td><%= mgr.getManagerMobileno() %></td>
                        <td><%= mgr.getDepartmentName() %></td>
                        <td><%= mgr.getDepartmentRoles() %></td>
                        <td class="action-btns">
                          <button class="btn btn-warning btn-sm edit-manager-btn" 
                            data-managercode="<%= mgr.getManagerCode() %>"
                            data-managerfirstname="<%= mgr.getManagerFirstName() %>"
                            data-managerlastname="<%= mgr.getManagerLastName() %>"
                            data-manageremail="<%= mgr.getManagerEmail() %>"
                            data-managermobileno="<%= mgr.getManagerMobileno() %>"
                            data-departmentname="<%= mgr.getDepartmentName() %>"
                            data-departmentroles="<%= mgr.getDepartmentRoles() %>"
                            data-managerpassword="<%= mgr.getManagerPassword() %>">
                            <i class="fas fa-edit"></i> Modifier
                          </button>
                          <button class="btn btn-danger btn-sm" 
                            onclick="confirmDeleteManager('<%= mgr.getManagerCode() %>')">
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
                Aucun manager enregistré
              </div>
            <% } %>
          </div>
      </div>
      
    </div>
    
  </div>

  <!-- Modal d'édition pour les employés -->
  <div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-edit"></i> Modifier employé</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <form method="POST" action="${pageContext.request.contextPath}/AddEmployeeServlet">
          <div class="modal-body">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="originalEmpcode" id="originalEmpcode">
            <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label">Numéro de sécurité sociale </label>
                <input type="text" class="form-control" name="empcode" id="editEmpcode" required>
              </div>
              <div class="col-md-6">
                <label class="form-label">Nom</label>
                <input type="text" class="form-control" name="firstName" id="editFirstName" required>
              </div>
              <div class="col-md-6">
                <label class="form-label">Prénom</label>
                <input type="text" class="form-control" name="lastName" id="editLastName" required>
              </div>
              <div class="col-md-6">
                <label class="form-label">Email</label>
                <input type="email" class="form-control" name="email" id="editEmail" required>
              </div>
              <div class="col-md-6">
                <label class="form-label">Département</label>
                <select class="form-select" name="department" id="editDepartment" required>
                  <option value="">Sélectionnez un département</option>
                  <%{
                      List<Department> deptList = (List<Department>) session.getAttribute("departments");
                      if(deptList != null) {
                        for(Department d : deptList) {
                  %>
                  <option value="<%= d.getDepartmentName() %>"><%= d.getDepartmentName() %></option>
                  <%       }
                      }
                  } %>
                </select>
              </div>
              <div class="col-md-6">
                <label class="form-label">Rôle</label>
                <select class="form-select" name="role" id="editRole" required>
                  <option value="">Sélectionnez un rôle</option>
                  <%{
                      List<String> roles = (List<String>) session.getAttribute("roles");
                      if(roles != null) {
                        for(String r : roles) {
                  %>
                  <option value="<%= r %>"><%= r %></option>
                  <%       }
                      }
                  } %>
                </select>
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
                <input type="tel" class="form-control" name="mobileno" id="editMobileno" pattern="[234]\d{7}" title="Doit commencer par 2/3/4 et avoir 8 chiffres" required>
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
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
              <i class="fas fa-times"></i> Annuler
            </button>
            <button type="submit" class="btn btn-primary">
              <i class="fas fa-save"></i> Enregistrer
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Modal d'édition pour les managers -->
  <div class="modal fade" id="editManagerModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-edit"></i> Modifier manager</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <form method="POST" action="${pageContext.request.contextPath}/ManagerServlet">
          <div class="modal-body">
            <input type="hidden" name="action" value="editManager">
            <input type="hidden" name="originalManagerCode" id="originalManagerCode">
            <div class="row g-3">
              <div class="col-md-4">
                <label class="form-label">Code Manager</label>
                <input type="text" class="form-control" name="managerCode" id="editManagerCode" required>
              </div>
              <div class="col-md-4">
                <label class="form-label">Nom</label>
                <input type="text" class="form-control" name="managerFirstName" id="editManagerFirstName" required>
              </div>
              <div class="col-md-4">
                <label class="form-label">Prénom</label>
                <input type="text" class="form-control" name="managerLastName" id="editManagerLastName" required>
              </div>
              <div class="col-md-6">
                <label class="form-label">Email</label>
                <input type="email" class="form-control" name="managerEmail" id="editManagerEmail" required>
              </div>
              <div class="col-md-6">
                <label class="form-label">Téléphone</label>
                <input type="tel" class="form-control" name="managerMobileno" id="editManagerMobileno" pattern="[234]\d{7}" title="Doit commencer par 2/3/4 et avoir 8 chiffres" required>
              </div>
              <div class="col-md-6">
                <label class="form-label">Département</label>
                <input type="text" class="form-control" name="departmentName" id="editManagerDepartmentName" required>
              </div>
              <div class="col-md-6">
                <label class="form-label">Liste des rôles</label>
                <input type="text" class="form-control" name="departmentRoles" id="editManagerDepartmentRoles" required>
              </div>
              <div class="col-md-6">
                <label class="form-label">Mot de passe</label>
                <input type="password" class="form-control" name="managerPassword" id="editManagerPassword" required>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
              <i class="fas fa-times"></i> Annuler
            </button>
            <button type="submit" class="btn btn-primary">
              <i class="fas fa-save"></i> Enregistrer
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Modal d'édition pour les départements -->
  <div class="modal fade" id="editDeptModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title"><i class="fas fa-edit"></i> Modifier département</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <form method="POST" action="${pageContext.request.contextPath}/ManagerServlet">
          <div class="modal-body">
            <input type="hidden" name="action" value="editDept">
            <input type="hidden" name="originalDeptName" id="originalDeptName">
            <div class="row g-3">
              <div class="col-md-6">
                <label class="form-label">Nom du département</label>
                <input type="text" class="form-control" name="departmentName" id="editDeptName" required>
              </div>
              <div class="col-md-6">
                <label class="form-label">Liste des rôles</label>
                <input type="text" class="form-control" name="departmentRoles" id="editDeptRoles" required>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
              <i class="fas fa-times"></i> Annuler
            </button>
            <button type="submit" class="btn btn-primary">
              <i class="fas fa-save"></i> Enregistrer
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script>
    function confirmDelete(empcode) {
      if (confirm('Voulez-vous vraiment supprimer cet employé ?')) {
        window.location = '${pageContext.request.contextPath}/DeleteEmployeeServlet?action=delete&empcode=' + empcode;
      }
    }
    function confirmDeleteManager(managerCode) {
      if (confirm('Voulez-vous vraiment supprimer ce manager ?')) {
        window.location = '${pageContext.request.contextPath}/ManagerServlet?action=deleteManager&managerCode=' + managerCode;
      }
    }
    function confirmDeleteDept(departmentName) {
      if (confirm('Voulez-vous vraiment supprimer ce département ?')) {
        window.location = '${pageContext.request.contextPath}/ManagerServlet?action=deleteDept&departmentName=' + encodeURIComponent(departmentName);
      }
    }
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
    document.querySelectorAll('.edit-manager-btn').forEach(button => {
      button.addEventListener('click', function() {
        const mgr = {
          managerCode: this.dataset.managercode,
          managerFirstName: this.dataset.managerfirstname,
          managerLastName: this.dataset.managerlastname,
          managerEmail: this.dataset.manageremail,
          managerMobileno: this.dataset.managermobileno,
          departmentName: this.dataset.departmentname,
          departmentRoles: this.dataset.departmentroles,
          managerPassword: this.dataset.managerpassword
        };
        document.getElementById('originalManagerCode').value = mgr.managerCode;
        document.getElementById('editManagerCode').value = mgr.managerCode;
        document.getElementById('editManagerFirstName').value = mgr.managerFirstName;
        document.getElementById('editManagerLastName').value = mgr.managerLastName;
        document.getElementById('editManagerEmail').value = mgr.managerEmail;
        document.getElementById('editManagerMobileno').value = mgr.managerMobileno;
        document.getElementById('editManagerDepartmentName').value = mgr.departmentName;
        document.getElementById('editManagerDepartmentRoles').value = mgr.departmentRoles;
        document.getElementById('editManagerPassword').value = mgr.managerPassword;
        new bootstrap.Modal(document.getElementById('editManagerModal')).show();
      });
    });
    document.querySelectorAll('.edit-dept-btn').forEach(button => {
      button.addEventListener('click', function() {
        const dept = {
          departmentName: this.dataset.departmentname,
          departmentRoles: this.dataset.departmentroles
        };
        document.getElementById('originalDeptName').value = dept.departmentName;
        document.getElementById('editDeptName').value = dept.departmentName;
        document.getElementById('editDeptRoles').value = dept.departmentRoles;
        new bootstrap.Modal(document.getElementById('editDeptModal')).show();
      });
    });
  </script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>