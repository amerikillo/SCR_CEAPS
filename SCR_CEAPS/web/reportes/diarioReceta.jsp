
<%@page import="Clases.ConectionDB"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.DecimalFormatSymbols"%>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss"); %>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%

    DecimalFormat formatter = new DecimalFormat("#,###,###");
    DecimalFormat formatterDecimal = new DecimalFormat("#,###,##0.00");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator('.');
    custom.setGroupingSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    formatterDecimal.setDecimalFormatSymbols(custom);
    HttpSession sesion = request.getSession();
//  Conexión a la BDD -------------------------------------------------------------
    ConectionDB conn = new ConectionDB();
    conn.conectar();
    Connection con=conn.getConn();
    Statement stmt = con.createStatement();
    ResultSet rset = null;
    Statement stmt2 = con.createStatement();
    ResultSet rset2 = null;
// fin objetos de conexión ------------------------------------------------------
    
    String id_usu = "";
    String cla_uni = "", des_uni = "";
    try {
        id_usu = (String) session.getAttribute("id_usu");
    } catch (Exception e) {
    }
    try {
        rset = stmt.executeQuery("select un.des_uni, us.cla_uni from usuarios us, unidades un where us.cla_uni = un.cla_uni and id_usu = '" + id_usu + "' ");
        while (rset.next()) {
            cla_uni = rset.getString("cla_uni");
            des_uni = rset.getString("des_uni");

        }
    } catch (Exception e) {

    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <!-- DW6 -->
    <head>

        <!-- Copyright 2005 Macromedia, Inc. All rights reserved. -->
        <title>:: REPORTE DIARIO SALIDA POR FARMACIA ::</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/bootstrap.css" rel="stylesheet" media="screen"/>
        <link href="../css/topPadding.css" rel="stylesheet"/>
        <link href="../css/datepicker3.css" rel="stylesheet"/>
        <link href="../css/dataTables.bootstrap.css" rel="stylesheet"/>
        <script language="javascript" src="list02.js" />
        <script language="JavaScript" type="text/javascript">
            //--------------- LOCALIZEABLE GLOBALS ---------------
            var d = new Date();
            var monthname = new Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
            //Ensure correct for language. English is "January 1, 2004"
            var TODAY = monthname[d.getMonth()] + " " + d.getDate() + ", " + d.getFullYear();
            //---------------   END LOCALIZEABLE   ---------------

        </script>
        <style type="text/css">
            <!--
            .style1 {
                color: #000000;
                font-weight: bold;
            }
            .style33 {font-size: x-small}
            .style40 {font-size: 9px}
            .style41 {font-size: 9}
            .style42 {font-family: Arial, Helvetica, sans-serif}
            .style32 {font-size: x-small; font-family: Arial, Helvetica, sans-serif; }
            .style43 {
                font-size: x-small;
                color: #FFFFFF;
                font-weight: bold;
            }
            .style47 {font-size: x-small; font-weight: bold; }
            .style49 {font-size: x-small; font-family: Arial, Helvetica, sans-serif; font-weight: bold; }
            .style50 {color: #000000}
            .style51 {color: #BA236A}
            .style58 {font-size: x-small; font-weight: bold; color: #666666; }
            .style66 {font-size: x-small; font-weight: bold; color: #333333; }
            a:hover {
                color: #333333;
            }
            .style68 {color: #CCCCCC}
            .style75 {color: #333333; }
            a:link {
                color: #711321;
            }
            .style76 {color: #003366}
            .style77 {
                color: #711321;
                font-weight: bold;
            }
            .Estilo1 {color: #FFFFFF}
            -->
        </style>
    </head>
    <body bgcolor="#ffffff" onload="">
        <%@include file="../jspf/mainMenu.jspf"%>
        <br />
        <p>

        </p><table width="652" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td height="37" colspan="4" bgcolor="#FFFFFF">
                    <div align="center">
                        <p align="center">
                            <img src="../imagenes/savi1.jpg" width="115" />
                            <img src="../imagenes/medalfaLogo.png" width="115" />
                        </p>
                    </div></td>
            </tr>
            <tr>
                <td width="4" nowrap bgcolor="#FFFFFF">&nbsp;</td>
                <td width="5" bgcolor="#FFFFFF">&nbsp;</td>
                <td width="453"><div align="center">
                        <table width="555" border="0" align="center" cellpadding="2" cellspacing="3">
                            <form action="diarioReceta.jsp" method="post" >
                                <tr>
                                    <td colspan="14"><div id="item21" style="display:none" align="justify" >
                                            <input type="text" name="txtf_hf" id="txtf_hf" size="10" readonly="true"/>
                                        </div></td>
                                </tr>
                                <tr>
                                    <td colspan="14" class="style1"><div align="left"></div></td>
                                </tr>
                                <tr>

                                    <td colspan="2" >&nbsp;</td>
                                </tr>
                                <tr>
                                    <center><label class="h2 text-center">CONSUMO DIARIO POR RECETA </label></center>
                                    <br/><br/>
                                    <div align="left" class="row">          
                                        <span class="col-sm-2 h4">Unidad: </span>
                                        <div class="col-sm-5">
                                            <select name="cla_uni" class="form-control">

                                                <%
                                                    try {
                                                        rset = stmt.executeQuery("select cla_uni, uni from recetas group by cla_uni");
                                                        while (rset.next()) {
                                                %>
                                                <option value="<%=rset.getString("cla_uni")%>"
                                                        <%
                                                        if(cla_uni.equals(rset.getString("cla_uni"))){
                                                            out.println("selected");
                                                        }
                                                        %>
                                                        ><%=rset.getString("uni")%></option>
                                                <%
                                                        }
                                                    } catch (Exception ex) {
                                                        System.out.println(ex.getMessage());
                                                    }
                                                %>
                                            </select>
                                        </div>
                                    </div><br/>
                                    <div class="row">
                                        <label class="col-sm-2 h4">Origen: </label>
                                        <div class="col-sm-2">
                                            <select name="id_ori" class="form-control">
                                                <!--option value="0">0</option-->
                                                <option value="1">1</option>
                                                <option value="2">2</option>
                                                <option value="">Todos</option>
                                            </select>
                                        </div>
                                    </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td bgcolor="#FFFFFF" colspan="15">
                                        <label class="h5">Rango de fechas del:&nbsp;&nbsp;             
                                            <input name="txtf_caduc" type="text" id="txtf_caduc" size="10" data-date-format="yyyy/mm/dd" class="form-control" readonly title="aaaa/mm/dd"/>
                                        </label>
                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                        <label class="h5"> al: &nbsp;&nbsp;
                                            <input name="txtf_caduci" type="text" id="txtf_caduci" size="10" data-date-format="yyyy/mm/dd" class="form-control" readonly title="aaaa/mm/dd"/>
                                        </label>
                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                        <label>&nbsp;&nbsp; </label>
                                        <input type="submit" name="Submit" value="Por Fechas" class="btn-sm btn-primary"/>
                                        <label></label>
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                </tr>
                            </form>
                        </table>
                    </div></td>
                <td width="194" nowrap bgcolor="#FFFFFF"><img src="../imagenes/px.gif" width="1" height="1" alt="" border="0" /></td>
            </tr>
            <tr>
                <td colspan="4">&nbsp;</td>
            </tr>
        </table>
        <table width="662" border="0" align="center" cellpadding="2">
            <tr>
                <td width="102"></td>
                <td height="63" colspan="2" align="center" valign="bottom" nowrap="nowrap" bgcolor="#FFFFFF" id="logo"><div align="center">
                        <span class="style49"> GOBIERNO DEL ESTADO DE MÉXICO<br />
                            SECRETARIA DE SALUD</br>
                            REPORTE DETALLADO DE CONSUMO POR RECETA <br />

                            DE LA UNIDAD:<br />
                            <%
                                try {
                                    rset = stmt.executeQuery("select distinct des_uni from unidades where cla_uni = '" + request.getParameter("cla_uni") + "'");
                                    while (rset.next()) {
                                        out.println(rset.getString(1));
                                    }
                                } catch (Exception ex) {
                                    System.out.println(ex.getMessage());
                                }
                            %> <br />
                            <%String fecha1="",fecha2="";
                                if(request.getParameter("txtf_caduc")==null){
                                    fecha1="";
                                }else{
                                    fecha1=request.getParameter("txtf_caduc");
                                }
                                if(request.getParameter("txtf_caduci")==null){
                                    fecha2="";
                                }else{
                                    fecha2=request.getParameter("txtf_caduci");
                                }
                            %>
                            PERIODO: <%=fecha1%> al <%=fecha2%><br />
                        </span><br/>

                    </div></td>
                <td width="103"></td>
            </tr>

        </table>
        <table width="40%" border="0" align="center" cellpadding="0" cellspacing="0">

            <tr>
                <td colspan="7" bgcolor="#003366"><img src="../mm_spacer.gif" alt="" width="1" height="1" border="0" /></td>
            </tr>

            <tr bgcolor="">
                <td height="25" colspan="7" id="dateformat">&nbsp;&nbsp;<span class="style76">
                        <script language="JavaScript" type="text/javascript">
                            //document.write(TODAY);	</script>
                    </span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <%
                        String ori = "TODOS";
                        try {
                            if ((request.getParameter("id_ori")).equals("0")) {
                                ori = "ADMON COMPRA";
                            }
                            if ((request.getParameter("id_ori")).equals("1")) {
                                ori = "ADMINISTRACIÓN";
                            }
                            if ((request.getParameter("id_ori")).equals("2")) {
                                ori = "VENTA";
                            }
                        } catch (Exception e) {
                        }
                    %>
                    <span class="h4 text-right">ORIGEN "<%=ori%>"</span></td>
            </tr>
            <tr>
                <td colspan="7" bgcolor="#003366"><img src="../mm_spacer.gif" alt="" width="1" height="1" border="0" /></td>
            </tr>

            <tr>

                <td colspan="2" valign="top"><form action="diarioReceta.jsp" method="post" name="form" onSubmit="javascript:return ValidateAbas(this)">
                        <table width="800" border="0" align="center">
                            <tr>
                                <td width="800"><table width="798" border="1">
                                        <tr>
                                            <td width="52" ><span class="style49">Fecha</span></td>
                                            <td width="26"> <span class="style49">Folio</span></td>
                                            <td width="118"> <span class="style49">Nombre M&eacute;dico </span></td>
                                            <td width="62"> <span class="style49">Paciente</span></td>
                                            <td width="104"> <span class="style49">Clave Articulo </span></td>
                                            <td width="119"> <span class="style49">Descripci&oacute;n</span></td>
                                            <td width="80"><span class="style49">Lote</span></td>
                                            <td width="89"><span class="style49">Caducidad</span></td>
                                            <td width="89"><span class="style49">Financiamiento</span></td>
                                            <!--td width="47"> <span class="style49">Costo Unitario </span></td-->
                                            <td width="41"> <span class="style49">Cant. Sol </span></td>
                                            <td width="43"> <span class="style49">Cant. Sur</span></td>
                                            <td width="43"> <span class="style49">Presentación</span></td>
                                            <td width="43"> <span class="style49">Cajas</span></td>
                                            <td width="43"> <span class="style49">Proximas a Cobrar</span></td>
                                        </tr>
                                        <%
                                            int totalCajas = 0, totalPendientes = 0;
                                            try {

                                                rset = stmt.executeQuery("SELECT  r.fecha_hora, r.fol_rec, m.nom_med, pa.nom_pac, p.cla_pro, p.des_pro, dp.lot_pro, dp.cad_pro, dr.can_sol as sol, dr.cant_sur as sur,dp.cla_fin,p.amp_pro  FROM unidades un, usuarios us, receta r, pacientes pa, medicos m, detreceta dr, detalle_productos dp, productos p WHERE un.cla_uni = us.cla_uni AND us.id_usu = r.id_usu AND r.cedula = m.cedula AND r.id_rec = dr.id_rec AND dr.det_pro = dp.det_pro AND dp.cla_pro = p.cla_pro AND un.cla_uni = '" + request.getParameter("cla_uni") + "' AND r.fecha_hora BETWEEN '" + request.getParameter("txtf_caduc") + " 00:00:01' and '" + request.getParameter("txtf_caduci") + " 23:59:59' and dp.id_ori like '%" + request.getParameter("id_ori") + "%' and r.id_tip = '1' and dr.baja !=1 GROUP BY dr.fol_det;");
                                                while (rset.next()) {
                                                    String financ = "";
                                                    if (rset.getString("dp.cla_fin").equals("1")) {
                                                        financ = "Seguro Popular";
                                                    } else if (rset.getString("dp.cla_fin").equals("2")) {
                                                        financ = "FASSA";
                                                    }
                                                    totalCajas = totalCajas + (int) Math.floor(rset.getDouble("sur") / rset.getDouble("amp_pro"));
                                                    totalPendientes = totalPendientes + (int) (rset.getDouble("sur") % rset.getDouble("amp_pro"));
                                        %>
                                        <tr>
                                            <td><span class="style49"><%=df2.format(df3.parse(rset.getString(1)))%></span></td>
                                            <td><span class="style49"><%=rset.getString(2)%></span></td>
                                            <td><span class="style49"><%=rset.getString(3)%></span></td>
                                            <td><span class="style49"><%=rset.getString(4)%></span></td>
                                            <td><span class="style49"><%=rset.getString(5)%></span></td>
                                            <td><span class="style49"><%=rset.getString(6)%></span></td>
                                            <td><span class="style49"><%=rset.getString(7)%></span></td>
                                            <td><span class="style49"><%=rset.getString(8)%></span></td>
                                            <td><span class="style49"><%=financ%></span></td>
                                            <td align="center"><span class="style49"><%=rset.getString(9)%></span></td>
                                            <td align="center"><span class="style49"><%=rset.getString(10)%></span></td>
                                            <td align="center"><span class="style49"><%=rset.getString("amp_pro")%></span></td>
                                            <td align="center"><span class="style49"><%=formatter.format(Math.floor(rset.getDouble("sur") / rset.getDouble("amp_pro")))%></span></td>
                                            <td align="center"><span class="style49"><%=formatter.format(rset.getDouble("sur") % rset.getDouble("amp_pro"))%></span></td>
                                        </tr>
                                        <%

                                                }
                                            } catch (Exception e) {
                                                System.out.println(e.getMessage());
                                            }
                                        %>
                                        <tr>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td>&nbsp;</td>
                                            <td class="style49" align="right">PIEZAS</td>
                                            <td class="style49" align="center">&nbsp;</td>
                                            <td class="style49" align="center">&nbsp;</td>
                                            <td class="style49" align="center">&nbsp;</td>
                                            <%try {
                                                    int totalSol = 0;
                                                    int totalSur = 0;
                                                    rset = stmt.executeQuery("SELECT dr.fec_sur, r.fol_rec, m.nom_med, pa.nom_pac, p.cla_pro, p.des_pro, dp.lot_pro, dp.cad_pro, (dr.can_sol) as sol, (dr.cant_sur) as sur FROM unidades un, usuarios us, receta r, pacientes pa, medicos m, detreceta dr, detalle_productos dp, productos p WHERE un.cla_uni = us.cla_uni AND us.id_usu = r.id_usu AND r.cedula = m.cedula AND r.id_rec = dr.id_rec AND dr.det_pro = dp.det_pro AND dp.cla_pro = p.cla_pro AND un.cla_uni = '" + request.getParameter("cla_uni") + "' AND r.fecha_hora BETWEEN '" + request.getParameter("txtf_caduc") + " 00:00:01' and '" + request.getParameter("txtf_caduci") + " 23:59:59' and dp.id_ori like '%" + request.getParameter("id_ori") + "%' AND dr.baja != 1 and r.id_tip = '1' group by dr.fol_det;");
                                                    while (rset.next()) {
                                                        totalSol = totalSol + rset.getInt(9);
                                                        totalSur = totalSur + rset.getInt(10);
                                                    }
                                            %>
                                            <td class="style49" align="center"><%=totalSol%></td>
                                            <td class="style49" align="center"><%=totalSur%></td>
                                            <%
                                                } catch (Exception e) {
                                                    System.out.println(e.getMessage());
                                                }
                                            %>
                                            <td class="style49" align="center">Cajas</td>
                                            <td class="style49" align="center"><%=totalCajas%></td>
                                            <td class="style49" align="center"><%=totalPendientes%></td>
                                        </tr>

                                        <tr>
                                            <%try {
                                                    int recetas = 0;
                                                    rset = stmt.executeQuery("SELECT dr.fec_sur, r.fol_rec, m.nom_med, pa.nom_pac, p.cla_pro, p.des_pro, dp.lot_pro, dp.cad_pro, sum(dr.can_sol) as sol, sum(dr.cant_sur) as sur FROM unidades un, usuarios us, receta r, pacientes pa, medicos m, detreceta dr, detalle_productos dp, productos p WHERE un.cla_uni = us.cla_uni AND us.id_usu = r.id_usu AND r.cedula = m.cedula AND r.id_rec = dr.id_rec AND dr.det_pro = dp.det_pro AND dp.cla_pro = p.cla_pro AND un.cla_uni = '" + request.getParameter("cla_uni") + "' AND r.fecha_hora BETWEEN '" + request.getParameter("txtf_caduc") + " 00:00:01' and '" + request.getParameter("txtf_caduci") + " 23:59:59' and dp.id_ori like '%" + request.getParameter("id_ori") + "%' and r.id_tip = '1' and dr.baja!=1 group by r.fol_rec ;");
                                                    while (rset.next()) {
                                                        recetas++;
                                                    }

                                            %>
                                            <td height="24" colspan="5" align="center" class="style49">TOTAL RECETAS EMITIDAS= <%=recetas%></td>

                                            <%
                                                int totalPiezas = 0;
                                                rset = stmt.executeQuery("SELECT dr.fec_sur, r.fol_rec, m.nom_med, pa.nom_pac, p.cla_pro, p.des_pro, dp.lot_pro, dp.cad_pro, (dr.can_sol) as sol, (dr.cant_sur) as sur FROM unidades un, usuarios us, receta r, pacientes pa, medicos m, detreceta dr, detalle_productos dp, productos p WHERE un.cla_uni = us.cla_uni AND us.id_usu = r.id_usu AND r.cedula = m.cedula AND r.id_rec = dr.id_rec AND dr.det_pro = dp.det_pro AND dp.cla_pro = p.cla_pro AND un.cla_uni = '" + request.getParameter("cla_uni") + "' AND r.fecha_hora BETWEEN '" + request.getParameter("txtf_caduc") + " 00:00:01' and '" + request.getParameter("txtf_caduci") + " 23:59:59' and dp.id_ori like '%" + request.getParameter("id_ori") + "%' and r.id_tip = '1' AND dr.baja != 1 group by dr.fol_det;");
                                                while (rset.next()) {
                                                    totalPiezas = totalPiezas + rset.getInt(10);
                                                }
                                            %>
                                            <td colspan="5" class="style49" align="center">TOTAL PIEZAS DISPENSADAS= <%=totalPiezas%></td>
                                            <td colspan="4" class="style49" align="center">TOTAL CAJAS DISPENSADAS= <%=totalCajas%></td>
                                            <%
                                                } catch (Exception e) {
                                                    System.out.println(e.getMessage());
                                                }
                                            %>
                                        </tr>
                                    </table>
                                </td>

                            </tr>
                        </table>
                    </form>   


                    </table>
                    </div></td>
            </tr>
        </table>    </td>
        <td width="4">&nbsp;</td>
        <td width="6" valign="top"><br />
            &nbsp;<br /></td>
        <td width="96">&nbsp;</td>
        </tr>
        <tr>
            <td width="4">&nbsp;</td>
            <td width="68">&nbsp;</td>
            <td width="27">&nbsp;</td>
            <td width="1036">&nbsp;</td>
            <td width="4">&nbsp;</td>
            <td width="6">&nbsp;</td>
            <td width="96">&nbsp;</td>
        </tr>
        </table>

        <map name="Map" id="Map">
            <area shape="poly" coords="241,165" href="#" />
            <area shape="poly" coords="230,40,231,88,270,43" href="#" />
        </map>
        <script src="../js/jquery-1.9.1.js"></script>
        <script src="../js/bootstrap.js"></script>
        <script src="../js/jquery-ui.js"></script>
        <script src="../js/bootstrap-datepicker.js"></script>
        <script type="text/javascript">
                    $("#txtf_caduc").datepicker({minDate: 0});
                    $("#txtf_caduci").datepicker({minDate: 0});

        </script>
    </body>
</html>
<%
    con.close();
%>