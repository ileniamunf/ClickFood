<%@ page import="java.util.ArrayList" %>
<%@ page import="it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.Prodotto" %>
<%@ page import="it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.Cliente" %>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<jsp:useBean id="prodList" type="java.util.ArrayList<it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.Prodotto>" scope="request"/>

<%ArrayList<String> categorie = new ArrayList<>(4);
    categorie.add("panino");
    categorie.add("contorno");
    categorie.add("bibita");
    categorie.add("extra");%>


<%Cliente cliente = null;
    if(session.getAttribute("Cliente")!=null){
        cliente = (Cliente) session.getAttribute("Cliente");
}%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Click Food&trade; - Ordina</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <link href="styles.css" rel="stylesheet">
    <link rel="icon" type="image/x-icon" href="resources/icons/icon.png">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

    <script type="text/javascript">

        function cartFind(cart, productName){
            /*Funzione per la ricerca di un prodotto nel carrello dato il nome*/
            let index = -1;

            for(let i=0; i<cart.length; i++) {
                if(cart[i].name == productName){
                    index = i;
                }
            }

            return index;
        }


        function updateTotalPrice(cart) {
            let sum = 0;
            if(cart.length == 0){
                $("#totalePrezzo").val("0.00");
            }else{
                for (let i = 0; i < cart.length; i++) {
                    sum += parseFloat(cart[i].price.replace(",", ".")) * parseInt(cart[i].quantity);
                    $("#totalePrezzo").val(sum.toFixed(2));

                }
            }

        }


        $(document).ready(function(){

            $("#numeroCarta").keyup(function(ev){
                //Gestione pressione tasti per l'inserimento del numero di carta
                let value = $("#numeroCarta").val();

                if((value.length == 4 || value.length == 9 || value.length == 14) && ev.keyCode != 8){ //keycode = 8 è il cancella
                    $("#numeroCarta").val(value + " ");
                }


                let addonImg = document.createElement("img");
                addonImg.width = 32;
                addonImg.height= 32;
                addonImg.src = "resources/icons/creditcard.svg";

                if(value.length == 19){
                    let v = $("#numeroCarta").val().replaceAll(" ", "");
                    const visa = new RegExp("^4[0-9]{12}(?:[0-9]{3})?");
                    const mastercard = new RegExp("^5[1-5][0-9]{14}");
                    const amex = new RegExp("^3[47][0-9]{13}");

                    if(visa.test(v) ){
                        addonImg.src = "resources/icons/visa.svg";
                    }
                    if(mastercard.test(v) ){
                        addonImg.src="resources/icons/mastercard.svg";
                    }
                    if(amex.test(v) ){
                        addonImg.src = "resources/icons/amex.svg";
                    }
                    $("#addon").html(addonImg);
                } else{
                    $("#addon").html("");
                }

            });

            //Gestione data per l'inserimento della data di scadenza della carta
            let today = new Date();
            let min = new Date(today.setMonth(today.getMonth() + 3));
            let max = new Date(today.setFullYear(today.getFullYear() + 5));

            $("#scadenza").attr("min", min.toISOString().slice(0, 10));
            $("#scadenza").attr("max", max.toISOString().slice(0, 10));

            //Inizializzazione carello
            let cart = []

            // Gestione card dei prodotti
            let productCards = document.querySelectorAll(".card-prodotto");

            productCards.forEach((productCard) => {
                // Per ognuna di esse aggiungo un event listener al click
                $(productCard).click((ev)=>{
                    /* Definizione di variabili per raccogliere esplicitamente gli elementi
                    della card (in base al DOM)*/
                    let radio = $(productCard).children("input[type=radio]");
                    let numbers = $(productCard).children().children("input[type=number]");
                    let addBtn = $(productCard).children().children(".addProdBtn");

                    // Disabilito il gestore di questo evento sul pulsante di aggiunta e sull'input numerico
                    $(productCard).children(".input-group").click((ev) => {
                        ev.stopPropagation();
                    })

                    /* Se il radio button nascosto associato al prodotto è marcato
                    allora lo smarco, disabilito l'input numerico e il pulsante di aggiunta e,
                    se il prodotto associato era in carrello, lo rimuovo*/
                    if($(radio).attr("checked") == "checked") {
                        $(radio).removeAttr("checked")
                        $(numbers).attr("hidden", "hidden");
                        $(addBtn).attr("hidden", "hidden");
                        $(addBtn).removeAttr("disabled");
                        $(addBtn).html(ADDICON);
                        $(productCard).removeClass("btn-success");
                        $(productCard).addClass("btn-warning");

                        let prodName = $(productCard).children("h3").text();
                        let index = cartFind(cart, prodName);

                        if(index != -1){
                            cart.splice(index, 1);
                            updateTotalPrice(cart);
                        }
                        /* Altrimenti marco il radio button e abilito l'input numerico e il pulsante di aggiunta*/
                    } else {
                        $(radio).attr("checked", "checked")
                        $(numbers).removeAttr("hidden");
                        $(addBtn).removeAttr("hidden");
                    }

                    $(productCard).toggleClass("selected");

                })
            })

            // Icone da usare per le trasformazioni
            const ADDICON = '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-plus" viewBox="0 0 16 16">'+
                '<path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>'+
                '</svg>'

            const CHECKICON = '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-check-lg" viewBox="0 0 16 16">' +
                '<path d="M12.736 3.97a.733.733 0 0 1 1.047 0c.286.289.29.756.01 1.05L7.88 12.01a.733.733 0 0 1-1.065.02L3.217 8.384a.757.757 0 0 1 0-1.06.733.733 0 0 1 1.047 0l3.052 3.093 5.4-6.425z"/>'+
                '</svg>';
            const UPDATEICON = '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-arrow-clockwise" viewBox="0 0 16 16">'+
                '<path fill-rule="evenodd" d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2z"/>'+
                '<path d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466"/>'+
                '</svg>'

            // Gestione pulsanti aggiunta prodotto
            let addButtons = document.querySelectorAll(".addProdBtn");

            addButtons.forEach((button) => {
                // Per ognuno di essi, aggiungiamo un listener click
                $(button).click(ev => {
                    // Definizione variabili per la raccolta delle info necessarie
                    let radioBtn = $(button).parent().siblings("input[type=radio]");

                    let productId = String(radioBtn.attr("id")).slice(5);
                    let productName = $(button).parent().siblings("h3").text();
                    let price = $(button).parent().siblings("p[hidden!=hidden]").text().slice(2, 5);
                    let quantity = $(button).siblings("input[type=number]").val();
                    let category = $(button).parent().siblings("p[hidden=hidden]").text().toLowerCase();

                    // Se al click non è stata settata esplicitamente la quantità, assumo che sia 1
                    if(quantity == ""){
                        $(button).siblings("input[type=number]").val(1);
                        quantity = 1;
                    }

                    /* Cerco il prodotto nel carrello: se non lo trovo, lo aggiungo per i parametri
                    specificati, altrimenti ne aggiorno la quantità in carrello*/
                    let index = cartFind(cart, productName);

                    if(index == -1){
                        cart.push({
                            "id": productId,
                            "name": productName,
                            "price": price,
                            "quantity": quantity,
                            "category": category
                        })
                    } else {
                        cart[index].quantity = quantity;
                    }

                    /* All'aggiunta del prodotto attivo la transizione della card da gialla a verde
                    e trasformo l'icona del pulsante in una spunta*/
                    let itemCard = $(button).parent().parent(".card-prodotto");

                    $(itemCard).removeClass("btn-warning");
                    $(itemCard).addClass("btn-success");

                    $(button).html(CHECKICON);
                    $(button).attr("disabled", "disabled");


                    updateTotalPrice(cart);


                })
            })

            let numericInputs = document.querySelectorAll("input[type=number]");

            numericInputs.forEach((nInput) => {
                $(nInput).change((ev) => {
                    let addBtn = $(nInput).siblings(".addProdBtn");
                    if($(addBtn).attr("disabled") == "disabled"){
                        $(addBtn).removeAttr("disabled");
                        $(addBtn).html(UPDATEICON);
                    }
                })
            })

            // Gestione modalità di consegna

            let spedizioneAccordionButtons = document.querySelectorAll("#infoSpedizione .accordion-button");

            // Il bottone dell'accordion è il rettangolo che nel form permette di far espandere o collassare una zona
            spedizioneAccordionButtons.forEach((button) => {
                /* Per ciascuno di essi, quando viene premuto, viene cambiata la modalità di consegna (se non è quella già
                selezionata), settando eventuali parametri necessari */
                $(button).click((ev) => {
                    if($(button).children("input[type=radio]").attr("checked") !== "checked"){
                        $("#infoSpedizione input[type=radio]").removeAttr("checked");
                        $(button).children("input[type=radio]").attr("checked", "checked");

                        let spedizione = $(button).children("input[type=radio]").val();
                        // Per gli ordini a domicilio rendo obbligatoria la via per la consegna
                        if(spedizione == "domicilio"){
                            $("#indirizzo").attr("required", "required");
                        } else {
                            $("#indirizzo").removeAttr("required");
                        }
                    }
                })
            })

            // Gestione modalità di pagamento
            let pagamentoAccordionButtons = document.querySelectorAll("#infoPagamento .accordion-button");

            // Il bottone dell'accordion è il rettangolo che nel form permette di far espandere o collassare una zona
            pagamentoAccordionButtons.forEach((button) => {
                /* Per ciascuno di essi, quando viene premuto, viene cambiata la modalità di pagamento (se non è quella già
                selezionata), settando eventuali parametri necessari */
                $(button).click((ev) => {
                    if($(button).children("input[type=radio]").attr("checked") !== "checked"){
                        $("#infoPagamento input[type=radio]").removeAttr("checked");
                        $(button).children("input[type=radio]").attr("checked", "checked");

                        let mpagamento = $(button).children("input[type=radio]").val();
                        // Se la modalità scelta è per carta, rendo obbligatori il numero, la scadenza e il cvv
                        if(mpagamento == "carta"){
                            $("#numeroCarta").attr("required", "required");
                            $("#scadenza").attr("required", "required");
                            $("#cvv").attr("required", "required");
                        } else {
                            $("#numeroCarta").removeAttr("required");
                            $("#scadenza").removeAttr("required");
                            $("#cvv").removeAttr("required");
                        }
                    }
                })
            })

            // Gestore submission form ordine
            $("#ordine").submit((ev) => {
                let inputs = document.querySelectorAll("#ordine input");
                let cartJSON = {"cartList": cart};
                ev.preventDefault();

                // Se il carrello è vuoto, blocco la submission
                // TO-DO: Notificare meglio l'invito ad aggiungere un prodotto
                if(cartJSON.cartList.length < 1) {
                    ev.stopPropagation();
                    alert("Non c'è nessun prodotto selezionato");
                    return;
                }

                // Se almeno un campo del form è invalido, blocco la submission
                let form = document.getElementById("ordine");

                if(!form.checkValidity()){
                    $("#ordine").addClass("was-validated");
                    ev.stopPropagation();
                    return;
                }

                // Serializzo i campi del form, per trattarli come una lista di parametri, e li converto in formato JSON
                let unindexedFormParams = $("#ordine").serializeArray();
                let formParamsJSON = {}

                // Trasformo i parametri in un oggetto JSON
                // Mantengo nell'oggetto solo quei parametri che hanno un valore diverso da '' 
                $.map(unindexedFormParams, function(n, i){
                    if(n['value'] != "") formParamsJSON[n['name']] = n['value'];
                });

                console.log(formParamsJSON);
                console.log(JSON.stringify(cartJSON));

                // Posso, quindi, inviare i dati serializzati al server
                $.post('OrdinaServlet', {
                    "formParams": JSON.stringify(formParamsJSON),
                    "cart": JSON.stringify(cartJSON)
                }, (data, status) => {
                }).done(function(data) {
                    window.location.reload();
                }).fail(function () {
                    window.location.href = "errore.jsp";
                });

            });

        });
    </script>

