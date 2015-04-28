<%-- 
    Document   : index
    Created on : 07-mar-2014, 15:38:43
    Author     : Americo
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%    HttpSession sesion = request.getSession();
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
        <!-- Bootstrap -->
        <link href="../css/bootstrap.css" rel="stylesheet" media="screen">
        <link href="../css/topPadding.css" rel="stylesheet">
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <title>SIALSS</title>
    </head>
    <body>
        <%@include file="../jspf/mainMenu.jspf"%>
        <br/>
        <div class="container">
            <div class="row text-left" style="width: 600px;">
                <h1>Reporte de Abastos</h2>
            </div>          
            <br/><br/>
            <div class="panel"  id="paAbasto">
                <table id="tbAbastos" class="table table-bordered">
                    <thead>
                        <tr>
                            <th class="h2 text-center" colspan="4">Abastos</th>
                        </tr>
                        <tr>
                            <th>Cantidad de Claves</th>
                            <th>Nombre</th>
                            <th>Fecha</th>
                            <th>Ver Detalle</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%       //                   
                            try {
                                con.conectar();
                                ResultSet rs = con.consulta("select COUNT(id) as CantidadClaves,nom_abasto, fecha from reporte_abasto GROUP BY nom_abasto");
                                while (rs.next()) {
                        %>
                        <tr id="f">
                            <td><%=rs.getString(1)%></td>
                            <td><%=rs.getString(2)%></td>
                            <td><%=rs.getString(3)%></td>
                            <td>
                                <a class="btn btn-info btn-sm" id="Detalles" onclick="DetalleAb('<%=rs.getString(2)%>')" data-toggle="modal" data-target="#DetalleAb"><span class="glyphicon glyphicon-eye-open"></span></a>
                                <button class="btn btn-sm btn-success" title="Exportar a Excel" type="button" onclick="window.open('reporteAbastoExcel.jsp?nom=<%=rs.getString(2)%>&fecha=<%=rs.getString(3)%>', '_blank');"><span class="glyphicon glyphicon-export"></span></button>
                            </td>
                        </tr>
                        <%
                                }
                                con.cierraConexion();
                            } catch (Exception ex) {
                                System.out.println("ErrorC->" + ex);
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

        <br>
        <br>
        <div class="row">
            <div class="col-md-12 text-center">
                <img src="../imagenes/medalfaLogo.png" width=100 alt="Logo">
            </div>
        </div>

        <div id="DetalleAb" class="modal fade in" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <a data-dismiss="modal" class="close">×</a>
                        <h3 id="dta">Detalle Abasto-<%=sesion.getAttribute("nom_abasto")%></h3>
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
                                        <th class="hidden">Codigo Barras</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        try {
                                            con.conectar();
                                            ResultSet rs = con.consulta("SELECT ra.clave, ra.lote, ra.caducidad, ra.cantidad, ra.origen, ra.cb FROM reporte_abasto AS ra where nom_abasto='" + sesion.getAttribute("nom_abasto") + "'");
                                            while (rs.next()) {

                                    %>
                                    <tr>
                                        <td><%= rs.getString(1)%></td>
                                        <td><%= rs.getString(2)%></td>
                                        <td><%= rs.getString(3)%></td>
                                        <td><%= rs.getString(4)%></td>
                                        <td><%= rs.getString(5)%></td>
                                        <td class="hidden"><%= rs.getString(6)%></td>
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
        <!-- 
================================================== -->
        <!-- Se coloca al final del documento para que cargue mas rapido -->
        <!-- Se debe de seguir ese orden al momento de llamar los JS -->
        <script src="../js/jquery-1.9.1.js"></script>
        <script src="../js/bootstrap.js"></script>
        <script src="../js/jquery-ui.js"></script>
        <script src="../js/md5.js"></script>
        <script src="../js/jquery.dataTables.js"></script>
        <script src="../js/dataTables.bootstrap.js"></script>
        <script src="../js/jquery.progressTimer.js"></script>
        <script type="text/javascript">
                                $(document).ready(function () {
                                    $('#tbAbastos').dataTable();
                                });
                                function DetalleAb(nom) {
                                    var dir = "../EditaAbasto";
                                    $.ajax({
                                        url: dir,
                                        data: {que: "R", nom: nom},
                                        success: function (data) {
                                            $('#tbDetalleAba').load('reporteAbasto.jsp #tbDetalleAba');
                                            $('#dta').load('reporteAbasto.jsp #dta');
                                        },
                                        error: function () {
                                            alert("Ocurrió un error");
                                        }
                                    });
                                }
        </script>
        <br/>
    </body>
</html>


