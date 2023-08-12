function reload() {
    var cookie = document.getElementById("cookie").value;
    if (cookie != "") {
        document.cookie = "schuelerportal_session=" + cookie;
    }
    else {
        cookie = document.cookie.split("=")[1];
    }

    loadPlan(cookie);
}

function start() {
    reload();
}

function loadPlan(cookie) {
    fetch("https://api.schueler.schule-infoportal.de/clagybam/api/vertretungsplan", {
        method: 'GET',
        credentials: 'include'
      })
    .then((response) => response.json())
    .then((json) => console.log(json));
  
}