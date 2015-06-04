<%-- 
    Document   : index
    Created on : 07-mar-2014, 15:38:43
    Author     : Americo
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%    ConectionDB con = new ConectionDB();
    HttpSession sesion = request.getSession();
    String id_usu = "";
    try {
        id_usu = (String) session.getAttribute("id_usu");
    } catch (Exception e) {
    }

    if (id_usu == null) {
        //response.sendRedirect("index.jsp");
    }

    String fol_rec = "", nom_pac = "", fec_sur = "", fec_sur2 = "", id_rec = "", id_tip = "";
    try {
        id_rec = request.getParameter("id_rec");
        id_tip = request.getParameter("id_tip");
        fol_rec = request.getParameter("fol_rec");
        nom_pac = request.getParameter("nom_pac");
        fec_sur = request.getParameter("fec_sur");
        fec_sur2 = request.getParameter("fec_sur2");
    } catch (Exception e) {

    }
    if (fol_rec == null) {
        fol_rec = "";
    }
    if (nom_pac == null) {
        nom_pac = "";
    }
    if (fec_sur == null) {
        fec_sur = "";
    }
    if (fec_sur2 == null) {
        fec_sur2 = "";
    }
    if (id_rec == null) {
        id_rec = "";
    }
    if (id_tip == null) {
        id_tip = "";
    }
    if (!id_tip.equals("")) {
        id_tip = " id_tip = '" + id_tip + "' and ";
    }
    if (!id_rec.equals("")) {
        id_rec = " id_rec = '" + id_rec + "' and ";
    }
    if (!fol_rec.equals("")) {
        fol_rec = " fol_rec = '" + fol_rec + "' and ";
    }
    if (!nom_pac.equals("")) {
        nom_pac = " nom_com like '%" + nom_pac + "%' and ";
    }
    if (!fec_sur.equals("")) {
        fec_sur = " DATE(fecha_hora) between '" + fec_sur + "' and '" + fec_sur2 + "' and ";
    }
