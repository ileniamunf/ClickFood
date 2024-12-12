package it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.utils;


import com.sun.mail.smtp.SMTPTransport;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.Cliente;
import net.glxn.qrgen.core.image.ImageType;
import net.glxn.qrgen.javase.QRCode;


import java.io.ByteArrayOutputStream;
import java.util.Properties;
import javax.activation.DataHandler;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.Transport;
import javax.mail.util.ByteArrayDataSource;


public class EmailSender{
    public void send(Cliente cliente, String codice){

        final String from = "click.food.wsda@gmail.com";  // sender email
        final String to = cliente.getEmail();     // receiver email
        final String password = "vcev irxv nfaj gnri";


        Properties prop = new Properties();
        prop.put("mail.smtp.host", "smtp.gmail.com");
        prop.put("mail.smtp.port", "587");
        prop.put("mail.smtp.auth", true);
        prop.put("mail.smtp.starttls.enable", "true");
        prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        prop.put("mail.smtp.ssl.protocols", "TLSv1.2");


        Session session = Session.getInstance(prop, new Authenticator() {

            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            Message message = new MimeMessage(session); // messaggio effettivo

            message.setFrom(new InternetAddress(from)); // header fields

            message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));

            String msg = "";
            String sign= "ClickFood&trade;";
            if(codice == ""){
                message.setSubject("Registrazione completata!\uD83D\uDE09");
                msg = "Grazie della tua iscrizione;" + "<br/>" + "ClickFood&trade;";
            }else if (codice.equals("recupero")){
                message.setSubject("Recupero password \uD83D\uDD10");
                msg= "Clicca il seguente link per reimpostare la tua password: " + "<br/>" + "<a href='http://localhost:8080/MunfulettoIlenia_WSDA_war_exploded/RecuperoPasswordServlet?email=" +cliente.getEmail()+"&codice=recupero'>Clicca qui!</a>";

            }else{
                message.setSubject("Ordine completato!\uD83C\uDF54");
                msg = "Grazie di aver ordinato da " + sign +"." + "<br/>" + "<br/>" + "Di seguito il codice QR da mostrare al ritiro; <br/>" +"Buon Appetito da " +sign +"! \uD83D\uDE0B";
            }


            // Invio del messaggio
            MimeBodyPart mimeBodyPart = new MimeBodyPart();
            mimeBodyPart.setContent(msg, "text/html; charset=utf-8");

            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(mimeBodyPart);

            if(codice != "" && codice!="recupero"){
                byte[] qrByteArray = QRCode.from(codice).withSize(250, 250).to(ImageType.PNG).stream().toByteArray();

                ByteArrayDataSource qrImageDataSource = new ByteArrayDataSource(qrByteArray, "image/png");

                MimeBodyPart qrCode = new MimeBodyPart();
                qrCode.setDataHandler(new DataHandler(qrImageDataSource));
                qrCode.setFileName(qrImageDataSource.getName());
                multipart.addBodyPart(qrCode);
            }

            message.setContent(multipart);

            Transport transport = session.getTransport("smtp");
            transport.send(message);


        } catch (MessagingException  mex){
            mex.printStackTrace();
        }

    }

}