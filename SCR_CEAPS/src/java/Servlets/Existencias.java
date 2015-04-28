/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import Clases.ConectionDB;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Americo
 */
public class Existencias extends HttpServlet {

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
        HttpSession sesion = request.getSession(true);
        try {
            if (request.getParameter("accion").equals("salidaAjuste")) {
                try {
                    String id_inv = request.getParameter("id_inv");
                    int cantAjuste = Integer.parseInt(request.getParameter("cantAjuste"));
                    int cantInv = 0;
                    String det_pro = "";
                    byte[] a = request.getParameter("obs").getBytes("UTF-8");
                    String obs = new String(a, "UTF-8");
                    con.conectar();
                    ResultSet rset = con.consulta("select cant, det_pro from inventario where id_inv = '" + id_inv + "'");
                    while (rset.next()) {
                        cantInv = rset.getInt("cant");
                        det_pro = rset.getString("det_pro");
                    }

                    con.insertar("update inventario set cant = '" + (cantInv - cantAjuste) + "' where id_inv = '" + id_inv + "' ");
                    con.insertar("insert into kardex values ('0','0','" + det_pro + "','" + cantAjuste + "','SALIDA POR AJUSTE','-',NOW(),'" + obs + "','" + sesion.getAttribute("id_usu") + "','0')");
                    con.cierraConexion();

                    out.println("<script>alert('Ajuste Correcto')</script>");
                } catch (Exception e) {

                    out.println("<script>Error al realizar el ajuste: " + e + " </script>");
                }
                out.println("<script>window.location='farmacia/salidasAjuste.jsp'</script>");
            }
        } catch (Exception e) {

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
