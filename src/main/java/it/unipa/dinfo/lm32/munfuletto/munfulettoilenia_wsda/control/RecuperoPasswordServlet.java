package it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.control;

import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.Cliente;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.utils.EmailSender;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.utils.Query;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.utils.SHA256;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet(name = "RecuperoPasswordServlet", value = "/RecuperoPasswordServlet")
public class RecuperoPasswordServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if(request.getParameter("email") != null){
            String email = request.getParameter("email");
            if(Query.searchUtente(email)){
                Cliente cliente = new Cliente(email);
                if(request.getParameter("codice") != null){
                    //Ha ricevuto il link
                    RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/view/cambiaPassword.jsp");
                    dispatcher.forward(request,response);
                }else{
                    //Non ha ancora ricevuto il link
                    EmailSender es = new EmailSender();
                    es.send(cliente, "recupero");

                    int codeOp=1;
                    request.getSession().setAttribute("codeOp",codeOp);
                    request.getSession().setAttribute("text","{\"Titolo\":\"Link inviato!✉️\", \"Corpo\": \"Abbiamo appena inviato un link per il ripristino della tua password.\"}");

                    response.sendRedirect("recuperoPassword.jsp");
                }
            }else{
                //Utente non esiste
                response.sendRedirect("index.jsp");
            }

        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("emailTitolare");
        String password = request.getParameter("pass");

        Pattern patternPw = Pattern.compile("^(.|\\s)*\\S(.|\\s)*$");
        Matcher pwMatcher = patternPw.matcher(password);


        if(pwMatcher.find() && Query.searchUtente(email)){
            if(Query.changePassword(email, SHA256.SHA256Hash(password))){
                int codeOp=1;
                request.getSession().setAttribute("codeOp",codeOp);
                request.getSession().setAttribute("text","{\"Titolo\":\"Successo!️\", \"Corpo\": \"La tua password è stata cambiata con successo.\"}");


            }else{
                int codeOp=2;
                request.getSession().setAttribute("codeOp",codeOp);
                request.getSession().setAttribute("text","{\"Titolo\":\"Errore️!\", \"Corpo\": \"Non siamo riusciti a cambiare la tua password.\"}");

            }

        }
    }
}
