var categoryVehicleSelected = "all";
var vehicleSelected = {};

var dataVehicles = []

var selectedColor = "primary";

window.addEventListener('message', function(event) {
    var data = event.data;

    if (event.data.type == "display") {
        $("body").fadeIn();

        document.getElementById("top-menu").innerHTML = '<a href="#all" onclick="menuVehicle(event)" value="all" class="selected">todos</a>';       

        for(var [key,value] of Object.entries(data.data)){   

            $('.top-menu').append(`
                <a href="#` + key + `" onclick="menuVehicle(event)" value="` + key + `">` + key + `</a>            
            `)

            for(var [k,v] of Object.entries(value)){
                dataVehicles.push(v);          
            }             
        }
        Dealership.Open(dataVehicles);

        //document.getElementById("playerName").innerHTML = data.playerName;        
        document.getElementById("playerMoney").innerHTML = data.playerMoney;
    }

    if (event.data.type == "hide") {
        $("body").fadeOut();
    }
    
    if (event.data.type == "menu") {

        for(var [k,v] of Object.entries(data.data)){
            dataVehicles.push(v);          
        }    
        Dealership.Open(dataVehicles);
    }

        
    if (event.data.type == "sussess-buy") {
        var data = event.data

        $("#messagePopup").css("background-color","rgba(0,0,0,0.4)");   

        $("#messagePopup").fadeIn(500);      
        
        $('#messagePopup').append(`

        <span>Você comprou: ` + data.vehicleName + ` - por ` + data.value + `</span>    
        
        `)
        
        setTimeout(function(){ $("#messagePopup").fadeOut(500);         document.getElementById("messagePopup").innerHTML = ''; }, 3000);

    }

    if (event.data.type == "notify") {       
        var data = event.data;

        $("#messagePopup").css("background-color","rgb(252, 18, 89)");      

        $("#messagePopup").fadeIn(500);      
        
        $('#messagePopup').append(`

        <span>`+ data.message +`</span>    
        
        `)
        
        setTimeout(function(){ $("#messagePopup").fadeOut(500);         document.getElementById("messagePopup").innerHTML = ''; }, 3000);

    }
});

$(document).ready(function() {
    $('.upper-bottom-container').on('afterChange', function(event, slick, currentSlide) {
        
        $('.button-container').appendTo(currentSlide);
    });
});

function menuVehicle(event) {
    var div = $(event.target).parent().find('.selected');
        
    $(div).removeClass('selected');

    $(event.currentTarget).addClass('selected');

    categoryVehicleSelected = $(event.currentTarget).attr('value');

    document.getElementById("nameBrand").innerHTML = '';
    document.getElementById("contentVehicle").innerHTML = '';              
    document.getElementById("vehiclebrand").innerHTML = '';
    document.getElementById("carouselCars").innerHTML = '';

    dataVehicles = [] 
    
    $.post('http://zDealership/menuSelected', JSON.stringify({menuId: categoryVehicleSelected.toLowerCase()}));
}
    // <p>Marca: <span class="brand">`+vehicleSelected.brand+`</span></p>  // linha 117 - marca desconhecida
function openModalMenu(){    
    document.getElementById("closemenu").innerHTML = '';

    $('.modal').css("display","flex");

    $('#closemenu').append(`
        <div class="background-circle"></div>
        <div class="modal-content">
            <p class="title">Confirmação de pagamento:</p>
            <p class="vehicle">O veículo</p>         

            
            <p>Modelo: <span class="model">`+vehicleSelected.modelcar+`</span></p>
        </div>

        <div class="modal-footer">
            <div class="modal-price">
                <p class='price sale'>R$ `+ vehicleSelected.sale+` 000</p>
                <p class='price discount'>R$ `+ parseFloat(vehicleSelected.sale * 1.1).toFixed(3)+`</p>                  
            </div>
            <div class="modal-buttons">     
                <div>
                    <span>Comprar</span>
                    <button id="money" class="modal-money button" onclick="buyVehicle('confirm')" >💰</button>
                </div>
                <div>
                    <span>Cancelar</span>
                    <button href="#!" id="card" class="modal-money button" onclick="buyVehicle('cancel')">❌</button>
                </div>
            </div>
        </div>
    `);
}


