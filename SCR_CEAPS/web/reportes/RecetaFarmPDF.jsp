<%-- 
    Document   : RecetaFarmPDF
    Created on : 15/04/2015, 11:54:39 AM
    Author     : ALEJO (COL)
--%>

<%@page import="net.sf.jasperreports.engine.JasperRunManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.sql.Connection"%>
<%@page import="Clases.ConectionDB"%>
<%@page import="java.io.File"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    ConectionDB con = new ConectionDB();
    String Folio = request.getParameter("folio");
    String Imagen = "imagen/isem.png";
    String Imagen2 = "imagen/savi1.jpg";
    String Imagen3 = "imagen/gobierno.png";
    String Reporte = "RecetaFarmR.jasper";
    String tip_cob = "";
    String tipo = "";
    Connection conexion;
    con.conectar();
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    conexion = con.getConn();
    if (request.getParameter("tipo") != null) {
        tipo = request.getParameter("tipo");
    }
    if (tipo.equals("1")) {
        File reportFile = new File(application.getRealPath("/reportes/RecetaFarm.jasper"));

        try {
            ResultSet rs = con.consulta("select tip_cob from recetas where fol_rec='" + Folio + "' and cant_sur!=0 GROUP BY fol_rec");
            if (rs.next()) {
                tip_cob = rs.getString(1);
            }

        } catch (Exception ex) {
            System.out.println("Error al buscar" + ex);
        }
        Map parameter = new HashMap();
        parameter.put("folio", Folio);
        parameter.put("logo1", Imagen);
        parameter.put("logo2", Imagen2);
        parameter.put("logo3", Imagen3);
        parameter.put("reporte", Reporte);
        System.out.println("FolioS22-->" + Folio);
        if (tip_cob.equals("SP")) {
            parameter.put("SP", "X");
            parameter.put("PA", "");
            parameter.put("PR", "");
        } else if (tip_cob.equals("PA")) {
            parameter.put("SP", "");
            parameter.put("PA", "X");
            parameter.put("PR", "");
        } else {
            parameter.put("SP", "");
            parameter.put("PA", "");
            parameter.put("PR", "X");
        }
        try {
            byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(), parameter, conexion);
            /*Indicamos que la respuesta va a ser en formato PDF*/
            response.setContentType("application/pdf");
            response.setContentLength(bytes.length);
            ServletOutputStream ouputStream = response.getOutputStream();
            ouputStream.write(bytes, 0, bytes.length); /*Limpiamos y cerramos flujos de salida*/
            ouputStream.flush();
            ouputStream.close();
        } catch (Exception ex) {
            System.out.println("ErrorR->" + ex);
            out.println("<script>alert('Error al General el Reporte')</script>");
            out.println("<script>window.close();</script>");
        }
    } else {
        File reportFile = new File(application.getRealPath("/reportes/RecetaCol.jasper"));
        Map parameter = new HashMap();
        parameter.put("folio", Folio);
        parameter.put("logo1", Imagen);
        parameter.put("logo2", Imagen2);
        parameter.put("logo3", Imagen3);
        parameter.put("reporte", Reporte);
        System.out.println("FolioS22-->" + Folio);

        byte[] bytes = JasperRunManager.runReportToPdf(reportFile.getPath(), parameter, conexion);
        /*Indicamos que la respuesta va a ser en formato PDF*/
        response.setContentType("application/pdf");
        response.setContentLength(bytes.length);
        ServletOutputStream ouputStream = response.getOutputStream();
        ouputStream.write(bytes, 0, bytes.length); /*Limpiamos y cerramos flujos de salida*/ ouputStream.flush();
        ouputStream.close();
    }
    con.cierraConexion();
%>
