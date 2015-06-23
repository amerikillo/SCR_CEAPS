
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("yyyyMMddhhmmss"); %>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("dd/MM/yyyy");%>
<!DOCTYPE html>
<%
    DecimalFormat formatter = new DecimalFormat("#,###,###");
    DecimalFormat formatter2 = new DecimalFormat("#,###,###.##");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    ConectionDB con = new ConectionDB();
    con.conectar();
    HttpSession sesion = request.getSession();
    //declaracion de variables-------------------------------------------------------------------------------------------------------------------
    String but = "";
    String fecha1 = "", fecha2 = "", mensaje = "";
//-------------------------------------------------------------------------------------------------------------------------------------------

    Calendar calendar = Calendar.getInstance();
//out.println("Fecha Actual: " + calendar.getTime());
    calendar.add(Calendar.MONTH, -1);
//out.println("Fecha antigua: " + df.format(calendar.getTime()));
    String fecha_act = "" + df.format(calendar.getTime());
    String d = "0";
    int dias = 0;

//-----------------Genera Folio------------------------------------
    String folio = "";
    String cve_unidad = "";
    ResultSet rset = con.consulta("select cla_uni from unidades where cla_uni = 1002;");
    while (rset.next()) {
        cve_unidad = rset.getString(1);
    }
    folio = cve_unidad + df2.format(new java.util.Date()) + df3.format(new java.util.Date());

