/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


/*
 * 
 * @returns {undefined}
 */

function focoInicial() {
    document.getElementById('nombre_jq').focus();
    if (document.getElementById('nom_pac').value !== "") {
        document.getElementById('causes').focus();
    }
}

function borraNoAfi() {
    $('#sp_pac').val("");
    $('#select_pac').empty();
}
function borraNombre() {
    $('#nombre_jq').val("");
}

function sumar() {
    //alert('hola');
    var unidades = document.formulario_receta.unidades.value;
    if (unidades === "")
        unidades = 0;
    var horas = document.formulario_receta.horas.value;
    if (horas === "")
        horas = 0;
    var dias = document.formulario_receta.dias.value;
    if (dias === "")
        dias = 0;
    //alert(horas);
    var hrs = 24 / parseInt(horas);
    //alert(unidades+""+hrs+""+dias);
    var total = parseInt(unidades) * hrs * parseInt(dias);
    var amp = document.formulario_receta.amp.value;
    var cajas = total / amp;
    if (isNaN(amp))
        amp = 0;
    if (isNaN(cajas))
        cajas = 0;
    if (isNaN(total))
        total = 0;


    //document.formulario_receta.piezas_sol.value = Math.ceil(total);
    //document.formulario_receta.can_sol.value = Math.ceil(cajas);
    document.formulario_receta.piezas_sol.value = Math.ceil(unidades);
    document.formulario_receta.can_sol.value = Math.ceil(unidades);
}


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

/*if(document.getElementById('nom_pac').val!==""){
 document.getElementById('carnet').focus();
 }
 if(document.getElementById('carnet').val!==""){
 document.getElementById('cla_pro').focus();
 }*/
