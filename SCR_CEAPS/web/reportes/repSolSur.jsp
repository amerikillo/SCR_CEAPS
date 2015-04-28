<%-- 
    Document   : Reporte
    Created on : 26/12/2012, 09:05:24 AM
    Author     : Unknown
--%>

<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy");%>
<% /*Parametros para realizar la conexión*/

    DecimalFormat formatter = new DecimalFormat("#,###,###");
    DecimalFormat formatterDecimal = new DecimalFormat("#,###,##0.00");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator('.');
    custom.setGroupingSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    formatterDecimal.setDecimalFormatSymbols(custom);
    HttpSession sesion = request.getSession();
    ConectionDB con = new ConectionDB();

    int sumTotal = 0, pendSur = 0, cajAmp = 0;

    String origen = "";
    try {
        if (request.getParameter("id_origen").equals("1")) {
            origen = "ISEM";
        } else if (request.getParameter("id_origen").equals("2")) {
            origen = "SAVI";
        } else if (request.getParameter("id_origen").equals("3")) {
            origen = "AMBOS";
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
        con.conectar();
        ResultSet rset = con.consulta("select un.des_uni, us.cla_uni from usuarios us, unidades un where us.cla_uni = un.cla_uni and id_usu = '" + id_usu + "' ");
        while (rset.next()) {
            cla_uni = rset.getString("cla_uni");
            des_uni = rset.getString("des_uni");
            
        }
        con.cierraConexion();
    } catch (Exception e) {

    }
%>
<html>
    <head>
        <link href="../css/bootstrap.css" rel="stylesheet" media="screen">
        <style type="text/css">
            .letra{
                font-size: 12px;
            }
        </style>
    </head>
    <body class="container">
        <%            try {

        %>
        <div class="text-center">
            GOBIERNO DEL ESTADO DE MÉXICO <br/>
            SECRETARIA DE SALUD <br/>
            SAVI S.A. DE C.V. <br/>
            <%=des_uni%> <br/>
            REPORTE POR CLAVE DEL CONSUMO POR RECETA  <br/>            
            PERIODO: <%=request.getParameter("hora_ini")%> al <%=request.getParameter("hora_fin")%>  <br/>                        
        </div>
        <%} catch (Exception e) {

            }
        %>
        <a class="btn btn-default" href="../farmacia/repSolSur.jsp">Regresar</a>
        <a class="btn btn-default" href="gnrRepSolSur.jsp?hora_ini=<%=request.getParameter("hora_ini")%>&hora_fin=<%=request.getParameter("hora_fin")%>"><span class="glyphicon glyphicon-download"></span></a>
        <%
            /*
             Para origen 1
             */
            try {
        %>
        <table class="table table-bordered table-condensed table-striped" >
            <tr>
                <td>Clave</td>
                <td>Descripción</td>
                <!--td>Amp Sol</td>
                <td>Amp Sur</td-->
                <td>Cajas Sol</td>
                <td>Cajas Sur</td>
            </tr>
            <%
                con.conectar();
                ResultSet rset = con.consulta("select r.cla_pro,r.des_pro,sum(can_sol) as can_sol,sum(cant_sur) as cant_sur, ((sum(can_sol))/amp_pro) as caj_sol, ((sum(cant_sur))/amp_pro) as caj_sur from repsolsur r, productos p, usuarios usu, unidades uni  where r.id_usu = usu.id_usu and usu.cla_uni = uni.cla_uni and uni.cla_uni = '" + cla_uni + "' and r.cla_pro = p.cla_pro and fec_sur between '" + request.getParameter("hora_ini") + "' and '" + request.getParameter("hora_fin") + "'  group by cla_pro order by r.cla_pro+0 ");
                while (rset.next()) {
                    //System.out.println(rset.getString("cla_pro"));
                    //System.out.println("holaa");
%>
            <tr>
                <td><%=rset.getString("cla_pro")%></td>
                <td><%=rset.getString("des_pro")%></td>                
                <!--td class="text-right"><%=formatter.format(rset.getDouble("can_sol"))%></td>
                <td class="text-right"><%=formatter.format(rset.getDouble("cant_sur"))%></td-->           
                <td class="text-right"><%=formatter.format(Math.floor(rset.getDouble("caj_sol")))%></td>      
                <td class="text-right"><%=formatter.format(Math.floor(rset.getDouble("caj_sur")))%></td>

            </tr>

            <%                }
                    con.cierraConexion();
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
            <tr>
                <td></td>                
                <td>Totales</td>
                <%
                    try {
                        double totalSol = 0, totalSur = 0;
                        con.conectar();
                        ResultSet rset = con.consulta("select sum(can_sol), sum(cant_sur) from repsolsur where fec_sur between '" + request.getParameter("hora_ini") + "' and '" + request.getParameter("hora_fin") + "' ");
                        while (rset.next()) {
                %>
                <!--td class="text-right"><%=formatter.format(rset.getInt(1))%></td>
                <td class="text-right"><%=formatter.format(rset.getInt(2))%></td-->
                <%
                    }
                    double cajasSol = 0;
                    double cajasSur = 0;
                    rset = con.consulta("select (SUM(can_sol)/amp_pro), (SUM(cant_sur)/amp_pro) from repsolsur r, productos p where r.cla_pro = p.cla_pro and fec_sur between '" + request.getParameter("hora_ini") + "' and '" + request.getParameter("hora_fin") + "' group by r.cla_pro");
                    while (rset.next()) {
                        cajasSol = cajasSol + Math.floor(rset.getDouble(1));
                        cajasSur = cajasSur + Math.floor(rset.getDouble(2));
                    }
                %>
                <td class="text-right"><%=formatter.format(cajasSol)%></td>
                <td class="text-right"><%=formatter.format(cajasSur)%></td>
                <%

                        con.cierraConexion();
                    } catch (Exception e) {
                        System.out.println(e.getMessage());
                    }
                %>

            </tr> 
            <tr>
                <td colspan="6">

                </td>
            </tr>

            <tr>
                <td colspan="6">
                    <div style="float: left">
                        Administrador de la Unidad
                    </div>
                    <div style="float: right">
                        Filtro de la Secretaría de Salud del Estado de México
                    </div>
                    <div style="text-align: center ">
                        Encargado de la Farmacia
                    </div>
                </td>
            </tr>
        </table>
    </body>
</html>
