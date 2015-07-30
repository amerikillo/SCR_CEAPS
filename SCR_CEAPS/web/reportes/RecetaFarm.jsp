<%-- 
    Document   : RecetaFarm
    Created on : 25/11/2014, 04:45:27 PM
    Author     : CEDIS TOLUCA3
--%>
<%@page import="Clases.ConectionDB"%>
<%@page import="javax.print.attribute.standard.Copies"%>
<%@page import="javax.print.attribute.standard.MediaSizeName"%>
<%@page import="javax.print.attribute.standard.MediaSize"%>
<%@page import="javax.print.attribute.standard.MediaPrintableArea"%>
<%@page import="javax.print.attribute.PrintRequestAttributeSet"%>
<%@page import="javax.print.attribute.HashPrintRequestAttributeSet"%>
<%@page import="net.sf.jasperreports.engine.export.JRPrintServiceExporterParameter"%>
<%@page import="net.sf.jasperreports.engine.export.JRPrintServiceExporter"%>
<%@page import="javax.print.PrintServiceLookup"%>
<%@page import="javax.print.PrintService"%>
<%@page import="net.sf.jasperreports.view.JasperViewer"%>
<%@page import="net.sf.jasperreports.engine.util.JRLoader"%>
<%@page import="java.net.URL"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.io.*"%> 
<%@page import="java.util.HashMap"%> 
<%@page import="java.util.Map"%> 
<%@page import="net.sf.jasperreports.engine.*"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%> 
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%

    String Folio = "", Tipo = "", Usuario = "";
    String pag = "";
    try {
        Folio = request.getParameter("fol_rec");
        Tipo = request.getParameter("tipo");
        pag = request.getParameter("pag");
        Usuario = request.getParameter("usuario");
    } catch (Exception e) {
    }

    String Imagen = "imagen/isem.png";
    String Imagen2 = "imagen/savi1.jpg";
    String Imagen3 = "imagen/gobierno.png";
    String Reporte = "RecetaFarmR.jasper";

%>

