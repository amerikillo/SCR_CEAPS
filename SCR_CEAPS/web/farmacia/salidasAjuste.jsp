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
    String accion = "", F_DesPro = "";
    String id_usu = "";
    String cla_uni = "";
    try {
        id_usu = (String) session.getAttribute("id_usu");
    } catch (Exception e) {
    }

    accion = request.getParameter("accion");
    if (accion == null) {
        accion = "";
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

    int existencia = 0, id_inv = 0;
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
        <title>Salidas por Ajuste</title>
    </head>
    <body>
        <%@include file="../jspf/mainMenu.jspf" %>%>
        <div class="container" style="padding-top: 50px">
            <h1>Salidas por Ajuste (-)</h1>
            <hr/>
            <div class="row">
                <form action="salidasAjuste.jsp" method="post">
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
                            F_DesPro = rset.getString("des_pro");
            %>
            <form action="salidasAjuste.jsp" method="post">
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
                                ResultSet rset2 = con.consulta("select id_ori from existencias where cla_pro = '" + rset.getString("cla_pro") + "' and cla_uni='" + cla_uni + "' group by id_ori order by id_ori");
                                while (rset2.next()) {
                            %>
                            <option value="<%=rset2.getString("id_ori")%>"><%=rset2.getString("id_ori")%></option>
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
                        F_DesPro = rset.getString("des_pro");

            %>
            <form action="salidasAjuste.jsp" method="post">
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
            <div class="hidden">
                <h4 class="col-sm-3">Clave: <%=request.getParameter("cla_pro")%></h4>
                <h4 class="col-sm-9">Descripción: <%=F_DesPro%></h4>
            </div>
            <div class="row">
                <h4 class="col-sm-4">Lote: <%=request.getParameter("lot_pro")%></h4>
                <h4 class="col-sm-4">Caducidad: <%=request.getParameter("cad_pro")%></h4>
                <h4 class="col-sm-4">Origen: <%=request.getParameter("id_ori")%></h4>
            </div>

            <%
                rset2 = con.consulta("select cant, id_inv from existencias where cla_pro = '" + request.getParameter("cla_pro") + "' and lot_pro = '" + request.getParameter("lot_pro") + "' and cad_pro = '" + request.getParameter("cad_pro") + "' and id_ori = '" + request.getParameter("id_ori") + "' ");
                while (rset2.next()) {
                    existencia = rset2.getInt("cant");
                    id_inv = rset2.getInt("id_inv");
            %>
            <div class="row">
                <h4 class="col-sm-2">Cantidad Existente</h4>
                <div class="col-sm-2">
                    <input class="form-control" value="<%=rset2.getInt("cant")%>" readonly />
                </div>
            </div>
            <%
                    }
                }
            %>
            <form action="../Existencias">
                <input class="hidden" name="id_inv" value="<%=id_inv%>">
                <div class="row">
                    <h4 class="col-sm-2">Cantidad del ajuste</h4>
                    <div class="col-sm-2">
                        <input class="form-control" type="number" max="<%=existencia%>" name="cantAjuste" required/>
                    </div>
                </div>
                    <textarea class="form-control" rows="5" required placeholder="Justificación" name="obs"></textarea>
                <br/>
                <button class="btn btn-block btn-primary" name="accion" value="salidaAjuste">Ajustar(-)</button>
            </form> 
            <%
                    }
                    con.cierraConexion();
                } catch (Exception e) {
                    System.out.println(e);
                    out.println(e.getMessage());
                }
            %>

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
