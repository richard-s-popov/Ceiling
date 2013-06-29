function savedbFunc(){
    // создание переменных данных пользователя и запись их в базу
    name_user = document.getElementById("name_user").value;
    window.localStorage.setItem("key_name_user", name_user);
    phone_user = document.getElementById("phone_user").value;
    window.localStorage.setItem("key_phone_user", phone_user);
    email_user = document.getElementById("email_user").value;
    window.localStorage.setItem("key_email_user", email_user);
    document.getElementById("name_user").value = name_user;
    
    // создание переменных данных менеджера и запись их в базу
    name_manager = document.getElementById("name_manager").value;
    window.localStorage.setItem("key_name_manager", name_manager);
    phone_manager = document.getElementById("phone_manager").value;
    window.localStorage.setItem("key_phone_manager", phone_manager);
    email_manager = document.getElementById("email_manager").value;
    window.localStorage.setItem("key_email_manager", email_manager);
    
    // создание переменных данных цеха и запись их в базу
    phone_workshop = document.getElementById("phone_workshop").value;
    window.localStorage.setItem("key_phone_workshop", phone_workshop);
    email_workshop = document.getElementById("email_workshop").value;
    window.localStorage.setItem("key_email_workshop", email_workshop);
    
    alert("Данные успешно сохранены");
}

function onDeviceReady() {
    //извлекаем данные настроек из памяти
    name_user = window.localStorage.getItem("key_name_user");
    phone_user = window.localStorage.getItem("key_phone_user");
    email_user = window.localStorage.getItem("key_email_user");
    name_manager = window.localStorage.getItem("key_name_manager");
    phone_manager = window.localStorage.getItem("key_phone_manager");
    email_manager = window.localStorage.getItem("key_email_manager");
    phone_workshop = window.localStorage.getItem("key_phone_workshop");
    email_workshop = window.localStorage.getItem("key_email_workshop");
    
    
//    alert("onDeviceReady work it on!");
}
function populateForm() {
    document.getElementById("name_user").value = name_user;
    document.getElementById("phone_user").value = phone_user;
    document.getElementById("email_user").value = email_user;
    document.getElementById("name_manager").value = name_manager;
    document.getElementById("phone_manager").value = phone_manager;
    document.getElementById("email_manager").value = email_manager;
    document.getElementById("phone_workshop").value = phone_workshop;
    document.getElementById("email_workshop").value = email_workshop;
    
//    alert("populateForm work it on!");
}

function alertFunc() {
    onDeviceReady()
};
//document.getElementById("message").onclick = alertFunc;
document.getElementById("save_btn").onclick = savedbFunc;

