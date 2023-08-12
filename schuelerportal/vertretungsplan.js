function reload() {
    var cookie = document.getElementById("cookie").value;
    console.log(cookie)
    if (cookie != "") {
        document.cookie = "schuelerportal_session=" + cookie + "; SameSite=None; Secure; path=/"
        //document.cookie = "schuelerportal_school=clagybam; path=/; SameSite=None; Secure;";
    }
    
    loadPlan();
}

function start() {
    reload();
}

function loadPlan() {
    /*
    fetch("https://api.schueler.schule-infoportal.de/clagybam/api/vertretungsplan", {
        credentials: 'include',
        mode: 'cors',
        headers: {
            //"Content-Type": "application/json",
            'test' : document.cookie,
            //'Access-Control-Allow-Origin'  : "localhost:5500",
            //'Access-Control-Allow-Credentials' : 'true',
            //'Accept' : 'application/json',
        },
    })
    */
    fetch("https://api.schueler.schule-infoportal.de/clagybam/api/vertretungsplan", {
        headers: {
            //"Content-Type": "application/json",
            'Cookie' : document.cookie,
            //'Access-Control-Allow-Origin'  : "localhost:5500",
            //'Access-Control-Allow-Credentials' : 'true',
            //'Accept' : 'application/json',
        },
    })
    .then((response) => console.log(response));
    /*
    .then((response) => response.json())
    .then((json) => console.log(json));
    */
  
}