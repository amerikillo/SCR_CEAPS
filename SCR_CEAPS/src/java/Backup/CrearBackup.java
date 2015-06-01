/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Backup;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Americo
 */
public class CrearBackup extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        AdministrarBackup backup = new AdministrarBackup();
        try {
            /* TODO output your page here. You may use following sample code. */
            /*out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CrearBakcup</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CrearBakcup at " + request.getContextPath() + "</h1>");
            out.println("<h1>Servlet CrearBakcup at " + request.getSession().getServletContext().getRealPath("") + "</h1>");
            out.println("<h1>Servlet CrearBakcup at " + System.getenv("Path") + "</h1>");
            out.println("</body>");
            out.println("</html>");*/
            String ruta = request.getSession().getServletContext().getRealPath("");
            backup.setDB_EXE("mysqldump");
            //out.println("<h1>Servlet CrearBakcup at " + backup.getDB_EXE() + "</h1>");
            backup.setDB_HOST("localhost");
            backup.setDB_NAME("scr_ceaps");
            backup.setDB_PASS("eve9397");
            backup.setDB_PORT("3306");
            backup.setDB_USER("root");
            backup.setDESTINATION(ruta + File.separator + "backup" + File.separator + "comprimido");
            backup.setFOLDER_NAME(ruta + File.separator + "backup" + File.separator + "sql");
            if (backup.Iniciar()) {
                out.println("<script>alert('Respaldo creado Correctamente')</script>");
            } else {
                out.println("<script>alert('Error al crear el respaldo')</script>");
            }
            out.println("<script>window.location.href='farmacia/existencias.jsp'</script>");
        } finally {
            out.close();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
