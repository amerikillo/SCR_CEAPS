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
import java.sql.SQLException;
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
public class CapturaMedicamentoManual extends HttpServlet {

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
        DateFormat df2 = new SimpleDateFormat("dd/MM/yyyy");
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        ConectionDB con = new ConectionDB();
        JSONObject json = new JSONObject();
        JSONArray jsona = new JSONArray();
        HttpSession sesion = request.getSession(true);
        String fecha1 = df.format(new Date());
        String fecha2 = "2030-01-01";
        System.out.println("hola");
        ResultSet ExisRec = null;
        try {
            con.conectar();
            try {
                int sol = Integer.parseInt(request.getParameter("can_sol"));
                int sur = sol;
                int sol1 = 0;
                String causes = "", causes2 = "";
                sesion.setAttribute("folio_recRM", request.getParameter("folio"));
                /*
                 * Causes 2
                 */
                byte[] a = request.getParameter("causes").getBytes("UTF-8");
                String causes_L = new String(a, "UTF-8");
                sesion.setAttribute("diag1", causes_L);
                String[] arrayCauses = causes_L.split(" - ");
                String indicaciones = request.getParameter("can_sol")+" CAJAS POR " + request.getParameter("dias") + " DIA(S)";
                byte[] b = request.getParameter("indicaciones").getBytes("ISO-8859-1");
                String indica = new String(b, "UTF-8");
                if (!indica.equals("")) {
                    indicaciones = indicaciones + " | \n" + indica;
                }
                if (arrayCauses.length > 1) {
                    causes_L = arrayCauses[1];
                }
                ResultSet rset_cau = con.consulta("select id_cau from causes where des_cau = '" + causes_L + "' ");
                while (rset_cau.next()) {
                    causes = rset_cau.getString(1);
                }
                if (causes.equals("")) {
                    causes = "999";
                }
                /*
                 * Causes 2
                 */

                a = request.getParameter("causes2").getBytes("UTF-8");
                causes_L = new String(a, "UTF-8");
                sesion.setAttribute("diag2", causes_L);
                arrayCauses = causes_L.split(" - ");
                if (arrayCauses.length > 1) {
                    causes_L = arrayCauses[1];
                }
                rset_cau = con.consulta("select id_cau from causes where des_cau = '" + causes_L + "' ");
                while (rset_cau.next()) {
                    causes2 = rset_cau.getString(1);
                }
                if (causes2.equals("")) {
                    //causes2 = "999";
                }
                String det_pro = "";
                String id_rec = "";
                String id_tip = "";
                ResultSet rset = con.consulta("select r.id_rec, id_tip from receta r, usuarios us, unidades un where r.fol_rec = '" + request.getParameter("folio") + "' and r.cedula = '" + request.getParameter("cedula") + "' and r.id_usu = us.id_usu and us.cla_uni = un.cla_uni and un.des_uni = '" + request.getParameter("uni_ate") + "' and r.id_tip='1' ");
                while (rset.next()) {
                    id_rec = rset.getString(1);
                    id_tip = rset.getString(2);
                }
                System.out.println("tipoooooo" + id_tip);
                System.out.println("----------------****" + id_rec);
                con.insertar("update receta set baja = '0', transito = '1'  where id_rec = '" + id_rec + "' ");
                if (id_tip.equals("1")) {
                    /*
                     *
                     *Para receta de farmacia
                     *
                     */
                    int can_sol = 0, can_sur = 0, can_sol1 = 0, can_sur1 = 0, cont = 0, Contador = 0, can_sol_1 = 0;
                    ResultSet NReg = con.consulta("SELECT cla_pro AS contador FROM recetas where id_rec='" + id_rec + "' and baja=0 group by cla_pro");
                    Contador = 0;
                    while (NReg.next()) {
                        Contador++;
                    }

                    rset = con.consulta("SELECT I.id_inv, DP.det_pro, P.cla_pro, P.des_pro, DP.cad_pro, DP.lot_pro, I.cant, DP.cla_fin, DP.id_ori FROM detalle_productos DP, productos P, inventario I, unidades U, usuarios US WHERE DP.cla_pro = P.cla_pro AND DP.det_pro = I.det_pro AND I.cla_uni = U.cla_uni AND US.cla_uni = U.cla_uni AND P.cla_pro = '" + request.getParameter("cla_pro") + "' AND US.id_usu='" + sesion.getAttribute("id_usu") + "' and DP.cad_pro between '" + fecha1 + "' and '" + fecha2 + "' ORDER BY  DP.id_ori, DP.cad_pro, I.cant ASC ");
                    while (rset.next()) {
                        NReg = con.consulta("SELECT (cla_pro) AS contador FROM recetas where id_rec='" + id_rec + "' and baja=0 and can_sol!=0 group by cla_pro");
                        Contador = 0;
                        while (NReg.next()) {
                            Contador++;
                        }
                        det_pro = rset.getString("det_pro");
                        if (Integer.parseInt(rset.getString("cant")) > 0) {
                            // Contador = Contador + 1;
                            ResultSet ExisRec1 = con.consulta("SELECT SUM(can_sol) AS can_sol,SUM(cant_sur) AS can_sur FROM detreceta WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "' and can_sol>0 and baja=0");
                            while (ExisRec1.next()) {
                                can_sol_1 = ExisRec1.getInt(1);
                            }
                            if (Contador < 4 || can_sol_1 > 0) {
                                sol1 = sol;
                                sol = sol - Integer.parseInt(rset.getString("cant"));
                                if (sol <= 0) {
                                    if (sol == 0) {

                                        sur = Integer.parseInt(rset.getString("cant"));
                                        ExisRec = con.consulta("SELECT SUM(can_sol) AS can_sol,SUM(cant_sur) AS can_sur FROM detreceta WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "' and can_sol>0");
                                        while (ExisRec.next()) {

                                            can_sol = ExisRec.getInt(1);
                                            can_sur = ExisRec.getInt(2);
                                        }
                                        can_sur1 = can_sur + sur;
                                        can_sol1 = can_sol + Integer.parseInt(request.getParameter("can_sol"));
                                        if (can_sol > 0) {
                                            System.out.println("Entro1" + "/" + cont);
                                            con.actualizar("update detreceta set can_sol='" + can_sol1 + "',cant_sur='" + can_sur1 + "' WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "'");
                                            con.actualizar("update kardex set cant = '" + can_sur1 + "' WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "' ");
                                        } else {
                                            //Contador = Contador + 1;
                                            System.out.println("No Entro1" + "/" + cont);
                                            con.insertar("insert into detreceta values ('0', '" + rset.getString("det_pro") + "', '" + sur + "', '" + sur + "', '" + request.getParameter("fecha") + "', '1', '" + id_rec + "', CURTIME(), '" + causes + "','" + indicaciones + "', '0', '0' ,'" + causes2 + "') ");
                                            con.insertar("insert into kardex values ('0', '" + id_rec + "', '" + rset.getString("det_pro") + "', '" + sur + "', 'SALIDA RECETA', '-', NOW(), 'SALIDA POR RECETA FAR', '" + sesion.getAttribute("id_usu") + "', '0')");
                                        }
                                        can_sol = 0;
                                        con.insertar("update inventario set cant = '0', web = '0' where id_inv = '" + rset.getString("id_inv") + "' ");
                                    }
                                    if (sol < 0) {

                                        sur = sol * -1;
                                        ExisRec = con.consulta("SELECT SUM(can_sol) AS can_sol,SUM(cant_sur) AS can_sur FROM detreceta WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "' and can_sol>0");
                                        while (ExisRec.next()) {

                                            can_sol = ExisRec.getInt(1);
                                            can_sur = ExisRec.getInt(2);
                                        }
                                        can_sur1 = can_sur + sol1;
                                        can_sol1 = can_sol + sol1;
                                        if (can_sol > 0) {
                                            System.out.println("Entro2" + "//" + cont);
                                            con.actualizar("update detreceta set can_sol='" + can_sol1 + "',cant_sur='" + can_sur1 + "' WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "'");
                                            con.actualizar("update kardex set cant = '" + can_sur1 + "' WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "' ");
                                        } else {
                                            System.out.println("No Entro2" + "/" + cont);
                                            //Contador = Contador + 1;
                                            con.insertar("insert into detreceta values ('0', '" + rset.getString("det_pro") + "', '" + (sol1) + "', '" + (sol1) + "', '" + request.getParameter("fecha") + "', '1', '" + id_rec + "', CURTIME(), '" + causes + "','" + indicaciones + "', '0', '0','" + causes2 + "' ) ");
                                            con.insertar("insert into kardex values ('0', '" + id_rec + "', '" + rset.getString("det_pro") + "', '" + sol1 + "', 'SALIDA RECETA', '-', NOW(), 'SALIDA POR RECETA FAR', '" + sesion.getAttribute("id_usu") + "', '0')");
                                        }
                                        can_sol = 0;
                                        con.insertar("update inventario set cant = '" + (-1 * sol) + "', web = '0' where id_inv = '" + rset.getString("id_inv") + "' ");
                                    }
                                    break;
                                }
                                ExisRec = con.consulta("SELECT SUM(can_sol) AS can_sol,SUM(cant_sur) AS can_sur FROM detreceta WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "' and can_sol>0 and baja=0");
                                while (ExisRec.next()) {
                                    can_sol = ExisRec.getInt(1);
                                    can_sur = ExisRec.getInt(2);
                                }
                                can_sur1 = can_sur + Integer.parseInt(rset.getString("cant"));
                                can_sol1 = can_sol + Integer.parseInt(rset.getString("cant"));
                                if (can_sol > 0) {
                                    System.out.println("Entro3" + "/" + cont);
                                    con.actualizar("update detreceta set can_sol='" + can_sol1 + "',cant_sur='" + can_sur1 + "' WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "'");
                                    con.actualizar("update kardex set cant = '" + can_sur1 + "' WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "' ");
                                } else {
                                    //Contador = Contador + 1;
                                    System.out.println("No Entro3" + "/" + cont);
                                    con.insertar("insert into detreceta values ('0', '" + rset.getString("det_pro") + "', '" + rset.getString("cant") + "', '" + rset.getString("cant") + "', '" + request.getParameter("fecha") + "', '1', '" + id_rec + "', CURTIME(), '" + causes + "','" + indicaciones + "', '0', '0','" + causes2 + "' ) ");
                                    con.insertar("insert into kardex values ('0', '" + id_rec + "', '" + rset.getString("det_pro") + "', '" + rset.getString("cant") + "', 'SALIDA RECETA', '-', NOW(), 'SALIDA POR RECETA FAR', '" + sesion.getAttribute("id_usu") + "', '0')");
                                }
                                can_sol = 0;
                                con.insertar("update inventario set cant = '0', web = '0' where id_inv = '" + rset.getString("id_inv") + "' ");

                            } else {
                                out.println("<script>alert('SOLO 4 MEDICAMENTOS.')</script>");
                                con.cierraConexion();
                                out.println("<script>window.location='receta/receta_manual.jsp'</script>");
                                //out.println("<script>alert('SOLO 4 MEDICAMENTOS');</script>");
                            }
                        } else {
                        }
                    }
                    if (det_pro.equals("")) {
                        con.insertar("insert into detalle_productos values(0,'" + request.getParameter("cla_pro") + "','-','2020-01-01','1','1','0')");
                        ResultSet rsetNuevoInsumo = con.consulta("select det_pro from detalle_productos where cla_pro = '" + request.getParameter("cla_pro") + "' and lot_pro = '-' and cad_pro ='2020-01-01'");
                        while (rsetNuevoInsumo.next()) {
                            String cla_uni = "";
                            ResultSet rset2 = con.consulta("select cla_uni from usuarios where id_usu = '" + sesion.getAttribute("id_usu") + "'");
                            while (rset2.next()) {
                                cla_uni = rset2.getString("cla_uni");
                            }
                            con.insertar("insert into inventario values (CURDATE(),'" + cla_uni + "','" + rsetNuevoInsumo.getString("det_pro") + "','0','0','0')");
                        }

                        rset = con.consulta("SELECT I.id_inv, DP.det_pro, P.cla_pro, P.des_pro, DP.cad_pro, DP.lot_pro, I.cant, DP.cla_fin, DP.id_ori FROM detalle_productos DP, productos P, inventario I, unidades U, usuarios US WHERE DP.cla_pro = P.cla_pro AND DP.det_pro = I.det_pro AND I.cla_uni = U.cla_uni AND US.cla_uni = U.cla_uni AND P.cla_pro = '" + request.getParameter("cla_pro") + "' AND US.id_usu='" + sesion.getAttribute("id_usu") + "' and DP.cad_pro between '" + fecha1 + "' and '" + fecha2 + "' ORDER BY  DP.id_ori, DP.cad_pro, I.cant ASC ");
                        while (rset.next()) {

                            NReg = con.consulta("SELECT (cla_pro) AS contador FROM recetas where id_rec='" + id_rec + "' and baja=0 and can_sol!=0 group by cla_pro");
                            Contador = 0;
                            while (NReg.next()) {
                                Contador++;
                            }
                            det_pro = rset.getString("det_pro");
                            if (Integer.parseInt(rset.getString("cant")) > 0) {
                                // Contador = Contador + 1;
                                ResultSet ExisRec1 = con.consulta("SELECT SUM(can_sol) AS can_sol,SUM(cant_sur) AS can_sur FROM detreceta WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "' and can_sol>0");
                                while (ExisRec1.next()) {

                                    can_sol_1 = ExisRec1.getInt(1);
                                }
                                if (Contador < 4 || can_sol_1 > 0) {
                                    sol1 = sol;
                                    sol = sol - Integer.parseInt(rset.getString("cant"));
                                    if (sol <= 0) {
                                        if (sol == 0) {

                                            sur = Integer.parseInt(rset.getString("cant"));
                                            ExisRec = con.consulta("SELECT SUM(can_sol) AS can_sol,SUM(cant_sur) AS can_sur FROM detreceta WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "' and can_sol>0");
                                            while (ExisRec.next()) {

                                                can_sol = ExisRec.getInt(1);
                                                can_sur = ExisRec.getInt(2);
                                            }
                                            can_sur1 = can_sur + sur;
                                            can_sol1 = can_sol + Integer.parseInt(request.getParameter("can_sol"));
                                            if (can_sol > 0) {
                                                System.out.println("Entro1" + "/" + cont);
                                                con.actualizar("update detreceta set can_sol='" + can_sol1 + "',cant_sur='" + can_sur1 + "' WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "'");
                                                con.actualizar("update kardex set cant = '" + can_sur1 + "' WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "' ");
                                            } else {
                                                //Contador = Contador + 1;
                                                System.out.println("No Entro1" + "/" + cont);
                                                con.insertar("insert into detreceta values ('0', '" + rset.getString("det_pro") + "', '" + request.getParameter("can_sol") + "', '" + sur + "', '" + request.getParameter("fecha") + "', '1', '" + id_rec + "', CURTIME(), '" + causes + "','" + indicaciones + "', '0', '0','" + causes2 + "' ) ");
                                                con.insertar("insert into kardex values ('0', '" + id_rec + "', '" + rset.getString("det_pro") + "', '" + sur + "', 'SALIDA RECETA', '-', NOW(), 'SALIDA POR RECETA FAR', '" + sesion.getAttribute("id_usu") + "', '0')");
                                            }
                                            can_sol = 0;
                                            con.insertar("update inventario set cant = '0', web = '0' where id_inv = '" + rset.getString("id_inv") + "' ");
                                        }
                                        if (sol < 0) {

                                            sur = sol * -1;
                                            ExisRec = con.consulta("SELECT SUM(can_sol) AS can_sol,SUM(cant_sur) AS can_sur FROM detreceta WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "' and can_sol>0");
                                            while (ExisRec.next()) {

                                                can_sol = ExisRec.getInt(1);
                                                can_sur = ExisRec.getInt(2);
                                            }
                                            can_sur1 = can_sur + sol1;
                                            can_sol1 = can_sol + sol1;
                                            if (can_sol > 0) {
                                                System.out.println("Entro2" + "//" + cont);
                                                con.actualizar("update detreceta set can_sol='" + can_sol1 + "',cant_sur='" + can_sur1 + "' WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "'");
                                                con.actualizar("update kardex set cant = '" + can_sur1 + "' WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "' ");
                                            } else {
                                                System.out.println("No Entro2" + "/" + cont);
                                                //Contador = Contador + 1;
                                                con.insertar("insert into detreceta values ('0', '" + rset.getString("det_pro") + "', '" + (sol1) + "', '" + (sol1) + "', '" + request.getParameter("fecha") + "', '1', '" + id_rec + "', CURTIME(), '" + causes + "','" + indicaciones + "', '0', '0','" + causes2 + "' ) ");
                                                con.insertar("insert into kardex values ('0', '" + id_rec + "', '" + rset.getString("det_pro") + "', '" + sol1 + "', 'SALIDA RECETA', '-', NOW(), 'SALIDA POR RECETA FAR', '" + sesion.getAttribute("id_usu") + "', '0')");
                                            }
                                            can_sol = 0;
                                            con.insertar("update inventario set cant = '" + (-1 * sol) + "', web = '0' where id_inv = '" + rset.getString("id_inv") + "' ");
                                        }
                                        break;
                                    }
                                    ExisRec = con.consulta("SELECT SUM(can_sol) AS can_sol,SUM(cant_sur) AS can_sur FROM detreceta WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "' and can_sol>0");
                                    while (ExisRec.next()) {

                                        can_sol = ExisRec.getInt(1);
                                        can_sur = ExisRec.getInt(2);
                                    }
                                    can_sur1 = can_sur + Integer.parseInt(rset.getString("cant"));
                                    can_sol1 = can_sol + Integer.parseInt(rset.getString("cant"));
                                    if (can_sol > 0) {
                                        System.out.println("Entro3" + "/" + cont);
                                        con.actualizar("update detreceta set can_sol='" + can_sol1 + "',cant_sur='" + can_sur1 + "' WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "'");
                                        con.actualizar("update kardex set cant = '" + can_sur1 + "' WHERE det_pro='" + det_pro + "' AND id_rec='" + id_rec + "' ");
                                    } else {
                                        //Contador = Contador + 1;
                                        System.out.println("No Entro3" + "/" + cont);
                                        con.insertar("insert into detreceta values ('0', '" + rset.getString("det_pro") + "', '" + rset.getString("cant") + "', '" + rset.getString("cant") + "', '" + request.getParameter("fecha") + "', '1', '" + id_rec + "', CURTIME(), '" + causes + "','" + indicaciones + "', '0', '0','" + causes2 + "' ) ");
                                        con.insertar("insert into kardex values ('0', '" + id_rec + "', '" + rset.getString("det_pro") + "', '" + rset.getString("cant") + "', 'SALIDA RECETA', '-', NOW(), 'SALIDA POR RECETA FAR', '" + sesion.getAttribute("id_usu") + "', '0')");
                                    }
                                    can_sol = 0;
                                    con.insertar("update inventario set cant = '0', web = '0' where id_inv = '" + rset.getString("id_inv") + "' ");

                                } else {
                                    out.println("<script>alert('SOLO 4 MEDICAMENTOS.')</script>");
                                    //out.println("<script>window.location='receta/receta_manual.jsp'</script>");
                                    //out.println("<script>alert('SOLO 4 MEDICAMENTOS');</script>");
                                }
                            } else {
                            }
                        }
                    }

                    NReg = con.consulta("SELECT (cla_pro) AS contador FROM recetas where id_rec='" + id_rec + "' and baja=0 and can_sol!=0 group by cla_pro");
                    Contador = 0;
                    while (NReg.next()) {
                        Contador++;
                    }
                    if (sol > 0) {
                        if (Contador < 4) {
                            //Contador = Contador + 1;
                            if (!(det_pro != "")) {
                                ResultSet rset2 = con.consulta("SELECT det_pro FROM detalle_productos where cla_pro='" + request.getParameter("cla_pro") + "' GROUP BY cla_pro");
                                if (rset2.next()) {
                                    det_pro = rset2.getString(1);
                                }
                            }
                            int banPend = 0, can_solAnt = 0;
                            String fol_det = "";
                            ResultSet rset2 = con.consulta("select fol_det,can_sol from detreceta where id_rec = '" + id_rec + "' and det_pro = '" + det_pro + "' ");
                            while (rset2.next()) {
                                banPend = 1;
                                can_solAnt = rset2.getInt("can_sol");
                                fol_det = rset2.getString("fol_det");
                            }
                            if (banPend == 1) {
                                con.insertar("update detreceta set can_sol = '" + (sol + can_solAnt) + "' , baja='0' where fol_det = '" + fol_det + "'");
                            } else {
                                con.insertar("insert into detreceta values ('0', '" + det_pro + "', '" + sol + "', '0', '" + request.getParameter("fecha") + "', '0', '" + id_rec + "', CURTIME(), '" + causes + "','" + indicaciones + "', '0', '0','" + causes2 + "' ) ");
                            }
                            con.insertar("insert into kardex values ('0', '" + id_rec + "', '" + det_pro + "', '0', 'SALIDA RECETA', '-', NOW(), 'SALIDA POR RECETA FAR', '" + sesion.getAttribute("id_usu") + "', '0')");
                        } else {
                            out.println("<script>alert('SOLO 4 MEDICAMENTOS.')</script>");
                            con.cierraConexion();
                            out.println("<script>window.location='receta/receta_manual.jsp'</script>");
                            //out.println("<script>window.location=receta/receta_manual.jsp'</script>");
                        }
                    }
                } else if (id_tip.equals("2")) {
                    /*
                     *
                     *Para receta de colactiva
                     *
                     */

                    sol = Integer.parseInt(request.getParameter("piezas_sol"));
                    sur = Integer.parseInt(request.getParameter("piezas_sol"));
                    rset = con.consulta("SELECT I.id_inv, DP.det_pro, P.cla_pro, P.des_pro, DP.cad_pro, DP.lot_pro, I.cant, DP.cla_fin, DP.id_ori FROM detalle_productos DP, productos P, inventario I, unidades U, usuarios US WHERE DP.cla_pro = P.cla_pro AND DP.det_pro = I.det_pro AND I.cla_uni = U.cla_uni AND US.cla_uni = U.cla_uni AND P.cla_pro = '" + request.getParameter("cla_pro") + "' AND US.id_usu='" + sesion.getAttribute("id_usu") + "' ORDER BY  DP.id_ori, DP.cad_pro, I.cant ASC ");
                    while (rset.next()) {
                        det_pro = rset.getString("det_pro");

                        if (Integer.parseInt(rset.getString("cant")) > 0) {
                            sol1 = sol;
                            sol = sol - Integer.parseInt(rset.getString("cant"));
                            if (sol <= 0) {
                                if (sol == 0) {
                                    sur = Integer.parseInt(rset.getString("cant"));
                                    con.insertar("insert into detreceta values ('0', '" + rset.getString("det_pro") + "', '" + request.getParameter("can_sol") + "', '" + sur + "', '" + request.getParameter("fecha") + "', '1', '" + id_rec + "', CURTIME(), '1','SIN INDICACIONES', '0', '0','SIN INDICACIONES' ) ");
                                    con.insertar("insert into kardex values ('0', '" + id_rec + "', '" + rset.getString("det_pro") + "', '" + sur + "', 'SALIDA RECETA', '-', NOW(), 'SALIDA POR RECETA COL', '" + sesion.getAttribute("id_usu") + "', '0')");
                                    con.insertar("update inventario set cant = '0', web = '0' where id_inv = '" + rset.getString("id_inv") + "' ");
                                }
                                if (sol < 0) {
                                    sur = sol * -1;
                                    con.insertar("insert into detreceta values ('0', '" + rset.getString("det_pro") + "', '" + (sol1) + "', '" + (sol1) + "', '" + request.getParameter("fecha") + "', '1', '" + id_rec + "', CURTIME(), '1','SIN INDICACIONES', '0', '0','SIN INDICACIONES' ) ");
                                    con.insertar("insert into kardex values ('0', '" + id_rec + "', '" + rset.getString("det_pro") + "', '" + sol1 + "', 'SALIDA RECETA', '-', NOW(), 'SALIDA POR RECETA COL', '" + sesion.getAttribute("id_usu") + "', '0')");
                                    con.insertar("update inventario set cant = '" + (-1 * sol) + "', web = '0' where id_inv = '" + rset.getString("id_inv") + "' ");
                                }
                                break;
                            }
                            con.insertar("insert into detreceta values ('0', '" + rset.getString("det_pro") + "', '" + rset.getString("cant") + "', '" + rset.getString("cant") + "', '" + request.getParameter("fecha") + "', '1', '" + id_rec + "', CURTIME(), '1','SIN INDICACIONES', '0', '0','SIN INDICACIONES' ) ");
                            con.insertar("insert into kardex values ('0', '" + id_rec + "', '" + rset.getString("det_pro") + "', '" + rset.getString("cant") + "', 'SALIDA RECETA', '-', NOW(), 'SALIDA POR RECETA COL', '" + sesion.getAttribute("id_usu") + "', '0')");
                            con.insertar("update inventario set cant = '0', web = '0' where id_inv = '" + rset.getString("id_inv") + "' ");
                        } else {
                        }
                    }
                    if (sol > 0) {
                        if (!(det_pro != "")) {
                            det_pro = "1";
                        }
                        con.insertar("insert into detreceta values ('0', '" + det_pro + "', '" + sol + "', '0', '" + request.getParameter("fecha") + "', '0', '" + id_rec + "', CURTIME(), '1','SIN INDICACIONES', '0', '0','SIN INDICACIONES' ) ");
                        con.insertar("insert into kardex values ('0', '" + id_rec + "', '" + det_pro + "', '0', 'SALIDA RECETA', '-', NOW(), 'SALIDA POR RECETA COL', '" + sesion.getAttribute("id_usu") + "', '0')");
                    }
                }

            } catch (Exception e) {
                System.out.println(e.getMessage());
            }

            try {
                ResultSet rset = con.consulta("SELECT dr.fol_det, p.cla_pro, p.des_pro, dp.lot_pro, dp.cad_pro, dr.can_sol, dr.cant_sur, dr.status, o.des_ori from productos p, detalle_productos dp, detreceta dr, receta r, origen o where dr.baja !='1' and p.cla_pro = dp.cla_pro and dp.det_pro = dr.det_pro AND dr.id_rec = r.id_rec AND dp.id_ori = o.id_ori AND r.fol_rec = '" + request.getParameter("folio") + "' and r.id_usu = '" + sesion.getAttribute("id_usu") + "' order by p.cla_pro+0 ;");
                while (rset.next()) {
                    json.put("fol_det", rset.getString("fol_det"));
                    json.put("cla_pro", rset.getString("cla_pro"));
                    json.put("des_pro", rset.getString("des_pro"));
                    json.put("can_sol", rset.getString("can_sol"));
                    json.put("cant_sur", rset.getString("cant_sur"));
                    jsona.add(json);
                    json = new JSONObject();
                }
                //out.println(jsona);
                System.out.println(jsona);
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
            //response.sendRedirect("receta/receta_manual.jsp");
            con.cierraConexion();
            out.println("<script>window.location='receta/receta_manual.jsp'</script>");
        } catch (SQLException e) {
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
