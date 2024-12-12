package it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.control;

import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.utils.Connessione;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.utils.Query;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ResposabileServlet", value = "/ResposabileServlet")
public class ResposabileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if(request.getSession().getAttribute("Responsabile") == null){
            response.sendRedirect("index.jsp");
            return ;
        }

        JSONArray tempistiche = Query.getTempisticheResponsabile();
        int numero_ordini = Query.getNumeroOrdiniTotali();
        int numero_clienti = Query.getNumeroClientiTotali();
        request.getSession().setAttribute("tempistiche",tempistiche);
        request.getSession().setAttribute("numero_ordini",numero_ordini);
        request.getSession().setAttribute("numero_clienti",numero_clienti);

        RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/view/Responsabile.jsp");
        dispatcher.forward(request,response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request,response);
    }
}
