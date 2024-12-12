package it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.control;

import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.utils.Query;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.json.JSONObject;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AddettoServlet", value = "/AddettoServlet")
public class AddettoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if(request.getSession().getAttribute("Addetto") == null){
            response.sendRedirect("index.jsp");
            return ;
        }

        Map<Integer, List<JSONObject>> ordini = Query.getOrdiniAddetto();
        request.getSession().setAttribute("OrdiniAlBanco", ordini);

        RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/view/Addetto.jsp");
        dispatcher.forward(request,response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id_Ordine = request.getParameter("id_Ordine");
        String stato_corrente = request.getParameter("stato");


        String new_stato= "completato";


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