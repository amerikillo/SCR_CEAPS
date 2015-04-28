<%@page import="Clases.ConectionDB"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" import="java.text.*" import="java.lang.*" import="java.util.*" import= "javax.swing.*" import="java.io.*" import="java.text.DateFormat" 
         import="java.text.ParseException" import="java.text.SimpleDateFormat" import="java.util.Calendar" import="java.util.Date" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns:v="urn:schemas-microsoft-com:vml"
      xmlns:o="urn:schemas-microsoft-com:office:office"
      xmlns:x="urn:schemas-microsoft-com:office:excel"
      xmlns="http://www.w3.org/TR/REC-html40">
    <%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
    <%java.text.DateFormat df2 = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
    <%
        DecimalFormat formatter = new DecimalFormat("#,###,###");
        DecimalFormat formatterDecimal = new DecimalFormat("#,###,##0.00");
        DecimalFormatSymbols custom = new DecimalFormatSymbols();
        custom.setDecimalSeparator('.');
        custom.setGroupingSeparator(',');
        formatter.setDecimalFormatSymbols(custom);
        formatterDecimal.setDecimalFormatSymbols(custom);
        //  Conexión a la BDD -------------------------------------------------------------
        ConectionDB conn = new ConectionDB();
        conn.conectar();
        Connection con = conn.getConn();
        Statement stmt = con.createStatement();
        ResultSet rset = null;
        Statement stmt2 = con.createStatement();
        ResultSet rset2 = null;
        // fin objetos de conexión ------------------------------------------------------
        int ban = 0;
        int total = 0;
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename=REPORTE DE CONSUMO POR RECETA COLECTIVA.xls");
    %>
    <head>
        <meta http-equiv=Content-Type content="text/html; charset=windows-1252">
            <meta name=ProgId content=Excel.Sheet>
                <meta name=Generator content="Microsoft Excel 11">
                    <link rel=File-List href="CENSITOSMMMMM_archivos/filelist.xml">
                        <link rel=Edit-Time-Data href="CENSITOSMMMMM_archivos/editdata.mso">
                            <link rel=OLE-Object-Data href="CENSITOSMMMMM_archivos/oledata.mso">

                                <style>
                                    <!--table
                                    {mso-displayed-decimal-separator:"\.";
                                     mso-displayed-thousand-separator:"\,";}
                                    @page
                                    {margin:.98in .79in .98in .79in;
                                     mso-header-margin:0in;
                                     mso-footer-margin:0in;
                                     mso-page-orientation:landscape;}
                                    tr
                                    {mso-height-source:auto;}
                                    col
                                    {mso-width-source:auto;}
                                    br
                                    {mso-data-placement:same-cell;}
                                    .style0
                                    {mso-number-format:General;
                                     text-align:general;
                                     vertical-align:bottom;
                                     white-space:nowrap;
                                     mso-rotate:0;
                                     mso-background-source:auto;
                                     mso-pattern:auto;
                                     color:windowtext;
                                     font-size:10.0pt;
                                     font-weight:400;
                                     font-style:normal;
                                     text-decoration:none;
                                     font-family:Arial;
                                     mso-generic-font-family:auto;
                                     mso-font-charset:0;
                                     border:none;
                                     mso-protection:locked visible;
                                     mso-style-name:Normal;
                                     mso-style-id:0;}
                                    td
                                    {mso-style-parent:style0;
                                     padding:0px;
                                     mso-ignore:padding;
                                     color:windowtext;
                                     font-size:10.0pt;
                                     font-weight:400;
                                     font-style:normal;
                                     text-decoration:none;
                                     font-family:Arial;
                                     mso-generic-font-family:auto;
                                     mso-font-charset:0;
                                     mso-number-format:General;
                                     text-align:general;
                                     vertical-align:bottom;
                                     border:none;
                                     mso-background-source:auto;
                                     mso-pattern:auto;
                                     mso-protection:locked visible;
                                     white-space:nowrap;
                                     mso-rotate:0;}
                                    .xl24
                                    {mso-style-parent:style0;
                                     color:white;
                                     font-size:8.0pt;
                                     font-weight:700;
                                     font-family:Arial, sans-serif;
                                     mso-font-charset:0;
                                     text-align:center;
                                     background:black;
                                     mso-pattern:auto none;}
                                    .xl25
                                    {mso-style-parent:style0;
                                     font-size:8.0pt;
                                     font-family:Arial, sans-serif;
                                     mso-font-charset:0;
                                     text-align:center;}
                                    .xl26
                                    {mso-style-parent:style0;
                                     color:white;
                                     font-weight:700;
                                     font-family:Arial, sans-serif;
                                     mso-font-charset:0;
                                     background:black;
                                     mso-pattern:auto none;}
                                    .xl27
                                    {mso-style-parent:style0;
                                     font-weight:700;
                                     font-family:Arial, sans-serif;
                                     mso-font-charset:0;}
                                    .xl28
                                    {mso-style-parent:style0;
                                     text-align:right;}
                                    .xl29
                                    {mso-style-parent:style0;
                                     text-align:left;}
                                    .xl30
                                    {mso-style-parent:style0;
                                     text-decoration:underline;
                                     text-underline-style:single;}
                                    .xl31
                                    {mso-style-parent:style0;
                                     border:1.0pt solid windowtext;}
                                    .xl32
                                    {mso-style-parent:style0;
                                     text-align:center;}
                                    .xl33
                                    {mso-style-parent:style0;
                                     color:white;
                                     text-align:center;
                                     background:black;
                                     mso-pattern:auto none;}
                                    .xl34
                                    {mso-style-parent:style0;
                                     color:white;
                                     font-weight:700;
                                     font-family:Arial, sans-serif;
                                     mso-font-charset:0;
                                     text-align:center;
                                     background:black;
                                     mso-pattern:auto none;}
                                    .xl35
                                    {mso-style-parent:style0;
                                     text-align:center;
                                     border-top:1.0pt solid windowtext;
                                     border-right:none;
                                     border-bottom:1.0pt solid windowtext;
                                     border-left:1.0pt solid windowtext;}
                                    .xl36
                                    {mso-style-parent:style0;
                                     text-align:center;
                                     border-top:1.0pt solid windowtext;
                                     border-right:none;
                                     border-bottom:1.0pt solid windowtext;
                                     border-left:none;}
                                    .xl37
                                    {mso-style-parent:style0;
                                     text-align:center;
                                     border-top:1.0pt solid windowtext;
                                     border-right:1.0pt solid windowtext;
                                     border-bottom:1.0pt solid windowtext;
                                     border-left:none;}
                                    .xl38
                                    {mso-style-parent:style0;
                                     font-size:18.0pt;
                                     font-family:Arial, sans-serif;
                                     mso-font-charset:0;
                                     text-align:center;}
                                    .style5 {font-family: Arial, Helvetica, sans-serif; font-size: 12; }
                                    -->
                                </style>

                                </head>

                                <body link=blue vlink=purple>
                                    <p>

                                    </p>

                                    <table width="1008" border="0" align="center">
                                        <tr>
                                            <td width="418"><table width="980" border="1">
                                                    <tr>
                                                        <td width="83"><span class="Estilo13">Clave</span></td>
                                                        <td width="392"><div align="center"><span class="Estilo13">Descripci&oacute;n</span></div></td>
                                                        <td width="125"><div align="center"><span class="Estilo13">UM </span></div></td>
                                                        <td width="108"><div align="center"><span class="Estilo13">LOTE </span></div></td>
                                                        <td width="121"><div align="center"><span class="Estilo13">CADUCIDAD </span></div></td>
                                                        <td width="111"><div align="center"><span class="Estilo13">Total Piezas </span></div></td>
                                                        <td width="111"><div align="center"><span class="Estilo13">Presentación </span></div></td>
                                                        <td width="111"><div align="center"><span class="Estilo13">Cajas </span></div></td>
                                                        <td width="111"><div align="center"><span class="Estilo13">Piezas Próximas a Cobrar </span></div></td>
                                                        <td width="111"><div align="center"><span class="Estilo13">Financiamiento </span></div></td>
                                                    </tr>
                                                    <%
                                                        try {
                                                            rset = stmt.executeQuery("SELECT p.amp_pro, p.pres_pro, r.fol_rec, m.nom_med, pa.nom_pac, p.cla_pro, p.des_pro, dp.lot_pro, dp.cad_pro, dr.can_sol, sum(dr.cant_sur) as sur, dp.cla_fin FROM unidades un, usuarios us, receta r, pacientes pa, medicos m, detreceta dr, detalle_productos dp, productos p WHERE r.id_tip = '2' and un.cla_uni = us.cla_uni AND pa.id_pac = r.id_pac AND us.id_usu = r.id_usu AND r.cedula = m.cedula AND r.id_rec = dr.id_rec AND dr.det_pro = dp.det_pro AND dp.cla_pro = p.cla_pro AND un.cla_uni = '" + request.getParameter("unidad") + "' AND r.fecha_hora BETWEEN '" + request.getParameter("f1") + " 00:00:01' and '" + request.getParameter("f2") + " 23:59:59' and dp.id_ori like '%" + request.getParameter("ori") + "%' and dr.baja!=1 and dr.cant_sur!= 0 group by p.cla_pro, dp.lot_pro, dp.cad_pro ;");
                                                            while (rset.next()) {
                                                                ban = 1;
                                                                String financ = "";
                                                                if (rset.getString("dp.cla_fin").equals("1")) {
                                                                    financ = "Seguro Popular";
                                                                } else if (rset.getString("dp.cla_fin").equals("2")) {
                                                                    financ = "FASSA";
                                                                }
                                                    %>
                                                    <tr>
                                                        <td class="Estilo6"><%=rset.getString("cla_pro")%></td>
                                                        <td class="Estilo6"><%=rset.getString("des_pro")%></td>
                                                        <td align="center" class="Estilo9"><%=rset.getString("pres_pro")%></td>
                                                        <td align="center" class="Estilo9"><%=rset.getString("lot_pro")%></td>
                                                        <td align="center" class="Estilo9"><%=df2.format(df.parse(rset.getString("cad_pro")))%></td>
                                                        <td align="center" class="Estilo9"><%=rset.getString("sur")%></td>
                                                        <td align="center" class="Estilo9"><%=rset.getString("amp_pro")%></td>
                                                        <td align="center" class="Estilo9"><%=formatter.format(Math.floor(rset.getDouble("sur") / rset.getDouble("amp_pro")))%></td>
                                                        <td align="center" class="Estilo9"><%=formatter.format(rset.getDouble("sur") % rset.getDouble("amp_pro"))%></td>
                                                        <td align="center" class="Estilo9"><%=financ%></td>
                                                    </tr>
                                                    <%
                                                                int sumar = (int) Math.floor(rset.getDouble("sur") / rset.getDouble("amp_pro"));
                                                                System.out.println(sumar);
                                                                total = total + sumar;
                                                            }
                                                        } catch (Exception ex) {
                                                            System.out.println("Error1->" + ex.getMessage());
                                                        }
                                                    %>
                                                    <tr>
                                                        <td>&nbsp;</td>
                                                        <td></td>
                                                        <td align="center" class="Estilo9">&nbsp;</td>
                                                        <td align="center" class="Estilo9">&nbsp;</td>
                                                        <td align="center" class="Estilo9">&nbsp;</td>
                                                        <td align="center" class="Estilo9">&nbsp;</td>
                                                        <td align="center" class="Estilo9">Total</td>
                                                        <td align="center" class="Estilo9"><%=total%></td>
                                                        <td align="center" class="Estilo9">&nbsp;</td>
                                                        <td align="center" class="Estilo9">&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="10">&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="10"><div align="left" class="Estilo3">ADMINISTRADOR&nbsp;DE LA UNIDAD &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ENCARGADO(A) DE LA FARMACIA &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FILTRO DEL ISEM</div></td>
                                                    </tr>
                                                </table></td>
                                        </tr>
                                    </table>
                                    <p>&nbsp;</p>
                                </body>

                                </html>
                                <%
                                    con.close();
                                %>
