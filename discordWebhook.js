function sendMessage(form) {

    if (form.username.value === "") {
        alert("Please enter a username.");
        return;
    }
    if (form.message.value === "") {
        alert("Please enter a message.");
        return;
    }
    if (form.message.value.length > 4000) {
        alert("Message is too long.");
        return;
    }

    const request = new XMLHttpRequest();
    request.open("POST", form.channels.value); //"https://discord.com/api/webhooks/1139984568674418758/187hMMAZXhgVcXuQpLvukih5TDRq2UidnnadT9obCqsz1tcgFkq4kmi36aGBXRzJ1Baf"

    request.setRequestHeader('Content-type', 'application/json');

    const params = {
        username: form.username.value,
        avatar_url: form.avatar.value,
        content: form.message.value
    }

    request.send(JSON.stringify(params));

    form.message.value = "";
}

function avatar_onclick() {
    avatarArray = document.getElementsByClassName("avatar");
    for (let i = 0; i < avatarArray.length; i++) {
        if (avatarArray[i].style.display === "block") {
            avatarArray[i].style.display = "none";
        }
        else {
            avatarArray[i].style.display = "block";
        }
    }
}

function avatar_popup_ok() {
    avatarArray = document.getElementsByClassName("avatar");
    for (let i = 0; i < avatarArray.length; i++) {
        avatarArray[i].style.display = "none";
    }
}

avatar = document.getElementById("avatar");
avatar.addEventListener("change", function() {
    if (avatar.value === "") {
        document.getElementById("avatar-preview").src = "https://cdn.discordapp.com/embed/avatars/0.png";
        return;
    }
    document.getElementById("avatar-preview").src = avatar.value;
});