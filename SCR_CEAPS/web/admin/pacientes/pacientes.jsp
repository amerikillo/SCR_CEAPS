<%-- 
    Document   : alta_pacientes
    Created on : 10-mar-2014, 9:14:09
    Author     : Americo
--%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyyMMddhhmmss"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
<%
    /**
     * Listado de pacientes
     */
    HttpSession sesion = request.getSession();
    DecimalFormat formatter = new DecimalFormat("#,###,###");
    DecimalFormat formatter2 = new DecimalFormat("#,###,###.##");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    ResultSet rset;
    ConectionDB con = new ConectionDB();

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
        <link href="../../css/cupertino/jquery-ui-1.10.3.custom.css" rel="stylesheet">
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <title>Pacientes</title>
    </head>
    <body>
        <%@include file="../../jspf/mainMenu.jspf"%>
        <br/>
        <div class="container">
            <div class="container">
                <div class="row">
                    <div class="col-lg-10">

                        <div class="row">
                            <div class="col-md-5"><h2>Pacientes Registrados</h2></div>
                            <div class="col-md-1"></div>
                            <div class="col-md-3"><img src="../../imagenes/medalfaLogo.png" width=100 alt="Logo"></div>
                            <div class="col-md-3"><img src="../../imagenes/savi1.jpg" width=100 alt="Logo"></div>
                        </div>
                    </div>
                    <div class="col-lg-2">
                        <!--a class="btn btn-block btn-danger" href="../receta/receta_farmacia.jsp">Regresar</a-->
                    </div>
                </div>
                <br />
                <form action="pacientes.jsp" method="post">
                    <div class="row">
                        <h4 class="col-sm-3">Buscar un Paciente</h4>
                        <div class="col-sm-6">
                            <input class="form-control" name="nombre_jq" id="nombre_jq"/>
                        </div>
                        <div class="col-sm-1">
                            <button class="btn btn-primary btn-block" type="submit" name="accion" value="buscarPaciente">Buscar</button>
                        </div>
                        <div class="col-sm-2">
                            <a class="btn btn-block btn-success" href="alta_pacientes.jsp">Alta Paciente</a>
                        </div>
                    </div>
                </form>
                <%                    if (request.getParameter("accion") != null) {
                        if (request.getParameter("accion").equals("buscarPaciente")) {
                %>
                <div class="panel panel-default">
                    <form class="form-horizontal" role="form" name="formulario_pacientes" id="formulario_pacientes" method="post" action="">
                        <div class="panel-body">
                            <div class="col-lg-3">
                            </div>                            
                            <br />

                            <table class="table table-striped table-bordered" id="datosPacientes">
                                <thead>
                                    <tr>
                                        <td>ID Paciente</td>
                                        <td class="col-sm-2">Nombre Completo</td>                                                                           
                                        <td>No. Afiliación</td>
                                        <td>No. Expediente</td> 
                                        <td>Estado</td>
                                        <td>Tipo Cob.</td>
                                        <!--<td>Vigencia</td>-->
                                        <td></td>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%                                        try {
                                            byte[] a = request.getParameter("nombre_jq").getBytes("ISO-8859-1");
                                            String nombre_jq = new String(a, "UTF-8");
                                            con.conectar();
                                            //rset=null;
                                            rset = con.consulta("SELECT p.id_pac, p.nom_com, p.num_afi, p.expediente, p.f_status, p.tip_cob, CONCAT(p.ini_vig,' al ',p.fin_vig) AS Vigencia, fin_vig FROM pacientes  AS p  where p.nom_com like '%" + nombre_jq + "%'");

                                            while (rset.next()) {
                                                Date fecAfi = rset.getDate("fin_vig");
                                    %>
                                    <tr
                                        class="
                                        <%
                                            if ((new Date()).after(fecAfi)) {
                                                out.println("danger");
                                            }
                                        %>
                                        "
                                        >
                                        <td><%=rset.getString(1)%></td>
                                        <td class="col-sm-2"><%=rset.getString(2)%></td>
                                        <td><%=rset.getString(3)%></td>
                                        <td><%=rset.getString(4)%></td>
                                        <td><%=rset.getString(5)%></td>
                                        <td><%=rset.getString(6)%></td>
                                        <!--<td><%=rset.getString(7)%></td>-->
                                        <td>
                                            <a class="btn btn-sm btn-warning" href="editar_paciente.jsp?id=<%=rset.getString(1)%>"><span class='glyphicon glyphicon-pencil' ></span></a>
                                            <a class="btn btn-sm btn-danger" href="elimina_paciente.jsp?id=<%=rset.getString(1)%>"><span class='glyphicon glyphicon-remove' ></span></a>
                                        </td>                                                                      
                                    </tr>
                                    <%
                                            }
                                            con.cierraConexion();
                                        } catch (Exception e) {
                                            System.out.println(e.getMessage());
                                        }
                                    %>
                                </tbody>
                            </table>

                        </div>
                    </form>

                </div>
                <%
                        }
                    }
                %>
            </div>
        </div>
        <script src="../../js/jquery-1.9.1.js"></script>
        <script src="../../js/bootstrap.js"></script>
        <script src="../../js/jquery-ui.js"></script>
        <script src="../../js/bootstrap-datepicker.js"></script>
        <script src="../../js/moment.js"></script>
        <script src="../../js/jquery.dataTables.js"></script>
        <script src="../../js/dataTables.bootstrap.js"></script>
        <script>
            $(document).ready(function() {
                $('#datosPacientes').dataTable();
            });

            $(function() {
                $("#nombre_jq").keyup(function() {
                    var nombre = $("#nombre_jq").val();
                    $("#nombre_jq").autocomplete({
                        source: "../../AutoPacientes?nombre=" + nombre,
                        minLength: 2,
                        select: function(event, ui) {
                            $("#nombre_jq").val(ui.item.nom_com);
                            return false;
                        }
                    }).data("ui-autocomplete")._renderItem = function(ul, item) {
                        return $("<li>")
                                .data("ui-autocomplete-item", item)
                                .append("<a>" + item.nom_com + "</a>")
                                .appendTo(ul);
                    };
                });
            });
        </script>
    </body>
</html>
<!-- 
================================================== -->
<!-- Se coloca al final del documento para que cargue mas rapido -->
<!-- Se debe de seguir ese orden al momento de llamar los JS -->
