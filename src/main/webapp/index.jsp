<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Click Food&trade; - Index</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <link href="styles.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="icon" type="image/x-icon" href="resources/icons/icon.png">

</head>
<body id="main-body" class="d-flex flex-column">
<jsp:include page="WEB-INF/componenti/Navbar.jsp"/>

<div id="heroIndex" class="cover-container d-flex w-100 h-100 mx-auto flex-column">
    <div id="mainlink" ></div>
    <section id="indexMain" class="px-3 text-warning h-100 pb-5">
        <div class="bg-dark p-4 opacity-75 border border-dark rounded-3 mx-auto">
            <h1>Crea il tuo ordine!</h1>
            <p class="lead">Componi il tuo ordine, paga e gusta i nostri piatti direttamente a casa tua con un click!</p>
            <p class="lead text-center opacity-100">
                <a href="OrdinaServlet" class="btn btn-warning btn-lg">Ordina Ora!</a>
            </p>
        </div>
    </section>
</div><div id="menulink"></div>
<div id="heroMenu" class="cover-container d-flex w-100 mx-auto flex-column">
    <section id="menu" class="bg-dark text-warning my-auto pb-2">
        <div class="bg-dark p-2 opacity-75 border border-dark rounded-3 mx-auto pt-5"/>
    </section>
</div>

<jsp:include page="WEB-INF/componenti/Footer.jsp"/>

<%  if(Integer.parseInt(session.getAttribute("codeOp").toString()) != 0) {%>

<jsp:include page="WEB-INF/componenti/Modal.jsp" />

<%
        session.removeAttribute("codeOp");
    }
%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>