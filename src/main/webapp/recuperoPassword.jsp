<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%if(session.getAttribute("codeOp")==null){
    session.setAttribute("codeOp",0);
}%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ClickFood&trade; - Recupero Password</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" crossorigin="anonymous">
    <link href="styles.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="icon" type="image/x-icon" href="resources/icons/icon.png">

    <script type="text/javascript">
        $(document).ready(() => {
            let esitoModal = new bootstrap.Modal($("#esitoModal"));
            if(esitoModal != undefined){
                esitoModal.show();
            }
        });
    </script>
</head>

<body style="background-color: rgba(var(--bs-dark-rgb), 0.93);">
<jsp:include page="WEB-INF/componenti/Navbar.jsp" />

<div class="d-flex align-items-center h-100">
    <div class="container-md w-75 mx-auto align-middle px-3 py-2">
        <form action="RecuperoPasswordServlet" method="get">
            <div class="row mb-3">
                <h1 class="text-warning text-center" style="font-family: 'Pacifico', serif;">Recupera Password</h1>
            </div>
            <div class="row mb-3">
                <h2 class="text-warning text-center fs-1">
                    Inserisci il tuo indirizzo mail e ti invieremo un link per il recupero della password
                </h2>
            </div>
            <div class="row mb-3">
                <div class="form-floating px-2">
                    <input type="email" class="form-control form-control-lg" style="font-size: 2em;" id="email" placeholder="" required name="email" pattern="^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$">
                    <label for="email" class="form-label" style="font-size: 1.5em;">Indirizzo Mail</label>
                </div>
            </div>
            <div class="row mb-3">
                <button type="submit" class="btn btn-warning btn-lg w-50 mx-auto" style="font-size: 2em;">Invia Link</button>
            </div>

        </form>
    </div>
</div>


<jsp:include page="WEB-INF/componenti/Footer.jsp" />

<%  if(Integer.parseInt(session.getAttribute("codeOp").toString()) != 0) {%>

<jsp:include page="WEB-INF/componenti/Modal.jsp" />

<%
        session.removeAttribute("codeOp");
    }
%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>