<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" import="java.text.*" import="java.lang.*" import="java.util.*" import= "javax.swing.*" import="java.io.*" import="java.text.DateFormat" import="java.text.ParseException" import="java.text.SimpleDateFormat" import="java.util.Calendar" import="java.util.Date"  import="java.text.NumberFormat" import="java.util.Locale" errorPage="" %>
<%    HttpSession sesion = request.getSession();
//  Conexión a la BDD -------------------------------------------------------------
    ConectionDB conn = new ConectionDB();
    conn.conectar();
    Connection con = conn.getConn();
    Statement stmt = con.createStatement();
    ResultSet rset = null;
// fin objetos de conexión --------------------------------------------------------
    String pag = "";
    try {
        if (request.getParameter("reporte").equals("global")) {
            //response.sendRedirect("reporte_glob_val.jsp?cla_uni=" + request.getParameter("cla_uni") + "&f1=" + request.getParameter("txtf_caduc") + "&f2=" + request.getParameter("txtf_caduci") + "&ori=" + request.getParameter("ori") + "");
            pag = "validaMesRecGlob.jsp?cla_uni=" + request.getParameter("cla_uni") + "&f1=" + request.getParameter("txtf_caduc") + "&f2=" + request.getParameter("txtf_caduci") + "&ori=" + request.getParameter("ori") + "";
        }
        if (request.getParameter("reporte").equals("receta")) {
            pag = "validaMesRecFarm.jsp?cla_uni=" + request.getParameter("cla_uni") + "&f1=" + request.getParameter("txtf_caduc") + "&f2=" + request.getParameter("txtf_caduci") + "&ori=" + request.getParameter("ori") + "";
            //response.sendRedirect("reporte_re2_val.jsp?cla_uni=" + request.getParameter("cla_uni") + "&f1=" + request.getParameter("txtf_caduc") + "&f2=" + request.getParameter("txtf_caduci") + "&ori=" + request.getParameter("ori") + "");
        }
    } catch (Exception e) {
    }
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
        <title>Sistema de Reportes WEB :: GNKL</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/bootstrap.css" rel="stylesheet" media="screen"/>
        <link href="../css/topPadding.css" rel="stylesheet"/>
        <link href="../css/datepicker3.css" rel="stylesheet"/>
        <link href="../css/dataTables.bootstrap.css" rel="stylesheet"/>
        <script language="JavaScript" type="text/javascript">
            //--------------- LOCALIZEABLE GLOBALS ---------------
            var d = new Date();
            var monthname = new Array("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Deciembre");
            //Ensure correct for language. English is "January 1, 2004"
            var TODAY = monthname[d.getMonth()] + " " + d.getDate() + ", " + d.getFullYear();
            //---------------   END LOCALIZEABLE   ---------------
        </script>

        <style type="text/css">
            <!--
            .style1 {
                font-size: 12px
            }
            body {
                background-image: url();
                background-color: #E1E1E1;
            }
            .style2 {
                font-family: Arial, Helvetica, sans-serif
            }
            a:link {
                color: #000000;
            }
            a:visited {
                color: #990000;
            }
            a:hover {
                color: #0000FF;
            }
            .style5 {
                font-size: 36px;
                font-weight: bold;
                font-family: Arial, Helvetica, sans-serif;
            }
            .style6 {
                font-size: 18px
            }
            .style7 {
                font-size: 12px;
                font-family: Arial, Helvetica, sans-serif;
            }
            -->
        </style>
    </head>
    <body>
        <%@include file="../jspf/mainMenu.jspf"%>
        <br/>
        <table width="103%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
            <tr bgcolor="#D5EDB3">
                <td colspan="2" bgcolor="#FFFFFF">&nbsp;</td>
                <td height="50" colspan="3" align="center" valign="bottom" nowrap="nowrap" bgcolor="#FFFFFF" id="logo">
                    <div align="right">
                        <table width="946" border="0" align="left" cellpadding="2">
                            <tr>
                                <td width="792"><div align="center" class="h2">REPORTE DE VALIDACIONES MENSUAL RECETA FARMACIA </div></td>
                                <td width="140" height="67"></td>
                            </tr>
                        </table>
                    </div>    
                </td>
                <td width="4" bgcolor="#FFFFFF">&nbsp;</td>
            </tr>
            <tr bgcolor="#99CC66">
                <td height="20" colspan="7"  bgcolor="#FFFFFF" id="dateformat">&nbsp;&nbsp; 
                    <script language="JavaScript" type="text/javascript">
                        document.write(TODAY);</script></td>
            </tr>
            <tr>
                <td width="165" valign="top" bgcolor="#FFFFFF">
                    <table border="0" cellspacing="0" cellpadding="0" width="165" id="navigation">
                    </table>
                        <br />
                    &nbsp;<br />
                    &nbsp;<br />
                    &nbsp;<br /></td>
                <td width="4">&nbsp;</td>
                <td colspan="2" valign="top" bgcolor="#FFFFFF"><div align="center"></div>
                    <div align="left"></div>
                    <div align="left"></div>
                    <table width="925" border="3" align="left" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="453" class="bodyText"><table width="917" border="0" align="center" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td height="37" colspan="4" bgcolor="#FFFFFF"><div align="center">
                                                <p align="center"><img src="../imagenes/savi1.jpg" width="115"/>
                                                <img src="../imagenes/medalfaLogo.png" width="115"/></p>
                                            </div></td>
                                    </tr>
                                    <tr>
                                        <td width="4" nowrap bgcolor="#FFFFFF">&nbsp;</td>
                                        <td width="4" bgcolor="#FFFFFF">&nbsp;</td>
                                        <td width="638" bgcolor="#FFFFFF">
                                            <div align="center">
                                                <table width="687" border="0" align="center" cellpadding="2" cellspacing="3">
                                                    <form action="validaMesRec.jsp" method="get" >
                                                        <tr>
                                                            <td colspan="14"><div id="item21" style="display:none" align="justify" >
                                                                    <input type="text" name="txtf_hf" id="txtf_hf" size="10" readonly="true"/>
                                                                </div></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="14" class="style1"><div align="left"></div></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="14" class="style1"><br/></td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="16" class="style1" >
                                                                <label class="h4" for="glo"> Global Receta Farmacia: </label>
                                                                <input name="reporte" id="glo" type="radio" value="global" checked="checked"/>&nbsp;&nbsp;                  
                                                                <label class="h4" for="rec"> Desglose  Receta Farmacia:</label> 
                                                                <input name="reporte" id="rec" type="radio" value="receta" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" align="right">&nbsp;</td>
                                                            <td colspan="12" align="right" class="style1">
                                                                <br/>                                                  
                                                                <div class="row" align="center">
                                                                    <span class="h4 col-sm-2">Unidad: </span>
                                                                    <div class="col-sm-5">
                                                                        <select name="cla_uni" class="form-control">
                                                                            <%
                                                                                try {
                                                                                    rset = stmt.executeQuery("select DISTINCT cla_uni, uni from recetas");
                                                                                    while (rset.next()) {
                                                                            %>
                                                                            <option value="<%=rset.getString("cla_uni")%>"
                                                                                    <%
                                                                                        if (cla_uni.equals(rset.getString("cla_uni"))) {
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
                                                                    <span class="h4 col-sm-2">Origen: </span>
                                                                    <div class="col-sm-2">
                                                                        <select name="ori" class="form-control">
                                                                            <!--option value="ambos">Ambos</option-->
                                                                            <!--option value="0">0</option-->
                                                                            <option value="1">1</option>
                                                                            <option value="2">2</option>
                                                                        </select>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="#FFFFFF" colspan="15" class="style1">&nbsp;</td>
                                                        </tr>
                                                        <tr>
                                                            <td bgcolor="#FFFFFF" colspan="15" class="style1">
                                                                <label class="h5" >Rango de fechas del:&nbsp;&nbsp;                                                                
                                                                    <input name="txtf_caduc" type="text" id="txtf_caduc" size="10" readonly data-date-format="yyyy/mm/dd" title="AAAA-MM-DD" class="form-control"/>
                                                                </label>
                                                                &nbsp;&nbsp;&nbsp;&nbsp;
                                                                <label class="h5"> al: &nbsp;&nbsp;
                                                                    <input name="txtf_caduci" type="text" id="txtf_caduci" size="10" readonly data-date-format="yyyy/mm/dd" title="AAAA-MM-DD" class="form-control"/>
                                                                </label>
                                                                &nbsp;&nbsp;&nbsp;&nbsp;                                                                
                                                                <input type="submit" name="Submit" value="Buscar" class="btn-primary btn-sm"/>

                                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                                        </tr>
                                                        <input type="hidden" name="cmd" value="1" />
                                                    </form>
                                                </table>
                                            </div></td>
                                        <td width="179" nowrap bgcolor="#FFFFFF"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="4">&nbsp;</td>
                                    </tr>
                                </table></td>
                        </tr>
                    </table></td>
            </tr>
        </table>
         <br />
        <br />
        <iframe src="<%=pag%>" width="1550" height="800"></iframe>         
        <script src="../js/jquery-1.9.1.js"></script>
        <script src="../js/bootstrap.js"></script>
        <script src="../js/jquery-ui.js"></script>
        <script src="../js/bootstrap-datepicker.js"></script>
        <script>
                        $("#txtf_caduc").datepicker({minDate: 0});
                        $("#txtf_caduci").datepicker({minDate: 0});
        </script>
    </body>
</html>
<%
    con.close();
%>