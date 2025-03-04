// script.js
document.addEventListener("DOMContentLoaded", function () {
    const loginForm = document.querySelector(".login-container form");
    const registerForm = document.querySelector(".form-container form");

    if (loginForm) {
        loginForm.addEventListener("submit", function (event) {
            const nombre = document.getElementById("nombre").value.trim();
            const correo = document.getElementById("correo").value.trim();

            if (nombre === "" || correo === "") {
                alert("Por favor, complete todos los campos.");
                event.preventDefault();
            }
        });
    }

    if (registerForm) {
        registerForm.addEventListener("submit", function (event) {
            const nombre = document.getElementById("nombre").value.trim();
            const correo = document.getElementById("correo").value.trim();
            const telefono = document.getElementById("telefono").value.trim();
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            const phoneRegex = /^[0-9]{10}$/;

            if (nombre === "" || correo === "" || telefono === "") {
                alert("Todos los campos son obligatorios.");
                event.preventDefault();
            } else if (!emailRegex.test(correo)) {
                alert("Ingrese un correo válido.");
                event.preventDefault();
            } else if (!phoneRegex.test(telefono)) {
                alert("Ingrese un número de teléfono válido (10 dígitos).");
                event.preventDefault();
            }
        });
    }
});
