<%-- 
    Document   : alta_pacientes
    Created on : 10-mar-2014, 9:14:09
    Author     : Americo
--%>

<%@page import="java.util.Date"%>
<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Clases.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    ConectionDB con = new ConectionDB();
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
        <title>Alta de Pacientes</title>
    </head>
    <body>
        <%@include file="../../jspf/mainMenu.jspf"%>
        <br/>
        <div class="container-fluid">
            <div class="container">
                <div class="row">
                    <div class="col-lg-10">
                        <h3>Alta de Pacientes</h3>
                    </div>
                    <div class="col-lg-2">
                        <!--a class="btn btn-block btn-danger" href="pacientes.jsp">Regresar</a-->
                    </div>
                </div>
                <div class="panel panel-default">
                    <div class="panel-body">
                        <form method="post">
                            <div class="row">
                                <label for="tip_cob" class="col-sm-2 control-label">Tipo de Cobranza</label>
                                <div class="col-sm-2">
                                    <select class="form-control" id="tip_cob" name="tip_cob" onchange="numAfiPA(this);">
                                        <option>SP</option>
                                        <option>PR</option>
                                        <option>PA</option>
                                        <option value="60">Mas de 60</option>
                                        <option value="IRA">Infecc. Resp Aguda</option>
                                        <option>EDA</option>
                                        <option value="AR">Antirrabico</option>
                                        <option value="SE">Seguro Escolar</option>
                                        <option value="IND">Indigente</option>
                                        <option value="PN">Prenatal</option>
                                    </select>
                                </div>
                                <label for="no_afi" class="col-sm-2 control-label">Número de Afiliación</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" id="no_afi" name="no_afi" onkeypress="return isNumberKey(event)" placeholder=""  value="" required/>
                                </div>
                            </div>

                            <br />
                            <div class="row">
                                <label for="num_afil" class="col-sm-2 control-label">Número de Afiliados</label>
                                <div class="col-sm-2">
                                    <input type="number" name="numAfiliados" id="numAfiliados" class="form-control" required="" />
                                </div>
                                <div class="col-sm-2">
                                    <button class="btn btn-primary"><span class="glyphicon glyphicon-ok"></span></button>
                                </div>
                            </div>
                            <hr/>
                        </form>
                        <form class="form-horizontal" role="form" name="formulario_pacientes" id="formulario_pacientes" method="get" action="../../Pacientes">
                            <%
                                int numAfiliados = 0;
                                try {
                                    numAfiliados = Integer.parseInt(request.getParameter("numAfiliados"));
                                } catch (Exception e) {
                                    numAfiliados = 0;
                                }
                                if (numAfiliados > 0) {
                            %>
                            <div class="row">
                                <label for="no_afi" class="col-sm-2 control-label">Número de Afiliación</label>
                                <div class="col-sm-4">
                                    <input id="no_afi" name="no_afi" value="<%=request.getParameter("no_afi")%>" readonly class="form-control" />
                                </div>

                                <label for="tip_cob" class="col-sm-2 control-label">Tipo de Cobranza</label>
                                <div class="col-sm-4">
                                    <input id="tip_cob" name="tip_cob" value="<%=request.getParameter("tip_cob")%>" readonly class="form-control" />
                                </div>
                            </div>
                            <input name="numeroAfiliados" value="<%=numAfiliados%>" class="hidden">
                            <hr/>
                            <%
                                }
                                for (int i = 1; i <= numAfiliados; i++) {
                            %>
                            <h3>Afiliado <%=i%></h3>
                            <div class="row">
                                <label for="ape_pat" class="col-sm-2 control-label">Apellido Paterno</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" id="<%=i%>ape_pat" name="<%=i%>ape_pat" placeholder="" onkeyup="upperCase(this.id)" required  value=""/>
                                </div>
                                <label for="ape_mat" class="col-sm-2 control-label">Apellido Materno</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" id="<%=i%>ape_mat" name="<%=i%>ape_mat" placeholder="" onkeyup="upperCase(this.id)" required value=""/>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <label for="nombre" class="col-sm-2 control-label">Nombre(s)</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="<%=i%>nombre" name="<%=i%>nombre" placeholder="" onkeyup="upperCase(this.id)" required value=""/>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <label for="fec_nac" class="col-sm-2 control-label">Fecha de Nacimiento</label>
                                <!--div class="col-sm-2">
                                    <input type="text" class="form-control" id="fec_nac" name="fec_nac"   maxlength="10" data-date-format="dd/mm/yyyy"   placeholder=""  value="" onkeypress="
                                            LP_data();
                                            anade(this);
                                            return isNumberKey(event, this);"/>
                                </div-->
                                <div class="col-sm-2">
                                    <input class="form-control" id="<%=i%>fec_nac" name="<%=i%>fec_nac" type="date" max="<%=df2.format(new Date())%>" required/>
                                </div>
                                <label for="sexo" class="col-sm-1 control-label">Sexo</label>
                                <div class="col-sm-2">
                                    <select class="form-control" id="<%=i%>sexo" name="<%=i%>sexo" required>
                                        <option value = 'M' >MASCULINO</option>
                                        <option value = 'F'>FEMENINO</option>
                                    </select>
                                </div>
                            </div>
                            <br />
                            <div class="row">
                                <label for="no_afi" class="col-sm-2 control-label">Número de Expediente</label>
                                <div class="col-sm-4">
                                    <input type="text" class="form-control" id="<%=i%>no_exp" name="<%=i%>no_exp" placeholder="" onkeyup="upperCase(this.id)" required  value=""/>
                                </div>                                
                            </div>
                            <hr />

                            <%
                                  } 
                                if (numAfiliados > 0) {
                            %>

                            <div class="row">
                                <div class="col-lg-6">
                                    <button class="btn btn-block btn-primary" id="Guardar" onclick="return confirm('Desea agregar al paciente(s)?')">Guardar</button>
                                </div>
                                <div class="col-lg-6">
                                    <button class="btn btn-block btn-success" id="Regresar" >Regresar</button>
                                </div>
                            </div>
                            <%
                                }
                            %>
                        </form>
                    </div>

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
        <script src="../../js/bootstrap-datepicker.js"></script>
        <script src="../../js/moment.js"></script>
        <script>
                                        function numAfiPA(e) {
                                            var tipo = e.value;
                                            var d = new Date();
                                            //alert(d);
                                            var now = moment();
                                            now.format('dddd');
                                            //alert(now);
                                            //var tipo = "";
                                            if(tipo===""){
                                                
                                            }
                                            if (document.getElementById('tip_cob').value === 'PR') {
                                                tipo = 'PR';
                                                document.getElementById('numAfiliados').value = 1;
                                                document.getElementById('numAfiliados').readOnly = true;
                                            } else if (document.getElementById('tip_cob').value === 'PA') {
                                                tipo = 'PA';
                                                document.getElementById('numAfiliados').value = 0;
                                                document.getElementById('numAfiliados').readOnly = false;
                                            } else if (document.getElementById('tip_cob').value === 'SP') {
                                                tipo = 'SP';
                                                document.getElementById('numAfiliados').value = 0;
                                                document.getElementById('numAfiliados').readOnly = false;
                                            }
                                            document.getElementById('no_afi').value = tipo + now.format('YYMMDDHHmmss');
                                            document.getElementById('no_afi').readOnly = true;
                                            if (document.getElementById('tip_cob').value === 'SP') {
                                                document.getElementById('no_afi').value = "";
                                                document.getElementById('no_afi').readOnly = false;
                                            }
                                            if (document.getElementById('tip_cob').value === '--Seleccione--') {
                                                document.getElementById('no_afi').value = "";
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
                                        $('#Regresar').click(function() {
                                            self.location = 'pacientes.jsp';
                                        });
        </script>
    </body>
</html>