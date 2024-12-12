<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="Responsabile" type="it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.Utente" scope="session"/>
<jsp:useBean id="tempistiche" type="org.json.JSONArray" scope="session"/>
<jsp:useBean id="numero_ordini" type="java.lang.Integer" scope="session"/>
<jsp:useBean id="numero_clienti" type="java.lang.Integer" scope="session"/>
<!DOCTYPE html>
<html>
<head>
    <title>Click Food&trade; - <%=Responsabile.getNome()%></title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <link href="styles.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js"></script>
    <link rel="icon" type="image/x-icon" href="resources/icons/icon.png">


    <script>
        $(document).ready(() => {
            const xValuesCompletato = ["da lavorare", "in lavorazione", "al banco", "completato"];
            const yValuesCompletato = [0, <%=tempistiche.getJSONObject(6).getInt("tempo_medio")%>, <%=tempistiche.getJSONObject(1).getInt("tempo_medio")%>, <%=tempistiche.getJSONObject(2).getInt("tempo_medio")%>];
        
            const graficoCompletato = new Chart("completato",{
                    type: "line",
                    data: {
                        labels: xValuesCompletato,
                        datasets: [{
                            borderColor: "rgba(28, 28, 24, 0.1)",
                            data: yValuesCompletato
                        }]
                    },
                    options: {
                        legend: {display: false},
                        scales: {
                          yAxes: [{ticks: {min: 0, max:3000}}],
                        }
                    }
                }
            );

            const xValuesConsegnato = ["da lavorare", "in lavorazione", "domicilio", "in consegna", "consegnato"];
            const yValuesConsegnato = [0, <%=tempistiche.getJSONObject(6).getInt("tempo_medio")%>, <%=tempistiche.getJSONObject(4).getInt("tempo_medio")%>, <%=tempistiche.getJSONObject(5).getInt("tempo_medio")%>, <%=tempistiche.getJSONObject(3).getInt("tempo_medio")%>];
        
            const graficoConsegnato = new Chart("consegnato",{
                    type: "line",
                    data: {
                        labels: xValuesConsegnato,
                        datasets: [{
                            borderColor: "rgba(28, 28, 24, 0.1)",
                            data: yValuesConsegnato
                        }]
                    },
                    options: {
                        legend: {display: false},
                        scales: {
                          yAxes: [{ticks: {min: 0, max:3000}}],
                        }
                    }
                }
            );
        });
        
    </script>

</head>
<body id="dashboard" class="h-100 w-100 bg-dark">
    
    <jsp:include page="../componenti/Navbar.jsp"/>

    <div id="statisticsContainer" class="container-md d-grid w-100 text-dark">
        <div class="row mb-3">
            <div class="col-md-6">
                <div class="bg-warning border rounded-2 h-100 mt-2">
                    <div class="statistic-name text-center graph-text mb-3">Media tempo di preparazione</div>
                    <canvas id="completato" class="w-100 mx-auto" style="max-width: 960px;"></canvas>
                </div>
            </div>
            <div class="col-md-6">
                <div class="bg-warning border rounded-2 h-100 mt-2">
                    <div class="statistic-name text-center graph-text mb-3">Media tempo di consegna</div>
                    <canvas id="consegnato" class="w-100 mx-auto" style="max-width: 960px;"></canvas>
                </div>
            </div>
        </div>
        <div class="row my-3">
            <div class="col-md-4 small-stats">
                <div class="border rounded-2 text-center h-75 px-2">
                    <div class="h-50 statistic-name text-start">Tempo attesa medio</div>
                    <div class="h-50 statistic-value text-end fw-italic"><%=tempistiche.getJSONObject(8).getInt("tempo_medio")%>"</div>
                </div>
            </div>
            <div class="col-md-4 small-stats">
                <div class="border rounded-2 text-center h-75 px-2">
                    <div class="h-50 statistic-name text-start">Totale Ordini</div>
                    <div class="h-50 statistic-value text-end fw-italic"><%=numero_ordini%></div>
                </div>
            </div>
            <div class="col-md-4 small-stats">
                <div class="border rounded-2 text-center h-75 px-2">
                    <div class="h-50 statistic-name text-start">Totale Clienti</div>
                    <div class="h-50 statistic-value text-end fw-italic"><%=numero_clienti%></div>
                </div>
            </div>
        </div>
        
    </div>

    <jsp:include page="../componenti/Footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

</body>