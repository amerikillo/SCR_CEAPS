/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Clases;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

/**
 *
 * @author Amerikillo
 */
public class LeerCSV {

    public boolean leeCSV(String ruta, String nombre) {
        DateFormat df3 = new SimpleDateFormat("dd/MM/yyyy");
        DateFormat df2 = new SimpleDateFormat("yyyy-MM-dd");
        ConectionDB con = new ConectionDB();
        DecimalFormat formatter = new DecimalFormat("0000");
        DecimalFormat formatterDeci = new DecimalFormat("0000.00");
        String csvFile = ruta + "/abastos/" + nombre;
        BufferedReader br = null;
        String line = "";
        String cvsSplitBy = ",";
        try {
            con.conectar();
            try {
                con.insertar("delete from carga_abasto");
            } catch (SQLException ex) {
                System.out.println(ex.getMessage());
            }
            try {
                br = new BufferedReader(new FileReader(csvFile));
                while ((line = br.readLine()) != null) {
                    // use comma as separator
                    String inserta = "insert into carga_abasto values (0,";
                    String[] linea = line.split(cvsSplitBy);
                    if (!linea[0].equals("")) {
                        for (int i = 0; i < linea.length; i++) {
                            if (i != 1) {
                                if (i == 3) {
                                    String cadu = df2.format(df3.parse(linea[i]));
                                    inserta = inserta + " '" + cadu.trim() + "' , ";
                                } else if (i == 0) {
                                    System.out.println(linea[i]);
                                    System.out.println(linea[i].indexOf('.'));
                                    if (linea[i].indexOf('.') < 0) {
                                        inserta = inserta + " '" + formatter.format(Long.parseLong(linea[i])) + "' , ";
                                    } else {
                                        inserta = inserta + " '" + formatterDeci.format(Float.parseFloat(linea[i])) + "' , ";
                                    }
                                } else {
                                    if (i == linea.length - 1) {
                                        inserta = inserta + " '" + linea[i].trim() + "' ) ";
                                    } else {
                                        inserta = inserta + " '" + linea[i].trim() + "' , ";
                                    }
                                }
                            }
                        }
                        con.insertar(inserta);
                    }
                }
            } catch (Exception e) {
                System.out.println("ErrorCSV->" + e);
                return false;
            }
            con.cierraConexion();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }

        return true;
    }
}
