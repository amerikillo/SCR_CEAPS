/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Backup;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;
import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

/**
 *
 * @author ALEJO (COL)
 */
public class EnviaBackup {
    
    public boolean EnviaBackup(String ruta,String nombre){
    try {
        SimpleDateFormat df2 = new java.text.SimpleDateFormat("yyyy/MM/dd:HH-mm");
        Date fecha= new Date();
            /* TODO output your page here. You may use following sample code. */
            Properties props = new Properties();
            props.setProperty("mail.smtp.host", "smtp.gmail.com");
            props.setProperty("mail.smtp.starttls.enable", "true");
            props.setProperty("mail.smtp.port", "587");
            props.setProperty("mail.smtp.user", "ricardo.wence@gnkl.mx");
            props.setProperty("mail.smtp.auth", "true");

            MimeMultipart multi = new MimeMultipart();
            BodyPart archivo =new MimeBodyPart();
            // Preparamos la sesion
            Session session = Session.getDefaultInstance(props);

            // Construimos el mensaje
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress("ricardo.wence@gnkl.mx"));
            message.addRecipient(
                    Message.RecipientType.TO,
                    new InternetAddress("americo.guzman@gnkl.mx"));//Aqui se pone la direccion a donde se enviara el correo
            message.addRecipient(
                    Message.RecipientType.TO,
                    new InternetAddress("ricardo.wence@gnkl.mx"));
            message.addRecipient(
                    Message.RecipientType.TO,
                    new InternetAddress("anibal.rincon@gnkl.mx"));
            message.addRecipient(
                    Message.RecipientType.TO,
                    new InternetAddress("david.olvera@gnkl.mx"));
            message.setSubject("Copia de Seguridad Base de datos SCR_CEAPS con fecha: "+df2.format(fecha));
            message.setText("");
            
            archivo.setDataHandler(new DataHandler(new FileDataSource(ruta)));
            archivo.setFileName(nombre+".zip");
            multi.addBodyPart(archivo);
            message.setContent(multi);
            

            // Lo enviamos.
            Transport t = session.getTransport("smtp");
            t.connect("ricardo.wence@gnkl.mx", "ricardo.wence+111");
            t.sendMessage(message, message.getAllRecipients());
            // Cierre.
            t.close();
            return true;
        } catch(Exception ex) {
            System.out.println("ErrorCorreo->"+ex);
            return false;
        }
    }
}
