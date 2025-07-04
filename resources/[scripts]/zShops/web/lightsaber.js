let shop = ''

$(document).ready(function () {
    let actionShop = $('#actionmenu')
    window.addEventListener('message',function(event){
        let item = event.data
        switch(item.action){
            case 'showMenu':
				updateShop(item.shop)
				shop = item.shop
				actionShop.css('display', 'block')
            break

            case 'hideMenu':
				$(`#${item.shop}`).css('display', 'none')
				actionShop.css('display', 'none')
				shop = ''
			break

			case 'update':
				updateShop(item.shop)
			break
        }
    });

    document.onkeyup = data => {
		const key = data.key;
		if (key === 'Escape') {
			$.post('http://zShops/shopClose', JSON.stringify({shop: shop}))
			shop = ''
		}
	};
});

const updateDrag = () => {
	$('.populated').draggable({
		helper: 'clone',
		appendTo: 'body',
		containment: "parent"
	});

	$('.empty').droppable({
		hoverClass: 'hoverControl',
		drop: function (event, ui) {
			const origin = ui.draggable.parent()[0].id
			const tInv = $(this).parent()[0].id
			itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') }
			const target = $(this).data('slot')
			let amount = 0;
			let itemAmount = parseInt(ui.draggable.data('amount'))
			
			$('.populated, .empty, .use').off('draggable droppable')
			let clone1 = ui.draggable.clone()
			let slot2 = $(this).data('slot')
			
			updateDrag();

			if (origin === 'inventory-items' && tInv === 'inventory-items') {
				$.post('http://zShops/inventoryUpdateSlot', JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));

			} else if (origin === 'shop-items' && tInv === 'shop-items') {
				$.post('http://zShops/shopUpdateSlot', JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));

			} else if (origin === 'shop-items' && tInv === 'inventory-items') {			
				abrirModal('buy', itemData.key, itemData.slot)

			} else if (origin === 'inventory-items' && tInv === 'shop-items') {
				abrirModal('sell', itemData.key, itemData.slot)
			}
		}
	});
	
}

const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;
	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}
	return r.split('').reverse().join('');
}

const updateShop = (shop) => {
    $.post('http://zShops/requestDataShop', JSON.stringify({shop: shop}), (data) => {
        $('.info-weight').html(`
			<div class='info-weight-weight'>Inventário: </div>
			<div class='info-weight-data'><f>${(data.weight).toFixed(2)}</f>/${(data.maxweight).toFixed(2)}Kg⠀<f>-</f>⠀<f>${data.slots}</f>/${data.maxslots} slots em uso⠀⠀</div>
		`);
		$('.info-right-text').html(`
			<div class='info-right-title'>${(data.shopname)}</div>
			<div class='info-right-description'>Adquira os itens enquanto durar os estoques! Bebidas alcoólicas proibida para menores!</div>
		`);
        $('#inventory-items').html('')
        for (let x = 1; x <= data.maxslots; x++) {
			const slot = x.toString()
			if (data.inventory[slot] !== undefined) {
				const v = data.inventory[slot]
				const item = `
					<div class='item populated' data-amount='${v.amount}' data-weight='${v.weight}' data-item-key='${v.key}' data-name-key='${v.name}' data-slot='${slot}'>
						<div id='item-name'>${v.name}</div>
						<div id='item-amount'>${v.amount}x</div>
						<div id='item-weight'>${(v.weight * v.amount).toFixed(2)}Kg</div>
						<div id='item-icon'><img href='#' src='${data.imageService}/${v.index}.png'></div>
					</div>
				`;
				$('#inventory-items').append(item)
			} else {
				const item = `
					<div class='item empty' data-slot='${slot}'></div>
				`
				$('#inventory-items').append(item);
			}
		}
        $('#shop-items').html('')
        const nameList = data.shop.sort((a, b) => (a.slot > b.slot) ? 1 : -1);
        for (let x = 1; x <= data.shopslots; x++) {
            const slot = x.toString()
			if (nameList[x - 1] !== undefined) {
				const v = nameList[x - 1]
				const item = `
					<div class='item populated' data-item-key='${v.key}' data-name-key='${v.name}' data-stock='${v.stock}' data-price='${v.price}' data-slot='${slot}'>
						<div id='item-name'>${v.name}</div>
						<div id='item-amount'>${v.stock}x</div>
						<div id='item-weight'>$${v.price}</div>
						<div id='item-icon'><img href='#' src='${data.imageService}/${v.index}.png'></div>
					</div>
				`;
				$('#shop-items').append(item)
			} else {
				const item = `<div class='item empty' data-slot='${slot}'></div>`
				$('#shop-items').append(item)
			}
        }

		updateDrag()
    })
}

let typeOfValue = null
let valueOne = null
let valueTwo = null

function abrirModal(type, one, two) {
	document.getElementById('popup-1').classList.toggle('active');
	typeOfValue = type
	valueOne = one
	valueTwo = two
}
  
function fecharModal() {
	document.getElementById('popup-1').classList.toggle('active')
	typeOfValue = null
	valueOne = null
	valueTwo = null
	updateShop(shop)
}

function simAceita() {
	document.getElementById('popup-1').classList.toggle('active');
	if ($('.amount').val() == '' | parseInt($('.amount').val()) == 0 | parseInt($('.amount').val()) < 0) return updateAll();
	if (typeOfValue == 'buy') {
		$.post('http://zShops/buyItem', JSON.stringify({
			item: valueOne,
			slot: valueTwo,
			amount: parseInt(Number($(".amount").val())),
			shop: shop
		}));
	} else if (typeOfValue == 'sell') {
		$.post('http://zShops/sellItem', JSON.stringify({
			item: valueOne,
			slot: valueTwo,
			amount: parseInt(Number($(".amount").val())),
			shop: shop
		}));
	}
	typeOfValue = null
	valueOne = null
	valueTwo = null
	updateShop(shop)
}