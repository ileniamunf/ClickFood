<%@ page import="java.util.Arrays" %>
<jsp:useBean id="Cuoco" type="it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.Utente" scope="session"/>
<jsp:useBean id="OrdiniDaLavorare" type="java.util.Map<java.lang.Integer,java.util.List<org.json.JSONObject>>" scope="session"/>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%if(session.getAttribute("codeOp")==null){
    session.setAttribute("codeOp",0);
}%>
<html>
<head>
    <title>Click Food&trade; - <%= Cuoco.getNome()%></title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <link href="styles.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="icon" type="image/x-icon" href="resources/icons/icon.png">

    <script>
        $(document).ready(function(){
            //Reload della pagina ogni 30s
            setInterval(() => { console.log("reload"); window.location.reload();  }, 30000);


            $("#logout").click(() => {
                $.post("LogoutServlet", {}, function(data, status){
                    if(status == "success"){
                        window.location.reload();
                    }
                });
            });

            const PROCESSINGICON = "./resources/icons/hourglass.png";
            const CHECKICON = "./resources/icons/check.png";

            let buttons = document.querySelectorAll("button.change-status");

            buttons.forEach((button) => {
                if($(button).parent().children("p").children("span").text() == "da lavorare"){
                    $(button).children("span").text("Metti in Lavorazione");
                    $(button).children("img").attr("src", PROCESSINGICON);
                    $(button).children("img").attr("alt", "Metti in Lavorazione");
                } else if ($(button).parent().children("p").children("span").text() == "in lavorazione") {
                    $(button).children("span").text("Termina preparazione");
                    $(button).children("img").attr("src", CHECKICON);
                    $(button).children("img").attr("alt", "Termina preparazione");
                } else {
                    $(button).parent().remove(button);
                }
            });

            let forms = document.querySelectorAll("form");

            forms.forEach((form) => {
                $(form).submit((ev) => {
                    ev.preventDefault();

                    $.post("CuocoServlet", {
                        id_Ordine: $(form).children("input[name=idOrdine]").val(),
                        stato: $(form).children("input[name=statoOrdine]").val(),
                        indirizzo: $(form).children("input[name=indirizzo]").val()
                    }, function(data,status) {
                        if(status == "success"){
                            window.location.reload();
                        }

                    });
                });

            });

            let esitoModal = new bootstrap.Modal($("#esitoModal"));
            if(esitoModal != undefined){
                esitoModal.show();
            }


        });
    </script>
</head>
<body id="gestisci-ordini-body" class="d-flex flex-column" style="background-color: rgba(var(--bs-dark-rgb),0.93);">
<jsp:include page="../componenti/Navbar.jsp"/>
<%if(OrdiniDaLavorare.isEmpty()){%>
    <div id="noOrdini" class="text-center text-warning">
        <h1>Non ci sono ordini da visualizzare</h1>
    </div>
<% } else{ %>
<div class="card-container d-grid align-items-center position-relative mx-auto">
    <%Object[] keys = OrdiniDaLavorare.keySet().toArray();
      Arrays.sort(keys);%>
    <% for(Object i : keys){%>
    <div class="receipt text-center">
        <h1><%=i%></h1>
        <div class="receipt-container mb-3 mx-auto">
            <table class="mx-auto">
                <tr>
                    <th>Prodotto</th>
                    <th>Quantit&agrave;</th>
                </tr>

                <% for(int j=0; j<OrdiniDaLavorare.get(i).size();j++) {%>
                <tr>
                    <td><%=OrdiniDaLavorare.get(i).get(j).getString("Nome_Prodotto")%></td>
                    <td>x<%=OrdiniDaLavorare.get(i).get(j).getInt("Quantity")%></td>
                </tr>
                <% }%>
            </table>
            <hr/>
            <div id="note" class="receipt-container mb-3 mx-auto text-start">
                <h4><strong>Note:</strong> </h4>
                <h5><%=OrdiniDaLavorare.get(i).get(0).getString("Note")%></h5>
            </div>
        </div>

        <form>
            <input type="text" value="<%=i%>" hidden name="idOrdine"/>
            <input type="text" value="<%=OrdiniDaLavorare.get(i).get(0).getString("Stato")%>" hidden name="statoOrdine"/>
            <input type="text" value="<%=OrdiniDaLavorare.get(i).get(0).getString("Indirizzo")%>" hidden="hidden" name="indirizzo"/>
            <div id="statoOrdine" class="row text-center">
                <p>Stato attuale: <span style="color:#c01d2e"><%=OrdiniDaLavorare.get(i).get(0).getString("Stato")%></span></p>
                <button type="submit" class="change-status btn btn-dark mx-auto w-50">
                    <span></span>
                    <img height="30" width="30"/>
                </button>
            </div>
        </form>

    </div>
    <%}%>
</div>
<%} %>

<jsp:include page="../componenti/Footer.jsp"/>

<%  if(Integer.parseInt(session.getAttribute("codeOp").toString()) != 0) {%>

<jsp:include page="../componenti/Modal.jsp" />

<%
        session.removeAttribute("codeOp");
    }
%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
