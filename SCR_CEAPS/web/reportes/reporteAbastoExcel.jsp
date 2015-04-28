<%-- 
    Document   : index
    Created on : 07-mar-2014, 15:38:43
    Author     : Americo
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment; filename=Reporte abasto-" + request.getParameter("nom") + ".xls");
    HttpSession sesion = request.getSession();
    String id_usu = "", ver = "hidden";
    ConectionDB con = new ConectionDB();
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
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <title>SIALSS</title>
    </head>
    <body>            
        <div id="DetalleAb" class="modal fade in" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <a data-dismiss="modal" class="close">×</a>
                        <h3>Detalle Abasto-<%=sesion.getAttribute("nom_abasto")%></h3>
                        <h4>Fecha: <%=request.getParameter("fecha")%></h4>
                    </div>
                    <div class="modal-body">
                        <div class="panel panel-body">
                            <table class="table table-bordered" id="tbDetalleAba">
                                <thead>
                                    <tr>
                                        <th>Clave</th>
                                        <th>Lote</th>
                                        <th>Caducidad</th>
                                        <th>Cantidad</th>
                                        <th>Origen</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        try {
                                            con.conectar();
                                            ResultSet rs = con.consulta("SELECT ra.clave, ra.lote, ra.caducidad, ra.cantidad, ra.origen, ra.cb FROM reporte_abasto AS ra where nom_abasto='" + request.getParameter("nom") + "'");
                                            while (rs.next()) {

                                    %>
                                    <tr>
                                        <td><%= rs.getString(1)%></td>
                                        <td><%= rs.getString(2)%></td>
                                        <td><%= rs.getString(3)%></td>
                                        <td><%= rs.getString(4)%></td>
                                        <td><%= rs.getString(5)%></td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception ex) {
                                            System.out.println("ErrorEC->" + ex);
                                        }
                                    %>
                                </tbody>
                            </table>                            
                        </div>
                    </div>
                    <div class="modal-footer">
                        <a href="#" data-dismiss="modal" class="btn btn-primary">Cerrar</a>
                    </div>
                </div>
            </div>                
        </div>
        <br/>
    </body>
</html>


