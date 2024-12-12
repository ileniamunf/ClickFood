package it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.control;

import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.Cliente;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.DettagliOrdine;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.Ordine;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.Utente;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.utils.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet(name = "LoginServlet", value = "/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mail = request.getParameter("loginEmail");
        String password = request.getParameter("loginPassword");


        //Validazione input server-side
        Pattern patternEmail = Pattern.compile("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$");
        Pattern patternPw = Pattern.compile("^(.|\\s)*\\S(.|\\s)*$");
        Matcher emailMatcher = patternEmail.matcher(mail);
        Matcher pwMatcher = patternPw.matcher(password);


        if(emailMatcher.find() && pwMatcher.find()){

            Utente utente = Query.getUtente(mail, SHA256.SHA256Hash(password));

            if(utente == null){
                HttpSession session = request.getSession();
                String error = null;

                if(session.getAttribute("stato") == null) {
                    error = "*Email e/o password non validi.";
                }
                session.setAttribute("stato", error);

               response.sendRedirect("index.jsp");


            } else {
                HttpSession session = request.getSession();
                if(session.getAttribute("Cuoco") != null){
                    session.removeAttribute("Cuoco");
                }
                if(session.getAttribute("Addetto") != null){
                    session.removeAttribute("Addetto");
                }
                if(session.getAttribute("Responsabile") != null){
                    session.removeAttribute("Responsabile");
                }
                if(session.getAttribute("Cliente") != null){
                    session.removeAttribute("Cliente");
                }
                if(session.getAttribute("Fattorino") != null){
                    session.removeAttribute("Fattorino");
                }

                session.setAttribute("Utente",utente);



                String address = "";

                if(utente.getTipo().equals("Cliente")){
                    Cliente cliente = Query.getCliente(utente.getEmail());

                    if(cliente != null){
                        session.setAttribute("Cliente", cliente);

                        address = "/ClienteServlet";

                    }


                } else if (utente.getTipo().equals("Cuoco")){

                        session.setAttribute("Cuoco", utente);

                        address = "/CuocoServlet";


                } else if (utente.getTipo().equals("Addetto")) {

                        session.setAttribute("Addetto", utente);
                        address = "/AddettoServlet";

                } else if (utente.getTipo().equals("Responsabile")) {

                    session.setAttribute("Responsabile", utente);
                    address = "/ResposabileServlet";

                } else if (utente.getTipo().equals("Fattorino")) {

                    session.setAttribute("Fattorino", utente);
                    address = "/FattorinoServlet";

                }

                response.sendRedirect(request.getContextPath()+address);
            }



        }else{
            response.setStatus(500);
            response.sendRedirect("errore.jsp");
        }

    }

}