<html>
    <head><title></title></head>
    <body>
        <img src="../imagenes/GNKL_Small.JPG" width="100" alt="Lgo">
        <%            ConectionDB con = new ConectionDB();
            Connection conn;
            con.conectar();
            conn = con.getConn();

            int count = 0, Epson = 0, Impre = 0;
            String Nom = "";
            PrintService[] impresoras = PrintServiceLookup.lookupPrintServices(null, null);
            PrintService imprePredet = PrintServiceLookup.lookupDefaultPrintService();
            PrintRequestAttributeSet printRequestAttributeSet = new HashPrintRequestAttributeSet();
            MediaSizeName mediaSizeName = MediaSize.findMedia(4, 4, MediaPrintableArea.INCH);
            printRequestAttributeSet.add(mediaSizeName);
            printRequestAttributeSet.add(new Copies(1));

            for (PrintService printService : impresoras) {
                Nom = printService.getName();
                System.out.println("impresora" + Nom);
                if (Nom.contains("TM-T88V")) {
                    Epson = count;
                } else {
                    Impre = count;
                }
                count++;
            }
            if (Tipo.equals("1")) {
                System.out.println("Nombres:" + Usuario);
                File reportfile;
                try {
                    System.out.println("ruta_>" + application.getRealPath("/reportes/RecetaFarm.jasper"));
                    reportfile = new File(application.getRealPath("/reportes/RecetaFarm.jasper"));

                } catch (Exception ex) {
                    System.out.println("ErrorRuta1->" + ex);
                    reportfile = new File("/home/linux9/NetBeansProjects/SCR_MEDALFA/SCR_MEDALFA/web/reportes/RecetaFarm.jasper");
                }
                String tip_cob = "", tip_cons = "";
                try {
                    ResultSet rs = con.consulta("select tip_cob,tip_cons from recetas where fol_rec='" + Folio + "' and cant_sur!=0 GROUP BY fol_rec");
                    if (rs.next()) {
                        tip_cob = rs.getString(1);
                        tip_cons = rs.getString(2);
                    }
                    System.out.println("TIP-COB->" + tip_cob + " TIP-CONS->" + tip_cons);
                } catch (Exception ex) {
                    System.out.println("Error al buscar" + ex);
                }
                Map parameter = new HashMap();
                parameter.put("firma", session.getAttribute("id_usu"));
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
                if (tip_cons.equals("Consulta Externa")) {
                    parameter.put("CEX", "X");
                    parameter.put("URG", "");
                    parameter.put("HOS", "");
                } else if (tip_cons.equals("Urgencias")) {
                    parameter.put("CEX", "");
                    parameter.put("URG", "X");
                    parameter.put("HOS", "");
                } else if (tip_cons.equals("Hospitalizacion")) {
                    parameter.put("CEX", "");
                    parameter.put("URG", "");
                    parameter.put("HOS", "X");
                }
                JasperPrint jasperPrint = JasperFillManager.fillReport(reportfile.getPath(), parameter, conn);

                JRPrintServiceExporter exporter = new JRPrintServiceExporter();
                exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);

                exporter.setParameter(JRPrintServiceExporterParameter.PRINT_SERVICE_ATTRIBUTE_SET, imprePredet.getAttributes());
                exporter.setParameter(JRPrintServiceExporterParameter.DISPLAY_PAGE_DIALOG, Boolean.FALSE);
                exporter.setParameter(JRPrintServiceExporterParameter.DISPLAY_PRINT_DIALOG, Boolean.FALSE);
                //exporter.setParameter(JRPrintServiceExporterParameter.PRINT_REQUEST_ATTRIBUTE_SET, printRequestAttributeSet);
                try {
                    exporter.exportReport();
                } catch (Exception ex) {
                    out.print("<script type='text/javascript'>alert('Folio sin Datos ');</script>");
                    System.out.println("Error-> " + ex);
                }
                //  JasperPrintManager.printReport(jasperPrint, true);
                /*if (pag == "0") {
                 out.println("<script>window.close();</script>");
                 } else {
                 out.println("<script>window.location='../farmacia/modSurteFarmacia.jsp'</script>");
                 }*/

            } else if (Tipo.equals("2")) {
                File FileCol;
                try {
                    FileCol = new File(application.getRealPath("/reportes/RecetaCol.jasper"));
                } catch (Exception ex) {
                    System.out.println("ErrorRuta2->" + ex);
                    FileCol = new File("/home/linux9/NetBeansProjects/SCR_MEDALFA/SCR_MEDALFA/web/reportes/RecetaCol.jasper");
                }
                Map paraCol = new HashMap();
                paraCol.put("folio", Folio);
                System.out.println("Folio33-->" + Folio);

                JasperPrint jasperPrint = JasperFillManager.fillReport(FileCol.getPath(), paraCol, conn);

                JRPrintServiceExporter exporter = new JRPrintServiceExporter();
                exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
                exporter.setParameter(JRPrintServiceExporterParameter.PRINT_SERVICE_ATTRIBUTE_SET, imprePredet.getAttributes());
                exporter.setParameter(JRPrintServiceExporterParameter.DISPLAY_PAGE_DIALOG, Boolean.FALSE);
                exporter.setParameter(JRPrintServiceExporterParameter.DISPLAY_PRINT_DIALOG, Boolean.FALSE);
                //exporter.setParameter(JRPrintServiceExporterParameter.PRINT_REQUEST_ATTRIBUTE_SET, printRequestAttributeSet);       
                try {
                    exporter.exportReport();
                } catch (Exception ex) {
                    out.print("<script type='text/javascript'>alert('Folio sin Datos ');</script>");
                    System.out.println("Error-> " + ex);
                }

                //            JasperPrintManager.printReport(jasperPrint, false);            
            } else if (Tipo.equals("2")) {
                File reporticket;
                try {
                    reporticket = new File(application.getRealPath("reportes/RecetaTicket.jasper"));
                } catch (Exception ex) {
                    System.out.println("ErrorRutaCOL->" + ex);
                    //reporticket = new File("/home/linux9/NetBeansProjects/SCR_MEDALFA/SCR_MEDALFA/web/reportes/RecetaTicket.jasper");
                }
                Map parameterticket = new HashMap();
                parameterticket.put("folio", Folio);
                parameterticket.put("NomUsu", Usuario);
                //JasperPrint jasperPrintticket = JasperFillManager.fillReport(reporticket.getPath(), parameterticket, conn);

                JRPrintServiceExporter exporter = new JRPrintServiceExporter();
                //exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrintticket);
                exporter.setParameter(JRPrintServiceExporterParameter.PRINT_SERVICE_ATTRIBUTE_SET, impresoras[Epson].getAttributes());
                exporter.setParameter(JRPrintServiceExporterParameter.DISPLAY_PAGE_DIALOG, Boolean.FALSE);
                exporter.setParameter(JRPrintServiceExporterParameter.DISPLAY_PRINT_DIALOG, Boolean.FALSE);
                //exporter.setParameter(JRPrintServiceExporterParameter.PRINT_REQUEST_ATTRIBUTE_SET, printRequestAttributeSet);       
                try {
                    //exporter.exportReport();
                } catch (Exception ex) {
                    out.print("<script type='text/javascript'>alert('Folio sin Datos ');</script>");
                    System.out.println("Error-> " + ex);
                }

                //JasperPrintManager.printReport(jasperPrintticket, false);
                out.println("<script>window.location='../farmacia/ReTicket.jsp'</script>");
            } else {
                File reporticket;
                try {
                    reporticket = new File(application.getRealPath("reportes/RecetaTicket.jasper"));
                } catch (Exception ex) {
                    System.out.println("ErrorRuta++->" + ex);
                    //reporticket = new File("/home/linux9/NetBeansProjects/SCR_MEDALFA/SCR_MEDALFA/web/reportes/RecetaTicket.jasper");
                }
                Map parameterticket = new HashMap();
                parameterticket.put("folio", Folio);
                parameterticket.put("NomUsu", Usuario);
                //JasperPrint jasperPrintticket = JasperFillManager.fillReport(reporticket.getPath(), parameterticket, conn);

                JRPrintServiceExporter exporter = new JRPrintServiceExporter();
                //exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrintticket);
                exporter.setParameter(JRPrintServiceExporterParameter.PRINT_SERVICE_ATTRIBUTE_SET, impresoras[Epson].getAttributes());
                exporter.setParameter(JRPrintServiceExporterParameter.DISPLAY_PAGE_DIALOG, Boolean.FALSE);
                exporter.setParameter(JRPrintServiceExporterParameter.DISPLAY_PRINT_DIALOG, Boolean.FALSE);
                //exporter.setParameter(JRPrintServiceExporterParameter.PRINT_REQUEST_ATTRIBUTE_SET, printRequestAttributeSet);       
                try {
                    //exporter.exportReport();
                } catch (Exception ex) {
                    out.print("<script type='text/javascript'>alert('Folio sin Datos ');</script>");
                    System.out.println("Error-> " + ex);
                }

                // JasperPrintManager.printReport(jasperPrintticket, true);
        %>
        <script type="text/javascript">
            var ventana = window.self;
            ventana.opener = window.self;
            setTimeout("window.close()", 1000);
        </script>
        <%        }

        %>
        <script type="text/javascript">
            window.close();
        </script>
    </body>
</html>
