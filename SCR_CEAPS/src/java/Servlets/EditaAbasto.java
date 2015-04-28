/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import Clases.CargaAbasto;
import Clases.ConectionDB;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.simple.JSONObject;

/**
 *
 * @author ALEJO (COL)
 */
public class EditaAbasto extends HttpServlet {

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
        HttpSession sesion = request.getSession();
        ConectionDB con = new ConectionDB();
        JSONObject json = new JSONObject();
        try {
            String que = request.getParameter("que");
            if (que == null) {
                que = "";
            }
            if (que.equals("V")) {
                sesion.setAttribute("id", request.getParameter("id"));
            } else if (que.equals("E")) {
                try {
                    con.conectar();
                    con.actualizar("update carga_abasto set lote='" + request.getParameter("lote") + "',caducidad='" + request.getParameter("caduc") + "',cantidad='" + request.getParameter("cant") + "',origen='" + request.getParameter("ori") + "' where id='" + request.getParameter("id") + "'");
                    ResultSet rs = con.consulta("Select clave,lote,caducidad,cantidad,origen from carga_abasto where id='" + request.getParameter("id") + "'");
                    if (rs.next()) {
                        json.put("clave", rs.getString(1));
                        json.put("lote", rs.getString(2));
                        json.put("caducidad", rs.getString(3));
                        json.put("cantidad", rs.getString(4));
                        json.put("origen", rs.getString(5));
                        json.put("editar", "<a class=\"btn btn-warning\" id=\"Editar\" onclick=\"EditarAb(" + request.getParameter("id") + ")\" data-toggle=\"modal\" data-target=\"#EditarAbasto\"><span class=\"glyphicon glyphicon-edit\"></span></a>");
                        json.put("msg", "1");
                    }
                    con.cierraConexion();
                    out.println(json);
                } catch (Exception ex) {
                    System.out.print("ErrorEdi~~>" + ex);
                    json.put("msg", "0");
                    out.println(json);
                }
            } else if (que.equals("Val")) {
                CargaAbasto carga = new CargaAbasto();
                String mensaje = carga.cargaAbasto((String) sesion.getAttribute("cla_uni"), (String) sesion.getAttribute("id_usu"), (String) sesion.getAttribute("nomArchivo"));
                if (mensaje.equals("1")) {
                    try{
                        con.conectar();
                        con.actualizar("insert into reporte_abasto(clave,lote,caducidad,cantidad,origen,cb,fecha,nom_abasto) SELECT clave,lote,caducidad,cantidad,origen,cb,NOW(),'"+(String) sesion.getAttribute("nomArchivo")+"' from carga_abasto");
                        con.cierraConexion();
                    }catch(Exception ex){
                        System.out.print("ErrorRep->"+ex);
                        out.print("Error al guardar el reporte de abasto--");
                    }
                    out.print("Abasto cargado con Exito");
                    sesion.setAttribute("ver", "no");
                } else {
                    out.println(mensaje);
                }
            }else if (que.equals("R")) {
                System.out.println("nom->"+request.getParameter("nom"));
                sesion.setAttribute("nom_abasto", request.getParameter("nom"));
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
