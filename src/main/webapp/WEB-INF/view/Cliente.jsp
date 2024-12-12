<%@ page import="java.util.Arrays" %>
<%@ page import="java.sql.Date" %>
<jsp:useBean id="Cliente" type="it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.Utente" scope="session"/>
<jsp:useBean id="OrdiniCliente" type="java.util.Map<java.lang.Integer,java.util.List<org.json.JSONObject>>" scope="session"/>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%if(session.getAttribute("codeOp")==null){
    session.setAttribute("codeOp",0);
}%>
<html>
<head>
    <title>Click Food&trade; - <%= Cliente.getNome()%></title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <link href="styles.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="icon" type="image/x-icon" href="resources/icons/icon.png">

    <script>
        $(document).ready(function(){

            $("#logout").click(() => {
                $.post("LogoutServlet", {}, function(data, status){
                    if(status == "success"){
                        window.location.reload();
                    }
                });
            });

            const CLOCKICON = "./resources/icons/clock.png";
            const PANICON = "./resources/icons/pan.png";
            const RIDERICON = "./resources/icons/delivery.png";
            const HOUSEICON = "./resources/icons/house.png";
            const READYICON = "./resources/icons/ready.png";

            let spans = document.querySelectorAll("span");

            spans.forEach((span) => {
                let image = $(span).siblings("img");
                $(image).attr("alt",$(span).text());
                $(image).attr("width","30");
                $(image).attr("height","30");


                if($(span).text()== "completato" || $(span).text()== "consegnato"){
                    $(span).css("color","green");
                    $(image).attr("src",READYICON);
                }else if($(span).text() == "da lavorare"){
                    $(image).attr("src",CLOCKICON);
                }else if($(span).text() == "in lavorazione"){
                    $(image).attr("src",PANICON);
                }else if($(span).text() == "domicilio"){
                    $(image).attr("src",HOUSEICON);
                }else if($(span).text() == "in consegna"){
                    $(image).attr("src",RIDERICON);
                }
            });

        });
    </script>
</head>
<body id="gestisci-ordini-body" class="d-flex flex-column" style="background-color: rgba(var(--bs-dark-rgb),0.93);">
<jsp:include page="../componenti/Navbar.jsp"/>
<%if(OrdiniCliente.isEmpty()){%>
<div id="noOrdini" class="text-center text-warning">
    <h1>Non hai ancora fatto alcun ordine.</h1>
    <h2>Ordina <a href="OrdinaServlet"><strong>ora</strong></a>!</h2>
</div>
<% } else{ %>
<div class="card-container d-grid align-items-center position-relative mx-auto">
    <%Object[] keys = OrdiniCliente.keySet().toArray();
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

                <% for(int j=0; j<OrdiniCliente.get(i).size();j++) {%>
                <tr>
                    <td><%=OrdiniCliente.get(i).get(j).getString("Nome_Prodotto")%></td>
                    <td>x<%=OrdiniCliente.get(i).get(j).getInt("Quantity")%></td>
                </tr>
                <% }%>
            </table>
            <hr/>
            <div id="infoConsegna" class="receipt-container mb-3 mx-auto text-start">
                <%  float count = 0;
                    for(int j=0; j< OrdiniCliente.get(i).size();j++) {
                        count += OrdiniCliente.get(i).get(j).getFloat("Prezzo");
                    }%>
                <div class="row mb-3 w-75 mx-auto">
                    <div class="col text-start">
                        <h4><strong>Prezzo Tot: </strong></h4>
                    </div>
                    <div class="col text-start">
                        <h4>&euro; <%=count%> </h4>
                    </div>
                </div>
                <h4><strong>Indirizzo:</strong></h4>
                <h5><%=OrdiniCliente.get(i).get(0).getString("IndirizzoSpedizione")%></h5>
                <h4><strong>Pagamento:</strong> </h4>
                <h5><%=OrdiniCliente.get(i).get(0).getString("NumCarta")%></h5>
                <h4><strong>Email:</strong></h4>
                <h5><%=OrdiniCliente.get(i).get(0).getString("Email")%></h5>
                <h4><strong>Data:</strong></h4>
                <h5><%=(Date)OrdiniCliente.get(i).get(0).get("Data")%></h5>
            </div>
            <hr/>
            <div id="qrCode<%=i%>" class="qr-container text-center">
                <script>
                    $.getScript("qrcode.min.js", () => {
                        let qrcode = new QRCode(document.getElementById("qrCode<%=i%>"), {
                            text: "<%=OrdiniCliente.get(i).get(0).getString("CodiceRitiro")%>",
                            width: 128,
                            height: 128,
                            colorDark : "#000000",
                            colorLight : "#ffffff",
                            correctLevel : QRCode.CorrectLevel.H
                        });
                    });
                </script>
            </div>
        </div>



            <div id="statoOrdine" class="row text-center">
                <p>Stato attuale: <span style="color:#c01d2e"><%=OrdiniCliente.get(i).get(0).getString("Stato")%></span><br/> <img></p>
            </div>

    </div>
    <%}%>
</div>
<%} %>

<jsp:include page="../componenti/Footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>