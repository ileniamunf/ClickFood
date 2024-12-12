package it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.control;

import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.Cliente;
import it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.utils.Query;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.json.JSONObject;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ClienteServlet", value = "/ClienteServlet")
public class ClienteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if(request.getSession().getAttribute("Cliente") == null){
            response.sendRedirect("index.jsp");
            return ;
        }

        Cliente cliente = (Cliente)request.getSession().getAttribute("Cliente");

        Map<Integer, List<JSONObject>> ordini = Query.getOrdiniCliente(cliente.getEmail());
        request.getSession().setAttribute("OrdiniCliente", ordini);

        RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/view/Cliente.jsp");
        dispatcher.forward(request,response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request,response);
    }
}