$(function() {

    $(function() {
        $("#nombre_jq").keyup(function() {
            var nombre = $("#nombre_jq").val();
            $("#nombre_jq").autocomplete({
                source: "../AutoPacientes?nombre=" + nombre,
                minLength: 2,
                select: function(event, ui) {
                    $("#nombre_jq").val(ui.item.nom_com);
                    return false;
                }
            }).data("ui-autocomplete")._renderItem = function(ul, item) {
                return $("<li>")
                        .data("ui-autocomplete-item", item)
                        .append("<a>" + item.nom_com + "</a>")
                        .appendTo(ul);
            };
        });
    });
    $(function() {
        $("#medico_jq").keyup(function() {
            var nombre = $("#medico_jq").val();
            $("#medico_jq").autocomplete({
                source: "../AutoMedico?nombre=" + nombre,
                minLength: 1,
                select: function(event, ui) {
                    $("#medico_jq").val(ui.item.nom_med);
                    return false;
                }
            }).data("ui-autocomplete")._renderItem = function(ul, item) {
                return $("<li>")
                        .data("ui-autocomplete-item", item)
                        .append("<a>" + item.nom_med + "</a>")
                        .appendTo(ul);
            };
        });
    });

    $('#bus_pac').tooltip();
    $('#bus_pacn').tooltip();

    if ($("#nom_pac").val() !== "") {
        $("#carnet").focus();
    }
    if ($("#carnet").val() !== "") {
        $("#causes").focus();
    }

    $("#fecha").datepicker();
    $("#Caducidad").datepicker('option', {dateFormat: 'dd/mm/yy'});

    var form = $('#formulario_receta');
    $.ajax({
        type: form.attr('method'),
        url: '../MuestraInsumosReceta',
        data: form.serialize(),
        success: function(data) {
            limpiaCampos();
            hacerTabla(data);
        },
        error: function() {
            alert("Ha ocurrido un error - insumo receta");
        }
    });

    function limpiaCampos() {
        $("#cla_pro").val("");
        $("#des_pro").val("");
        $("#ori1").attr("value", "");
        $("#ori2").attr("value", "");
        $("#existencias").attr("value", "");
        $("#indica").val("");
        //$("#causes").val("");
        $("#can_sol").val("");
    }

    function hacerTabla(data) {
        var json = JSON.parse(data);
        $("#tablaMedicamentos").empty();
        $("#tablaMedicamentos").append(
                $("<tr>")
                .append($("<td>").append("Clave"))
                .append($("<td>").append("Descripción"))
                //.append($("<td>").append("Lote"))
                //.append($("<td>").append("Caducidad"))
                .append($("<td>").append("Diag 1"))
                .append($("<td>").append("Diag 2"))
                //.append($("<td>").append("Cant. Sur."))
                //.append($("<td>").append("Origen."))
                .append($("<td>").append(""))
                );
        for (var i = 0; i < json.length; i++) {
            var cla_pro = json[i].cla_pro;
            var des_pro = json[i].des_pro;
            var lot_pro = json[i].lot_pro;
            var cad_pro = json[i].cad_pro;
            if (cad_pro === "01/01/2020") {
                cad_pro = "-";
            }
            var fol_det = json[i].fol_det;
            var can_sol = json[i].can_sol;
            var cant_sur = json[i].cant_sur;
            var id_ori = json[i].id_ori;
            var indicaciones = json[i].indicaciones;
            var id_cau = json[i].id_cau;
            var id_cau2 = json[i].id_cau2;
            var duracionArray = indicaciones.split("POR");
            var duracionArray2 = duracionArray[1].split("|");
            var duracion = duracionArray2[0];
            if (cant_sur === "0") {
                lot_pro = '-';
                cad_pro = '-';
            }
            var btn_modi = "<a class='btn btn-warning btn-sm' id='btn_modi' value = '" + fol_det + "' name = 'btn_modi'  data-toggle=\'modal\'  href=\'#edita_clave_" + fol_det + "\'><span class='glyphicon glyphicon-pencil' ></span></a>";
            var btn_eliminar = "<a class='btn btn-danger btn-sm' id='btn_eli' value = '" + fol_det + "' name = 'btn_eli' data-toggle=\'modal\'  href=\'#elimina_clave_" + fol_det + "\'><span class='glyphicon glyphicon-remove' ></span></a>";
            $("#tablaMedicamentos").append(
                    $("<tr>")
                    .append($("<td>").append(cla_pro))
                    .append($("<td>").append(des_pro))
                    //.append($("<td>").append(lot_pro))
                    //.append($("<td>").append(cad_pro))
                    .append($("<td>").append(id_cau))
                    .append($("<td>").append(id_cau2))
                    //.append($("<td>").append(id_ori))
                    .append($("<td>").append(btn_modi).append(btn_eliminar))
                    );
            $("#tablaMedicamentos").append(
                    $("<tr>")
                    .append($("<td colspan='3'>").append("Indicaciones: " + indicaciones))
                    .append($("<td>").append("Duración: " + duracion))
                    .append($("<td>").append("Can. Sol.: " + can_sol))
                    );
        }
    }
});


