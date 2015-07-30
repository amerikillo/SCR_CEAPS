/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Servlets;

import Clases.ConectionDB;
import java.io.IOException;
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
public class EditaMedicamento extends HttpServlet {

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
        System.out.println("hols");
        ConectionDB con = new ConectionDB();
        HttpSession sesion = request.getSession(true);
        try {
            con.conectar();
            try {
                String det_pro = "", id_rec = "", lot_pro = "", cad_pro = "";
                int n_cant = 0, can_sol = 0, cant_sur = 0, cant_inv = 0;
                ResultSet rset = con.consulta("select dr.det_pro, dr.can_sol, dr.cant_sur, i.cant, dr.id_rec,dp.lot_pro, dp.cad_pro from detreceta dr, detalle_productos dp, inventario i where dr.det_pro = dp.det_pro and dp.det_pro = i.det_pro and dr.fol_det = '" + request.getParameter("fol_det") + "' ");
                while (rset.next()) {
                    det_pro = rset.getString(1);
                    can_sol = rset.getInt(2);
                    cant_sur = rset.getInt(3);
                    cant_inv = rset.getInt(4);
                    id_rec = rset.getString(5);
                    lot_pro = rset.getString("lot_pro");
                    cad_pro = rset.getString("cad_pro");
                }

                if (Integer.parseInt(request.getParameter("cant_sol")) == 0) {
                    System.out.println("Cantidad 0");
                    n_cant = cant_inv + cant_sur;
                    con.insertar("update detreceta set can_sol = '0', cant_sur = '0', baja='1', indicaciones='' where fol_det = '" + request.getParameter("fol_det") + "' ");
                    if (n_cant >= 0) {
                        con.insertar("update inventario set cant = '" + n_cant + "' where det_pro = '" + det_pro + "' ");
                    }
                    con.insertar("insert into kardex values ('0', '" + id_rec + "', '" + det_pro + "', '" + cant_sur + "', 'REINTEGRA AL INVENTARIO', '-', NOW(), 'SE ELIMINA INSUMO DE RECETA', '" + sesion.getAttribute("id_usu") + "', '0'); ");
                } else {
                    if (Integer.parseInt(request.getParameter("cant_sol")) > can_sol) {
                        if (Integer.parseInt(request.getParameter("cant_sol")) > cant_inv) {
                            System.out.println("***************************cantidad mayo que la de ");
                            if (cant_sur == 0) {
                                System.out.println("Cantidad mayor");
                                int dif = Integer.parseInt(request.getParameter("cant_sol")) - cant_sur;
                                n_cant = cant_inv - dif;
                                con.insertar("update detreceta set can_sol = '" + request.getParameter("cant_sol") + "', cant_sur = '0', baja='0', indicaciones='" + request.getParameter("cant_sol") + " POR " + request.getParameter("duraModal") + " DIA(S) | " + request.getParameter("indicaModal") + "' where fol_det = '" + request.getParameter("fol_det") + "' ");
                                if (n_cant >= 0) {
                                    con.insertar("update inventario set cant = '" + n_cant + "' where det_pro = '" + det_pro + "' ");
                                    con.insertar("insert into kardex values ('0', '" + id_rec + "', '" + det_pro + "', '" + dif + "', 'SALIDA RECETA', '-', NOW(), 'SE MODIFICA INSUMO', '" + sesion.getAttribute("id_usu") + "', '0'); ");
                                }

                            } else {
                                //con.insertar("update detreceta set indicaciones='" + request.getParameter("cant_sol") + " POR " + request.getParameter("duraModal") + " DIA(S) | " + request.getParameter("indicaModal") + "' where fol_det = '" + request.getParameter("fol_det") + "' ");
                            }
                        } else {
                            System.out.println("Cantidad mayor");
                            int dif = Integer.parseInt(request.getParameter("cant_sol")) - cant_sur;
                            n_cant = cant_inv - dif;
                            con.insertar("update detreceta set can_sol = '" + request.getParameter("cant_sol") + "', cant_sur = '" + request.getParameter("cant_sol") + "', baja='0', indicaciones='" + request.getParameter("cant_sol") + " POR " + request.getParameter("duraModal") + " DIA(S) | " + request.getParameter("indicaModal") + "' where fol_det = '" + request.getParameter("fol_det") + "' ");
                            if (n_cant >= 0) {
                                con.insertar("update inventario set cant = '" + n_cant + "' where det_pro = '" + det_pro + "' ");
                                con.insertar("insert into kardex values ('0', '" + id_rec + "', '" + det_pro + "', '" + dif + "', 'SALIDA RECETA', '-', NOW(), 'SE MODIFICA INSUMO', '" + sesion.getAttribute("id_usu") + "', '0'); ");
                            }

                        }
                    } else {
                        if (cant_sur == 0) {
                            System.out.println("Cantidad menor");
                            int dif = can_sol - Integer.parseInt(request.getParameter("cant_sol"));
                            n_cant = cant_inv + dif;
                            con.insertar("update detreceta set can_sol = '" + request.getParameter("cant_sol") + "', cant_sur = '0', indicaciones='" + request.getParameter("cant_sol") + " POR " + request.getParameter("duraModal") + " DIA(S) | " + request.getParameter("indicaModal") + "' where fol_det = '" + request.getParameter("fol_det") + "' ");
                            if (!request.getParameter("cant_sur").equals("0")) {
                                if (n_cant >= 0) {
                                    con.insertar("update inventario set cant = '" + n_cant + "' where det_pro = '" + det_pro + "' ");
                                    con.insertar("insert into kardex values ('0', '" + id_rec + "', '" + det_pro + "', '" + dif + "', 'REINTEGRA AL INVENTARIO', '-', NOW(), 'SE MODIFICA INSUMO DE RECETA', '" + sesion.getAttribute("id_usu") + "', '0'); ");
                                }

                            }
                        } else {
                            System.out.println("Cantidad menor");
                            int dif = can_sol - Integer.parseInt(request.getParameter("cant_sol"));
                            n_cant = cant_inv + dif;
                            con.insertar("update detreceta set can_sol = '" + request.getParameter("cant_sol") + "', cant_sur = '" + request.getParameter("cant_sol") + "', indicaciones='" + request.getParameter("cant_sol") + " POR " + request.getParameter("duraModal") + " DIA(S) | " + request.getParameter("indicaModal") + "' where fol_det = '" + request.getParameter("fol_det") + "' ");

                            if (!request.getParameter("cant_sur").equals("0")) {
                                if (n_cant >= 0) {
                                    con.insertar("update inventario set cant = '" + n_cant + "' where det_pro = '" + det_pro + "' ");
                                    con.insertar("insert into kardex values ('0', '" + id_rec + "', '" + det_pro + "', '" + dif + "', 'REINTEGRA AL INVENTARIO', '-', NOW(), 'SE MODIFICA INSUMO DE RECETA', '" + sesion.getAttribute("id_usu") + "', '0'); ");
                                }

                            }
                        }
                    }
                }

            } catch (Exception e) {
                System.out.println(e);
            }
            con.cierraConexion();
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

}
