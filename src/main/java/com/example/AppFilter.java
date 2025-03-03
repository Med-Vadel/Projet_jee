package com.example;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/AddEmployeeServlet", "/DepartmentServlet", "/EvaluateEmployeeServlet", "/ManagerServlet", "/Pages/add-employee.jsp", "/Pages/employeeDashboard.jsp", "/Pages/managerDashboard.jsp"})
public class AppFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("AppFilter initialized.");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        // ضبط الترميز ونوع المحتوى
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String requestURI = httpRequest.getRequestURI();

        System.out.println("Request URL: " + requestURI);
        System.out.println("HTTP Method: " + httpRequest.getMethod());
        System.out.println("AppFilter is working: processing the request.");

        // التعامل الخاص مع صفحة add-employee.jsp
        if (requestURI.contains("add-employee.jsp")) {
            HttpSession session = httpRequest.getSession(false);
            String currentUser = (session != null) ? (String) session.getAttribute("currentManager") : null;

            // إذا لم يكن هناك جلسة أو الخاصية غير موجودة، نحاول الحصول على بيانات الاعتماد من معطيات الطلب
            if (currentUser == null) {
                String username = httpRequest.getParameter("username");
                String password = httpRequest.getParameter("password");
                if ("admin".equals(username) && "admin".equals(password)) {
                    // إنشاء جلسة وتعيين الخاصية
                    session = httpRequest.getSession(true);
                    session.setAttribute("currentManager", "admin");
                    System.out.println("Admin credentials provided via parameters. Session created.");
                } else {
                    System.out.println("Access denied to add-employee.jsp. Admin credentials not provided or incorrect.");
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/Pages/login.jsp?error=notAuthorized");
                    return;
                }
            }

            // التحقق مرة أخرى من الخاصية في الجلسة
            currentUser = (session != null) ? (String) session.getAttribute("currentManager") : null;
            if (!"admin".equals(currentUser)) {
                System.out.println("Access denied to add-employee.jsp. Current user is not admin.");
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/Pages/login.jsp?error=notAuthorized");
                return;
            } else {
                System.out.println("Admin user detected. Access granted to add-employee.jsp.");
                chain.doFilter(request, response);
                return;
            }
        }

        // للطلبات الأخرى: يتطلب وجود جلسة مع "currentManager"
        HttpSession session = httpRequest.getSession(false);
        if (session == null || session.getAttribute("currentManager") == null) {
            System.out.println("AppFilter: Unauthorized access to " + requestURI + ", redirecting to login.jsp");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/Pages/login.jsp?error=notAuthorized");
            return;
        }
        
        // متابعة معالجة الطلب إذا كانت الجلسة موجودة وصحيحة
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("AppFilter destroyed.");
    }
}