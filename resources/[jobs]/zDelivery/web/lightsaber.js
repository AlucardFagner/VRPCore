$(document).ready(function() {
    // Partial Functions
    function closeMain() {
        $("#ui").css("display", "none");
    }

    function openMain() {
        $("#ui").css("display", "block");
    }

    function closeAll() {
        $(".body").css("display", "none");
    }

    function openContainer() {
        $(".taxi-container").css("display", "block");
    }

    function closeContainer() {
        $(".taxi-container").css("display", "none");
    }
    // Listen for NUI Events
    window.addEventListener('message', function(event) {
        var item = event.data;
        // Update HUD Balance
        if (item.updateBalance == true) {
            $('#entregas').html(event.data.entregas);
            $('#money').html('<br>$ ' + (event.data.dinheiro));
            if (event.data.rotatxt == "Restaurante") {
                $('#rota').html(event.data.rotatxt);
                $('#rota').css("color", "#ff3a1d");

            }
            if (event.data.rotatxt == "Entrega") {
                $('#rota').html(event.data.rotatxt);
                $('#rota').css("color", "#ffe600");
            }

        }
        // Open & Close main window
        if (item.openMeter == true) {
            openMain();

        }
        if (item.openMeter == false) {
            closeMain();

        }
        // Open sub-windows / partials
    });
    // On 'Esc' call close method
    document.onkeyup = function(data) {
        if (data.which == 27) {
            $.post('http://zDelivery/close', JSON.stringify({}));
        }
    };
});