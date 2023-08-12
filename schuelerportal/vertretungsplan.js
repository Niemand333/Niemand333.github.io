function reload() {
    var cookie = document.getElementById("cookie").value;
    console.log(cookie)
    if (cookie != "") {
        document.cookie = "schuelerportal_session=" + cookie + "; SameSite=None;"
        //document.cookie = "schuelerportal_school=clagybam; path=/; SameSite=None; Secure;";
    }
    
    loadPlan();
}

function start() {
    reload();
}

function loadPlan() {
    fetch("https://api.schueler.schule-infoportal.de/clagybam/api/vertretungsplan", {
        mode: "cors",
        method: 'GET',
        headers: {
            //'Access-Control-Allow-Origin'  : "localhost:5500",
            //'Access-Control-Allow-Credentials' : 'true',
            'Content-Type' : 'application/json',
            'Cookie' : document.cookie
        },
        credentials: 'include'
    })
    .then((response) => console.log(response));
    /*
    .then((response) => response.json())
    .then((json) => console.log(json));
    */
  
}