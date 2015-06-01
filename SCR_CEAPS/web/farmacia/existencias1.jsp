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
    String id_usu = "", cla_uni = "";
    try {
        id_usu = (String) session.getAttribute("id_usu");
    } catch (Exception e) {
    }

    if (id_usu == null) {
        response.sendRedirect("index.jsp");
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
        <title>Inventario</title>
    </head>
    <body>



        <div class="container-fluid">
            <div class="container">
                <h3>Existencias</h3>
                <div class="row">
                    <div class="col-lg-12 form-horizontal">
                        <h4><strong>Total de Piezas:
                                <%
                                    try {
                                        con.conectar();
                                        ResultSet rset = con.consulta("select sum(cant) from existencias where cad_pro between '" + fecha1 + "' and '" + fecha2 + "' and cla_uni = '" + cla_uni + "' ");
                                        while (rset.next()) {
                                            out.println(formatNumber.format(rset.getInt(1)));
                                        }
                                    } catch (Exception e) {
                                        out.println(e.getMessage());
                                    }
                                %>
                                piezas</strong>
                        </h4>
                    </div>
                </div>
                <br />
                <div class="row">
                    <form action="existencias1.jsp" method="post">
                        <label class="col-lg-2 control-label">Próximos a Caducar en Meses</label>

                        <div class="col-lg-1">
                            <input class="form-control" name="meses" id="meses" value="<%=meses%>" />
                        </div>
                        <div class="col-lg-1">
                            <button class="btn btn-primary" type="submit">Consultar</button>
                        </div>
                        <div class="col-lg-1">
                            <a class="btn btn-warning" href="existencias1.jsp" >Actualizar</a>
                        </div>
                    </form>
                </div>
                <br/>
                <table class="table table-bordered table-condensed table-responsive table-striped" id="existencias">
                    <thead>
                        <tr>
                            <td>Clave</td>
                            <!--td>CB</td-->
                            <td>Descripción</td>
                            <!--td>Lote</td>
                            <td>Caducidad</td>
                            <td>Origen</td-->
                            <td>Cantidad</td>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                con.conectar();
                                String clave = "", descrip = "", lote = "", caducidad = "", origen = "", cantidad = "0";

                                ResultSet rset = con.consulta("select * from existencias where cad_pro between '" + fecha1 + "' and '" + fecha2 + "' and cant!=0 and f_status='A' and cla_uni = '" + cla_uni + "' group by cla_pro");
                                while (rset.next()) {
                                    String caducado = "";
                                    clave = rset.getString(1);
                                    descrip = rset.getString(3);
                                    lote = rset.getString(4);
                                    caducidad = rset.getString(5);
                                    origen = rset.getString(6);
                                    cantidad = rset.getString(7);
                                    //caducidad = df3.format(df2.parse(caducidad));

                                    if (rset.getDate(5).before(new Date())) {
                                        caducado = "class='danger'";
                                    }
                                    caducidad = df3.format(df2.parse(caducidad));
                        %>
                        <tr <%=caducado%>>
                            <td><%=clave%></td>
                            <!--td></td-->
                            <td><%=descrip%></td>
                            <!--td><%=lote%></td>
                            <td><%=caducidad%></td>
                            <td><%=origen%></td-->
                            <td><%=cantidad%></td>
                        </tr>
                        <%

                                }
                                con.cierraConexion();
                            } catch (Exception e) {
                                System.out.println(e);
                            }
                        %>
                    </tbody>
                </table><br/>
                <label class="text-center h3">Claves en Cero</label><br/>
                <table class="table table-bordered table-condensed table-responsive table-striped" id="existenciasCero">
                    <thead>
                        <tr>
                            <td>Clave</td>
                            <!--td>CB</td-->
                            <td>Descripción</td>
                            <td>Cantidad</td>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                con.conectar();
                                String clave = "", descrip = "", lote = "", caducidad = "", origen = "", cantidad = "0";

                                ResultSet rset = con.consulta("select cla_pro,des_pro from productos where cla_pro not in (select dp.cla_pro from detalle_productos dp, inventario i where dp.det_pro=i.det_pro and i.cant!=0 and cla_uni = '" + cla_uni + "' GROUP BY cla_pro)");
                                while (rset.next()) {
                                    clave = rset.getString(1);
                                    descrip = rset.getString(2);

                        %>
                        <tr>

                            <td><%=clave%></td>
                            <!--td></td-->
                            <td><%=descrip%></td>
                            <td>0</td>
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
                $('#existenciasCero').dataTable();
            });
        </script>
    </body>
</html>

