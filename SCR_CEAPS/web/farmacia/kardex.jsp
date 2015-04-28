<%-- 
    Document   : kardex
    Created on : 23/02/2015, 05:09:23 PM
    Author     : Americo
--%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%    DecimalFormat formatter = new DecimalFormat("#,###,###");
    DecimalFormat formatter2 = new DecimalFormat("#,###,###.##");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    custom.setDecimalSeparator(',');
    formatter.setDecimalFormatSymbols(custom);
    ConectionDB con = new ConectionDB();
    HttpSession sesion = request.getSession();
    String accion = "";
    accion = request.getParameter("accion");
    if (accion == null) {
        accion = "";
    }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Estilos CSS -->
        <link href="../css/bootstrap.css" rel="stylesheet">
        <link rel="stylesheet" href="../css/cupertino/jquery-ui-1.10.3.custom.css" />
        <link href="../css/navbar-fixed-top.css" rel="stylesheet">
        <!---->
        <title>Kardex</title>
    </head>
    <body>
        <%@include file="../jspf/mainMenu.jspf" %>%>
        <div class="container" style="padding-top: 50px">
            <h1>Kardex</h1>
            <hr/>
            <div class="row">
                <form action="kardex.jsp" method="post">
                    <div class="col-sm-2">
                        <input class="form-control" placeholder="Código de Barras" name="cb" />
                    </div>
                    <div class="col-sm-2">
                        <input class="form-control" placeholder="Clave" name="cla_pro" />
                    </div>
                    <div class="col-sm-1">
                        <button class="btn btn-primary btn-block" name="accion" value="buscarInsumo"><span class="glyphicon glyphicon-search"></span></button>
                    </div>
                </form>
            </div>
            <hr/>
            <%
                try {
                    con.conectar();
                    if (accion.equals("buscarInsumo")) {
                        ResultSet rset = con.consulta("select cla_pro, des_pro from productos p, tb_codigob cb where p.cla_pro = cb.F_Clave and (p.cla_pro = '" + request.getParameter("cla_pro") + "' or cb.F_Cb='" + request.getParameter("cb") + "') group by cla_pro");
                        while (rset.next()) {
            %>
            <form action="kardex.jsp" method="get">
                <div class="row">
                    <h4 class="col-sm-12">
                        <input class="hidden" placeholder="Clave" name="cla_pro" value="<%=rset.getString("cla_pro")%>" />
                        Clave: <%=rset.getString("cla_pro")%>
                    </h4> 

                    <h4 class="col-sm-12">
                        Descripción: <%=rset.getString("des_pro")%>
                    </h4> 
                </div>
                <div class="row">
                    <div class="col-sm-2">
                        <select class="form-control" name="id_ori">
                            <option value="">Origen</option>
                            <%
                                ResultSet rset2 = con.consulta("select dp.id_ori, o.des_ori from detalle_productos dp, origen o where dp.id_ori = o.id_ori and dp.cla_pro = '" + rset.getString("cla_pro") + "' group by id_ori order by id_ori");
                                while (rset2.next()) {
                            %>
                            <option value="<%=rset2.getString("id_ori")%>"><%=rset2.getString("des_ori")%></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="col-sm-2">
                        <select class="form-control" onchange="cambiaLoteCadu(this);" name="lot_pro">
                            <option value="">Lote</option>
                            <%
                                rset2 = con.consulta("select lot_pro from detalle_productos where cla_pro = '" + rset.getString("cla_pro") + "' ");
                                while (rset2.next()) {
                            %>
                            <option value="<%=rset2.getString("lot_pro")%>"><%=rset2.getString("lot_pro")%></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="col-sm-2">
                        <select class="form-control" id="Cadu" name="cad_pro">
                            <option value="">Caducidad</option>
                            <%
                                rset2 = con.consulta("select cad_pro from detalle_productos where cla_pro = '" + rset.getString("cla_pro") + "' ");
                                while (rset2.next()) {
                            %>
                            <option value="<%=rset2.getString("cad_pro")%>"><%=rset2.getString("cad_pro")%></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="col-sm-1">
                        <button class="btn btn-primary btn-block" name="accion" value="buscarLote"><span class="glyphicon glyphicon-search"></span></button>
                    </div>
                </div>
            </form>
            <%                }
                }
                if (accion.equals("buscarLote")) {
                    ResultSet rset = con.consulta("select cla_pro, des_pro from productos p, tb_codigob cb where p.cla_pro = cb.F_Clave and (p.cla_pro = '" + request.getParameter("cla_pro") + "' or cb.F_Cb='" + request.getParameter("cb") + "') group by cla_pro");
                    while (rset.next()) {
            %>
            <form action="kardex.jsp" method="get">
                <div class="row">
                    <h4 class="col-sm-12">
                        <input class="hidden" placeholder="Clave" name="cla_pro" value="<%=rset.getString("cla_pro")%>" />
                        Clave: <%=rset.getString("cla_pro")%>
                    </h4> 

                    <h4 class="col-sm-12">
                        Descripción: <%=rset.getString("des_pro")%>
                    </h4> 
                </div>
                <div class="row">
                    <div class="col-sm-2">
                        <select class="form-control" name="id_ori">
                            <option value="">Origen</option>
                            <%
                                ResultSet rset2 = con.consulta("select dp.id_ori, o.des_ori from detalle_productos dp, origen o where dp.id_ori = o.id_ori and dp.cla_pro = '" + rset.getString("cla_pro") + "' group by id_ori order by id_ori");
                                while (rset2.next()) {
                            %>
                            <option value="<%=rset2.getString("id_ori")%>"><%=rset2.getString("des_ori")%></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="col-sm-2">
                        <select class="form-control" onchange="cambiaLoteCadu(this);" name="lot_pro">
                            <option value="">Lote</option>
                            <%
                                rset2 = con.consulta("select lot_pro from detalle_productos where cla_pro = '" + rset.getString("cla_pro") + "' ");
                                while (rset2.next()) {
                            %>
                            <option value="<%=rset2.getString("lot_pro")%>"><%=rset2.getString("lot_pro")%></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="col-sm-2">
                        <select class="form-control" id="Cadu" name="cad_pro">
                            <option value="">Caducidad</option>
                            <%
                                rset2 = con.consulta("select cad_pro from detalle_productos where cla_pro = '" + rset.getString("cla_pro") + "' ");
                                while (rset2.next()) {
                            %>
                            <option value="<%=rset2.getString("cad_pro")%>"><%=rset2.getString("cad_pro")%></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="col-sm-1">
                        <button class="btn btn-primary btn-block" name="accion" value="buscarLote"><span class="glyphicon glyphicon-search"></span></button>
                    </div>
                </div>
            </form>
            <hr/>
            <div class="panel panel-info">
                <div class="panel-heading">
                    Entradas
                </div>
                <div class="panel-body">
                    <table class="table table-bordered table-condensed table-striped">
                        <tr>
                            <td>Clave</td>
                            <td>Lote</td>
                            <td>Caducidad</td>
                            <td>Origen</td>
                            <td>Cantidad</td>
                            <td>Tipo Mov</td>
                            <td>Abasto</td>
                            <td>Fecha</td>
                            <td>Observaciones</td>
                        </tr>
                        <%
                            rset2 = con.consulta("select * from ventradas where cla_pro = '" + request.getParameter("cla_pro") + "' and lot_pro = '" + request.getParameter("lot_pro") + "' and cad_pro = '" + request.getParameter("cad_pro") + "' and id_ori = '" + request.getParameter("id_ori") + "' ");
                            while (rset2.next()) {
                        %>
                        <tr>
                            <td><%=rset2.getString("cla_pro")%></td>
                            <td><%=rset2.getString("lot_pro")%></td>
                            <td><%=rset2.getString("cad_pro")%></td>
                            <td><%=rset2.getString("id_ori")%></td>
                            <td><%=rset2.getString("cant")%></td>
                            <td><%=rset2.getString("tipo_mov")%></td>
                            <td><%=rset2.getString("fol_aba")%></td>
                            <td><%=rset2.getString("fecha")%></td>
                            <td><%=rset2.getString("obser")%></td>
                        </tr>
                        <%
                            }
                        %>
                    </table>
                </div>
            </div>
            <div class="panel panel-warning">
                <div class="panel-heading">
                    Salidas
                </div>
                <div class="panel-body">
                    <table class="table table-bordered table-condensed table-striped">
                        <tr>
                            <td>Clave</td>
                            <td>Lote</td>
                            <td>Caducidad</td>
                            <td>Origen</td>
                            <td>Cantidad</td>
                            <td>Tipo Mov</td>
                            <td>FolReceta</td>
                            <td>Paciente</td>
                            <td>Médico</td>
                            <td>Fecha</td>
                            <td>Observaciones</td>
                        </tr>
                        <%
                            rset2 = con.consulta("select * from vsalidas where cla_pro = '" + request.getParameter("cla_pro") + "' and lot_pro = '" + request.getParameter("lot_pro") + "' and cad_pro = '" + request.getParameter("cad_pro") + "' and id_ori = '" + request.getParameter("id_ori") + "' union select * from vsalidasajustes where cla_pro = '" + request.getParameter("cla_pro") + "' and lot_pro = '" + request.getParameter("lot_pro") + "' and cad_pro = '" + request.getParameter("cad_pro") + "' and id_ori = '" + request.getParameter("id_ori") + "' ");
                            while (rset2.next()) {
                        %>
                        <tr>
                            <td><%=rset2.getString("cla_pro")%></td>
                            <td><%=rset2.getString("lot_pro")%></td>
                            <td><%=rset2.getString("cad_pro")%></td>
                            <td><%=rset2.getString("id_ori")%></td>
                            <td><%=rset2.getString("cant")%></td>
                            <td><%=rset2.getString("tipo_mov")%></td>
                            <td><%=rset2.getString("fol_rec")%></td>
                            <td><%=rset2.getString("paciente")%></td>
                            <td><%=rset2.getString("medico")%></td>
                            <td><%=rset2.getString("fecha")%></td>
                            <td><%=rset2.getString("obser")%></td>
                        </tr>
                        <%
                            }
                        %>
                    </table>
                </div>
            </div>
            <%
                        }
                    }
                    con.cierraConexion();
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
            <h4></h4>
        </div>
        <script src="../js/jquery-1.9.1.js"></script>
        <script src="../js/bootstrap.js"></script>
        <script src="../js/jquery-ui.js"></script>
        <script>
                            function cambiaLoteCadu(elemento) {
                                var indice = elemento.selectedIndex;
                                document.getElementById('Cadu').selectedIndex = indice;
                            }
        </script>
    </body>
</html>
