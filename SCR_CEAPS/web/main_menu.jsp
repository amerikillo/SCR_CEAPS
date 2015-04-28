<%-- 
    Document   : index
    Created on : 07-mar-2014, 15:38:43
    Author     : Americo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%    HttpSession sesion = request.getSession();
    String id_usu = "";
    try {
        id_usu = (String) session.getAttribute("id_usu");
    } catch (Exception e) {
    }

    if (id_usu == null) {
        response.sendRedirect("index.jsp");
    }

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Bootstrap -->
        <link href="css/bootstrap.css" rel="stylesheet" media="screen">
        <link href="css/topPadding.css" rel="stylesheet">
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <title>Sistema de Captura de Recetas</title>
    </head>
    <body>
        <%@include file="jspf/mainMenu.jspf" %>

        <div class="container-fluid">
            <div class="starter-template">
                <h1>SIALSS</h1>

                <%                    try {
                        if (((String) sesion.getAttribute("tipo")).equals("FARMACIA")) {
                %>
                <h4>Médico</h4>
                <%
                } else if (((String) sesion.getAttribute("tipo")).equals("ADMON")) {
                %>
                <h4>Administrador de Usuarios</h4>
                <%
                } else {
                %>
                <h4>Farmacia</h4>
                <%
                        }
                    } catch (Exception e) {

                    }
                %>
                <p class="lead">Sistema de Captura de Receta</p>                
            </div>

        </div>
        <div class="row">
            <div class="col-md-5"></div>
            <div class="col-md-2"><center><img src="imagenes/medalfaLogo.png" width=200 alt="Logo"></center></div>
            <div class="col-md-5"></div>

        </div>

        <!-- 
        ================================================== -->
        <!-- Se coloca al final del documento para que cargue mas rapido -->
        <!-- Se debe de seguir ese orden al momento de llamar los JS -->
        <script src="js/jquery-1.9.1.js"></script>
        <script src="js/bootstrap.js"></script>
        <script src="js/jquery-ui-1.10.3.custom.js"></script>
    </body>
</html>

