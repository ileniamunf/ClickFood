<%@ page import="it.unipa.dinfo.lm32.munfuletto.munfulettoilenia_wsda.model.Utente" %>
<%if(session.getAttribute("codeOp")==null){
  session.setAttribute("codeOp",0);
}%>
<script type="text/javascript">
  $(document).ready(function(){
    let today1 = new Date();
    let today2 = new Date();
    let min = new Date(today1.setFullYear(today1.getFullYear() - 120));
    let max = new Date(today2.setFullYear(today2.getFullYear() - 18));

    $("#subscriptionDataNascita").attr("min", min.toISOString().slice(0, 10));
    $("#subscriptionDataNascita").attr("max", max.toISOString().slice(0, 10));

    $("input").focus(function(){
      $("#erroreCredenziali").text("");
    });



    $("#subscribe").click(() => {
      if($("#subscribeFormContainer").hasClass("hidden")){
        $("#subscribeFormContainer").removeClass("hidden");
        $("#subscribeFormContainer").addClass("show");
        if ($("#loginFormContainer").hasClass("show")) {
          $("#loginFormContainer").removeClass("show");
          $("#loginFormContainer").addClass("hidden");
        }
      } else if ($("#subscribeFormContainer").hasClass("show")) {
        $("#subscribeFormContainer").removeClass("show");
        $("#subscribeFormContainer").addClass("hidden");
      }
    });

    $("#login").click(() => {
      if($("#loginFormContainer").hasClass("hidden")){
        $("#loginFormContainer").removeClass("hidden");
        $("#loginFormContainer").addClass("show");
        if ($("#subscribeFormContainer").hasClass("show")) {
          $("#subscribeFormContainer").removeClass("show");
          $("#subscribeFormContainer").addClass("hidden");
        }
      } else if ($("#loginFormContainer").hasClass("show")) {
        $("#loginFormContainer").removeClass("show");
        $("#loginFormContainer").addClass("hidden");
      }
    });


    $("#logout").click(() => {
      $.post("LogoutServlet", {}, function(data, status){
        if(status == "success"){
          window.location.href="index.jsp";
        }
      });
    });

    $(window).click((ev) => {
      if (!$(ev.target).is("#subscribe") &&
              !$(ev.target).is("#subscribeForm") &&
              !$(ev.target).is($("#subscribeForm").children(".form-floating").children()) &&
              !$(ev.target).is($("#subscribeForm").children("div.text-end").children())
      ){
        if ($("#subscribeFormContainer").hasClass("show")) {
          if (!$(ev.target).is("#subscribeFormContainer")){
            $("#subscribeFormContainer").removeClass("show");
            $("#subscribeFormContainer").addClass("hidden");
          }
        }
      }
      if (!$(ev.target).is("#login") &&
              !$(ev.target).is("#loginForm") &&
              !$(ev.target).is($("#loginForm").children(".form-floating").children()) &&
              !$(ev.target).is($("#loginForm").children("div.text-end").children())
      ){
        if ($("#loginFormContainer").hasClass("show")) {
          if (!$(ev.target).is("#subscribeForm")){
            $("#loginFormContainer").removeClass("show");
            $("#loginFormContainer").addClass("hidden");
          }
        }
      }
    });


    $("#subscribeForm").submit((ev) => {
      'use strict'

      ev.preventDefault();
      if(!$(ev.target)[0].checkValidity()){
        ev.stopPropagation();
      }
      $("#subscribeForm").addClass('was-validated');

      $.post("RegistrazioneServlet", {
        newNome: $("#subscribeForm").find("#nome").val(),
        newCognome: $("#subscribeForm").find("#cognome").val(),
        newEmail: $("#subscribeForm").find("#subscriptionEmail").val(),
        newPassword: $("#subscribeForm").find("#subscriptionPassword").val(),
        newDataNascita: $("#subscribeForm").find("#subscriptionDataNascita").val()
      }, function(data, status){
        if(status == "success"){
          window.location.reload();
        }
      });

    });

    let esitoModal = new bootstrap.Modal($("#esitoModal"));
    if(esitoModal != undefined){
      esitoModal.show();
    }


  });
</script>

