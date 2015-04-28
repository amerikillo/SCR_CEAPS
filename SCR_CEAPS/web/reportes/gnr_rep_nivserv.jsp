
<%@page import="java.util.Date"%>
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
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment;filename=\"Reporte de Nivel de Servicio.xls\"");
    DecimalFormat formatter = new DecimalFormat("#,###,###");
    DecimalFormat formatter2 = new DecimalFormat("#,###,###.##");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    ConectionDB con = new ConectionDB();
    HttpSession sesion = request.getSession();
    String id_usu = "";
    String uni_ate = "", cedula = "", medico = "";
    try {
        id_usu = (String) session.getAttribute("id_usu");
        uni_ate = (String) session.getAttribute("cla_uni");
        cedula = (String) session.getAttribute("cedula");
        medico = (String) session.getAttribute("id_usu");

        con.conectar();
        try {
            ResultSet rset = con.consulta("select us.nombre, un.des_uni from usuarios us, unidades un where us.cla_uni = un.cla_uni and us.id_usu = '" + id_usu + "' ");
            while (rset.next()) {
                medico = rset.getString(1);
                uni_ate = rset.getString(2);
            }
        } catch (Exception e) {
            e.getMessage();
        }
        con.cierraConexion();
    } catch (Exception e) {
    }
    try {
        if (id_usu == null) {
            //response.sendRedirect("../index.jsp");
        }
    } catch (Exception e) {
    }
//declaracion de variables-------------------------------------------------------------------------------------------------------------------
    String cant_sol = "0", cant_sur = "0", fecha = "";
    String cant_sol_col = "0", cant_sur_col = "0";
    int sol = 0, sur = 0, dif = 0, sol_col = 0, total_sol = 0;
//-------------------------------------------------------------------------------------------------------------------------------------------

    String fecha1 = "2015-01-01", fecha2 = "2016-01-01", but = "";
    Date fechaAct = new Date();
    Calendar calendar = Calendar.getInstance();
    calendar.setTime(fechaAct); // Configuramos la fecha que se recibe
    calendar.add(Calendar.DAY_OF_YEAR, -7);  // numero de días a añadir, o restar en caso de días<0

    fecha2 = df.format(new Date());
    fecha1 = df.format(calendar.getTime());

    try {
        but = "" + request.getParameter("submit");
    } catch (Exception e) {
        System.out.print("not");
    }

    //out.print(but);
    if (but.equals("Por Fechas")) {
        String t1_jv = request.getParameter("f1");
        String t2_jv = request.getParameter("f2");
        //out.print(t2_jv);
        fecha1 = t1_jv;
        fecha2 = t2_jv;

    }
    con.conectar();
%>

<h2>Nivel de Servicio de Farmacias</h2><br />
<h3>Del : <%=fecha1%>
    al <%=fecha2%></h3>

