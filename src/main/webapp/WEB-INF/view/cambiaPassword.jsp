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

            $("input").focus(function(){
                $("#resultPass").text("");
            });


            $("body").on("submit", "#cambiaPasswordForm", function(ev){
                ev.preventDefault();

                let pass1 = $("#pass1").val();
                let pass2 = $("#pass2").val();

                if(pass1 != pass2){
                    $("#resultPass").html("Le due password non coincidono.");
                    $("#resultPass").css("color","red");
                }

                if ($("#cambiaPasswordForm")[0].checkValidity() && (pass1 == pass2)) {
                    $.post("${pageContext.request.contextPath}/RecuperoPasswordServlet", {
                        emailTitolare: "<%=request.getParameter("email")%>",
                        pass: $("#pass1").val()
                    }, function(data, status){
                        if(status == "success"){
                            window.location.reload();
                        }
                    });
                } else {
                    ev.preventDefault();
                    ev.stopPropagation();
                }

            });

            let esitoModal = new bootstrap.Modal($("#esitoModal"));
            if(esitoModal != undefined){
                esitoModal.show();
            }

        });


    </script>

</head>

<body style="background-color: rgba(var(--bs-dark-rgb), 0.93);">
<jsp:include page="../componenti/Navbar.jsp" />

<div class="d-flex align-items-center h-100">
    <div class="container-md w-75 mx-auto align-middle px-3 py-2">
        <form id="cambiaPasswordForm" method="post">
            <div class="row mb-3">
                <h1 class="text-warning text-center" style="font-family: 'Pacifico', serif;">Cambia Password</h1>
            </div>
            <div class="row mb-3">
                <h2 class="text-warning text-center fs-1">
                    Inserisci la tua nuova password.
                </h2>
            </div>
            <div class="row mb-3">
                <div class="form-floating px-2">
                    <input type="password" class="form-control form-control-lg" style="font-size: 2em;" id="pass1" placeholder="" required name="pass1" pattern="^(.|\s)*\S(.|\s)*$" maxlength="20" data-toggle="password">
                    <label for="pass1" class="form-label" style="font-size: 1.5em;">Password</label>
                </div>
            </div>
            <div class="row mb-3">
                <div class="form-floating px-2">
                    <input type="password" class="form-control form-control-lg" style="font-size: 2em;" id="pass2" placeholder="" required name="pass2" pattern="^(.|\s)*\S(.|\s)*$" maxlength="20" data-toggle="password">
                    <label for="pass2" class="form-label" style="font-size: 1.5em;">Riscrivi Password</label>
                </div>
            </div>
            <p id="resultPass"></p>
            <div class="row mb-3">
                <button type="submit" class="btn btn-warning btn-lg w-50 mx-auto" style="font-size: 2em;">Salva</button>
            </div>
        </form>
    </div>
</div>


<jsp:include page="../componenti/Footer.jsp" />
<%  if(Integer.parseInt(session.getAttribute("codeOp").toString()) != 0) {%>

<jsp:include page="../componenti/Modal.jsp" />

<%
        session.removeAttribute("codeOp");
    }
%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>