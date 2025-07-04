let clothesID = null;
let dataPart = null;
let dataPartName = null;
let change = {}

$(document).ready(function() {
    document.onkeydown = function(data) {
        if (data.keyCode == 27) {
            $('footer').html('');
            $(".clothes-shop").fadeOut();
            $('#total').html('0'); 
            change = {};
            $.post('https://zSkinShops/resetOutfit', JSON.stringify({}))
        }
    }

    document.onkeyup = function(data) {
        if (data.which == 174) {
            $.post('https://zSkinShops/changeColor', JSON.stringify({ clothingType: dataPartName, clothingTypeId: dataPart, articleNumber: clothesID, type: "texture", action: "previous" }));
        }
    }

    document.onkeyup = function(data) {
        if (data.which == 175) {
            $.post('https://zSkinShops/changeColor', JSON.stringify({ clothingType: dataPartName, clothingTypeId: dataPart, articleNumber: clothesID, type: "texture", action: "next" }));
        }
    }

    $("#leftHeading").click(function() {
        $.post('https://zSkinShops/leftHeading', JSON.stringify({ value: 10 }));
    })

    $("#handsUp").click(function() {
        $.post('https://zSkinShops/handsUp', JSON.stringify({}));
    })

    $("#rightHeading").click(function() {
        $.post('https://zSkinShops/rightHeading', JSON.stringify({ value: 10 }));
    })

    $("#payament").click(function() {
        $(".clothes-shop").fadeOut()
        $.post('https://zSkinShops/payament', JSON.stringify({ price: $('#total').text() }));
        $.post('https://zSkinShops/closeInterface', JSON.stringify({}));
        $('#total').html('0');
        change = {};
    })

    window.addEventListener('message', function(event) {
        let item = event.data;

        if (item.action == 'setPrice') {
            if (item.typeaction == "add") {
                $('#total').html(item.price)
            }
            if (item.typeaction == "remove") {
                $('#total').html(item.price)
            }
        }

        if (item.openShop) {
            change = {};
            $(".clothes-shop").fadeIn()
            dataPart = item.category
            dataPartName = item.categoryName
            for (var i = 0; i <= item.drawa; i++) {
                $("footer").append(`
                    <div class="item-clothe" data-id="${i}" onclick="select(this)">
                        <div class="img-clothe" style="background-image: url('${item.imageService}/${item.category}/${item.gender}/${item.prefix}(${i}).jpg')">  
                            <div class="overlay">
                                <span>${i}</span>
                            </div>
                        </div>
                    </div>
                `);
            };
        }
        if (item.changeCategory) {
            dataPart = item.category
            dataPartName = item.categoryName
            $('footer').html('')
            for (var i = 0; i <= item.drawa; i++) {
                $("footer").append(`
                    <div class="item-clothe" data-id="${i}" onclick="select(this)">
                        <div class="img-clothe" style="background-image: url('${item.imageService}/${item.category}/${item.gender}/${item.prefix}(${i}).jpg')">  
                            <div class="overlay">
                                <span>${i}</span>
                            </div>
                        </div>
                    </div>
                `);
            };
        }
    })
});

function update_valor() {
    const formatter = new Intl.NumberFormat('pt-BR', { minimumFractionDigits: 2 })
    let total = 0
    for (let key in change) { if (!change[key] == 0) { total += 40 } }
    $('#total').html(formatter.format(total))
}


function selectPart(element) {
    let dataPart = element.dataset.idpart
    let titlePart =  element.dataset.titlepart
    $('header h1').html(titlePart)
    $('.submenu-item').find('img').css('filter', 'brightness(1000%)')
    $('.submenu-item').removeClass('subActive')
    $(element).addClass('subActive')
    $(element).find('img').css('filter', 'brightness(100%)')
    $.post('https://zSkinShops/changeCategory', JSON.stringify({ part: dataPart }))
}

function select(element) {
    clothesID = element.dataset.id;
    $("footer div").css("border", "0");
    $('footer div').find('.overlay').css("background-color", "rgba(0, 0, 0, 0.507)");
    $(element).css("border", "1px solid #d14bd3");
    $(element).find('.overlay').css("background-color", "#d14bd3");
    $.post('https://zSkinShops/updateSkin', JSON.stringify({ 
        clothingType: dataPartName,
        clothingTypeId: dataPart,
        articleNumber: clothesID,
        type: "item",
        action: "none"
    }));
}

$(".fa-angle-right").click(function() {
    $.post('https://zSkinShops/changeColor', JSON.stringify({ clothingType: dataPartName, clothingTypeId: dataPart, articleNumber: clothesID, type: "texture", action: "next" }));
})

$(".fa-angle-left").click(function() {
    $.post('https://zSkinShops/changeColor', JSON.stringify({ clothingType: dataPartName, clothingTypeId: dataPart, articleNumber: clothesID, type: "texture", action: "previous" }));
})