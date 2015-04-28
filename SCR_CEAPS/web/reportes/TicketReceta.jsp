<%-- 
    Document   : Reporte
    Created on : 26/12/2012, 09:05:24 AM
    Author     : Unknown
--%>

<%@page import="Clases.ConectionDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="net.sf.jasperreports.engine.*" %> 
<%@ page import="java.util.*" %> 
<%@ page import="java.io.*" %> 
<%@ page import="java.sql.*" %> 
<% /*Parametros para realizar la conexión*/

    HttpSession sesion = request.getSession();
    String usua = "";
    if (sesion.getAttribute("nombre") != null) {
        usua = (String) sesion.getAttribute("nombre");
    } else {
        //response.sendRedirect("index.jsp");
    }
    String ruta = request.getRequestURL().toString();
    String ruta2[] = ruta.split("/");
    String rutaFinal = "";
    for (int i = 0; i < 4; i++) {
        out.println(ruta2[i] + i + "\n");
        rutaFinal = rutaFinal + ruta2[i] + "/";
    }
    String folio_gnk = (String) session.getAttribute("folio");
    ConectionDB con = new ConectionDB();
    Connection conexion;
    con.conectar();
    conexion = con.getConn();

    /*Establecemos la ruta del reporte*/
    File reportFile = new File(application.getRealPath("reportes/etiquetasReceta.jasper"));
    /* No enviamos parámetros porque nuestro reporte no los necesita asi que escriba 
     cualquier cadena de texto ya que solo seguiremos el formato del método runReportToPdf*/
    Map parameters = new HashMap();
    parameters.put("fol_rec", request.getParameter("fol_rec"));
    parameters.put("ruta", rutaFinal + "farmacia/modSurteFarmacia.jsp");
    /*Enviamos la ruta del reporte, los parámetros y la conexión(objeto Connection)*/
    byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(), parameters, conexion);
    /*Indicamos que la respuesta va a ser en formato PDF*/ response.setContentType("application/pdf");
    response.setContentLength(bytes.length);
    ServletOutputStream ouputStream = response.getOutputStream();
    ouputStream.write(bytes, 0, bytes.length); /*Limpiamos y cerramos flujos de salida*/ ouputStream.flush();
    ouputStream.close();

    conexion.close();
    con.cierraConexion();
%>
