<%-- 
    Document   : folio
    Created on : 13/04/2015, 08:34:38 AM
    Author     : Americo
--%>
<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%    HttpSession sesion = request.getSession();
    ConectionDB con = new ConectionDB();
    String uni="";
    try {
        con.conectar();
        
        ResultSet rs=con.consulta("SELECT uni.des_uni FROM unidades AS uni INNER JOIN usuarios AS u ON u.cla_uni = uni.cla_uni WHERE u.id_usu = '"+sesion.getAttribute("id_usu")+"'");
        if(rs.next()){
            uni=rs.getString(1);
        }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Bootstrap -->
        <link href="../../css/bootstrap.css" rel="stylesheet" media="screen">
        <link href="../../css/pie-pagina.css" rel="stylesheet" media="screen">
        <link href="../../css/topPadding.css" rel="stylesheet">
        <link href="../../css/datepicker3.css" rel="stylesheet">
        <link href="../../css/dataTables.bootStrap.css" rel="stylesheet">
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <title>SCR</title>
    </head>
    <body>

        <%@include file="../../jspf/mainMenu.jspf" %> 
        <div class="container-fluid">
            <div class="container">
                <h1>Administración del Sistema</h1>
                <h3>Folio de Recetas Colectivas</h3>
                <form action="../../administrarSistema">
                    <div class="row">
                        <h4 class="col-sm-2">Folio Actual:</h4>
                        <div class="col-sm-2">
                            <%                                String folioRec = "";
                                ResultSet rset = con.consulta("select id_rec from indices ");
                                while (rset.next()) {
                                    folioRec = rset.getString("id_rec");
                                }
                            %>
                            <input class="form-control" readonly value="<%=folioRec%>" />
                        </div>
                        <h4 class="col-sm-2">Nuevo Folio:</h4>
                        <div class="col-sm-2">
                            <input class="form-control" type="number" required min="1" name="id_rec" />
                        </div>
                    </div>
                    <button class="btn btn-block btn-primary" name="accion" value="actualizarFolio" onclick="return confirm('Seguro que desea actualizar el Folio?')">Actualizar Folio</button>
                </form>
                <h3>Unidad Perteneciente</h3>
                <form action="../../administrarSistema">
                    <div class="row">
                        <h4 class="col-sm-2">Unidad:</h4>
                        <div class="col-sm-3"><input class="form-control" id="unidad" value="<%=uni%>" disabled type="text"></div>
                        <div class="col-sm-3">
                            <select class="form-control" name="uni" id="uni">
                                <%
                                    ResultSet rset2 = con.consulta("select cla_uni,des_uni from unidades");
                                    while (rset2.next()) {
                                        out.print("<option value='" + rset2.getString(1) + "'>" + rset2.getString(2) + "</option>");
                                    }
                                %>
                            </select>
                        </div>
                        <div class="col-sm-2">
                            <button name="accion" value="uni" class="btn btn-success" title="Guardar Institución"><span class="glyphicon glyphicon-floppy-disk"></span></button>
                        </div>
                    </div>
                </form>
                <h3>Reiniciar Sistema</h3>
                <form action="../../administrarSistema">
                    <button class="btn btn-block btn-default" name="accion" value="reiniciarRecetas" onclick="return confirm('Seguro que desea reiniciar las recetas?')">Recetas</button>
                    <button class="btn btn-block btn-default" name="accion" value="reiniciarExistenciasYRecetas" onclick="return confirm('Seguro que desea reiniciar Existencias y Recetas?')">Existencias y Recetas</button>
                </form>
            </div>
        </div>
        <!-- 
================================================== -->
        <!-- Se coloca al final del documento para que cargue mas rapido -->
        <!-- Se debe de seguir ese orden al momento de llamar los JS -->
        <script src="../../js/jquery-1.9.1.js"></script>
        <script src="../../js/bootstrap.js"></script>
        <script src="../../js/jquery-ui-1.10.3.custom.js"></script>
        <script src="../../js/bootstrap-datepicker.js"></script>
        <script src="../../js/jquery.dataTables.js"></script>
        <script src="../../js/dataTables.bootstrap.js"></script>
        <script type="text/javascript">
            $(document).ready(function(){
                $('#uni').change(function(){
                   // $('#unidad').val($('#uni').val());
                });
            });
        </script>
    </body>
</html>
<%
        con.cierraConexion();
    } catch (Exception e) {
        out.println(e.getMessage());
    }
%>