</head>
<body id="order-body" class="d-flex flex-column">
    <jsp:include page="../componenti/Navbar.jsp" />

    <div style="background-color: rgba(var(--bs-dark-rgb))" class="w-100 text-warning position-absolute top-0">
        <form id="ordine" class="w-75 mx-auto needs-validation" method="post" novalidate>
            <div id="selezioneProdotti" class="text-center w-100 mb-5">
                <h1>Cosa vuoi ordinare?</h1>
                <p>Scegli i tuoi prodotti preferiti, al resto ci pensiamo noi! 😉</p>
                <hr/>
                <%for (String c: categorie){%>
                    <h2><%=c.substring(0,1).toUpperCase() + c.substring(1)%></h2><hr/>
                    <div class="d-grid mb-3" style="grid-template-columns: repeat(auto-fill, 280px)">
                        <%for (Prodotto p: prodList){%>
                            <%java.util.Formatter formatter = new java.util.Formatter();%>
                            <%if (p.getCategoria().equals(c)) {%>
                                <div class="card-prodotto btn btn-warning m-2">
                                    <p hidden><%=p.getCategoria()%></p>
                                    <img src="resources/images/products/id_<%=p.getId_prodotto()%>.png" alt="<%=p.getNome().replace(" ", "")%>" class="w-75 mx-auto" />
                                    <h3 style="text-decoration: underline"><%=p.getNome()%></h3>
                                    <p>&euro; <%=formatter.format("%.2f", p.getPrezzo())%></p>
                                    <input type="radio" name="<%=p.getNome().replace(" ", "")%>Radio" id="Radio<%=p.getId_prodotto()%>" hidden="hidden">
                                    <div class="input-group" id='<%=p.getNome().replace(" ", "")%>Quantity'>
                                        <input type="number" class="form-control w-25 mx-auto" name='<%=p.getNome().replace(" ", "")%>Number' id='<%=p.getNome().replace(" ", "")%>Number' placeholder="1" min="1" max="20" step="1" pattern="\d{1,2}" hidden>
                                        <button type="button" id='<%=p.getNome().replace(" ", "")%>Add' class="btn btn-warning border border-dark w-50 addProdBtn" hidden>
                                            <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-plus" viewBox="0 0 16 16">
                                                <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4"/>
                                            </svg>
                                        </button>
                                    </div>
                                </div>
                            <%}%>
                        <%}%>
                    </div>
                <%}%>
            </div>


            <div id="totale" class="text-center w-100 mb-5">
                <h1>Prezzo Tot.</h1>
                <div class="container bg-warnng text-dark px-2 py-4 border rounded-2" style="width: 300px;">
                    <span id="spanPrezzo">€</span>
                    <input type="text" name="totalePrezzo" id="totalePrezzo" placeholder="0.00" pattern="/d{1,10}/./d{2}" disabled="disabled" style="position: relative; bottom: 3px;"/>
                </div>
            </div>


            <div id="infoSpedizione" class="text-center w-100 mb-5">
                <h1>A chi consegneremo l'ordine?</h1>
                <p>Specifica le modalit&agrave; con cui vorrai consegnato il tuo ordine</p><hr/>
                <div class="container bg-warning text-dark px-2 py-4 border rounded-2">
                    <div class="row">
                        <div class="col">
                            <div class="form-floating mb-3">
                                <%if(cliente != null){ %>
                                    <input type="text" name="nomeRichiedente" id="nomeRichiedente" class="form-control" placeholder="Nome" required="required" pattern="^(([A-Z][a-z]|[a-z])+(\s?))+$" value="<%=cliente.getNome()%>">
                                <% }else { %>
                                <input type="text" name="nomeRichiedente" id="nomeRichiedente" class="form-control" placeholder="Nome" required="required" pattern="^(([A-Z][a-z]|[a-z])+(\s?))+$">
                                <% } %>
                                <label for="nomeRichiedente" class="form-label">Nome</label>
                            </div>
                        </div>
                        <div class="col">
                            <div class="form-floating mb-3">
                                <%if(cliente != null){ %>
                                <input type="text" name="cognomeRichiedente" id="cognomeRichiedente" class="form-control" placeholder="Cognome" required="required" pattern="^(([A-Z][a-z]|[a-z])+(\s?))+$" value="<%=cliente.getCognome()%>">
                                <% }else { %>
                                <input type="text" name="cognomeRichiedente" id="cognomeRichiedente" class="form-control" placeholder="Cognome" required="required" pattern="^(([A-Z][a-z]|[a-z])+(\s?))+$">
                                <% } %>
                                <label for="cognomeRichiedente" class="form-label">Cognome</label>
                            </div>
                        </div>
                    </div>
                    <div class="form-floating mb-3">
                        <%if(cliente != null){ %>
                        <input type="text" name="emailRichiedente" id="emailRichiedente" class="form-control" placeholder="Indirizzo e-mail" required="required" pattern="^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$" value="<%=cliente.getEmail()%>">
                        <% }else { %>
                        <input type="text" name="emailRichiedente" id="emailRichiedente" class="form-control" placeholder="Indirizzo e-mail" required="required" pattern="^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$">
                        <% } %>
                        <label for="emailRichiedente" class="form-label">Indirizzo e-mail</label>
                    </div>

                    <div class="accordion" id="consegnaAccordion">
                        <div class="accordion-item">
                          <h2 class="accordion-header">
                            <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#campiDomicilio" aria-expanded="true" aria-controls="campiDomicilio">
                              Consegna a domicilio
                              <input type="radio" name="modalitaConsegna" id="consDomicilioRadio" value="domicilio" checked hidden>
                            </button>
                          </h2>
                          <div id="campiDomicilio" class="accordion-collapse collapse show" data-bs-parent="#consegnaAccordion">
                            <div class="accordion-body">
                                <div class="form-floating mb-3">
                                    <input type="text" name="indirizzo" id="indirizzo" class="form-control" placeholder="Indirizzo (e.g Via Roma, 1)" required="required" pattern="^((V|v)ia|(L|l)argo|(C|c)ontrada)\s(([A-Z][a-z]|[a-z])+(\s?))+,(\s)*(\d)*">
                                    <label for="indirizzo" class="form-label">Indirizzo (e.g Via Roma, 1)</label>
                                </div>
                            </div>
                          </div>
                        </div>
                        <div class="accordion-item">
                          <h2 class="accordion-header">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#placeholderRitiro" aria-expanded="false" aria-controls="placeholderRitiro">
                              Ritiro in negozio
                              <input type="radio" name="modalitaConsegna" id="ritiroRadio" value="ritiro" hidden>
                            </button>
                          </h2>
                          <div id="placeholderRitiro" class="accordion-collapse collapse" data-bs-parent="#consegnaAccordion">
                            <div class="accordion-body">
                                <h2>Potrai ritirare il tuo ordine mostrando il codice di ritiro</h2>
                            </div>
                          </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div id="infoPagamento" class="text-center w-100 mb-5 h-100">
                <h1>Come pagherai l'ordine?</h1>
                <p>Specifica la modalit&agrave; di pagamento del tuo ordine</p><hr/>
                <div class="container bg-warning text-dark px-2 py-4 border rounded-2">
                    <div class="accordion" id="pagamentoAccordion">
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#campiCarta" aria-expanded="true" aria-controls="campiCarta">
                                Con carta
                                <input type="radio" name="modalitaPagamento" id="cartaRadio" value="carta" checked hidden>
                                </button>
                            </h2>
                            <div id="campiCarta" class="accordion-collapse collapse show" data-bs-parent="#infoPagamento">
                                <div class="accordion-body">
                                    <label for="numeroCarta" class="form-label">Numero Carta</label>
                                        <div class="input-group mb-3">
                                            <input type="text" name="numeroCarta" id="numeroCarta" class="form-control" placeholder="XXXX XXXX XXXX XXXX" pattern="^([0-9]{4} ){3}[0-9]{4}$" required="required" maxlength="19">

                                            <span class="input-group-text" id="addon"/>
                                        </div>
                                    <div class="mb-3">
                                        <label for="scadenza" class="form-label">Data di Scadenza</label>
                                        <input type="date" name="scadenza" id="scadenza" class="form-control" placeholder="YYYY-MM-DD" maxlength="10" required="required">
                                    </div>
                                    <div class="form-floating mb-3">
                                        <input type="password" name="cvv" id="cvv" class="form-control" pattern="^[1-9]{3}$" placeholder="XXX" maxlength="3" required="required">
                                        <label for="cvv" class="form-label">Cvv</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="accordion-item">
                            <h2 class="accordion-header">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#placeholderContanti" aria-expanded="false" aria-controls="placeholderContanti">
                                    In contanti
                                    <input type="radio" name="modalitaPagamento" id="contantiRadio" value="contanti" hidden>
                                </button>
                            </h2>
                            <div id="placeholderContanti" class="accordion-collapse collapse" data-bs-parent="#infoPagamento">
                                <div class="accordion-body">
                                    <h2>Potrai pagare il tuo ordine in contanti alla ricezione del tuo ordine!</h2>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>


            <div id="infoNote" class="text-center w-100 mb-5 h-100">
                <h1>Note per il tuo ordine!</h1>
                <p>Specifica dettagli in più del tuo ordine</p><hr/>
                <div class="container bg-warning text-dark px-2 py-4 border rounded-2">
                    <div class="accordion" id="noteAccordion">
                        <textarea style="width: 100%" name="note" id=note row="4" cols="64" placeholder="Note (e.g intolleranze, ingredienti,...)" maxlength="64" ></textarea>
                    </div>
                </div>

                <div class="row text-center my-3">
                    <button class="btn btn-warning w-50" type="submit" style="font-size: 3em; position:relative; left:25%;">
                        Invia Ordine
                        <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="currentColor" class="bi bi-send" viewBox="0 0 16 16">
                            <path d="M15.854.146a.5.5 0 0 1 .11.54l-5.819 14.547a.75.75 0 0 1-1.329.124l-3.178-4.995L.643 7.184a.75.75 0 0 1 .124-1.33L15.314.037a.5.5 0 0 1 .54.11ZM6.636 10.07l2.761 4.338L14.13 2.576zm6.787-8.201L1.591 6.602l4.339 2.76z"/>
                        </svg>
                    </button>
                </div>
            </div>
            
            
        </form>
    </div>
    
    <jsp:include page="../componenti/Footer.jsp"/>

    <%  if(Integer.parseInt(session.getAttribute("codeOp").toString()) != 0) {%>

    <jsp:include page="/WEB-INF/componenti/Modal.jsp" />

    <%
            session.removeAttribute("codeOp");
        }
    %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>