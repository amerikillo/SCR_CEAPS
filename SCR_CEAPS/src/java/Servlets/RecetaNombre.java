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
public class RecetaNombre extends HttpServlet {

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

            String nombre;
            long nomb;
            boolean numNom;
            try {
                nomb = Long.parseLong(request.getParameter("nombre_jq"));
                nombre = "" + nomb;
                numNom = true;
            } catch (Exception ex) {
                byte[] a = request.getParameter("nombre_jq").getBytes("ISO-8859-1");
                nombre = new String(a, "UTF-8");
                System.out.println("nombre *" + nombre + "*");
                if (nombre.equals("")) {
                    byte[] b = request.getParameter("select_pac").getBytes("ISO-8859-1");
                    nombre = new String(b, "UTF-8");
                }
                numNom = false;
            }
            System.out.println("nombre *" + nombre + "*");
            String id_rec = "";
            String idRec = "";
            ResultSet rsetFol = con.consulta("select max(fol_rec) as fol_rec from receta where transito='1' and id_usu = '" + sesion.getAttribute("id_usu") + "' ");
            while (rsetFol.next()) {
                idRec = rsetFol.getString("fol_rec");
            }
            if (idRec == null) {
                idRec = "0";
            }
            if (folio_rec.equals("")) {
                try {
                    ResultSet rset = con.consulta("select m.folAct from medicos m, usuarios u where u.cedula = m.cedula and u.id_usu = '" + sesion.getAttribute("id_usu") + "' ");
                    while (rset.next()) {
                        id_rec = rset.getString(1);
                    }
                    if (Integer.parseInt(idRec) + 1 == Integer.parseInt(id_rec) && Integer.parseInt(idRec) != 0) {
                        id_rec = idRec;
                    } else {
                        con.actualizar("update medicos m, usuarios u set m.folAct= '" + (Integer.parseInt(id_rec) + 1) + "' where u.cedula = m.cedula and u.id_usu = '" + sesion.getAttribute("id_usu") + "' ");
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
                ResultSet rset;
                if (numNom) {
                    rset = con.consulta("select id_pac, nom_com, sexo, fec_nac, num_afi, ini_vig, fin_vig,expediente from pacientes where id_pac = '" + nombre + "' and f_status='A' limit 1 ");
                }else{
                    rset = con.consulta("select id_pac, nom_com, sexo, fec_nac, num_afi, ini_vig, fin_vig,expediente from pacientes where nom_com = '" + nombre + "' and f_status='A' limit 1 ");
                }
                while (rset.next()) {
                    Date ini_v = df.parse(rset.getString("ini_vig"));
                    Date fin_v = df.parse(rset.getString("fin_vig"));
                    Date f_actual = new Date();
                    if (f_actual.before(fin_v) && f_actual.after(ini_v)) {
                        json.put("mensaje", "ok");

                        sesion.setAttribute("id_pac", rset.getString(1));
                        sesion.setAttribute("nom_com", rset.getString(2));
                        sesion.setAttribute("sexo", rset.getString(3));
                        sesion.setAttribute("fec_nac", df2.format(df.parse(rset.getString(4))));
                        sesion.setAttribute("num_afi", rset.getString(5));
                        sesion.setAttribute("carnet", rset.getString(8));
                        json.put("id_pac", rset.getString(1));
                        json.put("nom_com", rset.getString(2));
                        json.put("sexo", rset.getString(3));
                        json.put("fec_nac", df2.format(df.parse(rset.getString(4))));
                        json.put("num_afi", rset.getString(5));
                        json.put("carnet", rset.getString(8));
                    } else {
                        //json.put("mensaje", "ok");
                        json.put("mensaje", "vig_no_val");// valida la vigencia
                        //System.out.println("mal");

                        sesion.setAttribute("id_pac", "");
                        sesion.setAttribute("nom_com", "");
                        sesion.setAttribute("sexo", "");
                        sesion.setAttribute("fec_nac", "");
                        sesion.setAttribute("num_afi", "");
                        sesion.setAttribute("carnet", "");
                        json.put("id_pac", "");
                        json.put("nom_com", "");
                        json.put("sexo", "");
                        json.put("fec_nac", "");
                        json.put("num_afi", "");
                        json.put("carnet", "");
                        if (request.getParameter("tipoRec") != null) {
                            if (request.getParameter("tipoRec").equals("manual")) {
                                sesion.setAttribute("id_pac", rset.getString(1));
                                sesion.setAttribute("nom_com", rset.getString(2));
                                sesion.setAttribute("sexo", rset.getString(3));
                                sesion.setAttribute("fec_nac", df2.format(df.parse(rset.getString(4))));
                                sesion.setAttribute("num_afi", rset.getString(5));
                                sesion.setAttribute("carnet", rset.getString(8));
                                json.put("id_pac", rset.getString(1));
                                json.put("nom_com", rset.getString(2));
                                json.put("sexo", rset.getString(3));
                                json.put("fec_nac", df2.format(df.parse(rset.getString(4))));
                                json.put("num_afi", rset.getString(5));
                                json.put("carnet", rset.getString(8));
                            }
                        }
                    }

                    try {
                        con.actualizar("update receta set id_pac = '" + rset.getString(1) + "' where fol_rec = '" + folio_rec + "' and id_usu='" + sesion.getAttribute("id_usu") + "' ");
                    } catch (Exception e) {
                    }
                    ban = 1;
                    jsona.add(json);
                    json = new JSONObject();
                }
                if (ban == 0) {
                    json.put("id_pac", "");
                    json.put("nom_com", "");
                    json.put("sexo", "");
                    json.put("fec_nac", "");
                    json.put("num_afi", "");
                    json.put("mensaje", "inexistente");
                    jsona.add(json);
                    json = new JSONObject();
                }
            } catch (Exception e) {
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