$(document).ready(function() {
    $('#btn_eli').click(function() {
        var cla_pro = $('#btn_eli').val();
        alert(cla_pro);
    });

    $('#btn_capturar').click(function() {
        var cla_pro = $('#cla_pro').val();
        var des_pro = $('#des_pro').val();
        var hora = $('#horas').val();
        var dias = $('#dias').val();
        var form = $('#formulario_receta');
        var indicaciones = $('#indicacionesRM').val();
        if (cla_pro !== "" && des_pro !== "") {
            if ($('#causes').val() === "") {
                alert('Capture las causes');
                $('#causes').focus();
            } else if ($('#can_sol').val() === "" || $('#can_sol').val() === "0") {
                alert('Capture la cantidad a entregar');
            } else if (dias === "" || dias === "0" ) {
                alert('Capture Horas/Días');
            } else if (indicaciones === "") {
                alert('Capture Indicaciones');
            }else {
                document.getElementById('formulario_receta').action = "../CapturaMedicamentoManual";
                document.getElementById('formulario_receta').submit();
                /*$.ajax({
                 type: 'POST',
                 url: '../CapturaMedicamento',
                 data: form.serialize(),
                 success: function(data) {
                 $.ajax({
                 type: form.attr('method'),
                 url: '../MuestraInsumosReceta',
                 data: form.serialize(),
                 success: function(data) {
                 limpiaCampos();
                 hacerTabla(data);
                 }
                 });
                 }
                 });*/
                function limpiaCampos() {
                    $("#cla_pro").val("");
                    $("#des_pro").val("");
                    $("#ori1").attr("value", "");
                    $("#ori2").attr("value", "");
                    $("#existencias").attr("value", "");
                    $("#indica").val("");
                    //$("#causes").val("");
                    $("#can_sol").val("");
                }

                function hacerTabla(data) {
                    var json = JSON.parse(data);
                    $("#tablaMedicamentos").empty();
                    $("#tablaMedicamentos").append(
                            $("<tr>")
                            .append($("<td>").append("Clave"))
                            .append($("<td>").append("Descripción"))
                            //.append($("<td>").append("Lote"))
                            //.append($("<td>").append("Caducidad"))
                            .append($("<td>").append("Diag 1"))
                            .append($("<td>").append("Diag 2"))
                            //.append($("<td>").append("Cant. Sur."))
                            //.append($("<td>").append("Origen."))
                            .append($("<td>").append(""))
                            );
                    for (var i = 0; i < json.length; i++) {
                        var cla_pro = json[i].cla_pro;
                        var des_pro = json[i].des_pro;
                        var lot_pro = json[i].lot_pro;
                        var cad_pro = json[i].cad_pro;
                        if (cad_pro === "01/01/2020") {
                            cad_pro = "-";
                        }
                        var fol_det = json[i].fol_det;
                        var can_sol = json[i].can_sol;
                        var cant_sur = json[i].cant_sur;
                        var id_ori = json[i].id_ori;
                        var indicaciones = json[i].indicaciones;
                        var id_cau = json[i].id_cau;
                        var id_cau2 = json[i].id_cau2;
                        var duracionArray = indicaciones.split("POR");
                        var duracion = duracionArray[1];
                        if (cant_sur === "0") {
                            lot_pro = '-';
                            cad_pro = '-';
                        }
                        var btn_modi = "<a class='btn btn-warning btn-sm' id='btn_modi' value = '" + fol_det + "' name = 'btn_modi'  data-toggle=\'modal\'  href=\'#edita_clave_" + fol_det + "\'><span class='glyphicon glyphicon-pencil' ></span></a>";
                        var btn_eliminar = "<a class='btn btn-danger btn-sm' id='btn_eli' value = '" + fol_det + "' name = 'btn_eli' data-toggle=\'modal\'  href=\'#elimina_clave_" + fol_det + "\'><span class='glyphicon glyphicon-remove' ></span></a>";
                        $("#tablaMedicamentos").append(
                                $("<tr>")
                                .append($("<td>").append(cla_pro))
                                .append($("<td>").append(des_pro))
                                //.append($("<td>").append(lot_pro))
                                //.append($("<td>").append(cad_pro))
                                .append($("<td>").append(id_cau))
                                .append($("<td>").append(id_cau2))
                                //.append($("<td>").append(id_ori))
                                .append($("<td>").append(btn_modi).append(btn_eliminar))
                                );
                        $("#tablaMedicamentos").append(
                                $("<tr>")
                                .append($("<td colspan='3'>").append("Indicaciones: " + indicaciones))
                                .append($("<td>").append("Duracion: " + duracion))
                                .append($("<td>").append("Can. Sol.: " + can_sol))
                                );
                    }
                }
            }
        }
        else {
            alert("Capture primero el medicamento");
            $("#des_pro").focus();
        }
    });
    $('#btn_capturarManual').click(function() {
        var cla_pro = $('#cla_pro').val();
        var des_pro = $('#des_pro').val();
        var form = $('#formulario_receta');
        if (cla_pro !== "" && des_pro !== "") {
            if ($('#causes').val() === "") {
                alert('Capture las causes');
                $('#causes').focus();
            } else if ($('#can_sol').val() === "") {
                alert('Capture la cantidad a entregar');
            } else {
                document.getElementById('formulario_receta').action = "../CapturaMedicamentoManual";
                document.getElementById('formulario_receta').submit();
                /*$.ajax({
                 type: 'POST',
                 url: '../CapturaMedicamento',
                 data: form.serialize(),
                 success: function(data) {
                 $.ajax({
                 type: form.attr('method'),
                 url: '../MuestraInsumosReceta',
                 data: form.serialize(),
                 success: function(data) {
                 limpiaCampos();
                 hacerTabla(data);
                 }
                 });
                 }
                 });*/
                function limpiaCampos() {
                    $("#cla_pro").val("");
                    $("#des_pro").val("");
                    $("#ori1").attr("value", "");
                    $("#ori2").attr("value", "");
                    $("#existencias").attr("value", "");
                    $("#indica").val("");
                    //$("#causes").val("");
                    $("#can_sol").val("");
                }

                function hacerTabla(data) {
                    var json = JSON.parse(data);
                    $("#tablaMedicamentos").empty();
                    $("#tablaMedicamentos").append(
                            $("<tr>")
                            .append($("<td>").append("Clave"))
                            .append($("<td>").append("Descripción"))
                            //.append($("<td>").append("Lote"))
                            //.append($("<td>").append("Caducidad"))
                            .append($("<td>").append("Diag 1"))
                            .append($("<td>").append("Diag 2"))
                            //.append($("<td>").append("Cant. Sur."))
                            //.append($("<td>").append("Origen."))
                            .append($("<td>").append(""))
                            );
                    for (var i = 0; i < json.length; i++) {
                        var cla_pro = json[i].cla_pro;
                        var des_pro = json[i].des_pro;
                        var lot_pro = json[i].lot_pro;
                        var cad_pro = json[i].cad_pro;
                        if (cad_pro === "01/01/2020") {
                            cad_pro = "-";
                        }
                        var fol_det = json[i].fol_det;
                        var can_sol = json[i].can_sol;
                        var cant_sur = json[i].cant_sur;
                        var id_ori = json[i].id_ori;
                        var indicaciones = json[i].indicaciones;
                        var id_cau = json[i].id_cau;
                        var id_cau2 = json[i].id_cau2;
                        var duracionArray = indicaciones.split("POR");
                        var duracion = duracionArray[1];
                        if (cant_sur === "0") {
                            lot_pro = '-';
                            cad_pro = '-';
                        }
                        var btn_modi = "<a class='btn btn-warning btn-sm' id='btn_modi' value = '" + fol_det + "' name = 'btn_modi'  data-toggle=\'modal\'  href=\'#edita_clave_" + fol_det + "\'><span class='glyphicon glyphicon-pencil' ></span></a>";
                        var btn_eliminar = "<a class='btn btn-danger btn-sm' id='btn_eli' value = '" + fol_det + "' name = 'btn_eli' data-toggle=\'modal\'  href=\'#elimina_clave_" + fol_det + "\'><span class='glyphicon glyphicon-remove' ></span></a>";
                        $("#tablaMedicamentos").append(
                                $("<tr>")
                                .append($("<td>").append(cla_pro))
                                .append($("<td>").append(des_pro))
                                //.append($("<td>").append(lot_pro))
                                //.append($("<td>").append(cad_pro))
                                .append($("<td>").append(id_cau))
                                .append($("<td>").append(id_cau2))
                                //.append($("<td>").append(id_ori))
                                .append($("<td>").append(btn_modi).append(btn_eliminar))
                                );
                        $("#tablaMedicamentos").append(
                                $("<tr>")
                                .append($("<td colspan='3'>").append("Indicaciones: " + indicaciones))
                                .append($("<td>").append("Duracion: " + duracion))
                                .append($("<td>").append("Can. Sol.: " + can_sol))
                                );
                    }
                }
            }
        }
        else {
            alert("Capture primero el medicamento");
            $("#des_pro").focus();
        }
    });


    $('#btn_descripcion').click(function() {
        var dir = '../ProductoDescripcion';
        var form = $('#formulario_receta');
        var nom_pac = $('#nom_pac').val();
        if (nom_pac === "") {
            alert("Capture el paciente");
        }
        if ($('#des_pro').val() === "") {
            alert("Capture un Medicamento");
            $('#des_pro').focus();
        }
        else {
            $.ajax({
                type: form.attr('method'),
                url: dir,
                data: form.serialize(),
                success: function(data) {
                    dameProducto(data);
                }
            });
            function dameProducto(data) {
                var json = JSON.parse(data);
                for (var i = 0; i < json.length; i++) {
                    var ori0 = json[i].origen0;
                    var ori1 = json[i].origen1;
                    var ori2 = json[i].origen2;
                    var total = json[i].total;
                    var cla_pro = json[i].cla_pro;
                    var ampuleo = json[i].amp_pro;

                    $("#carnet").val(json[i].carnet);
                    $("#ori0").attr("value", ori0);
                    $("#ori1").attr("value", ori1);
                    $("#ori2").attr("value", ori2);
                    $("#existencias").attr("value", total);
                    $("#cla_pro").val(cla_pro);
                    $("#amp").attr("value", ampuleo);
                    $("#unidades").focus();
                    if (cla_pro === null) {
                        alert('Clave fuera de Catálogo');
                        $("#cla_pro").val("");
                        $("#des_pro").val("");
                        $("#ori0").attr("value", "");
                        $("#ori1").attr("value", "");
                        $("#ori2").attr("value", "");
                        $("#existencias").attr("value", "");
                        $("#indica").val("");
                        ////$("#causes").val("");
                        $("#can_sol").val("");
                        $("#des_pro").focus();
                    }
                    if (total === null && cla_pro !== null) {
                        //alert('Clave sin Existencias');
                        $("#cla_pro").val(cla_pro);
                        //$("#des_pro").val("");
                        $("#ori0").attr("value", "0");
                        $("#ori1").attr("value", "0");
                        $("#ori2").attr("value", "0");
                        $("#existencias").attr("value", "0");
                        $("#indica").val("");
                        ////$("#causes").val("");
                        $("#can_sol").val("");
                        $("#des_pro").focus();
                    }
                }
            }
        }
    });

    $('#btn_clave').click(function() {
        var dir = '../ProductoClave';
        var form = $('#formulario_receta');
        var nom_pac = $('#nom_pac').val();
        if (nom_pac === "") {
            alert("Capture el paciente");
        }
        if ($('#cla_pro').val() === "") {
            alert("Capture una clave");
            $('#causes').focus();
        }
        else {
            $.ajax({
                type: form.attr('method'),
                url: dir,
                data: form.serialize(),
                success: function(data) {
                    dameProducto(data);
                },
                error: function() {
                    alert("Ha ocurrido un error - clave");
                }
            });
            function dameProducto(data) {
                var json = JSON.parse(data);
                for (var i = 0; i < json.length; i++) {
                    var ori0 = json[i].origen0;
                    var ori1 = json[i].origen1;
                    var ori2 = json[i].origen2;
                    var total = json[i].total;
                    var descripcion = json[i].des_pro;
                    var ampuleo = json[i].amp_pro;
                    $("#carnet").val(json[i].carnet);
                    $("#ori0").attr("value", ori0);
                    $("#ori1").attr("value", ori1);
                    $("#ori2").attr("value", ori2);
                    $("#existencias").attr("value", total);
                    $("#des_pro").val(descripcion);
                    $("#amp").attr("value", ampuleo);
                    $("#unidades").focus();

                    if (descripcion === "null") {
                        alert('Clave fuera de Catálogo');
                        $("#cla_pro").val("");
                        $("#des_pro").val("");
                        $("#ori0").attr("value", "");
                        $("#ori1").attr("value", "");
                        $("#ori2").attr("value", "");
                        $("#existencias").attr("value", "");
                        $("#indica").val("");
                        ////$("#causes").val("");
                        $("#can_sol").val("");
                        $("#causes").focus();
                    }
                    //if (total === null && descripcion !== null) {
                    if (total === null && descripcion !== "null") {
                        //alert('Clave sin Existencias');
                        //$("#cla_pro").val("");
                        $("#des_pro").val(descripcion);
                        $("#ori0").attr("value", "0");
                        $("#ori1").attr("value", "0");
                        $("#ori2").attr("value", "0");
                        $("#existencias").attr("value", "0");
                        $("#indica").val("");
                        ////$("#causes").val("");
                        $("#can_sol").val("");
                        $("#causes").focus();
                    }
                }
            }
        }
    });

    $('#formulario_receta').submit(function() {
        //alert("Ingresó");
        return false;
    });

    $('#mostrar1').click(function() {
        var sp_pac = $('#sp_pac').val();
        var dir = '../Receta';
        var form = $('#formulario_receta');
        if($('#tipoCons').val()==="0"){
            alert("seleccione el tipo de consulta");
            $('#tipoCons').focus();
            return false;            
        }
        if ($('#folio').val() === "") {
            alert("Ingrese folio");
            $('#folio').focus();
            return false;
        }
        $.ajax({
            type: form.attr('method'),
            url: dir,
            data: form.serialize(),
            success: function(data) {
                devuelveFolio(data);
            },
            error: function() {
                alert("Ha ocurrido un error - mostrar");
            }
        });
        function devuelveFolio(data) {
            var json = JSON.parse(data);
            $('#select_pac').empty();
            $('#select_pac').focus();
            $('#select_pac').append(
                    $('<option>', {
                        value: "",
                        text: "--Seleccione una Opción--"
                    }));
            for (var i = 0; i < json.length; i++) {
                var fol_rec = json[i].fol_rec;
                var nom_com = json[i].nom_com;
                var sexo = json[i].sexo;
                var fec_nac = json[i].fec_nac;
                var num_afi = json[i].num_afi;
                var carnet = json[i].carnet;
                var mensaje = json[i].mensaje;
                // alert(nom_com);

                $('#select_pac').append(
                        $('<option>', {
                            value: nom_com,
                            text: nom_com
                        }));

                if (mensaje !== "") {
                    alert("Paciente Inexistente");
                }
            }
        }
    });


    $('#select_pac').change(function() {
        var select_pac = $('#select_pac').val();
        $('#nombre_jq').val("");
        //alert(sp_pac);
        var dir = '../RecetaNombre';
        var form = $('#formulario_receta');
        $.ajax({
            type: form.attr('method'),
            url: dir,
            data: form.serialize(),
            success: function(data) {
                devuelveFolio(data);
            },
            error: function() {
                alert("Ha ocurrido un error - paciente");
            }
        });
        function devuelveFolio(data) {
            var json = JSON.parse(data);
            for (var i = 0; i < json.length; i++) {
                var fol_rec = json[i].fol_rec;
                var nom_com = json[i].nom_com;
                var sexo = json[i].sexo;
                var fec_nac = json[i].fec_nac;
                var num_afi = json[i].num_afi;
                var mensaje = json[i].mensaje;
                var carnet = json[i].carnet;
                //alert(mensaje);
                /*if (mensaje === "vig_no_val") {
                 $("#nom_pac").val("");
                 $("#sexo").val("");
                 $("#fec_nac").val("");
                 $("#fol_sp").val("");
                 $("#nombre_jq").val("");
                 $("#nombre_jq").focus();
                 alert("Vigencia no Valida");
                 }*/
                if (mensaje === "inexistente") {
                    alert("Paciente Inexistente");
                    $("#nom_pac").val("");
                    $("#sexo").val("");
                    $("#fec_nac").val("");
                    $("#fol_sp").val("");
                    $("#nombre_jq").val("");
                    $("#nombre_jq").focus();
                }
                if (mensaje === "ok") {
                    $("#folio").val(fol_rec);
                    $("#nom_pac").val(nom_com);
                    $("#sexo").val(sexo);
                    $("#fec_nac").val(fec_nac);
                    $("#fol_sp").val(num_afi);
                    $("#carnet").val(carnet);
                    $("#causes").focus();
                }
            }
        }
    });



    $('#mostrar2').click(function() {
        var sp_pac = $('#sp_pac').val();
        var dir = '../RecetaNombre?tipoRec=manual';
        var form = $('#formulario_receta');
        if($('#tipoCons').val()==="0"){
            alert("seleccione el tipo de consulta");
            $('#tipoCons').focus();
            return false;            
        }
        if ($('#folio').val() === "") {
            alert("Ingrese folio");
            $('#folio').focus();
            return false;
        }
        $.ajax({
            type: form.attr('method'),
            url: dir,
            data: form.serialize(),
            success: function(data) {
                devuelveFolio(data);
            },
            error: function() {
                alert("Ha ocurrido un error mostrar 2");
            }
        });
        function devuelveFolio(data) {
            var json = JSON.parse(data);
            for (var i = 0; i < json.length; i++) {
                var mensaje = json[i].mensaje;
                var fol_rec = json[i].fol_rec;
                var nom_com = json[i].nom_com;
                var sexo = json[i].sexo;
                var fec_nac = json[i].fec_nac;
                var num_afi = json[i].num_afi;
                var carnet = json[i].carnet;
                $("#folio").val(fol_rec);
                $("#nom_pac").val(nom_com);
                $("#sexo").val(sexo);
                $("#fec_nac").val(fec_nac);
                $("#fol_sp").val(num_afi);
                $("#carnet").val(carnet);
                $("#causes").focus();
                /*if (mensaje === "vig_no_val") {
                 $("#nom_pac").val("");
                 $("#sexo").val("");
                 $("#fec_nac").val("");
                 $("#fol_sp").val("");
                 $("#nombre_jq").val("");
                 $("#nombre_jq").focus();
                 alert("Vigencia no valida");
                 }*/
                if (mensaje === "inexistente") {
                    alert("Paciente Inexistente");
                    $("#nom_pac").val("");
                    $("#sexo").val("");
                    $("#fec_nac").val("");
                    $("#fol_sp").val("");
                    $("#nombre_jq").val("");
                    $("#nombre_jq").focus();
                }
            }
        }
    });
    $('#mostrar3').click(function() {
        var sp_pac = $('#medico_jq').val();
        var dir = '../RecetaNombreCol';
        var form = $('#formulario_receta');
        if ($('#folio').val() === "") {
            alert("Ingrese folio");
            $('#folio').focus();
            return false;
        }
        $.ajax({
            type: form.attr('method'),
            url: dir,
            data: form.serialize(),
            success: function(data) {
                devuelveFolio2(data);
            },
            error: function() {
                alert("Ha ocurrido un error mostrar 3");
            }
        });
        function devuelveFolio2(data) {
            var json = JSON.parse(data);
            for (var i = 0; i < json.length; i++) {
                var mensaje = json[i].mensaje;
                var fol_rec = json[i].fol_rec;
                var nom_med = json[i].nom_med;
                var tipoConsulta = json[i].tipoConsulta;
                var cedula = json[i].cedula;

                // $("#folio").val(fol_rec);
                $("#medico").val(nom_med);
                $("#cedula").val(cedula);
                $("#tipoConsulta").val(tipoConsulta);
                $("#nombre_jq").focus();
                /*if (mensaje === "vig_no_val") {
                 $("#medico").val("");
                 $("#cedula").val("");
                 $("#tipoConsulta").val("");
                 $("#medico_jq").focus();
                 alert("Vigencia no valida");
                 }*/
                if (mensaje === "inexistente") {
                    alert("Médico Inexistente");
                    $("#medico").val("");
                    $("#cedula").val("");
                    $("#tipoConsulta").val("");
                    $("#medico_jq").focus();
                }
            }
        }
    });





});
