<%-- 
    Document   : AdministrarUnidades
    Created on : 29/04/2015, 04:29:02 PM
    Author     : ALEJO (COL)
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    ConectionDB con = new ConectionDB();

    con.conectar();

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="../css/bootstrap.css" rel="stylesheet" media="screen">
        <link href="../css/pie-pagina.css" rel="stylesheet" media="screen">
        <link href="../css/topPadding.css" rel="stylesheet">
        <link href="../css/datepicker3.css" rel="stylesheet">
        <link href="../css/dataTables.bootStrap.css" rel="stylesheet">
        <link href="../css/cupertino/jquery-ui-1.10.3.custom.css" rel="stylesheet">
        <title>Administrar Unidades</title>
    </head>
    <body>
        <div class="container">
            <h1>Administrar Unidades</h1>
            <div class="panel panel-body">
                <form id="frmUnidad">
                    <div class="row">
                        <label class="col-sm-2 h3">Crear Unidad</label>
                    </div><hr/>
                    <div class="row">
                        <label class="col-sm-1">Clave</label>
                        <div class="col-sm-1">
                            <input type="text" class="form-control" id="claUni" name="claUni" value="">
                        </div>
                        <label class="col-sm-2">Nombre Unidad</label>
                        <div class="col-sm-3">
                            <input type="text" class="form-control" id="nombreUni" name="nombreUni" value="">
                        </div>
                        <label class="col-sm-2 control-label">Clave ISEM</label>
                        <div class="col-sm-2">
                            <input type="text" value="" id="claIsem" name="claIsem" class="form-control">
                        </div>
                    </div><br/>
                    <div class="row">
                        <label class="col-sm-2">N° De Licencia</label>
                        <div class="col-sm-2">
                            <input class="form-control" type="text" id="lic" name="lic" value="">
                        </div>
                    </div><br/>
                    <div class="row">
                        <label class="col-sm-2">Jurisdicción</label>
                        <div class="col-sm-3">
                            <input type="hidden" value="" id="hJur">
                            <input readonly type="text" class="form-control" id="txtJur" name="txtJur" value="">
                        </div>
                        <div class="col-sm-3">
                            <select class="form-control" id="slcJur" name="slcJur">
                                <option value="">--Seleccione--</option>
                                <option title="esto" value="1">Eto</option>
                                <%                                    try {
                                        ResultSet rs = con.consulta("Select cla_jur,des_jur from jurisdicciones");
                                        while (rs.next()) {
                                            out.print("<option value='" + rs.getString(1) + "'>" + rs.getString(2) + "</option>");
                                        }
                                    } catch (Exception ex) {
                                        System.out.println("ErrorJ->" + ex);
                                    }
                                %>
                            </select>
                        </div>
                    </div><br/>
                    <div class="row">
                        <label class="col-sm-2">Municipio</label>
                        <div class="col-sm-3">
                            <input type="hidden" id="hMuni">
                            <input readonly type="text" class="form-control" id="txtMuni" name="txtMuni" value="">
                        </div>
                        <div class="col-sm-3">
                            <div id="divMuni">
                                <select class="form-control" id="slcMuni" onchange="slcMunicipio()" name="slcMuni">
                                    <option value="">--Seleccione--</option>
                                    <%
                                        try {
                                            ResultSet rs = con.consulta("Select cla_mun,des_mun from municipios where cla_jur='" + session.getAttribute("cla_jur") + "'");
                                            while (rs.next()) {
                                                out.print("<option value='" + rs.getString(1) + "'>" + rs.getString(2) + "</option>");
                                            }
                                        } catch (Exception ex) {
                                            System.out.println("ErrorM->" + ex);
                                        }
                                        session.setAttribute("cla_jur", "");
                                    %>
                                </select>
                            </div>
                        </div>
                    </div><br/>
                    <div class="row">
                        <label class="col-sm-2">Dirección</label>
                        <div class="col-sm-6">
                            <input type="text" class="form-control" id="dir" name="dir" value="">
                        </div>
                    </div><br/>
                    <div class="row">
                        <center><button type="button" class="btn btn-primary" id="Guardar" name="Guardar">Guardar</button> <input type="reset" class="btn btn-primary" value="Nuevo"></center>
                    </div><hr/>
                </form>
            </div>
        </div>
    <div class="container" style="max-width: 1600px">
        <table class="table table-bordered" id="tbUni">
            <thead>
                <tr>
                    <th class="h3 text-center" colspan="8">Unidades</th>
                </tr>
                <tr>
                    <th>Clave</th>
                    <th>Nombre</th>
                    <th>Clave ISEM</th>
                    <th>Jurisdicción</th>
                    <th>Municipio</th>
                    <th>Dirección</th>
                    <th>Licencia</th>
                    <th>Editar</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        ResultSet rs = con.consulta("SELECT unidades.cla_uni, unidades.des_uni, unidades.claisem, jurisdicciones.des_jur, municipios.des_mun, unidades.domic,jurisdicciones.cla_jur,municipios.cla_mun,unidades.licencia FROM unidades INNER JOIN municipios ON unidades.cla_mun = municipios.cla_mun INNER JOIN jurisdicciones ON municipios.cla_jur = jurisdicciones.cla_jur  ");
                        while (rs.next()) {
                            
                %>
                <tr>
                    <td><%=rs.getString(1)%></td>
                    <td><%=rs.getString(2)%></td>
                    <td><%=rs.getString(3)%></td>
                    <td><%=rs.getString(4)%></td>
                    <td><%=rs.getString(5)%></td>
                    <td><%=rs.getString(6)%></td>
                    <td><%=rs.getString(9)%></td>
                    <td><a class="btn btn-sm btn-warning" id="btnModi" onclick="Editar('<%=rs.getString(1)%>','<%=rs.getString(2)%>','<%=rs.getString(3).trim()%>','<%=rs.getString(4)%>','<%=rs.getString(5).trim()%>','<%=rs.getString(6)%>','<%=rs.getString(7)%>','<%=rs.getString(8)%>','<%=rs.getString(9)%>')"><span class="glyphicon glyphicon-edit"></span></a></td>
                </tr>
                <%   //        
                        }
                    } catch (Exception ex) {
                        System.out.println("ErrorTable->" + ex);
                    }
                %>
            </tbody>
        </table>                    
    </div>
    <%            con.cierraConexion();
    %>
    <script src="../js/jquery-1.9.1.js"></script>
    <script src="../js/bootstrap.js"></script>
    <script src="../js/jquery-ui.js"></script>
    <script src="../js/jquery.dataTables.js"></script>
    <script src="../js/dataTables.bootstrap.js"></script>
    <script type="text/javascript">
                                function slcMunicipio() {
                                    var dir = "../Unidades";
                                    $.ajax({
                                        url: dir,
                                        data: {que: 'Muni', id: $('#slcMuni').val()},
                                        success: function (data) {
                                            $('#hMuni').val($('#slcMuni').val());
                                            $('#txtMuni').val(data);
                                        },
                                        error: function () {
                                            alert("Ha ocurrido un error");
                                        }
                                    });
                                }
                                function Editar(id,nom,cla,jur,muni,dir,idJ,idM,lic){                                                                       
                                    $('#claUni').val(id);
                                    $('#nombreUni').val(nom);
                                    $('#claIsem').val(cla);
                                    $('#txtJur').val(jur);
                                    $('#txtMuni').val(muni);
                                    $('#dir').val(dir);
                                    $('#hJur').val(idJ);
                                    $('#hMuni').val(idM);
                                    $('#lic').val(lic);
                                }
                                $(document).ready(function () {
                                    $('#tbUni').dataTable();

                                    $('#slcJur').change(function () {
                                        $('#txtMuni').val("");
                                        var dir = "../Unidades";
                                        $.ajax({
                                            url: dir,
                                            data: {que: 'Jur', id: $('#slcJur').val()},
                                            success: function (data) {
                                                $('#divMuni').load('AdministrarUnidades.jsp #divMuni');
                                                $('#hJur').val($('#slcJur').val());
                                                $('#txtJur').val(data);
                                            },
                                            error: function () {
                                                alert("Ha ocurrido un error");
                                            }
                                        });
                                    });
                                    
                                    $('#Guardar').click(function () {                                        
                                        var dir = "../Unidades";
                                        if ($('#claUni').val() === "" || $('#nombreUni').val() === "" || $('#claIsem').val() === "" || $('#txtJur').val() === "" || $('#txtMuni').val() === "" || $('#dir').val() === "" || $('#lic').val()==="") {
                                            alert("Tiene campos vacios, porfavor verifique");
                                            return false;
                                        }
                                        $.ajax({
                                            url: dir,
                                            data: {que: 'G',id:$('#claUni').val(), nombreUni: $('#nombreUni').val(), claIsem: $('#claIsem').val(), jur: $('#hJur').val(), dir: $('#dir').val(),muni:$('#hMuni').val(),lic:$('#lic').val()},
                                            success: function (data) {
                                                alert(data);
                                                window.location.reload();
                                            },
                                            error: function () {
                                                alert("Ha ocurrido un error");
                                            }
                                        });
                                    });
                                });
    </script>
</body>
</html>
