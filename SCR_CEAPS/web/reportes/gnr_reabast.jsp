
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
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment;filename=\"Reporte de Reabastecimiento.xls\"");
//declaracion de variables-------------------------------------------------------------------------------------------------------------------
    String but = "";
    String fecha1 = "", fecha2 = "", mensaje = "";
//-------------------------------------------------------------------------------------------------------------------------------------------

    Calendar calendar = Calendar.getInstance();
    Calendar calendar2 = Calendar.getInstance();
//out.println("Fecha Actual: " + calendar.getTime());
    calendar.add(Calendar.MONTH, -1);
//out.println("Fecha antigua: " + df.format(calendar.getTime()));
    String fecha_act = "" + df.format(calendar.getTime());

    String d = "0";
    int dias = 0;

    try {
        but = "" + request.getParameter("submit");
    } catch (Exception e) {
        System.out.print("not");
    }

    //out.print(but);
    try {
        d = request.getParameter("dias");
    } catch (Exception e) {
        System.out.print("not");
    }
    if (d.equals("")) {
        d = "0";
    }
    //out.print(d);
    dias = Integer.parseInt(d);
    calendar2.add(Calendar.DATE, dias);
    String fecha_imp = "" + df.format(calendar2.getTime());
%>
<html>
    <head>
        <title>Reporte de Reabastecimiento</title>
    </head>
    <body>
        <div>
            Reporte de Reabastecimiento</div>
        <form method="post" style="">
            <p>
                <%
                    String qry_unidad = "SELECT des_uni FROM unidades where cla_uni = '" + request.getParameter("cla_uni") + "'";
                    String unidad = "";
                    ResultSet rset = con.consulta(qry_unidad);
                    while (rset.next()) {
                        unidad = rset.getString("des_uni");
                    }
                %>
                Unidad: <%=unidad%>
                <br />D&iacute;as para su pr&oacute;ximo abasto: <%=d%>
                <br />
                Fecha de entrega: <%=fecha_imp%></p>
        </form>
        <table width="780" border="1" style="font-size: 8px;">
            <tr>
                <td width="258"><Strong>Descripcion</Strong></td>
                <td width="53"><Strong>IFS</Strong></td>
                <td width="57"><Strong>Exist.<br/>Inventario</Strong></td>
                <td width="54"><Strong>Sobreabasto</Strong></td>
                <td width="54"><Strong>Recomendado<br /> a Surtir</Strong></td>
                <td width="62"><strong>Clave</strong></td>
                <td width="60"><Strong>Confirmacion / <br /> Autorizacion</Strong></td>
                <td width="130"><Strong>Observaciones</Strong></td>
            </tr>

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

                        if (cant_total != 0) {
                            String qry_inserta = "insert into reabastecimientos () values ()";
                        }
            %>
            <tr <%/*
                 if (cant_total == 0) {
                 out.print("style='visibility:hidden'");
                 }*/
                %>>
                <td style="text-align:left"><%=descrip_rf%></td>
                <td><%=(int) cant_quincenal%>
                </td>
                <td><%=cant_inv%>
                </td>
                <td <%
                    if ((int) sobre != 0) {
                        out.print("style='color:#FFF; background-color:#F00;'");
                    }
                    %>><%=(int) sobre%>
                </td>
                <td><strong><%=total_t%>
                    </strong></td>
                <td><%=clave_rf%></td>
                <td><strong><%=total_t%>
                    </strong></td>
                <td></td>
              <!--td><input type="text" size="3" value="<%=total_t%>"></td>
                <td><input type="text" size="35" value=""></td-->
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
        </table>
        <p>&nbsp;</p>


    </body>
    <%
        con.cierraConexion();
    %>
