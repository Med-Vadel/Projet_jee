<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.example.Employee, com.example.Manager, com.example.Evaluation" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Manager Dashboard</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    body { background-color: #f8f9fa; }
    .container { margin-top: 2rem; }
  </style>
</head>
<body>
  <div class="container">
    <%
      // التأكد من تسجيل دخول المدير
      Manager currentManager = (Manager) session.getAttribute("currentManager");
      if(currentManager == null) {
          response.sendRedirect("managerLogin.jsp");
          return;
      }
      List<Employee> employees = (List<Employee>) session.getAttribute("employees");
      List<Evaluation> evaluations = (List<Evaluation>) session.getAttribute("evaluations");
    %>
    <h2>Bienvenue, <%= currentManager.getManagerFirstName() %> <%= currentManager.getManagerLastName() %></h2>
    <h4>Département : <%= currentManager.getDepartmentName() %></h4>
    <hr>
    <h3>Liste des employés de votre département</h3>
    <%
      if(employees == null || employees.isEmpty()) {
    %>
      <div class="alert alert-info">Aucun employé enregistré dans ce département.</div>
    <%
      } else {
    %>
      <table class="table table-striped">
        <thead>
          <tr>
            <th>Code</th>
            <th>Nom complet</th>
            <th>Email</th>
            <th>Téléphone</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <%
            for(Employee emp : employees) {
              if(emp.getDepartment().equals(currentManager.getDepartmentName())) {
          %>
          <tr>
            <td><%= emp.getEmpcode() %></td>
            <td><%= emp.getFirstName() %> <%= emp.getLastName() %></td>
            <td><%= emp.getEmail() %></td>
            <td><%= emp.getMobileno() %></td>
            <td>
              <button class="btn btn-primary btn-sm evaluate-btn" data-empcode="<%= emp.getEmpcode() %>">
                Évaluer
              </button>
            </td>
          </tr>
          <%
              }
            }
          %>
        </tbody>
      </table>
    <%
      }
    %>

    <!-- عرض التقييمات: عرض فقط التقييمات التي أنشأها المدير الحالي -->
    <h3 class="mt-4">Évaluations des employés</h3>
    <%
      if(evaluations == null || evaluations.isEmpty()) {
    %>
      <div class="alert alert-warning">Aucune évaluation enregistrée.</div>
    <%
      } else {
    %>
      <table class="table table-bordered">
        <thead>
          <tr>
            <th>Code Employé</th>
            <th>Compétence technique</th>
            <th>Qualité du travail</th>
            <th>Esprit d'équipe</th>
            <th>Communication</th>
            <th>Respect des délais</th>
            <th>Commentaire</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <%
            for(Evaluation eval : evaluations) {
              if(eval.getManagerCode().equals(currentManager.getManagerCode())) {
          %>
          <tr>
            <td><%= eval.getEmpCode() %></td>
            <td><%= eval.getTechSkill() %>/10</td>
            <td><%= eval.getWorkQuality() %>/10</td>
            <td><%= eval.getTeamwork() %>/10</td>
            <td><%= eval.getCommunication() %>/10</td>
            <td><%= eval.getDeadlineRespect() %>/10</td>
            <td><%= eval.getGeneralComment() %></td>
            <td>
              <button class="btn btn-warning btn-sm edit-eval-btn" data-empcode="<%= eval.getEmpCode() %>"
                      data-techskill="<%= eval.getTechSkill() %>" data-workquality="<%= eval.getWorkQuality() %>"
                      data-teamwork="<%= eval.getTeamwork() %>" data-communication="<%= eval.getCommunication() %>"
                      data-deadlinerespect="<%= eval.getDeadlineRespect() %>" data-comment="<%= eval.getGeneralComment() %>">
                Modifier
              </button>
              <a href="${pageContext.request.contextPath}/EvaluateEmployeeServlet?action=deleteEval&empcode=<%= eval.getEmpCode() %>" 
                 class="btn btn-danger btn-sm" onclick="return confirm('Voulez-vous vraiment supprimer ce résultat ?');">
                Supprimer
              </a>
            </td>
          </tr>
          <%
              }
            }
          %>
        </tbody>
      </table>
    <%
      }
    %>
  </div>

  <!-- Modal d'évaluation détaillée (pour ajouter أو modifier l'évaluation) -->
  <div class="modal fade" id="evaluationModal" tabindex="-1" aria-labelledby="evaluationModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="evaluationModalLabel">Évaluation détaillée de l'employé</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <form method="POST" action="${pageContext.request.contextPath}/EvaluateEmployeeServlet">
          <div class="modal-body">
            <!-- إضافة حقل خفي "action" لتحديد العملية -->
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="empcode" id="evalEmpcode">
            <div class="mb-3">
              <label for="techSkill" class="form-label">Compétence technique (1-10)</label>
              <input type="number" class="form-control" id="techSkill" name="techSkill" min="1" max="10" required>
            </div>
            <div class="mb-3">
              <label for="workQuality" class="form-label">Qualité du travail (1-10)</label>
              <input type="number" class="form-control" id="workQuality" name="workQuality" min="1" max="10" required>
            </div>
            <div class="mb-3">
              <label for="teamwork" class="form-label">Esprit d'équipe (1-10)</label>
              <input type="number" class="form-control" id="teamwork" name="teamwork" min="1" max="10" required>
            </div>
            <div class="mb-3">
              <label for="communication" class="form-label">Communication (1-10)</label>
              <input type="number" class="form-control" id="communication" name="communication" min="1" max="10" required>
            </div>
            <div class="mb-3">
              <label for="deadlineRespect" class="form-label">Respect des délais (1-10)</label>
              <input type="number" class="form-control" id="deadlineRespect" name="deadlineRespect" min="1" max="10" required>
            </div>
            <div class="mb-3">
              <label for="generalComment" class="form-label">Commentaire général</label>
              <textarea class="form-control" id="generalComment" name="generalComment" rows="3"></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
            <button type="submit" class="btn btn-primary">Envoyer l'évaluation</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- Scripts Bootstrap et gestion des actions -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    var evaluationModal = new bootstrap.Modal(document.getElementById('evaluationModal'));
    
    // عند الضغط على زر "Évaluer" لإضافة تقييم جديد: مسح الحقول وتهيئة النموذج
    document.querySelectorAll('.evaluate-btn').forEach(function(button) {
      button.addEventListener('click', function() {
        var empcode = this.getAttribute('data-empcode');
        document.getElementById('evalEmpcode').value = empcode;
        document.getElementById('techSkill').value = "";
        document.getElementById('workQuality').value = "";
        document.getElementById('teamwork').value = "";
        document.getElementById('communication').value = "";
        document.getElementById('deadlineRespect').value = "";
        document.getElementById('generalComment').value = "";
        evaluationModal.show();
      });
    });
    
    // عند الضغط على زر "Modifier" لتعديل تقييم موجود: تعبئة النموذج بالبيانات الحالية
    document.querySelectorAll('.edit-eval-btn').forEach(function(button) {
      button.addEventListener('click', function() {
        var empcode = this.getAttribute('data-empcode');
        var techSkill = this.getAttribute('data-techskill');
        var workQuality = this.getAttribute('data-workquality');
        var teamwork = this.getAttribute('data-teamwork');
        var communication = this.getAttribute('data-communication');
        var deadlineRespect = this.getAttribute('data-deadlinerespect');
        var comment = this.getAttribute('data-comment');
        
        document.getElementById('evalEmpcode').value = empcode;
        document.getElementById('techSkill').value = techSkill;
        document.getElementById('workQuality').value = workQuality;
        document.getElementById('teamwork').value = teamwork;
        document.getElementById('communication').value = communication;
        document.getElementById('deadlineRespect').value = deadlineRespect;
        document.getElementById('generalComment').value = comment;
        
        evaluationModal.show();
      });
    });
  </script>
</body>
</html>