<%@page import="Clases.ConectionDB"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns:v="urn:schemas-microsoft-com:vml"
      xmlns:o="urn:schemas-microsoft-com:office:office"
      xmlns:x="urn:schemas-microsoft-com:office:excel"
      xmlns="http://www.w3.org/TR/REC-html40">
    <%

        // Conexion BDD via JDBC
        ConectionDB conn = new ConectionDB();
        conn.conectar();
        Connection con = conn.getConn();
        Statement stmt = con.createStatement();
        ResultSet rset = null;
        // fin conexion --------

        String f1 = "2013-01-01";
        String f2 = "2015-01-01";

        try {
            String but = request.getParameter("submit");

            f1 = request.getParameter("txtf_caduc");
            f2 = request.getParameter("txtf_caduci");
        } catch (Exception e) {
        }
        int total = 0;
        response.setContentType("application/vnd.ms-excel"); //Tipo de fichero.
        response.setHeader("Content-Disposition", "attachment;filename=\"Dispensado por dia_del" + f1 + "al" + f2 + ".xls\"");
    %>
    <head>
        <meta http-equiv=Content-Type content="text/html; charset=windows-1252">
            <meta name=ProgId content=Excel.Sheet>
                <meta name=Generator content="Microsoft Excel 11">
                    <link rel=File-List href="CENSITOSMMMMM_archivos/filelist.xml">
                        <link rel=Edit-Time-Data href="CENSITOSMMMMM_archivos/editdata.mso">
                            <link rel=OLE-Object-Data href="CENSITOSMMMMM_archivos/oledata.mso">

                                </head>

                                <body link=blue vlink=purple>
                                    <p>

                                        <!--img src="http://201.122.57.184:8080/ngb11/logo.png" /--></p>
                                    <p>&nbsp;</p>
                                    <table width="400" cellpadding="3" cellspacing="1" border="2" >

                                        <tr height="20">
                                            <td height="20" colspan="3" style="border:double"><p align="center">DISPENSADO POR UNIDAD RECETA COLECTIVA </p></td>
                                        </tr>
                                        <tr height="20">
                                            <td height="33" >		  </td>
                                            <td >
                                                <div align="center" class="Estilo8">Rango 
                                                    <%=f1%> 
                                                    del al 
                                                    <%=f2%>
                                                </div></td>
                                            <td>
                                            </td>
                                        </tr>
                                        <tr height="20">
                                            <td width="52" height="20" style="border:double"><div align="center">CLAVE&nbsp;</div></td>
                                            <td width="42"   style="border:double">DESCRIPCI&Oacute;N</td>
                                            <td width="42"   style="border:double"><div align="center">CANTIDAD</div></td>
                                        </tr>
                                        <%
                                            rset = stmt.executeQuery("SELECT p.cla_pro, p.des_pro, sum(dr.cant_sur) as cant FROM productos p, detalle_productos dp, detreceta dr, receta r, usuarios u, unidades un where r.id_tip = '2' and p.cla_pro = dp.cla_pro AND dp.det_pro = dr.det_pro AND dr.id_rec = r.id_rec AND r.id_usu = u.id_usu AND u.cla_uni = un.cla_uni AND r.fecha_hora  BETWEEN '" + f1 + " 00:00:01' and '" + f2 + " 23:59:59' and dr.baja!=1 GROUP BY p.cla_pro, dr.baja  ORDER BY dp.cla_pro+0 ASC ;");
                                            while (rset.next()) {
                                        %>
                                        <tr height="20" >
                                            <td style="border:double" align="left" ><%=rset.getString("cla_pro")%></td>
                                            <td  style="border:double"><%=rset.getString("des_pro")%></td>
                                            <td  style="border:double"><div align="center"><%=rset.getString("cant")%></div></td>
                                        </tr>
                                        <%
                                                total = total + Integer.parseInt(rset.getString("cant"));
                                            }
                                        %>
                                        <tr height="20" >
                                            <td style="border:double" align="left" >&nbsp;</td>
                                            <td  style="border:double">Total de Piezas</td>
                                            <td  style="border:double"><div align="center"><%=total%></div></td>
                                        </tr>

                                    </table>
                                    <p>&nbsp;</p>
                                </body>

                                </html>
                                <%
                                    con.close();
                                %>