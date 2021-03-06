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
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

/**
 *
 * @author Americo
 */
public class RecetaNombreCol extends HttpServlet {

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

        try {
            DateFormat df2 = new SimpleDateFormat("dd/MM/yyyy");
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            ConectionDB con = new ConectionDB();
            JSONObject json = new JSONObject();
            JSONArray jsona = new JSONArray();
            con.conectar();
            HttpSession sesion = request.getSession(true);
            String folio_sp = request.getParameter("sp_pac");
            String folio_rec = request.getParameter("folio");

            byte[] a = request.getParameter("medico_jq").getBytes("ISO-8859-1");
            String nombre = new String(a, "UTF-8");

            String id_rec = "";
            if (folio_rec.equals("")) {
                try {
                    ResultSet rset = con.consulta("select id_rec from indices");
                    while (rset.next()) {
                        id_rec = rset.getString(1);
                    }
                    if (id_rec.equals("")) {
                        con.actualizar("insert into indices (id_rec) values ('2')");
                        id_rec = "1";
                    } else {
                        con.actualizar("update indices set id_rec= '" + (Integer.parseInt(id_rec) + 1) + "' ");
                    }
                    json.put("fol_rec", id_rec);
                    sesion.setAttribute("folio_rec", id_rec);
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
                out.println();
            } else {
                json.put("fol_rec", folio_rec);
                sesion.setAttribute("folio_rec", folio_rec);
            }
            int ban = 0;
            try {
                ResultSet rset = con.consulta("SELECT cedula,nom_com, tipoConsulta FROM medicos WHERE nom_com = '" + nombre + "' limit 1 ");
                while (rset.next()) {

                    ban = 1;
                    sesion.setAttribute("cedula", rset.getString(1));
                    sesion.setAttribute("nom_med", rset.getString(2));
                    sesion.setAttribute("tipoConsulta", rset.getString(3));
                    json.put("cedula", rset.getString(1));
                    json.put("nom_med", rset.getString(2));
                    json.put("tipoConsulta", rset.getString(3));
                    jsona.add(json);
                    json = new JSONObject();
                }
                if (ban == 0) {
                    json.put("cedula", "");
                    json.put("nom_med", "");
                    json.put("mensaje", "inexistente");
                    jsona.add(json);
                    json = new JSONObject();
                }
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }

            System.out.println((String) sesion.getAttribute("folio_rec"));
            con.cierraConexion();
            out.println(jsona);
            System.out.println(jsona);
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        /*String folio_sp = request.getParameter("sp_pac");
         System.out.println(folio_sp);
         out.println(folio_sp);*/
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
