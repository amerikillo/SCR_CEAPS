<%-- 
    Document   : gnrMovClaves
    Created on : 24/04/2015, 11:18:05 AM
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
    
    
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment;filename=\"Reporte Movimiento Claves.xls\"");
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<h3>Claves Alto Movimiento</h3>
<table border="1">
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
<table border="1">
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
<table border="1">
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