<header class="d-flex flex-wrap align-items-center justify-content-center justify-content-md-between py-3 mb-0 border-bottom bg-dark px-2 position-fixed top-0 w-100">
  <div class="col-md-3 mb-2 mb-md-0 text-center">
    <a href="index.jsp#mainlink" class="d-inline-flex link-body-emphasis text-decoration-none">
      <img src="resources/icons/burger.png" height="54" width="60" alt="Logo">
      <span class="text-warning"><span id="logoName">Click Food</span>&trade;</span>
    </a>
  </div>

  <ul class="nav nav-masthead col-12 col-md-auto mb-2 justify-content-center mb-md-0">
    <li><a href="index.jsp#mainlink" class="nav-link text-warning px-2">Home</a></li>
    <li><a href="OrdinaServlet" class="nav-link text-warning px-2">Ordina</a></li>
    <li><a href="index.jsp#menulink" class="nav-link text-warning px-2">Men&ugrave;</a></li>
    <%if(request.getSession().getAttribute("Utente")!= null){
    Utente utente = (Utente) request.getSession().getAttribute("Utente");%>
    <% if(utente.getTipo().equals("Cuoco")){ %>
      <li><a href="CuocoServlet" class="nav-link text-warning px-2">Area Riservata</a></li>
    <% } else if(utente.getTipo().equals("Cliente")) {%>
       <li><a href="ClienteServlet" class="nav-link text-warning px-2">Area Riservata</a></li>
    <% } else if(utente.getTipo().equals("Addetto")) {%>
      <li><a href="AddettoServlet" class="nav-link text-warning px-2">Area Riservata</a></li>
    <% } else if(utente.getTipo().equals("Fattorino")) {%>
      <li><a href="FattorinoServlet" class="nav-link text-warning px-2">Area Riservata</a></li>
    <% } else if(utente.getTipo().equals("Responsabile")) {%>
      <li><a href="ResposabileServlet" class="nav-link text-warning px-2">Area Riservata</a></li>
    <% }%>
      <%}%>
  </ul>

  <%if(request.getSession().getAttribute("Utente")!= null){%>
  <div class="col-md-3 text-end">
    <button type="button" id="logout" class="btn btn-outline-warning">Esci</button>
  </div>
  <%} else {%>
  <div class="col-md-3 text-end">
    <button type="button" id="login" class="btn btn-warning me-2">Accedi</button>
    <button type="button" id="subscribe" class="btn btn-outline-warning">Iscriviti</button>
  </div>
  <%}%>



  <div class="form-container bg-dark border border-opacity-25 border-danger-subtle rounded-2 hidden" id="subscribeFormContainer">

    <form id="subscribeForm" class="form p-4 needs-validation" method="post" novalidate>
      <div class="text-center text-light">
        <h5>Iscriviti</h5>
      </div>
      <div class="form-floating mb-3">
        <input type="text" name="nome" id="nome" class="form-control" placeholder="Nome" required="required" pattern="^(([A-Z][a-z]|[a-z])+(\s?))+$">
        <label for="nome" class="form-label">Nome</label>
      </div>
      <div class="form-floating mb-3">
        <input type="text" name="cognome" id="cognome" class="form-control" placeholder="Cognome" required="required" pattern="^(([A-Z][a-z]|[a-z])+(\s?))+$">
        <label for="cognome" class="form-label">Cognome</label>
      </div>
      <div class="form-floating mb-3">
        <input type="email" name="subscriptionEmail" id="subscriptionEmail" class="form-control" placeholder="E-mail" required="required" pattern="^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$" maxlength="64">
        <label for="subscriptionEmail" class="form-label">E-mail</label>
      </div>
      <div class="form-floating mb-3">
        <input type="password" name="subscriptionPassword" id="subscriptionPassword" class="form-control" data-toggle="password" placeholder="Password" required="required" pattern="^(.|\s)*\S(.|\s)*$" maxlength="20">
        <label for="subscriptionPassword" class="form-label">Password</label>
      </div>
      <div class="form-floating mb-3">
        <input type="date" name="subscriptionDate" id="subscriptionDataNascita" class="form-control" placeholder="YYYY-MM-DD" maxlength="10" required="required">
        <label for="subscriptionDataNascita" class="form-label">Data di Nascita</label>
      </div>
      <div class="text-end">
        <button type="submit" class="btn btn-warning">Iscriviti</button>
      </div>
    </form>
  </div>

<% if(request.getSession().getAttribute("stato") != null){ %>
  <div class="form-container border bg-dark border-opacity-25 border-danger-subtle rounded-2 show" id="loginFormContainer">
<%} else { %>
  <div class="form-container border bg-dark border-opacity-25 border-danger-subtle rounded-2 hidden" id="loginFormContainer">
<%}%>
    <form id="loginForm" class="form p-4 " action="LoginServlet" method="post">
      <div class="text-center text-light">
        <h5>Accedi</h5>
      </div>
      <div class="form-floating mb-3">
        <input type="email" name="loginEmail" id="loginEmail" class="form-control" placeholder="E-mail" required="required" pattern="^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$" maxlength="64">
        <label for="loginEmail" class="form-label">E-mail</label>
      </div>
      <div class="form-floating mb-3">
        <input type="password" name="loginPassword" id="loginPassword" class="form-control" data-toggle="password" pd-role="passsword" placeholder="Password" required="required" pattern="^(.|\s)*\S(.|\s)*$" maxlength="20">
        <label for="loginPassword" class="form-label">Password</label>
      </div>


      <% if(request.getSession().getAttribute("stato") != null){%>
        <p id="erroreCredenziali" style="color: red; font-size: 20px;"> <%= request.getSession().getAttribute("stato") %> </p>
      <% request.getSession().removeAttribute("stato");}%>


      <div class="text-end">
        <button class="btn btn-warning" type="submit">Accedi</button>
        <br/>
        <a href="recuperoPassword.jsp" style="color: yellow; font-size: smaller; text-decoration: underline">Hai dimenticato la password?</a>
      </div>


    </form>
  </div>
</header>


