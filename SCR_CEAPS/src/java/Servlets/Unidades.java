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
 * @author ALEJO (COL)
 */
public class Unidades extends HttpServlet {

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
        try {
            String que;
            que = request.getParameter("que");
            if (que == null) {
                que = "";
            }
            if (que.equals("Jur")) {
                sesion.setAttribute("cla_jur", request.getParameter("id"));

                try {
                    con.conectar();
                    ResultSet rs = con.consulta("Select des_jur from jurisdicciones where cla_jur='" + request.getParameter("id") + "'");
                    if (rs.next()) {
                        out.print(rs.getString(1));
                    }
                    con.cierraConexion();
                } catch (Exception ex) {
                    System.out.println("Error" + ex);
                }
            } else if (que.equals("Muni")) {
                try {
                    con.conectar();
                    ResultSet rs = con.consulta("Select des_mun from municipios where cla_mun='" + request.getParameter("id") + "'");
                    while (rs.next()) {
                        out.print(rs.getString(1));
                    }
                    con.cierraConexion();
                } catch (Exception ex) {
                    System.out.println("Error" + ex);
                }
            }else if(que.equals("G")){
                try {
                    con.conectar();
                    ResultSet rs = con.consulta("Select cla_uni from unidades where cla_uni='" + request.getParameter("id") + "'");
                    if (rs.next()) {
                        con.actualizar("update unidades set des_uni='"+request.getParameter("nombreUni")+"',cla_mun='"+request.getParameter("muni")+"',claisem='"+request.getParameter("claIsem")+"',clajur='"+request.getParameter("jur")+"',domic='"+request.getParameter("dir")+"',licencia='"+request.getParameter("lic")+"'"
                                + "where cla_uni='"+request.getParameter("id")+"'");
                        out.print("Se Actualizó correctamente la unidad");
                    }else{
                        con.insertar("INSERT INTO unidades (cla_uni, des_uni, cla_mun, tip_uni, claisem, clajur, domic,licencia) VALUES "
                                + "('"+request.getParameter("id")+"', '"+request.getParameter("nombreUni")+"', '"+request.getParameter("muni")+"', 'F', '"+request.getParameter("claIsem")+"', '"+request.getParameter("jur")+"', '"+request.getParameter("dir")+"','"+request.getParameter("lic")+"')");
                        out.print("Se insertó correctamente la unidad");
                    }
                    con.cierraConexion();
                } catch (Exception ex) {
                    out.print("Error al Guardar");
                    System.out.println("Error" + ex);
                }
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
