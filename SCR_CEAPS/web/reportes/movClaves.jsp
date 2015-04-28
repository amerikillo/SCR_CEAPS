<%-- 
    Document   : movClaves
    Created on : 24/04/2015, 10:36:45 AM
    Author     : Americo
--%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%    DecimalFormat formatter = new DecimalFormat("#,###,###");
    DecimalFormat formatter2 = new DecimalFormat("#,###,###.##");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    ConectionDB con = new ConectionDB();
    HttpSession sesion = request.getSession();
    String accion = "";
    accion = request.getParameter("accion");
    if (accion == null) {
        accion = "";
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Estilos CSS -->
        <link href="../css/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" href="../css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="../css/navbar-fixed-top.css" rel="stylesheet">
        <!---->
        <title>Kardex</title>
    </head>
    <body>
        <%@include file="../jspf/mainMenu.jspf" %>%>
        <div class="container" style="padding-top: 50px">
            <div class="col-sm-1 col-sm-offset-11">
                <a class="btn btn-block btn-default" href="gnrMovClaves.jsp"><span class="glyphicon glyphicon-download-alt"></span></a>
            </div>
            <h3>Claves Alto Movimiento</h3>
            <table class="table table-condensed table-bordered">
                <tr>
                    <td>Clave</td>
                    <td>Descripción</td>
                    <td>Cantidad</td>
                </tr>
                <%
                    try {
                        con.conectar();
                        ResultSet rset = con.consulta("select cla_pro, des_pro, sum(cant_sur) as cant_sur from recetas group by cla_pro order by cant_sur desc limit 0,10");
                        while (rset.next()) {
                %>
                <tr>
                    <td><%=rset.getString("cla_pro")%></td>
                    <td><%=rset.getString("des_pro")%></td>
                    <td><%=rset.getString("cant_sur")%></td>
                </tr>
                <%
                        }
                        con.cierraConexion();
                    } catch (Exception e) {
                        out.println(e);
                    }
                %>
            </table>
            <h3>Claves Bajo Movimiento</h3>
            <table class="table table-condensed table-bordered">
                <tr>
                    <td>Clave</td>
                    <td>Descripción</td>
                    <td>Cantidad</td>
                </tr>
                <%
                    try {
                        con.conectar();
                        ResultSet rset = con.consulta("select cla_pro, des_pro, sum(cant_sur) as cant_sur from recetas where cant_sur!=0 group by cla_pro order by cant_sur asc limit 0,10");
                        while (rset.next()) {
                %>
                <tr>
                    <td><%=rset.getString("cla_pro")%></td>
                    <td><%=rset.getString("des_pro")%></td>
                    <td><%=rset.getString("cant_sur")%></td>
                </tr>
                <%
                        }
                        con.cierraConexion();
                    } catch (Exception e) {
                        out.println(e);
                    }
                %>
            </table>
            <h3>Claves Nulo Movimiento</h3>
            <table class="table table-condensed table-bordered">
                <tr>
                    <td>Clave</td>
                    <td>Descripción</td>
                    <td>Cantidad</td>
                </tr>
                <%
                    try {
                        con.conectar();
                        ResultSet rset = con.consulta("select cla_pro, des_pro from productos where cla_pro not in (select distinct cla_pro from recetas)");
                        while (rset.next()) {
                %>
                <tr>
                    <td><%=rset.getString("cla_pro")%></td>
                    <td><%=rset.getString("des_pro")%></td>
                    <td>0</td>
                </tr>
                <%
                        }
                        con.cierraConexion();
                    } catch (Exception e) {
                        out.println(e);
                    }
                %>
            </table>
        </div>
        <script src="../js/jquery-1.9.1.js"></script>
        <script src="../js/bootstrap.js"></script>
        <script src="../js/jquery-ui.js"></script>
        <script>
            function cambiaLoteCadu(elemento) {
                var indice = elemento.selectedIndex;
                document.getElementById('Cadu').selectedIndex = indice;
            }
        </script>
    </body>
</html>
