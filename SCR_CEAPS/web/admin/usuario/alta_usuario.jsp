<%-- 
    Document   : alta_pacientes
    Created on : 10-mar-2014, 9:14:09
    Author     : Americo
--%>
<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyyMMddhhmmss"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
<%
    HttpSession sesion = request.getSession();
    DecimalFormat formatter = new DecimalFormat("#,###,###");
    DecimalFormat formatter2 = new DecimalFormat("#,###,###.##");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    ResultSet rset;
    ConectionDB con = new ConectionDB();
    String que = "", titulo = "Alta de Usuarios", nombre = "", user = "", apeP = "", apeM = "", ocultarA = "hidden", ocultarG = "", disa = "", id = "", uni = "", pass = "", form = "../../Usuarios";
    if (request.getParameter("que") == null) {
        que = "";
    } else {
        que = request.getParameter("que");
    }
    con.conectar();
    ResultSet rs = con.consulta("SELECT uni.cla_uni,uni.des_uni FROM unidades AS uni INNER JOIN usuarios AS u ON u.cla_uni = uni.cla_uni WHERE u.id_usu = '" + sesion.getAttribute("id_usu") + "'");
    if (rs.next()) {
        uni = rs.getString(2);
    }
    if (que.equals("edi")) {
        id = request.getParameter("id");

        rset = con.consulta("SELECT us.id_usu, us.nombre, us.user, us.ape_pat, us.ape_mat, uni.des_uni,us.passReal FROM usuarios AS us INNER JOIN unidades AS uni ON us.cla_uni = uni.cla_uni where us.id_usu='" + id + "'");
        if (rset.next()) {
            id = rset.getString(1);
            nombre = rset.getString(2);
            user = rset.getString(3);
            apeP = rset.getString(4);
            apeM = rset.getString(5);
            uni = rset.getString(6);
            pass = rset.getString(7);
            titulo = "Edición de Usuarios";
            ocultarA = "";
            ocultarG = "hidden";
            disa = "disabled";
            form = "";
        }
    }

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Bootstrap -->
        <link href="../../css/bootstrap.css" rel="stylesheet" media="screen">
        <link href="../../css/pie-pagina.css" rel="stylesheet" media="screen">
        <link href="../../css/topPadding.css" rel="stylesheet">
        <link href="../../css/datepicker3.css" rel="stylesheet">
        <link href="../../css/cupertino/jquery-ui-1.10.3.custom.css" rel="stylesheet">
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <title>JSP Page</title>
    </head>
    <body>
        <%@include file="../../jspf/mainMenu.jspf" %>
        <div class="container">
            <div class="container">
                <div class="row">
                    <div class="col-lg-10">
                        <h3><%=titulo%></h3>
                    </div>
                    <div class="col-lg-2">
                        <!--a class="btn btn-block btn-danger" href="pacientes.jsp">Regresar</a-->
                    </div>
                </div>
                <div class="panel panel-default">
                    <form class="form-horizontal" role="form" name="formulario_pacientes" id="formulario_pacientes" method="get" action="<%=form%>">
                        <div class="panel-body">                            
                            <div class="row">
                                <label for="ape_pat" class="col-sm-2 control-label">Apellido Paterno</label>
                                <div class="col-sm-4">
                                    <input type="hidden" id="id_usu" value="<%=id%>">
                                    <input type="text" class="form-control" id="ape_pat" name="ape_pat" placeholder="" onkeyup="upperCase(this.id)"  value="<%=apeP%>"/>
                                </div>
                                <label for="ape_mat" class="col-sm-2 control-label">Apellido Materno</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" id="ape_mat" name="ape_mat" placeholder="" onkeyup="upperCase(this.id)" value="<%=apeM%>"/>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <label for="nombre" class="col-sm-2 control-label">Nombre(s)</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="nombre" name="nombre" placeholder="" onkeyup="upperCase(this.id)" value="<%=nombre%>"/>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <label for="unidad" class="col-sm-2 control-label">Unidad</label>
                                <div class="col-sm-5">
                                    <input class="form-control" id="unidad" name="unidad" type="text" placeholder="Unidad" size="1" value="<%=uni%>" readonly>
                                </div>
                            </div><br/>
                            <div class="row">
                                <label for="usuario" class="col-sm-2 control-label">Usuario</label>
                                <div class="col-sm-2">
                                    <input type="text" class="form-control" id="usuario" name="usuario" <%=disa%> placeholder="" onkeyup="" value="<%=user%>"/>
                                </div>
                                <label for="passw" class="col-sm-1 control-label">Password</label>
                                <div class="col-sm-2">
                                    <input type="text" class="form-control" id="passw" name="passw" placeholder="" onkeyup="" value="<%=pass%>"/>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <button class="btn btn-block btn-primary <%=ocultarG%>" id="Guardar" onclick="return validaGuardar();" <%=disa%>>Guardar</button>
                                <button type="button" class="btn btn-block btn-primary <%=ocultarA%>" id="Actualizar">Actualizar</button>
                            </div>
                        </div>
                    </form>

                </div>

            </div>
        </div>
        <!-- 
        ================================================== -->
        <!-- Se coloca al final del documento para que cargue mas rapido -->
        <!-- Se debe de seguir ese orden al momento de llamar los JS -->
        <script src="../../js/jquery-1.9.1.js"></script>
        <script src="../../js/bootstrap.js"></script>
        <script src="../../js/jquery-ui.js"></script>

        <script>

                                    function tabular(e, obj)
                                    {
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

                                    otro = 0;
                                    function LP_data() {
                                        var key = window.event.keyCode;//codigo de tecla. 
                                        if (key < 48 || key > 57) {//si no es numero 
                                            window.event.keyCode = 0;//anula la entrada de texto. 
                                        }
                                    }
                                    function anade(esto) {
                                        if (esto.value.length > otro) {
                                            if (esto.value.length === 2) {
                                                esto.value += "/";
                                            }
                                        }
                                        if (esto.value.length > otro) {
                                            if (esto.value.length === 5) {
                                                esto.value += "/";
                                            }
                                        }
                                        if (esto.value.length < otro) {
                                            if (esto.value.length === 2 || esto.value.length === 5) {
                                                esto.value = esto.value.substring(0, esto.value.length - 1);
                                            }
                                        }
                                        otro = esto.value.length;
                                    }

                                    function isNumberKey(evt)
                                    {
                                        var charCode = (evt.which) ? evt.which : event.keyCode;
                                        if (charCode > 31 && (charCode < 48 || charCode > 57))
                                            return false;

                                        return true;
                                    }

                                    function upperCase(x)
                                    {
                                        var y = document.getElementById(x).value;
                                        document.getElementById(x).value = y.toUpperCase();
                                        document.getElementById("mySpan").value = y.toUpperCase();

                                    }




                                    $(document).ready(function () {
                                        $('#formulario_pacientes').submit(function () {
                                            //alert("Ingresó");
                                            return false;
                                        });
                                        $('#Guardar').click(function () {
                                            var RegExPattern = /^\d{1,2}\/\d{1,2}\/\d{4,4}$/;

                                            var ape_pat = $('#ape_pat').val();
                                            var ape_mat = $('#ape_mat').val();
                                            var nombre = $('#nombre').val();
                                            var usuario = $('#usuario').val();
                                            var password = $('#passw').val();
                                            var tipo = $('#select_usu').val();
                                            var medico = $('#select_medico').val();
                                            var unidad = $('#unidad').val();
                                            var form = $('#formulario_pacientes');
                                            if (ape_pat === "" || ape_mat === "" || nombre === "" || usuario === "" || password === "" || tipo === "0" || unidad === "")
                                            {

                                                alert("Tiene campos vacíos, verifique.");

                                                return false;
                                            } else if (tipo === "2") {
                                                if (medico === "Seleccione Médico") {
                                                    alert("Seleccione Médico, verifique.");
                                                    return false;
                                                }
                                            }

                                            $.ajax({
                                                type: form.attr('method'),
                                                url: form.attr('action'),
                                                data: form.serialize(),
                                                success: function (data) {
                                                    devuelveFolio(data);
                                                },
                                                error: function () {
                                                    alert("Ha ocurrido un error");
                                                }
                                            });

                                            function devuelveFolio(data) {
                                                var json = JSON.parse(data);
                                                for (var i = 0; i < json.length; i++) {
                                                    var mensaje = json[i].mensaje;
                                                    var ban = json[i].ban;

                                                    if (ban === '1') {
                                                        $('#ape_pat').val("");
                                                        $('#ape_mat').val("");
                                                        $('#nombre').val("");
                                                        self.location = 'usuario.jsp';
                                                    }
                                                    alert(mensaje);

                                                }
                                            }


                                        });
                                        $('#Actualizar').click(function () {
                                            var id_usu = $('#id_usu').val();
                                            var ape_pat = $('#ape_pat').val();
                                            var ape_mat = $('#ape_mat').val();
                                            var nombre = $('#nombre').val();
                                            var usuario = $('#usuario').val();
                                            var password = $('#passw').val();
                                            var uni = $('#unidad').val();
                                            if (ape_pat === "" || ape_mat === "" || nombre === "" || usuario === "" || password === "" || uni === "") {
                                                alert("Tiene campos vacíos, verifique.");
                                                return false;
                                            }
                                            var url = "../../Usuarios";
                                            $.ajax({
                                                url: url,
                                                data: {que: "edi", id_usu: id_usu, ape_pat: ape_pat, ape_mat: ape_mat, nombre: nombre, password: password, usuario: usuario, uni: uni},
                                                success: function (data) {
                                                    var json = JSON.parse(data);
                                                    var mensaje = json[0].mensaje;
                                                    var ban = json[0].ban;
                                                    if (ban === '2') {
                                                        $('#ape_pat').val("");
                                                        $('#ape_mat').val("");
                                                        $('#nombre').val("");
                                                        window.location.href = 'usuario.jsp';
                                                    }
                                                    alert(mensaje);
                                                },
                                                error: function () {
                                                    alert("Ha ocurrido un error");
                                                }
                                            });
                                        });



                                    });


        </script>

        <script>
            $(document).ready(function () {
                $("#tip_med").hide();
                $("#select_medico").hide();
                $("#select_usu").click(function () {
                    var ban = $("#select_usu").val();
                    if (ban === 0 || ban === 1 || ban === 3) {
                        $("#tip_med").hide();
                        $("#select_medico").hide();
                    } else if (ban === 2) {
                        $("#tip_med").show();
                        $("#select_medico").show();
                    }
                });
                $(function () {
                    var availableTags = [
            <%
                try {
                    con.conectar();
                    try {
                        ResultSet rset2 = con.consulta("select des_uni from unidades");
                        while (rset2.next()) {
                            out.println("'" + rset2.getString(1) + "',");
                        }
                    } catch (Exception e) {

                    }
                    con.cierraConexion();
                } catch (Exception e) {

                }
            %>
                    ];
                    $('#unidad').autocomplete({
                        source: availableTags
                    });
                });
            });
        </script>
    </body>

</html>