%>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); %>
<%java.text.DateFormat df1 = new java.text.SimpleDateFormat("HH:mm:ss"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy");%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Bootstrap -->
        <link href="../css/bootstrap.css" rel="stylesheet" media="screen">
        <link href="../css/pie-pagina.css" rel="stylesheet" media="screen">
        <link href="../css/topPadding.css" rel="stylesheet">
        <link href="../css/cupertino/jquery-ui-1.10.3.custom.css" rel="stylesheet">
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <title>Sistema de Captura de Receta</title>
    </head>
    <body>
        <%@include file="../jspf/mainMenu.jspf"%>
        <br/>
        <div class="container-fluid">
            <div style="width: 90%;margin: auto;">
                <a class="btn btn-default btn-sm" href="modSurteFarmacia.jsp">Surtido de Recetas</a>
                <a class="btn btn-default  btn-sm" href="modSurteFarmaciaP.jsp">Recetas Pendientes</a>
                <a class="btn btn-default btn-sm" href="modRecetasSurtidas.jsp">Recetas Surtidas</a>
                <a class="btn btn-default active btn-sm">Recetas Canceladas</a>
                <h3>Recetas Canceladas</h3>
                <div class="row">
                    <div class="col-lg-4">
                        <div class="panel panel-danger">
                            <div class="panel-heading">
                                Búsqueda de Folios Cancelados
                            </div>
                            <div class="panel-body">
                                <form>
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <input type="radio" name="id_tip" id="id_tip" value="" checked>
                                            Todas
                                            <input type="radio" name="id_tip" id="id_tip" value="1">
                                            Farmacia
                                            <input type="radio" name="id_tip" id="id_tip" value="2">
                                            Colectiva
                                        </div>
                                    </div>
                                    Consecutivo:
                                    <input type="text" class="form-control" name="id_rec" />
                                    Por Folio:
                                    <input type="text" class="form-control" name="fol_rec" />
                                    Por Nombre de Derechohabiente:
                                    <input type="text" onclick="return tabular(event, this);" class="form-control" name="nom_pac" id="nom_pac" placeholder="Derechohabiente" autofocus/>
                                    Por Fecha:
                                    <input type="date" class="form-control" name="fec_sur" id="fec_sur" />
                                    Fin:
                                    <input type="date" class="form-control" name="fec_sur2" id="fec_sur2" />
                                    <button class="btn btn-success btn-block" type="submit">Buscar</button>
                                    <button class="btn btn-warning btn-block" type="submit">Todas</button>
                                </form>
                            </div>
                        </div>
                        <div class="panel panel-danger">
                            <div class="panel-body">
                                <%                                    int numRecetas = 0;
                                    int sumSol = 0, sumSur = 0;
                                    try {
                                        con.conectar();
                                        String qry = "SELECT sum(can_sol) as can_sol, sum(cant_sur) as cant_sur from recetas where 1=1 and " + id_rec + " " + fec_sur + " " + fol_rec + " " + nom_pac + " "+id_tip+"  transito!=1 and baja=1 group by id_rec ";
                                        if (((String) sesion.getAttribute("tipo")).equals("FARMACIA")) {
                                            qry = "SELECT sum(can_sol) as can_sol, sum(cant_sur) as cant_sur from recetas where id_usu='" + id_usu + "' and " + id_rec + " " + fec_sur + " " + fol_rec + " " + nom_pac + " "+id_tip+"  and transito!=1 and baja=1  group by id_rec";
                                        }
                                        ResultSet rset = con.consulta(qry);
                                        while (rset.next()) {
                                            numRecetas++;
                                            sumSol = sumSol + rset.getInt("can_sol");
                                            sumSur = sumSur + rset.getInt("cant_sur");
                                        }
                                    } catch (Exception e) {

                                    }
                                %>
                                <div class="row"><strong class="col-sm-12">Recetas Canceladas: <%=numRecetas%></strong></div>
                                <div class="row"><strong class="col-sm-12">Solicitado: <%=sumSol%></strong></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-8">
                        <div class="panel panel-danger">
                            <div class="panel-heading">
                                Folios Cancelados
                            </div>
                            <div class="panel-body">
                                <%
                                    try {
                                        con.conectar();
                                        String qry = "SELECT DISTINCT(fol_rec), nom_com, fecha_hora, id_rec, id_tip, medico from recetas where 1=1 and " + id_rec + " " + fec_sur + " " + fol_rec + " " + nom_pac + " "+id_tip+"  transito!=1 and baja=1 order by id_rec asc limit 0,50 ;";
                                        if (((String) sesion.getAttribute("tipo")).equals("FARMACIA")) {
                                            qry = "SELECT DISTINCT(fol_rec), nom_com, fecha_hora, id_rec, id_tip, medico from recetas where id_usu='" + id_usu + "' and " + id_rec + " " + fec_sur + " " + fol_rec + " " + nom_pac + " "+id_tip+"  and transito!=1 and baja=1 order by id_rec asc limit 0,50 ;";
                                        }
                                        ResultSet rset = con.consulta(qry);
                                        while (rset.next()) {
                                %>
                                <form action="../Farmacias" name="form_<%=rset.getString(4)%>">
                                    <div class="panel panel-default">
                                        <div class="panel-heading">
                                            <div class="row">
                                                <div class="col-sm-8">
                                                    <h4>No. Rec <%=rset.getString("id_rec")%> || Folio: <%=rset.getString(1)%> ||  <%=rset.getString("medico")%> </h4>
                                                </div>
                                                <div class="hidden">
                                                    <input class="hidden" value="<%=rset.getString(1)%>" name="fol_rec" />
                                                    <input class="hidden" value="<%=rset.getString(4)%>" name="id_rec" />
                                                    <%
                                                        String fol_det = "";
                                                        try {
                                                            ResultSet rset2 = con.consulta("select fol_det from detreceta where id_rec = '" + rset.getString(4) + "' ");
                                                            while (rset2.next()) {
                                                                fol_det = fol_det + rset2.getString(1) + ",";
                                                            }
                                                        } catch (Exception e) {

                                                        }
                                                    %>

                                                    <input class="hidden" name="fol_det" value="<%=fol_det%>" />
                                                </div>
                                                <!--div class="col-sm-3">
                                                    <button class="btn btn-block btn-info" type="button" name="imprimir" id="imprimir" value="imprimir" onclick="window.open('../reportes/RecetaFarm.jsp?fol_rec=<%=rset.getString(1)%>&tipo=<%=rset.getString("id_tip")%>&pag=0', '', 'width=1200,height=800,left=50,top=50,toolbar=no');">Imprimir</button> 
                                                </div>
                                                <div class="col-sm-3">
                                                    <button class="btn btn-block btn-warning" type="button" name="ExpPDF" id="ExpPDF" value="ExpPDF" onclick="window.open('../reportes/RecetaFarmPDF.jsp?folio=<%=rset.getString(1)%>&tipo=<%=rset.getString("id_tip")%>&pag=0', '', 'width=1200,height=800,left=50,top=50,toolbar=no');">Exportar a PDF</button> 
                                                </div-->
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="col-lg-4">
                                                <b>Paciente:</b><br /> <%=rset.getString(2)%> <br>
                                                <b>Fecha y hora:</b><br /><%=df3.format(df2.parse(rset.getString(3)))%>
                                                <br /><%=df1.format(df2.parse(rset.getString(3)))%>
                                            </div>
                                            <div class="col-lg-8">
                                                <table class="table table-bordered">
                                                    <tr>
                                                        <td>Clave:</td>
                                                        <td>Descripcion:</td>
                                                        <td>Solicitado:</td>
                                                        <td>Surtido:</td>
                                                        <td>Indicaciones</td>
                                                    </tr>
                                                    <%
                                                        ResultSet rset2 = con.consulta("select cla_pro, des_pro, can_sol, cant_sur, fol_det, indicaciones from recetas where id_rec = '" + rset.getString(4) + "'  ");
                                                        while (rset2.next()) {
                                                    %>
                                                    <tr>

                                                        <td><%=rset2.getString(1)%></td>
                                                        <td><%=rset2.getString(2)%></td>
                                                        <td><input type="text" class="form-control" value="<%=rset2.getString(3)%>" name="sol_<%=rset2.getString(5)%>" readonly="true" /></td>
                                                        <td><input type="text" class="form-control" value="<%=rset2.getString(4)%>" name="sur_<%=rset2.getString(5)%>" readonly="true" /></td>
                                                        <td><%=rset2.getString(6)%></td>
                                                    </tr>
                                                    <%
                                                        }
                                                    %>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                                <%
                                        }
                                        con.cierraConexion();
                                    } catch (Exception e) {
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>

    <!-- 
    ================================================== -->
    <!-- Se coloca al final del documento para que cargue mas rapido -->
    <!-- Se debe de seguir ese orden al momento de llamar los JS -->
    <script src="../js/jquery-1.9.1.js"></script>
    <script src="../js/bootstrap.js"></script>
    <script src="../js/jquery-ui.js"></script>
    <script type="text/javascript">
                                        $(document).ready(function () {
                                            $("#nom_pac").keyup(function () {
                                                var nombre2 = $("#nom_pac").val();
                                                $("#nom_pac").autocomplete({
                                                    source: "../AutoPacientes?nombre=" + nombre2,
                                                    minLength: 2,
                                                    select: function (event, ui) {
                                                        $("#nom_pac").val(ui.item.nom_com);
                                                        return false;
                                                    }
                                                }).data("ui-autocomplete")._renderItem = function (ul, item) {
                                                    return $("<li>")
                                                            .data("ui-autocomplete-item", item)
                                                            .append("<a>" + item.nom_com + "</a>")
                                                            .appendTo(ul);
                                                };
                                            });
                                        });

                                        function tabular(e, obj) {
                                            tecla = (document.all) ? e.keyCode : e.which;
                                            if (tecla !== 13)
                                                return;
                                            frm = obj.form;
                                            for (i = 0; i < frm.elements.length; i++)
                                                if (frm.elements[i] === obj)
                                                {
                                                    if (i === frm.elements.length - 1)
                                                        i = -1;
                                                    break
                                                }
                                            /*ACA ESTA EL CAMBIO*/
                                            if (frm.elements[i + 1].disabled === true)
                                                tabular(e, frm.elements[i + 1]);
                                            else
                                                frm.elements[i + 1].focus();
                                            return false;
                                        }
    </script>
    </body>
</html>

