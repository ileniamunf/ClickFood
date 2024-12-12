package it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.control;

import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.Cliente;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.Prodotto;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.utils.EmailSender;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.utils.Query;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.utils.SHA256;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet(name = "OrdinaServlet", value = "/OrdinaServlet")
public class OrdinaServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        ArrayList<Prodotto> prodList = Query.getProdotti();

        request.setAttribute("prodList", prodList);
        request.getRequestDispatcher("WEB-INF/view/ordina.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String formParamsString = request.getParameter("formParams");
        String cartString = request.getParameter("cart");

        JSONObject formParams = new JSONObject(formParamsString);
        //System.out.println("*** FORM PARAMETERS' JSON ***\n"+formParams.toString() + "\n");

        JSONArray cart = new JSONObject(cartString).getJSONArray("cartList");
        //System.out.println("*** CART'S JSON ***\n"+cart.toString());

        /* Parametri richiesti */
        String nomeRichiedente=formParams.getString("nomeRichiedente"),
                cognomeRichiedente=formParams.getString("cognomeRichiedente"),
                email = formParams.getString("emailRichiedente"),
                modalitaConsegna = formParams.getString("modalitaConsegna"),
                modalitaPagamento = formParams.getString("modalitaPagamento");

        /* Parametri Opzionali */
        String indirizzoSpedizione = "",
                numeroCarta = "",
                cvv = "";



        //Validazione input server-side
        Pattern patternNome = Pattern.compile("^(([A-Z][a-z]|[a-z])+(\\s?))+$");
        Pattern patternCognome = Pattern.compile("^(([A-Z][a-z]|[a-z])+(\\s?))+$");
        Pattern patternEmail = Pattern.compile("^[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$");
        Pattern patternDomicilio = Pattern.compile("^((V|v)ia|(L|l)argo|(C|c)ontrada)\\s(([A-Z][a-z]|[a-z])+(\\s?))+,(\\s)*(\\d)*");
        Pattern patternNumCard = Pattern.compile("^([0-9]{4} ){3}[0-9]{4}$");
        Pattern patternCvv= Pattern.compile("^[1-9]{3}$");


        Matcher nomeMatcher = patternNome.matcher(nomeRichiedente);
        Matcher cognomeMatcher = patternCognome.matcher(cognomeRichiedente);
        Matcher emailMatcher = patternEmail.matcher(email);

        if(modalitaConsegna.equals("domicilio")){
            indirizzoSpedizione = formParams.getString("indirizzo");
            Matcher indirizzoMatcher = patternDomicilio.matcher(indirizzoSpedizione);
            if(indirizzoMatcher.find()!=true){
                response.setStatus(500);
                response.sendRedirect("errore.jsp");
                return;
            }

        }

        if(modalitaPagamento.equals("carta")){
            numeroCarta = formParams.getString("numeroCarta");
            cvv = formParams.getString("cvv");

            Matcher numeroCartaMatcher = patternNumCard.matcher(numeroCarta);
            Matcher cvvMatcher = patternCvv.matcher(cvv);

            if((numeroCartaMatcher.find() && cvvMatcher.find())!=true){
                response.setStatus(500);
                return;
            }
        }
        int codeOp = 0;

        if(nomeMatcher.find() && cognomeMatcher.find() && emailMatcher.find()){
            ArrayList<Prodotto> prodottiOrdinati = new ArrayList<>();

            for(int i=0; i<cart.length(); i++){
                int id = Integer.parseInt(cart.getJSONObject(i).getString("id")),
                        quantita = cart.getJSONObject(i).getInt("quantity");
                String nomeProdotto = cart.getJSONObject(i).getString("name"),
                        categoria = cart.getJSONObject(i).getString("category");
                float prezzo = Float.parseFloat(cart.getJSONObject(i).getString("price").replace(",", "."));

                Prodotto p = new Prodotto(id, nomeProdotto, prezzo, categoria);
                for(int j=0; j<quantita; j++){
                    prodottiOrdinati.add(p);

                }
            }


          int max_id = Query.getMaxIdOrdine();
            if(Query.insertDettagliOrdine(prodottiOrdinati, formParams, max_id)){
                int newMax = max_id+1;
                response.setStatus(200);

                EmailSender es = new EmailSender();
                es.send(new Cliente(email, nomeRichiedente, cognomeRichiedente), SHA256.SHA256Hash("ORDER-"+newMax));

                codeOp = 6;
                request.getSession().setAttribute("codeOp", codeOp);
                request.getSession().setAttribute("text","{\"Titolo\":\"Ordine effettuato!\", \"Corpo\": \"Mostra questo QR Code al momento del ritiro del tuo ordine. <br/> (Non ti preoccupare, te lo abbiamo mandato anche per email \uD83D\uDE09)\"}");
                request.getSession().setAttribute("SHA256Ordine",SHA256.SHA256Hash("ORDER-"+newMax));

                Query.insertTimestamp(newMax, "da lavorare");

            }else{
                codeOp = 2;
                request.getSession().setAttribute("codeOp", codeOp);
                request.getSession().setAttribute("text","{\"Titolo\":\"Ordine non effettuato!\", \"Corpo\": \"Abbiamo riscontrato un errore nel suo ordine.\"}");

            }

        }else{
            response.setStatus(500);
            response.sendRedirect("errore.jsp");

        }

    }

}
