<% if(session.getAttribute("text") != null){%>
<script>
  $("#esitoModal").ready(() => {
    let obj = JSON.parse('<%=session.getAttribute("text")%>');
    $("#textModal").html(obj.Corpo);
    $("#esitoModalLabel").html(obj.Titolo);

    <%if(Integer.parseInt(request.getSession().getAttribute("codeOp").toString()) == 2 || Integer.parseInt(request.getSession().getAttribute("codeOp").toString()) == 4 || Integer.parseInt(request.getSession().getAttribute("codeOp").toString()) == 5){%>
    $("#icon").html("X");
    $(".modal-confirm .icon-box").css("background","#ef513a");
    $(".modal-confirm .btn").css("background","#ef513a");
    $(".modal-confirm .btn:hover, .modal-confirm .btn:focus").css("background","#da2c12");
    <%}%>

    <%if(Integer.parseInt(request.getSession().getAttribute("codeOp").toString()) == 6 ){%>
    $.getScript("qrcode.min.js", () => {
      let qrcode = new QRCode(document.getElementById("qrCode"), {
        text: "<%=session.getAttribute("SHA256Ordine")%>",
        width: 200,
        height: 200,
        colorDark : "#000000",
        colorLight : "#ffffff",
        correctLevel : QRCode.CorrectLevel.H
    });
    });
    <%}%>

    $("#dimissBtn").click(()=>{
      $("div.modal-backdrop.fade.show").remove();
    });
  });
</script>

<%}%>

<div id="esitoModal" class="modal fade">
  <div class="modal-dialog modal-confirm">
    <div class="modal-content">
      <div class="modal-header">
        <div class="icon-box">
          <i id="icon" class="material-icons"> &#x2713; </i>
        </div>
        <h4 class="modal-title w-100" id="esitoModalLabel"></h4>
      </div>
      <div class="modal-body">
        <p class="text-center" id="textModal"></p>
        <div id="qrCode"></div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary w-100" data-bs-dismiss="modal" id="dimissBtn">OK</button>
      </div>
    </div>
  </div>
</div>

