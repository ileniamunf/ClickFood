package it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.control;

import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.Cliente;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.utils.*;

@WebServlet(name = "RegistrazioneServlet", value = "/RegistrazioneServlet")
public class RegistrazioneServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String nome = request.getParameter("newNome");
        String cognome = request.getParameter("newCognome");
        String mail = request.getParameter("newEmail");
        String password = request.getParameter("newPassword");
        Date dataNascita = null;
        try {
            dataNascita = new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("newDataNascita"));
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }


        //Validazione input server-side
        Pattern patternNome = Pattern.compile("^(([A-Z][a-z]|[a-z])+(\\s?))+$");
        Pattern patternCognome = Pattern.compile("^(([A-Z][a-z]|[a-z])+(\\s?))+$");
        Pattern patternEmail = Pattern.compile("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$");
        Pattern patternPw = Pattern.compile("^(.|\\s)*\\S(.|\\s)*$");

        Matcher nomeMatcher = patternNome.matcher(nome);
        Matcher cognomeMatcher = patternCognome.matcher(cognome);
        Matcher emailMatcher = patternEmail.matcher(mail);
        Matcher pwMatcher = patternPw.matcher(password);

        int codeOp = 0;
        if(nomeMatcher.find() && cognomeMatcher.find() && emailMatcher.find() && pwMatcher.find()){
            if(Query.searchUtente(mail)){
                //Utente Esistente
                codeOp = 2;
                request.getSession().setAttribute("codeOp", codeOp);
                request.getSession().setAttribute("text","{\"Titolo\":\"Errore!\", \"Corpo\": \"Utente già esistente!\"}");

            }else{
                Cliente cliente = new Cliente(mail, SHA256.SHA256Hash(password), "Cliente", nome, cognome, dataNascita);

                if(Query.insertCliente(cliente)){
                    EmailSender es = new EmailSender();
                    es.send(cliente,"");

                    codeOp = 1;
                    request.getSession().setAttribute("codeOp", codeOp);
                    request.getSession().setAttribute("text","{\"Titolo\":\"Successo!\", \"Corpo\": \"Grazie per averci scelto.\"}");



                }else{
                    codeOp = 4;
                    request.getSession().setAttribute("codeOp", codeOp);
                    request.getSession().setAttribute("text","{\"Titolo\":\"Errore!\", \"Corpo\": \"Non e&grave; stato possibile aggiungere il nuovo Cliente.\"}");
                }
            }

        }else{
            response.setStatus(500);
            response.sendRedirect("errore.jsp");
        }
    }
}