function buyVehicle(option) {
    $('.modal').css("display","none");


    switch(option){
        case 'cancel':
            break;
        case 'confirm':
            $.post('http://zDealership/Buy', JSON.stringify(vehicleSelected));
            break;
    }   
}

var scrollAmount = 0

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESC
            $.post('http://zDealership/Close');
            $('body').css("display","none");
            document.getElementById("top-menu").innerHTML = '';       
            break;
        case 9: // TAB
            break;
        case 17: // TAB
            break;
        case 68: // LEFT A
            $.post('http://zDealership/rotate', JSON.stringify({key: "left"}))
            break;            
        case 65: // RIGHT D
            $.post('http://zDealership/rotate', JSON.stringify({key: "right"}))
            break;
        case 39: 
            scrollAmount = scrollAmount + 300
            $('.carousel-cars').animate({scrollLeft:scrollAmount}, 'fast');
            // seta direita
            break;
        case 37:
            scrollAmount = scrollAmount - 300
            $('.carousel-cars').animate({scrollLeft:scrollAmount}, 'fast');
            // seta esquerda
            break;
    }
});


$(document).on('keydown', function(ev) {
    var input = $(ev.target);
    var num = input.hasClass('input-number');
    var _key = false;
    if (ev.which == 68) {
        if (num === false) {
            _key = "left"
        }
        else if (num) {
            input.val(parseInt(input.val()) + 1)
            inputChange(input,true)
        }
    }
    if (ev.which == 65) {
        if (num === false) {
            _key = "right"
        }
        else if (num) {
            input.val(parseInt(input.val()) - 1)
            inputChange(input,false)
        }
    }

    if (_key) {
        $.post('http://zDealership/rotate', JSON.stringify({key: _key}))
    }

});


//  document.addEventListener('scroll', function (event) {
//     if (event.target.id === 'carouselCars') { // or any other filtering condition        
//         console.log('scrolling', event.target);
//     }
// }, true /*Capture event*/);



// $("#carouselCars").on( 'scroll', function(){
//     console.log('Event Fired');
//  });
 



$(document).on('mousedown', ".item-cars", function(event){

    switch(event.which) {        
        case 3:          
            // click direito
       
            break;
        case 1:
            // click esquerdo

            var div = $(this).parent().find('.active');        
            $(div).removeClass('active');

            var classList = $(event.currentTarget).attr('class').split(/\s+/);
            var itemDisabled = false;

            $.each(classList, function(index, item) {
                if (item === 'disable') {        
                    itemDisabled = true;
                }
            });

            if(!itemDisabled) {
                $(event.currentTarget).addClass('active');         

                $('#colorPicker').css("display","flex");
                
                var dataCar = $(event.currentTarget).find('.specification').find('span');

                var scroll =  $(event.currentTarget).position();
        
                if(scroll.left > 500) {
                    scrollAmount = scrollAmount + scroll.left
                } else if( scroll.left < 0 ) {
                    scrollAmount = scrollAmount - scrollAmount/2 + scroll.left
                } else {
                    scrollAmount = scrollAmount - scroll.left
                }           
                $('.carousel-cars').animate({scrollLeft:scrollAmount}, 'fast');

                $('.modal').css("display","none");

                document.getElementById("nameBrand").innerHTML = '';                
                document.getElementById("vehiclebrand").innerHTML = '';
                document.getElementById("contentVehicle").innerHTML = '';
                // Sua Logo //
                // document.getElementById("vehiclebrand").innerHTML = ' <img id="vehicle_brand_image" src="URL AQUI">
                // <span id="vehicle_brand">`+dataCar[0].outerText+`</span>     linha 281
                $('#nameBrand').append(`
                    
                    <span id="vehicle_name">`+dataCar[1].outerText+`</span> 
                `);

                $(".menu-modifications").css("display","block");

                vehicleSelected = {brand: dataCar[0].outerText, modelcar: dataCar[8].outerText, sale: dataCar[6].outerText/1000, name: dataCar[1].outerText }

                //vehicleSelected = JSON.stringify({ brand: dataCar[0].outerText, modelcar: dataCar[8].outerText, price: dataCar[6].outerText })
            //     <div class="handling-difficulty">        linha 300
            //     <span>`+dataCar[3].outerText+`</span>    linha 301
            //  </div>                                      linha 302
                $('#contentVehicle').append(`
                    <div class="handling-container">
                        <span>Informações do Veículo</span>
                        <div class="handling-bar-container">
                        <div class="handling-line"></div>
                        <div class="handling-circle" style="left: 100%;"></div>
                    </div>

                    </div>

                    <div class="row spacebetween">
                        <span class="title">Velocidade</span>
                        <span>`+dataCar[4].outerText+` KMH</span>
                    </div>

                    <div class="row spacebetween">
                        <span class="title">Desempenho</span>
                        <span>`+dataCar[5].outerText+` HP</span>
                    </div>

                    <div class="row spacebetween">
                        <span class="title">Preço</span>
                        <span>R$`+ dataCar[6].outerText / 1000+` 000</span>
                    </div>

                    <div class="row" id="buttonbuy">
                        <button class="buyButton" onclick="openModalMenu()"> Comprar </button>
                    </div>
                `);
                
                if (dataCar[7].outerText < 1) {
                    document.getElementById("buttonbuy").innerHTML = '<span class="sold-out-text">Estoque Indisponível</span>';
                }

                $.post("http://zDealership/SpawnVehicle", JSON.stringify({ modelcar: dataCar[8].outerText, price: dataCar[6].outerText }));
            }
        break;
    }
});