//out.print(folio);
//.................................................................
//---------------Llena la tabla de reabasteciminento---------------------
//-----------------------------------------------------------------------
    try {
        but = "" + request.getParameter("submit");
    } catch (Exception e) {
        System.out.print("not");
    }

    //out.print(but);
    if (but.equals("Calcular Reposicion")) {

        try {
            d = request.getParameter("dia");
        } catch (Exception e) {
            System.out.print("not");
        }
        if (d.equals("")) {
            d = "0";
        }
        //out.print(d);
        dias = Integer.parseInt(d);

    }
    if (but.equals("Generar Abasto")) {
        //response.setContentType("application/vnd.ms-excel");
        //response.setHeader("Content-Disposition", "attachment;filename=\"report.xls\"");
    }

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Estilos CSS -->
        <link href="../css/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" href="../css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="../css/navbar-fixed-top.css" rel="stylesheet">
        <link href="../css/dataTables.bootStrap.css" rel="stylesheet">
        <!---->
        <title>Reporte de Reabastecimiento</title>
    </head>
    <body class="container">
        <%@include file="../jspf/mainMenu.jspf"%>
        <br/><br/><br/>
        <div>
            <table>
                <tr>
                    <td></td>
                    <td>
                        <h1>Reporte de Reabastecimiento</h1>
                    </td>
                    <td></td>
                </tr>
            </table>


        </div>
        <div>
        </div>

        <div>
            <!--Folio: <%=folio%>-->
            <form method="post" style="text-align:center">
                <div class="row">
                    <h4 class="col-sm-4">Días para su próximo abasto:</h4>
                    <div class="col-sm-1">
                        <input type="text" class="form-control" name="dia" id="dia" value="<%=d%>"/> 
                    </div>
                    <div class="col-sm-3">
                        <input type="submit" class="btn btn-primary btn-block" name="submit" value="Calcular Reposicion"/>
                    </div>
                    <div class="col-sm-2">
                        <a href="gnr_reabast.jsp?dias=<%=dias%>&submit=<%=request.getParameter("submit")%>&cla_uni=<%=request.getParameter("cla_uni")%>" class="btn btn-block btn-default" target="_blank">Descargar</a>
                    </div>
                </div>
            </form>

            <table class="table table-condensed table-bordered table-striped" id="tablaReabast">
                <thead>
                    <tr>
                        <td><Strong>Clave</Strong></td>
                        <td><Strong>Descripcion</Strong></td>
                        <td><Strong>Consumo <br/>Mensual</Strong></td>
                        <td><Strong>IFS</Strong></td>
                        <!--td><Strong>Consumo <br/>Semanal</Strong></td-->
                        <td><Strong>Existencia<br/>Actual</Strong></td>
                        <td><Strong>Sobreabasto</Strong></td>
                        <td><Strong>Cant. <br/>Sugerida</Strong></td>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String clave_rf = "", descrip_rf = "";

                        String qry_clave = "select cla_pro, des_pro from productos where f_status='A' order by cla_pro";
                        //out.print(qry_clave);

                        rset = con.consulta(qry_clave);
                        while (rset.next()) {
                            clave_rf = rset.getString("cla_pro");
                            descrip_rf = rset.getString("des_pro");
                            String cant_rf = "0", cant_rc = "0", cant_inv = "0";
                            String qry_rf = "select sum(can_sol) from recetas where DATE(fecha_hora) between '" + fecha_act + "' and DATE(NOW()) and cla_pro='" + clave_rf + "' and baja!=1 group by cla_pro";
                            //out.print(qry_rf+"<br>");
                            ResultSet rset2 = con.consulta(qry_rf);
                            while (rset2.next()) {
                                cant_rf = rset2.getString(1);
                                if (cant_rf.equals("")) {
                                    cant_rf = "0";
                                }

                            }

                            String qry_inv = "select sum(i.cant) from inventario i, detalle_productos dp where i.det_pro = dp.det_pro and dp.cla_pro='" + clave_rf + "' group by dp.cla_pro";
                            rset2 = con.consulta(qry_inv);
                            while (rset2.next()) {
                                cant_inv = rset2.getString(1);
                                if (cant_inv.equals("")) {
                                    cant_inv = "0";
                                }
                            }

                            float cant_total = (Float.parseFloat(cant_rf));

                            if (cant_total > -1) {
                                float con_diario = (cant_total / 30);
                                float cons_dia = con_diario;
                                double dia_abasto2 = Math.ceil(cons_dia * dias);
                                int dia_abasto = (int) (dia_abasto2);
                                float cant_quincenal = (float) (Math.ceil(cant_total / 4));
                                float cant_semana = (float) (Math.ceil(cant_quincenal / 2));
                                float sobre = 0;
                                int exist_fut = (Integer.parseInt(cant_inv)) - dia_abasto;

                                float cant_re = (cant_quincenal) - ((int) (exist_fut));
                                if (cant_re <= 0) {
                                    sobre = (cant_re) * -1;
                                    cant_re = 0;
                                }
                                float x = 3;
                                float y = 30;
                                float min_con = (x / y);
                                //out.print(qry_rf+"<br>");
                                //cant_rf=rset.getString("sum(cant_sol)");
                                //out.print(clave_rf + " " + cant_rf+"<br>");

                                int total_t = (int) (cant_re);

                                if (exist_fut <= 0) {
                                    total_t = (int) cant_quincenal;
                                }
                                if (exist_fut > (int) (cant_quincenal)) {//Sobreabasto
                                    total_t = 0;
                                }
                                if (con_diario <= min_con) {
                                    total_t = 1;
                                }
                    %>
                    <tr <%                    /*if (cant_total == 0) {
                         out.print("style='visibility:hidden'");
                         }*/
                        %>>

                        <td><%=clave_rf%>
                        </td>
                        <td><%=descrip_rf%><%//=(min_con+"***"+con_diario+"***"+(cons_dia*dias)+"***"+dia_abasto2+"***"+exist_fut)%></td>
                        <td><%=(int) cant_total%>
                        </td>
                        <td><%=(int) cant_quincenal%>
                        </td>
                        <!--td><%=(int) cant_semana%>
                        </td-->
                        <td><%=cant_inv%>
                        </td>
                        <td <%
                            if ((int) sobre != 0) {
                                out.print("style='color:#FFF; background-color:#F00;'");
                            }
                            %>><%=(int) sobre%>
                        </td>
                        <td>
                            <strong><%=total_t%>
                            </strong>
                        </td>
                    </tr>
                    <%

                                con_diario = 0;
                                cons_dia = 0;
                                dia_abasto = 0;
                                dia_abasto2 = 0;
                                cant_quincenal = 0;
                                cant_semana = 0;
                                exist_fut = 0;
                                cant_re = 0;
                                sobre = 0;
                                min_con = 0;
                                total_t = 0;

                            }
                        }
                    %>
                </tbody>
            </table>

            <p>&nbsp;</p>
        </div>
        <script src="../js/jquery-1.9.1.js"></script>
        <script src="../js/bootstrap.js"></script>
        <script src="../js/jquery-ui-1.10.3.custom.js"></script>
        <script src="../js/jquery.dataTables.js"></script>
        <script src="../js/dataTables.bootstrap.js"></script>
        <script>
            $(document).ready(function() {
                $('#tablaReabast').dataTable();
            });
        </script>
    </body>
    <%
        con.cierraConexion();
    %>
