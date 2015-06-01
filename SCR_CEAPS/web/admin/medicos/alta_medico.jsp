<%-- 
    Document   : alta_pacientes
    Created on : 10-mar-2014, 9:14:09
    Author     : Americo
--%>
<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.ConectionDB"%>
<!DOCTYPE html>
<%java.text.DateFormat df = new java.text.SimpleDateFormat("yyyyMMddhhmmss"); %>
<%java.text.DateFormat df2 = new java.text.SimpleDateFormat("yyyy-MM-dd"); %>
<%java.text.DateFormat df3 = new java.text.SimpleDateFormat("dd/MM/yyyy"); %>
<%
    HttpSession sesion = request.getSession();
    DecimalFormat formatter = new DecimalFormat("#,###,###");
    DecimalFormat formatter2 = new DecimalFormat("#,###,###.##");
    DecimalFormatSymbols custom = new DecimalFormatSymbols();
    ResultSet rset;
    String cla_uni = "", des_uni = "";
    ConectionDB con = new ConectionDB();
    try {
        con.conectar();
        ResultSet rs = con.consulta("SELECT uni.cla_uni,uni.des_uni FROM unidades AS uni INNER JOIN usuarios AS u ON u.cla_uni = uni.cla_uni WHERE u.id_usu = '" + sesion.getAttribute("id_usu") + "'");
        if (rs.next()) {
            cla_uni = rs.getString(1);
            des_uni = rs.getString(2);
        }
    } catch (Exception ex) {
        System.out.print("Error->" + ex);
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- Bootstrap -->
        <link href="../../css/bootstrap.css" rel="stylesheet" media="screen">
        <link href="../../css/pie-pagina.css" rel="stylesheet" media="screen">
        <link href="../../css/topPadding.css" rel="stylesheet">
        <link href="../../css/datepicker3.css" rel="stylesheet">
        <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <title>JSP Page</title>
    </head>
    <body>
        
        <%@include file="../../jspf/mainMenu.jspf" %> 
        <div class="container-fluid">
            <div class="container">
                <div class="row">
                    <div class="col-lg-10">
                        <h3>Alta de Médico</h3>
                    </div>
                    <div class="col-lg-2">
                        <!--a class="btn btn-block btn-danger" href="pacientes.jsp">Regresar</a-->
                    </div>
                </div>
                <div class="panel panel-default">
                    <form class="form-horizontal" role="form" name="formulario_pacientes" id="formulario_pacientes" method="get" action="../../Medicos">
                        <div class="panel-body">                            
                            <div class="row">
                                <label for="ape_pat" class="col-sm-2 control-label">Apellido Paterno</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" id="ape_pat" name="ape_pat" placeholder="" onkeyup="upperCase(this.id)"  value=""/>
                                </div>
                                <label for="ape_mat" class="col-sm-2 control-label">Apellido Materno</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" id="ape_mat" name="ape_mat" placeholder="" onkeyup="upperCase(this.id)" value=""/>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <label for="nombre" class="col-sm-2 control-label">Nombre(s)</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="nombre" name="nombre" placeholder="" onkeyup="upperCase(this.id)" value=""/>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <label for="cedula" class="col-sm-2 control-label">Cédula</label>
                                <div class="col-sm-2">
                                    <input type="text" class="form-control" id="cedula" name="cedula" placeholder="" onkeyup="upperCase(this.id)" value=""/>
                                </div>
                                <label for="fec_nac" class="col-sm-2 control-label">Fecha Nac</label>
                                <div class="col-sm-2">
                                    <input type="date" class="form-control" id="fec_nac" name="fec_nac" max="<%=df2.format(new Date())%>"/>
                                </div>
                                <label for="sexo" class="col-sm-1 control-label">R.F.C.</label>
                                <div class="col-sm-2">
                                    <input type="text" class="form-control" id="rfc" name="rfc" placeholder="" onkeyup="upperCase(this.id)" value=""/>
                                </div>
                                <div class="col-sm-1">
                                    <button type="button" class="btn btn-warning btn-block" title="Generar RFC" onclick="generarRFC()"><span class="glyphicon glyphicon-hdd"></span></button>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <label for="fec_nac" class="col-sm-2 control-label">Usuario</label>
                                <div class="col-sm-2">
                                    <input type="text" class="form-control" id="usuario" name="usuario" placeholder="" value=""/>
                                </div>
                                <label for="sexo" class="col-sm-1 control-label">Password</label>
                                <div class="col-sm-2">
                                    <input type="text" class="form-control" id="password" name="password" placeholder="" value=""/>
                                </div>
                                <div class="col-sm-1">
                                    <button type="button" class="btn btn-warning btn-block" title="Generar Usuario y Contraseña" onclick="generarUserPass()"><span class="glyphicon glyphicon-hdd"></span></button>
                                </div>
                                <label for="folIni" class="col-sm-1 control-label">Folio Ini</label>
                                <div class="col-sm-2">
                                    <input type="number" class="form-control" id="folIni" name="folIni" required />
                                </div>
                            </div>
                            <br/>
                            <div class="row">
                                <label for="fec_nac" class="col-sm-2 control-label">Unidad</label>
                                <div class="col-sm-6">
                                    <input type="hidden" value="<%=cla_uni%>" name="cla_uni">
                                    <select disabled="" class="form-control" id="unidad" name="unidad">
                                        <option value="<%=cla_uni%>"><%=des_uni%></option>
                                    </select>
                                </div>
                                <label for="folFin" class="col-sm-1 control-label">Folio Fin</label>
                                <div class="col-sm-2">
                                    <input type="number" class="form-control" id="folFin" name="folFin" required />
                                </div>
                            </div><br/>
                            <div class="row">
                                <label class="col-sm-2 control-label">Tipo de Consulta</label>
                                <div class="col-sm-2">
                                    <select class="form-control" id="slcTipoConsu" name="slcTipoConsu">
                                        <option value="Consulta Externa">Consulta Externa</option>
                                        <option value="Urgencias">Urgencias</option>
                                        <option value="Hospitalización">Hospitalización</option>
                                    </select>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <div class="col-lg-6">
                                    <button class="btn btn-block btn-primary" id="Guardar" onclick="">Guardar</button>
                                </div>
                                <div class="col-lg-6">
                                    <button class="btn btn-block btn-success" id="Regresar" >Regresar</button>
                                </div>
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
        <script src="../../js/jquery-ui-1.10.3.custom.js"></script>

        <script>
                                        function generarRFC() {
                                            var apePat = $('#ape_pat').val();
                                            var apeMat = $('#ape_mat').val();
                                            var nombres = $('#nombre').val();
                                            var fecNac = $('#fec_nac').val();
                                            if (apePat === "" || apeMat === "" || nombres === "" || fecNac === "") {
                                                alert("Faltan datos, verifique");
                                            } else {
                                                var ape1 = apePat.substr(0, 2);
                                                var ape2 = apeMat.substr(0, 1);
                                                var nom1 = nombres.substr(0, 1);
                                                var fec1 = fecNac.replace("-", "");
                                                var fec1 = fec1.replace("-", "");
                                                var fec1 = fec1.substr(2, 8);
                                                $('#rfc').val(ape1 + ape2 + nom1 + fec1);
                                            }
                                        }
                                        function generarUserPass() {
                                            var apePat = $('#ape_pat').val();
                                            var apeMat = $('#ape_mat').val();
                                            var nombres = $('#nombre').val();
                                            var fecNac = $('#fec_nac').val();
                                            if (apePat === "" || apeMat === "" || nombres === "" || fecNac === "") {
                                                alert("Faltan datos, verifique");
                                            } else {
                                                var userArray = nombres.split(" ");
                                                var user = userArray[0];
                                                var fec1 = fecNac.replace("-", "");
                                                var fec1 = fec1.replace("-", "");
                                                var fec1 = fec1.substr(2, 8);
                                                $('#usuario').val(user.toLowerCase());
                                                $('#password').val(user.toLowerCase() + fec1);
                                            }
                                        }
                                        function tabular(e, obj)
                                        {
                                            tecla = (document.all) ? e.keyCode : e.which;
                                            if (tecla != 13)
                                                return;
                                            frm = obj.form;
                                            for (i = 0; i < frm.elements.length; i++)
                                                if (frm.elements[i] == obj)
                                                {
                                                    if (i == frm.elements.length - 1)
                                                        i = -1;
                                                    break
                                                }
                                            /*ACA ESTA EL CAMBIO*/
                                            if (frm.elements[i + 1].disabled == true)
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
                                                if (esto.value.length == 2) {
                                                    esto.value += "/";
                                                }
                                            }
                                            if (esto.value.length > otro) {
                                                if (esto.value.length == 5) {
                                                    esto.value += "/";
                                                }
                                            }
                                            if (esto.value.length < otro) {
                                                if (esto.value.length == 2 || esto.value.length == 5) {
                                                    esto.value = esto.value.substring(0, esto.value.length - 1);
                                                }
                                            }
                                            otro = esto.value.length
                                        }

                                        function isNumberKey(evt)
                                        {
                                            var charCode = (evt.which) ? evt.which : event.keyCode
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
                                                var cedula = $('#cedula').val();
                                                var unidad = $('#unidad').val();
                                                var rfc = $('#rfc').val();
                                                var folIni = $('#folIni').val();
                                                var folFin = $('#folFin').val();
                                                var form = $('#formulario_pacientes');
                                                if (ape_pat === "" || ape_mat === "" || nombre === "" || cedula === "" || rfc === "" || unidad === "" || folIni === "" || folFin === "") {
                                                    alert("Tiene campos vacíos, verifique.");
                                                    return false;
                                                }
                                                if (parseInt(folIni) > parseInt(folFin)) {
                                                    alert("El folio inicial no puede ser mayor al folio final");
                                                    return false;
                                                }
                                                $.ajax({
                                                    url: form.attr('action'),
                                                    data: {que: "F", iniRec: folIni, finRec: folFin},
                                                    success: function (data) {
                                                        var json = JSON.parse(data);
                                                        if (json[0].pasa === "1") {
                                                            alert(json[0].msg);
                                                            return false;
                                                        } else {
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
                                                                    if (ban === "1") {
                                                                        $('#ape_pat').val("");
                                                                        $('#ape_mat').val("");
                                                                        $('#nombre').val("");
                                                                        $('#cedula').val("");
                                                                        $('#rfc').val("");
                                                                        window.location = 'medico.jsp';
                                                                    }
                                                                    alert(mensaje);
                                                                }
                                                            }
                                                        }
                                                    },
                                                    error: function () {
                                                        alert("Ha ocurrido un error");
                                                    }
                                                });
                                            });
                                            $('#Regresar').click(function () {
                                                self.location = 'medico.jsp';
                                            });

                                        });


        </script>
    </body>
</html>