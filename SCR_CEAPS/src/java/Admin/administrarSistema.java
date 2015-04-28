/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Admin;

import Clases.ConectionDB;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Americo
 */
@WebServlet(name = "administrarSistema", urlPatterns = {"/administrarSistema"})
public class administrarSistema extends HttpServlet {

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
        ConectionDB con = new ConectionDB();
        HttpSession sesion = request.getSession();
        try {
            try {
                if (request.getParameter("accion").equals("actualizarFolio")) {
                    try {
                        con.conectar();
                        con.insertar("update indices set id_rec = '" + request.getParameter("id_rec") + "'");
                        con.cierraConexion();
                        out.println("<script>alert('Folio Actualizado Correctamente')</script>");
                    } catch (Exception e) {
                        System.out.println(e);
                        out.println("<script>alert('Error al actualizar folio:" + e.getMessage() + "')</script>");
                    }
                    out.println("<script>window.location='admin/recetas/folio.jsp'</script>");
                } else if (request.getParameter("accion").equals("reiniciarRecetas")) {
                    try {
                        con.conectar();
                        con.insertar("delete from receta");
                        con.cierraConexion();
                        out.println("<script>alert('Limpieza correcta en Recetas')</script>");
                    } catch (Exception e) {
                        System.out.println(e);
                        out.println("<script>alert('Error al limpiar recetas:" + e.getMessage() + "')</script>");
                    }
                    out.println("<script>window.location='admin/recetas/folio.jsp'</script>");
                } else if (request.getParameter("accion").equals("reiniciarExistenciasYRecetas")) {
                    try {
                        con.conectar();
                        con.insertar("delete from receta");
                        con.insertar("delete from detalle_productos");
                        con.cierraConexion();
                        out.println("<script>alert('Limpieza correcta en Existencias y Recetas')</script>");
                    } catch (Exception e) {
                        System.out.println(e);
                        out.println("<script>alert('Error al limpiar:" + e.getMessage() + "')</script>");
                    }
                    out.println("<script>window.location='admin/recetas/folio.jsp'</script>");
                }else if (request.getParameter("accion").equals("uni")) {
                    try{
                    con.conectar();
                    con.actualizar("update usuarios set cla_uni='"+request.getParameter("uni")+"' where id_usu='"+sesion.getAttribute("id_usu")+"'");
                    con.cierraConexion();
                    out.print("<script>alert('Unidad asignada con éxito')</script>");
                    out.print("<script>window.location='admin/recetas/folio.jsp'</script>");
                    }catch(Exception ex){
                        System.out.println("ErrorUni~>"+ex);
                    }
                }
            } catch (Exception e) {
                out.println(e.getMessage());
            }
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