(() => {
    Dealership = {};

    
        
    Dealership.Open = function(data) { 
        for(i = 0; i < (data.length); i++) {   

            var modelUper = data[i].model;                
            
            if (data[i].qtd < 1) {
                $(".carousel-cars").append('<div class="item-cars"> <div class="col-lg-3 col-md-6 "> <div class="specification" style="opacity:0.0; position:absolute;"><span id="brand">'+ data[i].brand +'</span><span id="name">'+ data[i].name +'</span><span id="fabrication">'+ data[i].fabrication +'</span><span id="handling">'+ data[i].handling +'</span><span id="topspeed">'+ data[i].topspeed +'</span><span id="power">'+ data[i].power +'</span><span id="price">'+ data[i].price +'</span><span id="qtd">'+ data[i].qtd +'</span><span id="model">'+ data[i].model +'</span><span id="category">'+ data[i].category +'</span></div> <div class="soldOut">Estoque Indisponível</div> <div class="img-fluid" style="background-image: url(../imgs/' + modelUper.toUpperCase() +'.png);"></div></div></div>');
            }                 
            else if (data[i].qtd > 0) {
                $(".carousel-cars").append('<div class="item-cars" > <div class="col-lg-3 col-md-6 "> <div class="specification" style="opacity:0.0; position:absolute;"><span id="brand">'+ data[i].brand +'</span><span id="name">'+ data[i].name +'</span><span id="fabrication">'+ data[i].fabrication +'</span><span id="handling">'+ data[i].handling +'</span><span id="topspeed">'+ data[i].topspeed +'</span><span id="power">'+ data[i].power +'</span><span id="price">'+ data[i].price +'</span><span id="qtd">'+ data[i].qtd +'</span><span id="model">'+ data[i].model +'</span><span id="category">'+ data[i].category +'</span></div><div class="img-fluid" style="background-image:  url(../imgs/' + modelUper.toUpperCase() +'.png);"></div></div></div>');
            }            
        }     
    }
    Dealership.Open(dataVehicles)
})();


function openOption(option){
    var dataValue = $("#"+option).attr("data-value");

    $("#primary").attr("data-value","opening");
    $("#primary").css("display","none");

    $("#secondary").attr("data-value","opening");
    $("#secondary").css("display","none");

    document.getElementById("primary").innerHTML = '';
    document.getElementById("secondary").innerHTML = '';

    selectedColor = option;

    if (!dataValue || dataValue == "opening") {
        $("#"+option).attr("data-value","open");
        $("#"+option).css("display","block");        
        $('#colorPicker').css("display","block");       

        $("#"+option).append(`
            <div id="colorPicker">
                <a class="color"><div class="colorInner"></div></a>        
                <div class="track"></div>               
            </div>
        `);

        var $box = $('#colorPicker');
        $box.tinycolorpicker();
    }
}

// function setVehicleColorRGB(R,G,B){
    
//     if (selectedColor == 'primary'){
//         $.post("http://zDealership/RGBVehicle", JSON.stringify({primary: true, R: R, G: G, B: B}));
//     } else {
//         $.post("http://zDealership/RGBVehicle", JSON.stringify({primary: false, R: R, G: G, B: B}));
//     }

// }
                        
