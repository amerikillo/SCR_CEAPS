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
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

/**
 *
 * @author Americo
 */
public class ModiMedico extends HttpServlet {

    ConectionDB con = new ConectionDB();

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
            JSONObject json = new JSONObject();
            JSONArray jsona = new JSONArray();
            DateFormat df2 = new SimpleDateFormat("dd/MM/yyyy");
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            int baja = 0;
            con.conectar();
            try {
                byte[] a = request.getParameter("ape_pat").getBytes("ISO-8859-1");
                String ape_pat = new String(a, "UTF-8");
                a = request.getParameter("ape_mat").getBytes("ISO-8859-1");
                String ape_mat = new String(a, "UTF-8");
                a = request.getParameter("nombre").getBytes("ISO-8859-1");
                String nombre = new String(a, "UTF-8");

                String tipoConsu = request.getParameter("txtTipoConsu");
                String completo = ape_pat.toUpperCase() + " " + ape_mat.toUpperCase() + " " + nombre.toUpperCase();
                System.out.println("Nombre completo:" + completo);
                con.actualizar("update medicos set tipoConsulta='" + tipoConsu + "', ape_pat='" + ape_pat.toUpperCase() + "',ape_mat='" + ape_mat.toUpperCase() + "',nom_med='" + nombre.toUpperCase() + "',nom_com='" + (ape_pat.toUpperCase() + " " + ape_mat.toUpperCase() + " " + nombre.toUpperCase()) + "',rfc='" + request.getParameter("rfc") + "',cedulapro='" + request.getParameter("cedula") + "',f_status='" + request.getParameter("estatus") + "', iniRec='" + request.getParameter("iniRec") + "',finRec='" + request.getParameter("finRec") + "',folAct='" + request.getParameter("folAct") + "' WHERE cedula='" + request.getParameter("clave") + "'");
                if (request.getParameter("estatus").equals("A")) {
                    baja = 1;
                } else {
                    baja = 0;
                }
                con.actualizar("UPDATE usuarios SET pass=MD5('" + request.getParameter("password") + "'),baja='" + baja + "',passReal='" + request.getParameter("password") + "', ape_pat='" + ape_pat.toUpperCase() + "',ape_mat='" + ape_mat.toUpperCase() + "',nombre='" + nombre.toUpperCase() + "', user = '" + request.getParameter("usuario") + "'  WHERE cedula='" + request.getParameter("clave") + "'");
                json.put("mensaje", "Médico actualizado correctamente con la Clave " + request.getParameter("clave") + " ");
                json.put("ban", "1");

            } catch (Exception e) {
                json.put("mensaje", "El Médico no se pudo actualizar");
                System.out.println(e.getMessage());
            }
            out.println();

            con.cierraConexion();
            jsona.add(json);
            out.println(jsona);
            System.out.println(jsona);
        } catch (Exception e) {
            System.out.println(e.getMessage());
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
