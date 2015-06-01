/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Backup;

/**
 *
 * @author ALEJO (COL)
 */
import java.io.File;
import java.math.BigInteger;
import java.util.Date;
import java.util.Properties;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

/**
 * Datavault Manager
 *
 * @author Nitesh Apte
 * @version 1.0
 * @license GPL
 */
public class AdministrarBackup {

    private String DB_HOST;
    private String DB_NAME;
    private String DB_PORT;
    private String DB_USER;
    private String DB_PASS;
    private String FOLDER_NAME;
    private String DB_EXE;
    private String DESTINATION;

    public BigInteger timeNoted;
    String projectName = new String();

    private static final String PROP_FILE = "config.properties";

    public AdministrarBackup() {
        System.out.println("Voy por aca");
        readConfiguration();
    }

    public void readConfiguration() {
        try {
            Properties prop = new Properties();
            String path = new File(".").getCanonicalPath();
            File f = new File(path + File.separator + "backup" + File.separator);
            if (!f.exists()) {
                f.mkdir();
            }
            f = new File(path + File.separator + "archivo" + File.separator);
            if (!f.exists()) {
                f.mkdir();
            }
            System.out.println(path);
            //prop.load(this.getClass().getResourceAsStream(PROP_FILE));
            setDB_HOST("localhost");
            setDB_NAME("scr_ceaps");
            setDB_PORT("3306");
            setDB_USER("root");
            setDB_PASS("eve9397");
            setFOLDER_NAME(path + "/backup");
            setDB_EXE("mysqldump");
            setDESTINATION(path + "/archivo");

        } catch (Exception e) {
            System.out.println("Cannot read the property file.->" + e);
        }
    }

    public Boolean databaseBackup() {
        if (new BaseDatosBackup().backupDatabase(getDB_HOST(), getDB_PORT(), getDB_USER(), getDB_PASS(), getDB_NAME(), getFOLDER_NAME(), getDB_EXE())) {
            return true;
        } else {
            return false;
        }
    }

    public Boolean folderBackup() throws Exception {
        DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd-HHmm");
        Date nowtime = new Date();
        if (new CarpetaZipBackup().zipFolder(getFOLDER_NAME() + "/" + getDB_NAME() + "_" + dateFormat.format(nowtime), getDESTINATION() + "/" + getDB_NAME() + "_" + dateFormat.format(nowtime) + ".zip")) {
            //timeNoted = BigInteger.valueOf(Long.parseLong(dateFormat.format(nowtime)));
            return true;
        } else {
            return false;
        }
    }

    public Boolean enviaBackup() throws Exception {
        DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd-HHmm");
        Date nowtime = new Date();
        return new EnviaBackup().EnviaBackup(getDESTINATION() + "/" + getDB_NAME() + "_" + dateFormat.format(nowtime) + ".zip", getDB_NAME() + "_" + dateFormat.format(nowtime));
    }

    public boolean Iniciar() {
        AdministrarBackup dm = new AdministrarBackup();
        try {
            if (dm.databaseBackup()) {
                if (dm.folderBackup()) {
                    System.out.println("Proceso de respaldo completo, iniciando envio por correo...");
                    if (dm.enviaBackup()) {
                        System.out.println("Se envio correctamente el archivo");
                        return true;
                    } else {
                        System.out.println("Error al enviar el archivo por correo");
                        return false;
                    }
                } else {
                    System.out.println("Folder backup process failed.");
                    return false;
                }
            } else {
                System.out.println("Process failed.");
                return false;
            }
        } catch (Exception e) {
            System.out.println("Error main->" + e);
            return false;
        }
    }

    /**
     * @return the DB_HOST
     */
    public String getDB_HOST() {
        return DB_HOST;
    }

    /**
     * @param DB_HOST the DB_HOST to set
     */
    public void setDB_HOST(String DB_HOST) {
        this.DB_HOST = DB_HOST;
    }

    /**
     * @return the DB_NAME
     */
    public String getDB_NAME() {
        return DB_NAME;
    }

    /**
     * @param DB_NAME the DB_NAME to set
     */
    public void setDB_NAME(String DB_NAME) {
        this.DB_NAME = DB_NAME;
    }

    /**
     * @return the DB_PORT
     */
    public String getDB_PORT() {
        return DB_PORT;
    }

    /**
     * @param DB_PORT the DB_PORT to set
     */
    public void setDB_PORT(String DB_PORT) {
        this.DB_PORT = DB_PORT;
    }

    /**
     * @return the DB_USER
     */
    public String getDB_USER() {
        return DB_USER;
    }

    /**
     * @param DB_USER the DB_USER to set
     */
    public void setDB_USER(String DB_USER) {
        this.DB_USER = DB_USER;
    }

    /**
     * @return the DB_PASS
     */
    public String getDB_PASS() {
        return DB_PASS;
    }

    /**
     * @param DB_PASS the DB_PASS to set
     */
    public void setDB_PASS(String DB_PASS) {
        this.DB_PASS = DB_PASS;
    }

    /**
     * @return the FOLDER_NAME
     */
    public String getFOLDER_NAME() {
        return FOLDER_NAME;
    }

    /**
     * @param FOLDER_NAME the FOLDER_NAME to set
     */
    public void setFOLDER_NAME(String FOLDER_NAME) {
        this.FOLDER_NAME = FOLDER_NAME;
    }

    /**
     * @return the DB_EXE
     */
    public String getDB_EXE() {
        return DB_EXE;
    }

    /**
     * @param DB_EXE the DB_EXE to set
     */
    public void setDB_EXE(String DB_EXE) {
        this.DB_EXE = DB_EXE;
    }

    /**
     * @return the DESTINATION
     */
    public String getDESTINATION() {
        return DESTINATION;
    }

    /**
     * @param DESTINATION the DESTINATION to set
     */
    public void setDESTINATION(String DESTINATION) {
        this.DESTINATION = DESTINATION;
    }
}
