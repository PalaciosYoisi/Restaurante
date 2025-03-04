// script.js
document.addEventListener("DOMContentLoaded", function () {
    const form = document.querySelector("form");
    const select = document.getElementById("vista");
    const resultado = document.getElementById("resultado");

    form.addEventListener("submit", function (event) {
        if (select.value === "") {
            event.preventDefault();
            alert("Por favor, seleccione una vista antes de continuar.");
        }
    });

    // Animación suave cuando se muestra la tabla
    if (resultado.innerHTML.trim() !== "") {
        resultado.style.opacity = 0;
        setTimeout(() => {
            resultado.style.opacity = 1;
            resultado.style.transition = "opacity 0.5s";
        }, 100);
    }
});
