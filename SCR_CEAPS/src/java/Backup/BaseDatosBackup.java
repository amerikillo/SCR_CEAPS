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
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.FileOutputStream;
import java.io.File;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

/**
 * Takes backup of database
 *
 * @author Nitesh Apte
 * @version 1.0
 * @license GPL
 */
public class BaseDatosBackup {

    private int STREAM_BUFFER = 512000;

    public boolean backupDatabase(String host, String port, String user, String password, String dbname, String rootpath, String dbexepath) {

        boolean success = false;
        try {
            String dump = getServerDumpData(host, port, user, password, dbname, dbexepath);
            if (!dump.isEmpty()) {
                byte[] data = dump.getBytes();
                DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd-HHmm");
                Date date = new Date();
                File file = new File(rootpath + File.separator + dbname+"_"+dateFormat.format(date));
                if (!file.isDirectory()) {
                    file.mkdir();
                }

                String filepath = rootpath + File.separator + dbname+"_"+dateFormat.format(date) + File.separator + dbname + dateFormat.format(date) + ".sql";
                File filedst = new File(filepath);
                FileOutputStream dest = new FileOutputStream(filedst);
                dest.write(data);
                dest.close();
                success = true;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return success;
    }

    public String getServerDumpData(String host, String port, String user, String password, String db, String mysqlpath) {

        StringBuilder dumpdata = new StringBuilder();
        String execline = mysqlpath;
        try {
            String command[] = new String[]{execline,
                "--host=" + host,
                "--port=" + port,
                "--user=" + user,
                "--password=" + password,

                db};

            ProcessBuilder pb = new ProcessBuilder(command);
            Process process = pb.start();
            InputStream in = process.getInputStream();
            BufferedReader br = new BufferedReader(new InputStreamReader(in));

            int count;
            char[] cbuf = new char[STREAM_BUFFER];

            while ((count = br.read(cbuf, 0, STREAM_BUFFER)) != -1) {
                dumpdata.append(cbuf, 0, count);
            }
            br.close();
            in.close();
        } catch (Exception ex) {
            ex.printStackTrace();
            return "";
        }
        return dumpdata.toString();
    }
}
