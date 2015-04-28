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
    try {
        id_usu = (String) session.getAttribute("id_usu");
    } catch (Exception e) {
    }

    if (id_usu == null) {
        response.sendRedirect("index.jsp");
    }

    String fecha1 = df2.format(new Date());
    String fecha2 = "2030-01-01";
    int meses=0;
    try {
        meses = Integer.parseInt(request.getParameter("meses"));
        if (meses==0){
            meses=500;
        }
        Calendar c1 = GregorianCalendar.getInstance();
        c1.add(Calendar.MONTH,meses);

        fecha2 = df2.format(c1.getTime());
        if (meses==500){
            meses=0;
        }
        
    } catch (Exception e) {
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Bootstrap -->
        <link href="../css/bootstrap.css" rel="stylesheet" media="screen">
        <link href="../css/topPadding.css" rel="stylesheet">
        <link href="../css/dataTables.bootStrap.css" rel="stylesheet">
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <title>Sistema de Captura de Receta</title>
    </head>
    <body>
        
        <%@include file="../jspf/mainMenu.jspf"%>

        <div class="container-fluid">
            <div class="container">
                <h3>Catálogo Medicamento</h3>                
                <br />
                <div class="row">
                   
                    <!--div class="col-lg-3">
                        <a class="btn btn-primary" href="CatalogoAgregar.jsp" >Agregar Nuevo Insumo<span class='glyphicon glyphicon-book' ></span></a>
                    </div-->
                   
                </div>
                <br/>
                <table class="table table-bordered table-condensed table-responsive table-striped" id="existencias">
                    <thead>
                        <tr>
                            <td>Clave</td>
                            <td>Descripción</td>
                            <td>Tipo Med.</td>
                            <td>Estatus</td>
                            <td></td>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                con.conectar();
                                ResultSet rset = con.consulta("SELECT cla_pro,des_pro,tip_pro,f_status FROM productos");
                                while (rset.next()) {
                        %>
                        <tr>

                            <td><%=rset.getString(1)%></td>
                            <td><%=rset.getString(2)%></td>
                            <td><%=rset.getString(3)%></td>
                            <td><%=rset.getString(4)%></td>                            
                            <td><!--a class="btn btn-warning" href="CatalogoModifica.jsp?clave=<%=rset.getString(1)%>" ><span class='glyphicon glyphicon-pencil' ></span></a>&nbsp;&nbsp;<a class="btn btn-danger" href="CatalogoElimina.jsp?clave=<%=rset.getString(1)%>" ><span class='glyphicon glyphicon-remove' ></span></a--></td>
                        </tr>
                        <%
                                }
                                con.cierraConexion();
                            } catch (Exception e) {

                            }
                        %>
                    </tbody>
                </table>

            </div>
        </div>

    </body>
    <!-- 
    ================================================== -->
    <!-- Se coloca al final del documento para que cargue mas rapido -->
    <!-- Se debe de seguir ese orden al momento de llamar los JS -->
    <script src="../js/jquery-1.9.1.js"></script>
    <script src="../js/bootstrap.js"></script>
    <script src="../js/jquery.dataTables.js"></script>
    <script src="../js/dataTables.bootstrap.js"></script>
    <script src="../js/jquery-ui-1.10.3.custom.js"></script>
    <script>
        $(document).ready(function() {
            $('#existencias').dataTable();
            
        });
    </script>
</html>

