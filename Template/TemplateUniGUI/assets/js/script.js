document.getElementById("signInButton").addEventListener("click", function(event) {
    ajaxRequest(MainForm.form, "signin",["email=arthur.steinbach@tmrti.com.br","senha=123"]);
});