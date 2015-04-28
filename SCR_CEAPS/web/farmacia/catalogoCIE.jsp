<%-- 
    Document   : catalogoMedicos
    Created on : 16/02/2015, 03:56:50 PM
    Author     : Americo
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    ConectionDB con = new ConectionDB();
    HttpSession sesion = request.getSession();
    String id_usu = "";
    String uni_ate = "", cedula = "", medico = "";
    try {
        id_usu = (String) session.getAttribute("id_usu");
        uni_ate = (String) session.getAttribute("cla_uni");
        cedula = (String) session.getAttribute("cedula");
        medico = (String) session.getAttribute("id_usu");

        con.conectar();
        try {
            ResultSet rset = con.consulta("select us.nombre, un.des_uni from usuarios us, unidades un where us.cla_uni = un.cla_uni and us.id_usu = '" + id_usu + "' ");
            while (rset.next()) {
                medico = rset.getString(1);
                uni_ate = rset.getString(2);
            }
        } catch (Exception e) {
            e.getMessage();
        }
        con.cierraConexion();
    } catch (Exception e) {
    }
    try {
        if (id_usu == null) {
            response.sendRedirect("../index.jsp");
        }
    } catch (Exception e) {
    }
%>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyyMMddhhmmss"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy");%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Bootstrap -->
        <link href="../css/bootstrap.css" rel="stylesheet" media="screen">
        <link href="../css/dataTables.bootStrap.css" rel="stylesheet">
        <!--link href="../css/datepicker3.css" rel="stylesheet"-->
        <link href="../css/cupertino/jquery-ui-1.10.3.custom.css" rel="stylesheet">
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <title>SIALSS</title>
    </head>
    <body class="container">
        <h1>Catálogo CIE-10</h1>
        <hr/>
        <table class="table table-bordered table-condensed table-striped" id="catMedicos">
            <thead>
                <tr>
                    <td>Clave</td>
                    <td>Causes</td>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        con.conectar();
                        ResultSet rset = con.consulta("select id_cau, des_cau from causes where id_cau not in ('998', '999');");
                        while (rset.next()) {
                %>
                <tr>
                    <td><%=rset.getString("id_cau")%></td>
                    <td><%=rset.getString("des_cau")%></td>
                </tr>
                <%
                        }
                        con.cierraConexion();
                    } catch (Exception e) {

                    }
                %>
            </tbody>
        </table>
        <script src="../js/jquery-1.9.1.js"></script>
        <script src="../js/bootstrap.js"></script>
        <script src="../js/jquery.dataTables.js"></script>
        <script src="../js/dataTables.bootstrap.js"></script>
        <script src="../js/jquery-ui-1.10.3.custom.js"></script>
        <script>
            $(document).ready(function() {
                $('#catMedicos').dataTable();
            });
        </script>
    </body>
</html>
