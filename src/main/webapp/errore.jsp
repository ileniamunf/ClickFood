<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Errore</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <link href="styles.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="icon" type="image/x-icon" href="resources/icons/icon.png">
</head>
<body>
<jsp:include page="WEB-INF/componenti/Navbar.jsp" />
<div style="position: relative; top: 90px; padding: 20px">
    <h1> ERRORE </h1>
    <h2>Si è riscontrato un problema, non abbiamo potuto soddisfare la tua richiesta.</h2>
    <button class="btn btn-warning" onclick="window.location.href='index.jsp'"> Torna alla Home</button>
</div>


<jsp:include page="WEB-INF/componenti/Footer.jsp" />
</body>
</html>