<table class="table table-condensed table-striped table-bordered">
    <tr>
        <td>
            <table  class="table table-condensed table-striped table-bordered">
                <tr>
                    <td>Fecha</td>
                </tr>
                <tr>
                    <td>Pzs Solicitadas</td>
                </tr>
                <tr>
                    <td>Pzs no Surtidas</td>
                </tr>
                <tr>
                    <td>Claves Solicitadas</td>
                </tr>
                <tr>
                    <td>Claves no Surtidas</td>
                </tr>
                <tr>
                    <td>Recetas Solicitadas</td>
                </tr>
                <tr>
                    <td>Rec 100 / Rec Parciales</td>
                </tr>
                <tr>
                    <td>Porcentaje</td>
                </tr>
                <tr>
                    <td>Pzs Vendidas</td>
                </tr>
                <tr>
                    <td>Importe Venta</td>
                </tr>
            </table>

        </td>

        <td>
            <table class="table table-condensed table-striped table-bordered">
                <%
                    try {
                %>
                <tr>
                    <%
                        String qry_fecha = "select fec_sur from detreceta where fec_sur BETWEEN '" + fecha1 + "' AND '" + fecha2 + "' group by fec_sur";
                        ResultSet rset = con.consulta(qry_fecha);
                        while (rset.next()) {
                            fecha = df2.format(df.parse(rset.getString("fec_sur")));
                    %>
                    <td style="width:auto"><%=fecha%></td>
                    <%
                        }
                    %>
                    <td><strong>Totales</strong></td>
                </tr>
                <%
                    String qry_pzsol = "select sum(can_sol) as sol, r.fecha_hora from receta r, detreceta dr where r.id_rec = dr.id_rec AND r.fecha_hora BETWEEN '" + fecha1 + " 00:00:01' and '" + fecha2 + " 23:59:59' group by DAY(fecha_hora) ;";
        //String qry_pzsol="select sum(can_sol) as sol, fec_sur from detreceta where fec_sur BETWEEN '"+fecha1+"' AND '"+fecha2+"' group by fec_sur";
                %>
                <tr>
                    <%
                        int total_pzs_sol = 0;
                        rset = con.consulta(qry_pzsol);
                        while (rset.next()) {
                            cant_sol = rset.getString("sol");
                            fecha = rset.getString("fecha_hora");
                            sol = Integer.parseInt(cant_sol);
                            total_sol = sol;
                            total_pzs_sol += total_sol;
                    %>
                    <td style="text-align: right"><%=total_sol%></td>
                    <%
                        }
                    %>
                    <td style="text-align: right"><strong><%=total_pzs_sol%></strong></td>
                </tr>
                <%
                    } catch (Exception e) {
                        out.println(e.getMessage());
                    }
                %>

                <%
                    try {
                %>
                <%
                    String qry_pzsur = "select sum(can_sol) as sol, sum(cant_sur) as sur, r.fecha_hora from receta r, detreceta dr where r.id_rec = dr.id_rec AND r.fecha_hora BETWEEN '" + fecha1 + " 00:00:01' and '" + fecha2 + " 23:59:59' group by DAY(r.fecha_hora) ;";
                %>
                <tr>
                    <%
                        int total_pzs_no_sur = 0;
                        ResultSet rset = con.consulta(qry_pzsur);
                        while (rset.next()) {
                            cant_sol = rset.getString("sol");
                            cant_sur = rset.getString("sur");
                            fecha = rset.getString("fecha_hora");
                            sol = Integer.parseInt(cant_sol);
                            sur = Integer.parseInt(cant_sur);
                            dif = sol - sur;

                            total_sol = dif;

                    %>
                    <td style="text-align: right"><%=total_sol%></td>
                    <%
                            total_pzs_no_sur += total_sol;
                        }
                    %>
                    <td style="text-align: right"><strong><%=total_pzs_no_sur%></strong></td>
                </tr>
                <%
                    } catch (Exception e) {
                        out.println(e.getMessage());
                    }
                %>


                <%
                    try {
                %>
                <tr>
                    <%
                        int tot_clavez_sol = 0, total_cla_sol_c = 0;
                        String qry_cant_pzs = "select fec_sur from detreceta where fec_sur BETWEEN '" + fecha1 + "' AND '" + fecha2 + "' group by fec_sur";
                        ResultSet rset = con.consulta(qry_cant_pzs);
                        while (rset.next()) {
                            fecha = rset.getString("fec_sur");
                            int cont = 0, cont2 = 0;
                            String qry_clasur = "select dp.cla_pro from receta r, detreceta dr, detalle_productos dp where r.id_rec = dr.id_rec  AND dr.det_pro = dp.det_pro and r.fecha_hora BETWEEN '" + fecha + " 00:00:01' and '" + fecha + " 23:59:59' group by DAY(r.fecha_hora), dp.cla_pro ;";
                            ResultSet rset2 = con.consulta(qry_clasur);
                            while (rset2.next()) {
                                cont++;
                            }
                    %>
                    <td style="text-align: right">
                        <%=cont + cont2%>
                    </td>
                    <%
                        }

                        String qry_cant_pzsf = "select dp.cla_pro from receta r, detreceta dr, detalle_productos dp where r.id_rec = dr.id_rec and dr.det_pro = dp.det_pro and r.fecha_hora BETWEEN '" + fecha1 + " 00:00:01' and '" + fecha2 + " 23:59:59' group by dp.cla_pro ;";
                        rset = con.consulta(qry_cant_pzsf);
                        while (rset.next()) {
                            tot_clavez_sol++;
                        }

                        int total_cla_soli = tot_clavez_sol;
                    %>

                    <td style="text-align: right"><strong><%=total_cla_soli%></strong></td>
                </tr>
                <%
                    } catch (Exception e) {
                        out.println(e.getMessage());
                    }
                %>

                <%
                    try {
                %>
                <tr>
                    <%
                        int total_cla_no_sur = 0, cont_nosur = 0, cont4 = 0;
                        String qry_cant_pzs1 = "select fec_sur from detreceta where fec_sur BETWEEN '" + fecha1 + "' AND '" + fecha2 + "' group by fec_sur";
                        ResultSet rset = con.consulta(qry_cant_pzs1);
                        while (rset.next()) {
                            fecha = rset.getString("fec_sur");
                            int cont = 0, cont2 = 0, tot = 0, cont3 = 0, cont5 = 0;
                            String qry_clasur = "select dp.cla_pro from receta r, detreceta dr,  detalle_productos dp where dr.status=0 and r.id_rec = dr.id_rec and dr.det_pro = dp.det_pro and r.fecha_hora BETWEEN '" + fecha + " 00:00:01' and '" + fecha + " 23:59:59' group by DAY(r.fecha_hora), dp.cla_pro ;";
                            ResultSet rset2 = con.consulta(qry_clasur);
                            while (rset2.next()) {
                                cont++;
                            }

                            tot = (cont + cont5);
                    %>
                    <td style="text-align: right">
                        <%=tot%>

                    </td>
                    <%
                            //total_cla_no_sur += tot;
                            //cont_nosur++;
                        }
                        int tot_clavez_nsol1 = 0, total_cla_nsol_c = 0;
                        String qry_cant_pzsnf = "select dp.cla_pro from receta r, detreceta dr, detalle_productos dp where dr.status=0 and r.id_rec = dr.id_rec AND dr.det_pro = dp.det_pro and r.fecha_hora BETWEEN '" + fecha1 + " 00:00:01' and '" + fecha2 + " 23:59:59' group by dp.cla_pro ;";
                        rset = con.consulta(qry_cant_pzsnf);
                        while (rset.next()) {
                            tot_clavez_nsol1++;
                        }

                        int total_cla_nos = tot_clavez_nsol1 + total_cla_nsol_c;
                    %>
                    <td style="text-align: right"><strong><%=total_cla_nos%></strong></td>
                </tr>
                <%
                    } catch (Exception e) {
                        out.println(e.getMessage());
                    }
                %>




                <%
                    try {
                %>
                <%
                    String qry_tot_rece = "select fec_sur from detreceta  where fec_sur BETWEEN '" + fecha1 + "' AND '" + fecha2 + "' group by fec_sur";
                %>
                <tr>
                    <%
                        int tot_rec_sol = 0;
                        ResultSet rset = con.consulta(qry_tot_rece);
                        while (rset.next()) {
                            fecha = rset.getString("fec_sur");
                            int tot_folios = 0;
                            String qry_pzsur_col = "select r.id_rec from receta r where r.fecha_hora between '" + fecha + " 00:00:01' and '" + fecha + " 23:59:59' and r.baja = '0' group by id_rec";
                            ResultSet rset2 = con.consulta(qry_pzsur_col);
                            while (rset2.next()) {
                                tot_folios++;
                            }
                    %>
                    <td style="text-align: right"><%=tot_folios%></td>
                    <%
                            tot_rec_sol += tot_folios;
                        }
                    %>

                    <td style="text-align: right"><strong><%=tot_rec_sol%></strong></td>
                </tr>
                <%
                    } catch (Exception e) {
                        out.println(e.getMessage());
                    }
                %>


                <%
                    try {
                %>
                <%
                    String qry_sur = "select fec_sur from detreceta  where fec_sur BETWEEN '" + fecha1 + "' AND '" + fecha2 + "' group by fec_sur";
                %>
                <tr>
                    <%
                        int tot_rec_100 = 0, tot_rec_par = 0;
                        ResultSet rset = con.consulta(qry_sur);
                        while (rset.next()) {
                            int r_rf = 0, r_no = 0, r_parcial = 0;
                            fecha = rset.getString("fec_sur");

                            String qry_surno = "select r.id_rec from receta r where r.fecha_hora between '" + fecha + " 00:00:01' and '" + fecha + " 23:59:59' and r.baja = '0'  group by id_rec";
                            ResultSet rset2 = con.consulta(qry_surno);
                            while (rset2.next()) {
                                r_rf++;
                            }

                            qry_surno = "select r.id_rec from receta r, detreceta dr where r.id_rec = dr.id_rec and dr.status='0' and r.baja='0'  and r.fecha_hora between '" + fecha + " 00:00:01' and '" + fecha + " 23:59:59'  group by id_rec";
                            rset2 = con.consulta(qry_surno);
                            while (rset2.next()) {
                                r_no++;
                            }

                            r_parcial = r_rf - r_no;
                    %>
                    <td style="text-align: right"><%=r_parcial%> / <%=r_no%></td>
                    <%
                            tot_rec_100 += r_parcial;
                            tot_rec_par += r_no;
                        }
                    %>
                    <td style="text-align: right"><strong><%=(tot_rec_100)%>/<%=tot_rec_par%></strong></td>
                </tr>
                <%
                    } catch (Exception e) {
                        out.println(e.getMessage());
                    }
                %>



                <%
                    try {
                %>
                <%
                    String qry_por = "select sum(can_sol) as sol, sum(cant_sur) as sur, r.fecha_hora from receta r, detreceta dr where r.id_rec = dr.id_rec AND r.fecha_hora BETWEEN '" + fecha1 + " 00:00:01' and '" + fecha2 + " 23:59:59' group by DAY(fecha_hora) ;";
                %>
                <tr>
                    <%
                        int c_dias = 0;
                        float total_por = 0;
                        ResultSet rset = con.consulta(qry_por);
                        while (rset.next()) {
                            cant_sol = rset.getString("sol");
                            cant_sur = rset.getString("sur");
                            fecha = rset.getString("fecha_hora");

                            if (cant_sol_col == null) {
                                cant_sol_col = "0";
                            }

                            if (cant_sur_col == null) {
                                cant_sur_col = "0";
                            }

                            float sol_d = Integer.parseInt(cant_sol);
                            float sur_d = Integer.parseInt(cant_sur);
                            float sol_d_col = Integer.parseInt(cant_sol_col);
                            float sur_d_col = Integer.parseInt(cant_sur_col);

                            float tot_f = ((sur_d + sur_d_col) * 100) / (sol_d + sol_d_col);

                    %>
                    <td style="text-align: right"><%=tot_f%> %</td>
                    <%
                            c_dias++;
                            total_por += tot_f;
                        }
                        float tot_porc = 0;
                        if (c_dias == 0) {
                            tot_porc = 0;
                        } else {
                            tot_porc = (total_por / c_dias);
                        }

                    %>
                    <td style="text-align: right"><strong><%=tot_porc%> %</strong></td>
                </tr>
                <%
                    } catch (Exception e) {
                        out.println(e.getMessage());
                    }
                %>


                <%
                    try {
                %>
                <tr>
                    <%
                        int tot_pzs_sol = 0;
                        String qry_fecha1 = "select sum(cant_sur) as sur, r.fecha_hora from receta r, detreceta dr where r.id_rec = dr.id_rec  AND r.fecha_hora BETWEEN '" + fecha1 + " 00:00:01' and '" + fecha2 + " 23:59:59' group by DAY(r.fecha_hora) ;";
                        ResultSet rset = con.consulta(qry_fecha1);
                        while (rset.next()) {
                            cant_sol = rset.getString("sur");
                            fecha = rset.getString("fecha_hora");

                            if (cant_sol_col == null) {
                                cant_sol_col = "0";
                            }
                            sol = Integer.parseInt(cant_sol);
                            sol_col = Integer.parseInt(cant_sol_col);
                            total_sol = sol + sol_col;
                    %>
                    <td style="text-align: right"><%=total_sol%></td>
                    <%
                            tot_pzs_sol += total_sol;
                        }
                    %>
                    <td style="text-align: right"><strong><%=tot_pzs_sol%></strong></td>
                </tr>
                <%
                    } catch (Exception e) {
                        out.println(e.getMessage());
                    }
                %>



                <%
                    try {
                %>
                <tr>
                    <%
                        float tot_ventas = 0;
                        String qry_fecha2 = "SELECT p.cos_pro, dr.cant_sur, sum(p.cos_pro * dr.cant_sur) as sum FROM detreceta dr, detalle_productos dp, productos p, receta r where dr.id_rec = r.id_rec and dr.det_pro = dp.det_pro AND dp.cla_pro = p.cla_pro and r.fecha_hora between '" + fecha1 + " 00:00:01' and '" + fecha2 + " 23:59:59' group by DAY(r.fecha_hora) asc;";
                        ResultSet rset = con.consulta(qry_fecha2);
                        while (rset.next()) {
                            float precio = Float.parseFloat(rset.getString("sum"));
                    %>
                    <td style="text-align: right">$ <%=formatter2.format(precio)%></td>
                    <%
                            tot_ventas += precio;
                        }
                    %>
                    <td style="text-align: right"><strong>$ <%=formatter2.format(tot_ventas)%></strong></td>
                </tr>
                <%
                    } catch (Exception e) {
                        out.println(e.getMessage());
                    }
                %>

            </table>
        </td>
    </tr>
</table>
<%
    con.cierraConexion();
%>