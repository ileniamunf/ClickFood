package it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.control;

import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.DettagliOrdine;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.Ordine;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.utils.Query;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.utils.SHA256;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CuocoServlet", value = "/CuocoServlet")
public class CuocoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if(request.getSession().getAttribute("Cuoco") == null){
            response.sendRedirect("index.jsp");
            return ;
        }

        Map<Integer, List<JSONObject>> ordini = Query.getOrdiniCuoco();
        request.getSession().setAttribute("OrdiniDaLavorare", ordini);

        RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/view/Cuoco.jsp");
        dispatcher.forward(request,response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            String id_Ordine = request.getParameter("id_Ordine");
            String stato_corrente = request.getParameter("stato");
            String indirizzo = request.getParameter("indirizzo");



            String new_stato= "da lavorare";
            if(stato_corrente.equals("da lavorare")){
                 new_stato = "in lavorazione";
            }else if(stato_corrente.equals("in lavorazione")){
                if(indirizzo.equals("")){
                    new_stato = "al banco";
                }else{
                    new_stato = "domicilio";
                }
            }



            if(Query.changeStatus(id_Ordine,new_stato)){
              Query.insertTimestamp(Integer.parseInt(id_Ordine),new_stato);

            }else{
                //change non effettuato
                int codeOp=4;
                request.getSession().setAttribute("codeOp", codeOp);
                request.getSession().setAttribute("text","{\"Titolo\":\"Errore!\", \"Corpo\": \"Impossibile eseguire l\\'operazione, si prega di riprovare aggiornando la pagina.\"}");

            }

    }
}
