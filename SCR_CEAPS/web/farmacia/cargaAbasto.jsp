<%-- 
    Document   : index
    Created on : 07-mar-2014, 15:38:43
    Author     : Americo
--%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%    DecimalFormat formatter = new DecimalFormat("#,###,###");
    HttpSession sesion = request.getSession();
    String id_usu = "", ver = "hidden";
    ConectionDB con = new ConectionDB();
    try {
        id_usu = (String) session.getAttribute("id_usu");
    } catch (Exception e) {
    }

    if (id_usu == null) {
        response.sendRedirect("index.jsp");
    }
    ArrayList pass = new ArrayList();
    try {
        con.conectar();
        ResultSet rset = con.consulta("select pass from usuarios where id_usu='" + id_usu + "'");
        while (rset.next()) {
            pass.add(rset.getString(1));
        }
        con.cierraConexion();
    } catch (Exception e) {
    }

    for (int i = 0; i < pass.size(); i++) {
        System.out.println(pass.get(i));
    }
    if (sesion.getAttribute("ver") != null) {
        if (sesion.getAttribute("ver").toString().equals("si")) {
            ver = "";
        } else {
            ver = "hidden";
        }
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Bootstrap -->
        <link href="../css/bootstrap.css" rel="stylesheet" media="screen">
        <link href="../css/topPadding.css" rel="stylesheet">
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <title>SIALSS</title>
    </head>
    <body>
        <%@include file="../jspf/mainMenu.jspf"%>
        <br/>
        <div class="container">
            <div class="container" style="width: 600px;">
                <h2>Cargar Abasto</h2>

                <form name="cargaAbasto" method="POST" enctype="multipart/form-data" action="../FileUploadServlet" onsubmit="funcionCarga()">
                    <div class="row">
                        <label class="form-horizontal col-lg-4">Seleccione un archivo:</label>
                        <div class="col-lg-8">
                            <input type="file" class="form-control" name="archivo" accept="text/csv">
                        </div>
                    </div>
                    <br />
                    <div class="row">
                        <label class="form-horizontal col-lg-4">Contraseña:</label>
                        <div class="col-lg-8">
                            <input type="password" id="contra" placeholder="Contraseña de Administrador" class="form-control">
                        </div>
                    </div>
                    <br />
                    <div class="col-lg-12">
                        <button class="btn btn-primary btn-block" onclick="return comparaClave();" id="btnCarga">Cargar</button>
                    </div>
                </form>
            </div>          
            <div class="row" id="imgCarga">
                <div class="col-md-12 text-center">
                    <img src="../imagenes/ajax-loader-1.gif" width=100 alt="Logo">
                </div>
            </div>
            <br/><br/>

            <div class="panel <%=ver%>"  id="paAbasto">
                <%
                    try {
                        con.conectar();
                        ResultSet rs = con.consulta("Select sum(cantidad) from carga_abasto");
                        while (rs.next()) {
                %>

                <h3>Total de piezas: <%=formatter.format(rs.getInt(1))%></h3>
                <%
                        }
                        con.cierraConexion();
                    } catch (Exception e) {

                    }
                %>
                <table id="tbAbastos" class="table table-bordered">
                    <thead>
                        <tr>
                            <th class="h2 text-center" colspan="7">Abasto</th>
                        </tr>
                        <tr>
                            <th></th>
                            <th>Clave</th>
                            <th>Lote</th>
                            <th>Caducidad</th>
                            <th>Cantidad</th>
                            <th>Origen</th>
                            <th class="hidden">Codigo Barras</th>
                            <th>Editar</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                con.conectar();
                                ResultSet rs = con.consulta("Select clave,lote,caducidad,cantidad,origen,cb,id from carga_abasto");
                                while (rs.next()) {

                                    String cadu = "1";
                                    String caducado = "";
                                    if (rs.getDate(3).before(new Date())) {
                                        cadu = "0";
                                        caducado = "class='danger'";
                                    }
                        %>
                        <tr id="f_<%=rs.getString(7)%>" <%=caducado%> >
                            <td><div class="hidden"><%=cadu%></div></td>
                            <td><%=rs.getString(1)%></td>
                            <td><%=rs.getString(2)%></td>
                            <td><%=rs.getString(3)%></td>
                            <td><%=rs.getString(4)%></td>
                            <td><%=rs.getString(5)%></td>
                            <td class="hidden"><%=rs.getString(6)%></td>
                            <td><a class="btn btn-warning" id="Editar" onclick="EditarAb(<%=rs.getString(7)%>)" data-toggle="modal" data-target="#EditarAbasto"><span class="glyphicon glyphicon-edit"></span></a></td>
                        </tr>
                        <%
                                }
                                con.cierraConexion();
                            } catch (Exception ex) {
                                System.out.println("ErrorC->" + ex);
                            }
                        %>
                    </tbody>
                </table>
                <center> <button type="button" class="btn btn-primary btn-lg" id="ValidarAbasto" onclick="return confirm('Desea validar el abasto?')">Validar Abasto</button></center>
            </div>
            <div class="progress hidden" id="loadProg"></div>
        </div>

        <br>
        <br>
        <div class="row">
            <div class="col-md-12 text-center">
                <img src="../imagenes/medalfaLogo.png" width=100 alt="Logo">
            </div>
        </div>

        <div id="EditarAbasto" class="modal fade in" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <a data-dismiss="modal" class="close">×</a>
                        <h3>Editar Clave</h3>
                    </div>
                    <div class="modal-body">
                        <div class="panel panel-body">
                            <table id="tbEditaClave">
                                <%
                                    String clave = "", lote = "", caduc = "", cant = "", ori = "", cb = "", id = "";
                                    try {
                                        con.conectar();
                                        ResultSet rs = con.consulta("Select clave,lote,caducidad,cantidad,origen,cb,id from carga_abasto where id='" + session.getAttribute("id") + "'");
                                        if (rs.next()) {
                                            clave = rs.getString(1);
                                            lote = rs.getString(2);
                                            caduc = rs.getString(3);
                                            cant = rs.getString(4);
                                            ori = rs.getString(5);
                                            cb = rs.getString(6);
                                            id = rs.getString(7);

                                        }
                                    } catch (Exception ex) {
                                        System.out.println("ErrorEC->" + ex);
                                    }
                                %>
                                <tr>
                                    <td>
                                        <div class="row">
                                            <input type="hidden" id="hId" value="<%=id%>">
                                            <label class="col-sm-2">Clave</label>
                                            <div class="col-sm-2">
                                                <input class="form-control" name="clave" id="clave" type="text" disabled value="<%=clave%>">
                                            </div>
                                            <label class="col-sm-1">Lote</label>
                                            <div class="col-sm-2">
                                                <input class="form-control" name="lote" id="lote" type="text" value="<%=lote%>">
                                            </div>
                                            <label class="col-sm-2">Caducidad</label>
                                            <div class="col-sm-3">
                                                <input class="form-control" name="caduc" id="caduc" type="date" value="<%=caduc%>">
                                            </div>
                                        </div><br/> 
                                        <div class="row">
                                            <label class="col-sm-2">Cantidad</label>
                                            <div class="col-sm-2">
                                                <input class="form-control" name="cant" onkeypress="isNumberKey(event, this)" id="cant" type="number" value="<%=cant%>" min="0">
                                            </div>
                                            <label class="col-sm-1">Origen</label>
                                            <div class="col-sm-2">
                                                <input class="form-control" name="ori" id="ori" type="text" value="<%=ori%>">
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>                            
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" id="Guardar" name="Guardar" value="Guardar">Guardar</button>
                        <a href="#" data-dismiss="modal" class="btn btn-primary">Cerrar</a>
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
        <script src="../js/md5.js"></script>
        <script src="../js/jquery.dataTables.js"></script>
        <script src="../js/dataTables.bootstrap.js"></script>
        <script src="../js/jquery.progressTimer.js"></script>
        <script type="text/javascript">
                                                    $(document).ready(function() {
                                                        $('#imgCarga').toggle();
                                                        $('#tbAbastos').dataTable();
                                                    });

                                                    function funcionCarga() {
                                                        $('#btnCarga').attr('disabled', true);
                                                        $('#imgCarga').toggle();
                                                    }
                                                    function comparaClave() {
                                                        var pass = document.getElementById('contra').value;
                                                        var result = CryptoJS.MD5(pass);
                                                        result = result + "";
            <%                for (int i = 0; i < pass.size(); i++) {
            %>

                                                        if (result === "<%=pass.get(i)%>") {
                                                            alert("Datos correctos");
                                                            return true;
                                                        }
            <%
                }
            %>
                                                        alert("Datos incorrectos");
                                                        return false;
                                                    }
                                                    function EditarAb(id) {
                                                        var dir = "../EditaAbasto";
                                                        $.ajax({
                                                            url: dir,
                                                            data: {que: "V", id: id},
                                                            success: function(data) {
                                                                $('#tbEditaClave').load('cargaAbasto.jsp #tbEditaClave');
                                                            },
                                                            error: function() {
                                                                alert("Ocurrió un error");
                                                            }
                                                        });
                                                    }
                                                    $('#Guardar').click(function() {
                                                        if ($('#lote').val() === "" || $('#caduc').val() === "" || $('#cant').val() === "" || $('#ori').val() === "") {
                                                            alert("Hay campos vacios, por favor verifique");
                                                            return false;
                                                        }
                                                        var ori = $('#ori').val();
                                                        if (!(ori === "2" || ori === "1")) {
                                                            alert("El origen debe ser 1 o 2");
                                                            $('#ori').val("");
                                                            return false;
                                                        }
                                                        var cant = $('#cant').val();
                                                        if (parseInt(cant) < 0) {
                                                            alert("La Cantidad no puede ser menor a 0");
                                                            $('#cant').focus();
                                                            return false;
                                                        }
                                                        var id = $('#hId').val();
                                                        var dir = "../EditaAbasto";
                                                        $.ajax({
                                                            url: dir,
                                                            data: {que: "E", id: id, lote: $('#lote').val(), caduc: $('#caduc').val(), cant: $('#cant').val(), ori: $('#ori').val()},
                                                            success: function(data) {
                                                                var json = JSON.parse(data);
                                                                if (json.msg === "0") {
                                                                    alert('Error al Editar');
                                                                } else {
                                                                    $('#f_' + id).html("<td></td><td>" + json.clave + "</td>" +
                                                                            "<td>" + json.lote + "</td>" +
                                                                            "<td>" + json.caducidad + "</td>" +
                                                                            "<td>" + json.cantidad + "</<td>" +
                                                                            "<td>" + json.origen + "</<td>" +
                                                                            "<td>" + json.editar + "</<td>");
                                                                    $('#EditarAbasto').click();
                                                                }
                                                            },
                                                            error: function() {
                                                                alert("Ocurrió un error");
                                                            }
                                                        });
                                                    });

                                                    $('#ValidarAbasto').click(function() {
                                                        var dir = "../EditaAbasto";
                                                        $('#ValidarAbasto').attr("disabled", "disabled");
                                                        $("#loadProg").removeClass("hidden");
                                                        var progress = $("#loadProg").progressTimer({
                                                            timeLimit: 150,
                                                            onFinish: function() {
                                                            }
                                                        });
                                                        $.ajax({
                                                            url: dir,
                                                            data: {que: "Val"},
                                                            success: function(data) {
                                                                progress.progressTimer('complete');
                                                                alert(data);
                                                                window.location.reload();
                                                            },
                                                            error: function() {
                                                                alert("Ocurrió un error");
                                                                $("#loadProg").addClass()("hidden");
                                                                $('#ValidarAbasto').attr("disabled", "");
                                                            }
                                                        });
                                                    });
                                                    function isNumberKey(evt, obj)
                                                    {
                                                        var charCode = (evt.which) ? evt.which : event.keyCode;
                                                        if (charCode === 13 || charCode > 31 && (charCode < 48 || charCode > 57)) {
                                                            if (charCode === 13) {
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
                                                            return false;
                                                        }
                                                        return true;

                                                    }
        </script>
        <br/>
    </body>
</html>


