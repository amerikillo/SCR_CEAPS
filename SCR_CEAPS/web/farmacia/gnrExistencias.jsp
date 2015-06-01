<%-- 
    Document   : index
    Created on : 07-mar-2014, 15:38:43
    Author     : Americo
--%>

<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>

<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    DecimalFormat formatNumber = new DecimalFormat("#,###,###,###");
    ConectionDB con = new ConectionDB();
    HttpSession sesion = request.getSession();
    String id_usu = "";
    String cla_uni = "";
    try {
        id_usu = (String) session.getAttribute("id_usu");
    } catch (Exception e) {
    }

    try {
        con.conectar();
        ResultSet rset = con.consulta("select cla_uni from usuarios where id_usu = '" + id_usu + "' ");
        while (rset.next()) {
            cla_uni = rset.getString("cla_uni");
        }
        con.cierraConexion();
    } catch (Exception e) {

    }
    if (id_usu == null) {
        response.sendRedirect("index.jsp");
    }

    String fecha1 = "2010-01-01";
    String fecha2 = "2030-01-01";
    int meses = 0;
    try {
        meses = Integer.parseInt(request.getParameter("meses"));
        if (meses == 0) {
            meses = 500;
        }
        Calendar c1 = GregorianCalendar.getInstance();
        c1.add(Calendar.MONTH, meses);

        fecha2 = df2.format(c1.getTime());
        if (meses == 500) {
            meses = 0;
        }

    } catch (Exception e) {
    }

    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment;filename=\"Existencias.xls\"");
%>
<table border="1">
    <thead>
        <tr>
            <td>Clave</td>
            <!--td>CB</td-->
            <td>Descripción</td>
            <td>Lote</td>
            <td>Caducidad</td>
            <td>Origen</td>
            <td>Cantidad</td>
        </tr>
    </thead>
    <tbody>
        <%
            try {
                con.conectar();
                String clave = "", descrip = "", lote = "", caducidad = "", origen = "", cantidad = "0";

                ResultSet rset = con.consulta("select * from existencias where cad_pro between '" + fecha1 + "' and '" + fecha2 + "' and cant!=0 and f_status='A' and cla_uni = '" + cla_uni + "' order by cla_pro+0");
                while (rset.next()) {
                    clave = rset.getString(1);
                    descrip = rset.getString(3);
                    lote = rset.getString(4);
                    caducidad = rset.getString(5);
                    origen = rset.getString(6);
                    cantidad = rset.getString(7);
                    caducidad = df3.format(df2.parse(caducidad));
        %>
        <tr>

            <td><%=clave%></td>
            <td><%=descrip%></td>
            <td><%=lote%></td>
            <td><%=caducidad%></td>
            <td><%=origen%></td>
            <td><%=cantidad%></td>
        </tr>
        <%

                }
                con.cierraConexion();
            } catch (Exception e) {

            }
        %>
    </tbody>
</table>