let ok = false
let trunkchest = false

$(document).ready(function () {
	window.addEventListener('message', function (event) {
		switch (event.data.action) {
			case 'showInventory':
				updateBackpack();
				$('#actionmenu').css('display', 'block')
				$('#inventory').css('display', 'block')
				$('#chest').css('display', 'none')
				$('#trunkchest').css('display', 'none')
				$('#inspect').css('display', 'none')
			break;

			case 'showChest':
				updateChest();
				$('#actionmenu').css('display', 'block')
				$('#chest').css('display', 'block')
				$('#inventory').css('display', 'none')
				$('#trunkchest').css('display', 'none')
				$('#inspect').css('display', 'none')
			break;
			
			case 'showTrunkchest':
				updateTrunkchest();
				$('#actionmenu').css('display', 'block')
				$('#trunkchest').css('display', 'block')
				$('#inventory').css('display', 'none')
				$('#chest').css('display', 'none')
				$('#inspect').css('display', 'none')
				trunkchest = true
			break;

			case 'showInspect':
				updateInspect();
				$('#actionmenu').css('display', 'block')
				$('#inspect').css('display', 'block')
				$('#inventory').css('display', 'none')
				$('#trunkchest').css('display', 'none')
				$('#chest').css('display', 'none')
			break;

			case 'showChesthome':
				updateChesthome();
				$('#actionmenu').css('display', 'block')
				$('#chesthome').css('display', 'block')
				$('#inspect').css('display', 'none')
				$('#inventory').css('display', 'none')
				$('#trunkchest').css('display', 'none')
				$('#chest').css('display', 'none')
			break;

			case 'showDrops':
				updateDrop();
				$('#actionmenu').css('display', 'block')
				$('#droped').css('display', 'block')
			break;

			case 'showDropsHideInventory':
				updateDrop();
				$('#sends').css('display', 'none')
				$('#inventory').css('display', 'none')
				$('#droped').css('display', 'block')
			break;

			case 'hideMenu':
				$('#sends').css('display', 'none')
				$('#actionmenu').css('display', 'none')
				$('#inventory').css('display', 'none')
				$('#droped').css('display', 'none')
				$('#chest').css('display', 'none')
				$('#trunkchest').css('display', 'none')
				$('#inspect').css('display', 'none')
				$('#chesthome').css('display', 'none')
				trunkchest = false
			break;

			case 'showHotbar':
				updateHotbar();
				$('#hotbar').fadeIn(450)
			break;

			case 'hideHotbar':
				$('#hotbar').fadeOut(750)
			break;

			case 'updateDrop':
				updateDrop();
			break;

			case 'updateBackpack':
				updateBackpack();
			break;

			case 'updateChest':
				updateChest();
			break;

			case 'updateTrunkchest':
				updateTrunkchest();
			break;

			case 'updateInspect':
				updateInspect();
			break;

			case 'updateChesthome':
				updateChesthome();
			break;
		}
	});

	document.onkeyup = data => {
		const key = data.key;
		if (key === 'Escape') {
			if(trunkchest){
				$.post('http://zInventory/trunkClose', JSON.stringify({}));
			} else {
				$.post('http://zInventory/invClose', JSON.stringify({}));
			}
		}
	};

	document.onkeydown = function(event){
		if(event.keyCode == 71){
			$.post('http://zInventory/unEquipeBackpack', JSON.stringify({}));
		}

		if(event.keyCode == 46){
			updateDrop();
			$('#sends').css('display', 'none')
			$('#inventory').css('display', 'none')
			$('#droped').css('display', 'block')
			$('#trunkchest').css('display', 'none')
			$('#inspect').css('display', 'none')
			$('#chest').css('display', 'none')
			$('#chesthome').css('display', 'none')
		}

		if(event.keyCode == 83){
			updateSend();
			$('#inventory').css('display', 'none')
			$('#droped').css('display', 'none')
			$('#sends').css('display', 'block')
			$('#trunkchest').css('display', 'none')
			$('#inspect').css('display', 'none')
			$('#chest').css('display', 'none')
			$('#chesthome').css('display', 'none')
		}
	}

	$('body').mousedown(e => {
		if (e.button == 1) return false;
	});
});

let weightLeft = 0;
let maxWeightLeft = 0;

const updateAll = () => {
	updateDrop();
	updateBackpack();
	updateChest();
	updateTrunkchest();
	updateInspect();
	updateChesthome();
}

const updateDrag = () => {
	$('.populated').draggable({
		helper: 'clone',
		appendTo: 'body',
		containment: "parent"
	});

	$('.empty').droppable({
		hoverClass: 'hoverControl',
		drop: function (event, ui) {
			if (ui.draggable.parent()[0] == undefined) return;
			const origin = ui.draggable.parent()[0].id;
			
			if (origin === undefined) return;
			const tInv = $(this).parent()[0].id;

			if (origin === 'droped-drops' && tInv === 'droped-drops') return;
			itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };

			const target = $(this).data('slot');

			if (itemData.key === undefined || target === undefined) return;
			let amount = 0;
			let itemAmount = parseInt(ui.draggable.data('amount'));
			if ($('.amount').val() == '' | parseInt($('.amount').val()) == 0)
				amount = itemAmount;
			else amount = parseInt($('.amount').val());
			if (amount > itemAmount) amount = itemAmount;

			$('.populated, .empty, .use').off('draggable droppable');
			let clone1 = ui.draggable.clone();
			let slot2 = $(this).data('slot');
				
		

			if (amount == itemAmount) {
				let clone2 = $(this).clone();
				let slot1 = ui.draggable.data('slot');

				$(this).replaceWith(clone1);
				ui.draggable.replaceWith(clone2);

				$(clone1).data('slot', slot2);
				$(clone2).data('slot', slot1);
			} else {
				let newAmountOldItem = itemAmount - amount;
				let weight = parseFloat(ui.draggable.children('#item-weight').html());
				let weightPerItem = (weight / itemAmount).toFixed(2);
				let newWeightClone1 = (amount * weightPerItem).toFixed(2);
				let newWeightOldItem = (newAmountOldItem * weightPerItem).toFixed(2);

				ui.draggable.data('amount', newAmountOldItem);

				clone1.data('amount', amount);

				$(this).replaceWith(clone1);
				$(clone1).data('slot', slot2);

				ui.draggable.children('#item-amount').html(ui.draggable.data('amount') + 'x');
				ui.draggable.children('#item-weight').html(newWeightOldItem);

				$(clone1).children('#item-amount').html(clone1.data('amount') + 'x');
				$(clone1).children('#item-weight').html(newWeightClone1);
				
			}

			let futureWeightLeft = weightLeft;

			if (origin === 'droped-items' && tInv === 'droped-drops') {
				futureWeightLeft = futureWeightLeft - (parseFloat(ui.draggable.data('weight')) * amount);
			} else if (origin === 'droped-drops' && tInv === 'droped-items') {
				futureWeightLeft = futureWeightLeft + (parseFloat(ui.draggable.data('weight')) * amount);
			}
			
			weightLeft = futureWeightLeft;
			updateDrag();
			
			if (origin === 'droped-items' && tInv === 'droped-items' || origin === 'inventory-items' && tInv === 'inventory-items') {
				$.post('http://zInventory/updateSlot', JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			} else if (origin === 'droped-drops' && tInv === 'droped-items') {
				const id = ui.draggable.data('id');
				const grid = ui.draggable.data('grid');				
				abrirModal('take', id, target)
			} else if (origin === 'droped-items' && tInv === 'droped-drops') {
				abrirModal('drop', itemData.key, itemData.slot)
				// Chest
			} else if (origin === 'chest-personal-items' && tInv === 'chest-items') {
				abrirModal('chestStore', itemData.key, itemData.slot)
			} else if (origin === 'chest-items' && tInv === 'chest-personal-items') {
				abrirModal('chestTake', itemData.key, itemData.slot)
				// TrunkChest
			} else if (origin === 'trunkchest-personal-items' && tInv === 'trunkchest-items') {
				abrirModal('trunkchestStore', itemData.key, itemData.slot)
			} else if (origin === 'trunkchest-items' && tInv === 'trunkchest-personal-items') {
				abrirModal('trunkchestTake', itemData.key, itemData.slot)
				// Inspect
			} else if (origin === 'inspect-personal-items' && tInv === 'inspect-items') {
				abrirModal('inspectStore', itemData.key, itemData.slot)
			} else if (origin === 'inspect-items' && tInv === 'inspect-personal-items') {
				abrirModal('inspectTake', itemData.key, itemData.slot)
				// ChestHome
			} else if (origin === 'chesthome-personal-items' && tInv === 'chesthome-items') {
				abrirModal('chesthomeStore', itemData.key, itemData.slot)
			} else if (origin === 'chesthome-items' && tInv === 'chesthome-personal-items') {
				abrirModal('chesthomeTake', itemData.key, itemData.slot)
			} else if (origin === 'chesthome-items' && tInv === 'chesthome-items') {
				$.post('http://zInventory/chesthomeUpdateSlot', JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			}

			$('.amount').val('');
		}
	});

	$('.populated').droppable({
		hoverClass: 'hoverControl',
		drop: function (event, ui) {
			if (ui.draggable.parent()[0] == undefined) return;

			const origin = ui.draggable.parent()[0].id;
			if (origin === undefined) return;
			const tInv = $(this).parent()[0].id;

			if (origin === 'droped-drops' && tInv === 'droped-drops') return;

			itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
			const target = $(this).data('slot');

			if (itemData.key === undefined || target === undefined) return;

			let amount = 0;
			let itemAmount = parseInt(ui.draggable.data('amount'));

			if ($('.amount').val() == '' | parseInt($('.amount').val()) == 0)
				amount = itemAmount;
			else
				amount = parseInt($('.amount').val());

			if (amount > itemAmount)
				amount = itemAmount;

			$('.populated, .empty, .use').off('draggable droppable');

			let futureWeightLeft = weightLeft;

			if (ui.draggable.data('item-key') == $(this).data('item-key')) {
				let newSlotAmount = amount + parseInt($(this).data('amount'));
				let newSlotWeight = parseFloat(ui.draggable.children('#item-weight').html()) + parseFloat($(this).children('#item-weight').html());

				$(this).data('amount', newSlotAmount);
				$(this).children('#item-amount').html(newSlotAmount + 'x');
				$(this).children('#item-weight').html(newSlotWeight.toFixed(2));

				if (amount == itemAmount) {
					ui.draggable.replaceWith(`<div class='item empty' data-slot='${ui.draggable.data('slot')}'></div>`);
				} else {
					let newMovedAmount = itemAmount - amount;
					let newMovedWeight = newMovedAmount * parseFloat(ui.draggable.data('weight'));

					ui.draggable.data('amount', newMovedAmount);
					ui.draggable.children('#item-amount').html(newMovedAmount + 'x');
					ui.draggable.children('#item-weight').html(newMovedWeight.toFixed(2));
				}

				if (origin === 'droped-items' && tInv === 'droped-drops') {
					futureWeightLeft = futureWeightLeft - (parseFloat(ui.draggable.data('weight')) * amount);
				} else if (origin === 'droped-drops' && tInv === 'droped-items') {
					futureWeightLeft = futureWeightLeft + (parseFloat(ui.draggable.data('weight')) * amount);
				}
			} else {
				if (origin === 'droped-drops' && tInv === 'droped-items') return;

				let clone1 = ui.draggable.clone();
				let clone2 = $(this).clone();

				let slot1 = ui.draggable.data('slot');
				let slot2 = $(this).data('slot');

				if (origin === 'droped-items' && tInv === 'droped-drops') {
					futureWeightLeft = futureWeightLeft - parseFloat(ui.draggable.data('amount')) + parseFloat($(this).data('amount'));
				}

				ui.draggable.replaceWith(clone2);
				$(this).replaceWith(clone1);

				$(clone1).data('slot', slot2);
				$(clone2).data('slot', slot1);
			}

			updateDrag();

			if (origin === 'droped-items' && tInv === 'droped-items' || origin === 'inventory-items' && tInv === 'inventory-items') {
				$.post('http://zInventory/updateSlot', JSON.stringify({
					item: itemData.key,
					slot: itemData.slot,
					target: target,
					amount: parseInt(amount)
				}));
			} else if (origin === 'droped-drops' && tInv === 'droped-items') {
				const id = ui.draggable.data('id');
				const grid = ui.draggable.data('grid');
				abrirModal('take', id, target)
			} else if (origin === 'droped-items' && tInv === 'droped-drops') {
				abrirModal('drop', itemData.key, itemData.slot)
				// Chest
			} else if (origin === 'chest-personal-items' && tInv === 'chest-items') {
				abrirModal('chestStore', itemData.key, itemData.slot)
			} else if (origin === 'chest-items' && tInv === 'chest-personal-items') {
				abrirModal('chestTake', itemData.key, itemData.slot)
				// TrunkChest
			} else if (origin === 'trunkchest-personal-items' && tInv === 'trunkchest-items') {
				abrirModal('trunkchestStore', itemData.key, itemData.slot)
			} else if (origin === 'trunkchest-items' && tInv === 'trunkchest-personal-items') {
				abrirModal('trunkchestTake', itemData.key, itemData.slot)
				// Inspect
			} else if (origin === 'inspect-personal-items' && tInv === 'inspect-items') {
				abrirModal('inspectStore', itemData.key, itemData.slot)
			} else if (origin === 'inspect-items' && tInv === 'inspect-personal-items') {
				abrirModal('inspectTake', itemData.key, itemData.slot)
				// ChestHome
			} else if (origin === 'chesthome-personal-items' && tInv === 'chesthome-items') {
				abrirModal('chesthomeStore', itemData.key, itemData.slot)
			} else if (origin === 'chesthome-items' && tInv === 'chesthome-personal-items') {
				abrirModal('chesthomeTake', itemData.key, itemData.slot)
			} 

			$('.amount').val('');
		}
	});

	$('#sends-send').droppable({
		hoverClass: 'hoverControl',
		drop: function (event, ui) {
			const origin = ui.draggable.parent()[0].id;
			if (origin === undefined || origin === 'droped-drops') return;
			itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
			if (itemData.key === undefined) return;	
			abrirModal('send', itemData.key, itemData.slot)
			$('.amount').val('');
		}
	});


	$('.use').droppable({
		hoverClass: 'hoverControl',
		drop: function (event, ui) {
			const origin = ui.draggable.parent()[0].className;
			if (origin === undefined || origin === 'droped-drops') return;
			itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };

			if (itemData.key === undefined) return;

			$.post('http://zInventory/useItem', JSON.stringify({
				item: itemData.key,
				slot: itemData.slot,
				amount: parseInt(parseInt($('.amount').val()))
			}));

			$('.amount').val('');
		}
	});

	$('.populated').on('auxclick', e => {
		e.preventDefault();
		if (e.which === 3) {
			const item = e.target;
			const origin = $(item).parent()[0].className;
			
			if (origin === undefined || origin === 'droped-drops') return;

			itemData = { key: $(item).closest('.populated').data('item-key'), slot: $(item).closest('.populated').data('slot') };

			if (itemData.key === undefined) return;

			let amount = 1

			$.post('http://zInventory/useItem', JSON.stringify({
				item: itemData.key,
				slot: itemData.slot,
				amount: amount
			}));
		}
	});
}

const updateBackpack = () => {
	$.post('http://zInventory/requestBackpack', JSON.stringify({}), (data) => {
		$('.info-weight').html(`
			<div class='info-weight-weight'>Peso & Slots: </div>
			<div class='info-weight-data'><f>${(data.weight).toFixed(2)}</f>/${(data.maxweight).toFixed(2)}Kg⠀<f>-</f>⠀<f>${data.slots}</f>/${data.maxslots} slots em uso</div>
			<div class='info-weight-fit'></div>
		`);
		$('#inventory-items').html('');
		for (let x = 1; x <= data.maxslots; x++) {
			const slot = x.toString();
			if (data.inventory[slot] !== undefined) {
				const v = data.inventory[slot];
				const item = `
					<div class='item populated' data-amount='${v.amount}' data-weight='${v.weight}' data-item-key='${v.key}' data-name-key='${v.name}' data-slot='${slot}'>
						<div id='item-name'>${v.name}</div>
						<div id='item-amount'>${formatarNumero(v.amount)}</div>
						<div id='item-weight'>${(v.weight * v.amount).toFixed(2)}Kg</div>
						<div id='item-icon'><img href='#' src='${data.imageService}/${v.index}.png'></div>
					</div>
				`;
				$('#inventory-items').append(item);
			} else {
				const item = `
					<div class='item empty' data-slot='${slot}'></div>
				`;
				$('#inventory-items').append(item);
			}
		}
		updateDrag();
	});
}

const updateHotbar = () => {
	$.post('http://zInventory/requestHotBar', JSON.stringify({}), (data) => {
		$('#hotbar-items').html('');
		for (let x = 1; x <= 5; x++) {
			const slot = x.toString();
			if (data.inventory[slot] !== undefined) {
				const v = data.inventory[slot];
				const item = `
					<div class='item populated' data-amount='${v.amount}' data-weight='${v.weight}' data-item-key='${v.key}' data-name-key='${v.name}' data-slot='${slot}'>
						<div id='item-slot'>${slot}</div>
						<div id='item-amount'>${formatarNumero(v.amount)}</div>
						<div id='item-icon'><img href='#' src='${data.imageService}/${v.index}.png'></div>
					</div>
				`;
				$('#hotbar-items').append(item);
			} else {
				const item = `
					<div class='item empty' data-slot='${slot}'>
						<div id='item-slot'>${slot}</div>
					</div>
				`;
				$('#hotbar-items').append(item);
			}
		}
		updateDrag();
	});
}

const updateSend = () => {
	$.post('http://zInventory/requestBackpack', JSON.stringify({}), (data) => {
		$('.info-weight').html(`
			<div class='info-weight-weight'>Peso & Slots: </div>
			<div class='info-weight-data'><f>${(data.weight).toFixed(2)}</f>/${(data.maxweight).toFixed(2)}Kg⠀<f>-</f>⠀<f>${data.slots}</f>/${data.maxslots} slots em uso</div>
			<div class='info-weight-fit'></div>
		`);
		$('#sends-items').html('');
		for (let x = 1; x <= data.maxslots; x++) {
			const slot = x.toString();
			if (data.inventory[slot] !== undefined) {
				const v = data.inventory[slot];
				const item = `
					<div class='item populated' data-amount='${v.amount}' data-weight='${v.weight}' data-item-key='${v.key}' data-name-key='${v.name}' data-slot='${slot}'>
						<div id='item-name'>${v.name}</div>
						<div id='item-amount'>${formatarNumero(v.amount)}x</div>
						<div id='item-weight'>${(v.weight * v.amount).toFixed(2)}Kg</div>
						<div id='item-icon'><img href='#' src='${data.imageService}/${v.index}.png'></div>
					</div>
				`;
				$('#sends-items').append(item);
			} else {
				const item = `
					<div class='item empty' data-slot='${slot}'></div>
				`;
				$('#sends-items').append(item);
			}
		}
		updateDrag();
	});
}

const updateDrop = () => {
	$.post('http://zInventory/requestDrops', JSON.stringify({}), (data) => {
		$('.info-weight').html(`
			<div class='info-weight-weight'>Peso & Slots: </div>
			<div class='info-weight-data'><f>${(data.weight).toFixed(2)}</f>/${(data.maxweight).toFixed(2)}Kg⠀<f>-</f>⠀<f>${data.slots}</f>/${data.maxslots} slots em uso</div>
			<div class='info-weight-fit'></div>
		`);
		$('#droped-items').html('');
		for (let x = 1; x <= data.maxslots; x++) {
			const slot = x.toString();
			if (data.inventory[slot] !== undefined) {
				const v = data.inventory[slot];
				const item = `
					<div class='item populated' data-amount='${v.amount}' data-weight='${v.weight}' data-item-key='${v.key}' data-name-key='${v.name}' data-slot='${slot}'>
						<div id='item-name'>${v.name}</div>
						<div id='item-amount'>${formatarNumero(v.amount)}x</div>
						<div id='item-weight'>${(v.weight * v.amount).toFixed(2)}Kg</div>
						<div id='item-icon'><img href='#' src='${data.imageService}/${v.index}.png'></div>
					</div>
				`;
				$('#droped-items').append(item);
			} else {
				const item = `
					<div class='item empty' data-slot='${slot}'></div>
				`;
				$('#droped-items').append(item);
			}
		}
		$('#droped-drops').html('');
		const nameList2 = data.drop.sort((a, b) => (a.name > b.name) ? 1 : -1);
		for (let x = 1; x <= 32; x++) {
			const slot = x.toString();
			if (nameList2[x - 1] !== undefined) {
				const v = nameList2[x - 1];
				const item = `
					<div class='item populated' data-item-key='${v.key}' data-name-key='${v.name}' data-id='${v.id}' data-grid='${v.grid}' data-amount='${v.amount}' data-weight='${v.weight}' data-slot='${slot}'>
						<div id='item-name'>${v.name}</div>
						<div id='item-amount'>${formatarNumero(v.amount)}x</div>
						<div id='item-weight'>${(v.weight * v.amount).toFixed(2)}Kg</div>
						<div id='item-icon'><img href='#' src='${data.imageService}/${v.index}.png'></div>
					</div>
				`;
				$('#droped-drops').append(item);
			} else {
				const item = `<div class='item empty' data-slot='${slot}'></div>`;
				$('#droped-drops').append(item);
			}
		}
		updateDrag();
	});
}

const updateChest = () => {
	$.post('http://zInventory/requestChest', JSON.stringify({}), (data) => {
		$('.info-weight').html(`
			<div class='info-weight-weight'>Inventário: </div>
			<div class='info-weight-data'><f>${(data.weight).toFixed(2)}</f>/${(data.maxweight).toFixed(2)}Kg⠀<f>-</f>⠀<f>${data.slots}</f>/${data.maxslots} slots em uso⠀⠀</div>
			<div class='info-weight-weight'>Baú: </div>
			<div class='info-weight-data'><f>${(data.chestweight).toFixed(2)}</f>/${(data.maxchestweight).toFixed(2)}Kg⠀<f>-</f>⠀<f>${data.chestslots}</f>/${data.maxchestslots} slots em uso</div>
		`);
		$('#chest-personal-items').html('');
		for (let x = 1; x <= data.maxslots; x++) {
			const slot = x.toString();
			if (data.inventory[slot] !== undefined) {
				const v = data.inventory[slot];
				const item = `
					<div class='item populated' data-amount='${v.amount}' data-weight='${v.weight}' data-item-key='${v.key}' data-name-key='${v.name}' data-slot='${slot}'>
						<div id='item-name'>${v.name}</div>
						<div id='item-amount'>${formatarNumero(v.amount)}x</div>
						<div id='item-weight'>${(v.weight * v.amount).toFixed(2)}Kg</div>
						<div id='item-icon'><img href='#' src='${data.imageService}/${v.index}.png'></div>
					</div>
				`;
				$('#chest-personal-items').append(item);
			} else {
				const item = `
					<div class='item empty' data-slot='${slot}'></div>
				`;
				$('#chest-personal-items').append(item);
			}
		}
		$('#chest-items').html('');
		const nameList2 = data.chest.sort((a, b) => (a.slot > b.slot) ? 1 : -1);
		for (let x = 1; x <= data.maxchestslots; x++) {
			const slot = x.toString();
			if (nameList2[x - 1] !== undefined) {
				const v = nameList2[x - 1];
				const item = `
					<div class='item populated' data-item-key='${v.key}' data-name-key='${v.name}' data-id='${v.id}' data-amount='${v.amount}' data-weight='${v.weight}' data-slot='${slot}'>
						<div id='item-name'>${v.name}</div>
						<div id='item-amount'>${formatarNumero(v.amount)}x</div>
						<div id='item-weight'>${(v.weight * v.amount).toFixed(2)}Kg</div>
						<div id='item-icon'><img href='#' src='${data.imageService}/${v.index}.png'></div>
					</div>
				`;
				$('#chest-items').append(item);
			} else {
				const item = `<div class='item empty' data-slot='${slot}'></div>`;
				$('#chest-items').append(item);
			}
		}
		updateDrag();
	});
}

const updateTrunkchest = () => {
	$.post('http://zInventory/requestTrunkchest', JSON.stringify({}), (data) => {
		$('.info-weight').html(`
			<div class='info-weight-weight'>Inventário: </div>
			<div class='info-weight-data'><f>${(data.weight).toFixed(2)}</f>/${(data.maxweight).toFixed(2)}Kg⠀<f>-</f>⠀<f>${data.slots}</f>/${data.maxslots} slots em uso⠀⠀</div>
			<div class='info-weight-weight'>Porta-Mala: </div>
			<div class='info-weight-data'><f>${(data.weightcar).toFixed(2)}</f>/${(data.maxweightcar).toFixed(2)}Kg⠀<f>-</f>⠀<f>${data.slotscar}</f>/${data.maxslotscar} slots em uso</div>
		`);
		$('#trunkchest-personal-items').html('');
		for (let x = 1; x <= data.maxslots; x++) {
			const slot = x.toString();
			if (data.myinventory[slot] !== undefined) {
				const v = data.myinventory[slot];
				const item = `
					<div class='item populated' data-amount='${v.amount}' data-weight='${v.weight}' data-item-key='${v.key}' data-name-key='${v.name}' data-slot='${slot}'>
						<div id='item-name'>${v.name}</div>
						<div id='item-amount'>${formatarNumero(v.amount)}x</div>
						<div id='item-weight'>${(v.weight * v.amount).toFixed(2)}Kg</div>
						<div id='item-icon'><img href='#' src='${data.imageService}/${v.index}.png'></div>
					</div>
				`;
				$('#trunkchest-personal-items').append(item);
			} else {
				const item = `
					<div class='item empty' data-slot='${slot}'></div>
				`;
				$('#trunkchest-personal-items').append(item);
			}
		}
		$('#trunkchest-items').html('');
		const nameList2 = data.myvehicle.sort((a, b) => (a.slot > b.slot) ? 1 : -1);
		for (let x = 1; x <= data.maxslotscar; x++) {
			const slot = x.toString();
			if (nameList2[x - 1] !== undefined) {
				const v = nameList2[x - 1];
				const item = `
					<div class='item populated' data-item-key='${v.key}' data-name-key='${v.name}' data-id='${v.id}' data-amount='${v.amount}' data-weight='${v.weight}' data-slot='${slot}'>
						<div id='item-name'>${v.name}</div>
						<div id='item-amount'>${formatarNumero(v.amount)}x</div>
						<div id='item-weight'>${(v.weight * v.amount).toFixed(2)}Kg</div>
						<div id='item-icon'><img href='#' src='${data.imageService}/${v.index}.png'></div>
					</div>
				`;
				$('#trunkchest-items').append(item);
			} else {
				const item = `<div class='item empty' data-slot='${slot}'></div>`;
				$('#trunkchest-items').append(item);
			}
		}
		updateDrag();
	});
}

const updateInspect = () => {
	$.post('http://zInventory/requestInspect', JSON.stringify({}), (data) => {
		$('.info-weight').html(`
			<div class='info-weight-weight'>Inventário: </div>
			<div class='info-weight-data'><f>${(data.weight).toFixed(2)}</f>/${(data.maxweight).toFixed(2)}Kg⠀<f>-</f>⠀<f>${data.slots}</f>/${data.maxslots} slots em uso⠀⠀</div>
			<div class='info-weight-weight'>Revistado: </div>
			<div class='info-weight-data'><f>${(data.weighttwo).toFixed(2)}</f>/${(data.maxweighttwo).toFixed(2)}Kg⠀<f>-</f>⠀<f>${data.slotstwo}</f>/${data.maxslotstwo} slots em uso</div>
		`);
		$('#inspect-personal-items').html('');
		for (let x = 1; x <= data.maxslots; x++) {
			const slot = x.toString();
			if (data.inventory[slot] !== undefined) {
				const v = data.inventory[slot];
				const item = `
					<div class='item populated' data-amount='${v.amount}' data-weight='${v.weight}' data-item-key='${v.key}' data-name-key='${v.name}' data-slot='${slot}'>
						<div id='item-name'>${v.name}</div>
						<div id='item-amount'>${formatarNumero(v.amount)}x</div>
						<div id='item-weight'>${(v.weight * v.amount).toFixed(2)}Kg</div>
						<div id='item-icon'><img href='#' src='${data.imageService}/${v.index}.png'></div>
					</div>
				`;
				$('#inspect-personal-items').append(item);
			} else {
				const item = `
					<div class='item empty' data-slot='${slot}'></div>
				`;
				$('#inspect-personal-items').append(item);
			}
		}
		$('#inspect-items').html('');
		for (let x = 1; x <= data.maxslotstwo; x++) {
			const slot = x.toString();
			if (data.inventorytwo[slot] !== undefined) {
				const v = data.inventorytwo[slot];
				const item = `
					<div class='item populated' data-amount='${v.amount}' data-weight='${v.weight}' data-item-key='${v.key}' data-name-key='${v.name}' data-slot='${slot}'>
						<div id='item-name'>${v.name}</div>
						<div id='item-amount'>${formatarNumero(v.amount)}x</div>
						<div id='item-weight'>${(v.weight * v.amount).toFixed(2)}Kg</div>
						<div id='item-icon'><img href='#' src='${data.imageService}/${v.index}.png'></div>
					</div>
				`;
				$('#inspect-items').append(item);
			} else {
				const item = `
					<div class='item empty' data-slot='${slot}'></div>
				`;
				$('#inspect-items').append(item);
			}
		}
		updateDrag();
	});
}

const updateChesthome = () => {
	$.post('http://zInventory/requestChesthome', JSON.stringify({}), (data) => {
		$('.info-weight').html(`
			<div class='info-weight-weight'>Inventário: </div>
			<div class='info-weight-data'><f>${(data.weigth).toFixed(2)}</f>/${(data.maxweight).toFixed(2)}Kg⠀<f>-</f>⠀<f>${data.slots}</f>/${data.maxslots} slots em uso⠀⠀</div>
			<div class='info-weight-weight'><f>${(data.chesthomename)}</f> | Baú: </div>
			<div class='info-weight-data'><f>${(data.weighthome).toFixed(2)}</f>/${(data.maxweighthome).toFixed(2)}Kg⠀<f>-</f>⠀<f>${data.slotshome}</f>/${data.maxslotshome} slots em uso</div>
		`);
		$('#chesthome-personal-items').html('');
		for (let x = 1; x <= data.maxslots; x++) {
			const slot = x.toString();
			if (data.inventory[slot] !== undefined) {
				const v = data.inventory[slot];
				const item = `
					<div class='item populated' data-amount='${v.amount}' data-weight='${v.weight}' data-item-key='${v.key}' data-name-key='${v.name}' data-slot='${slot}'>
						<div id='item-name'>${v.name}</div>
						<div id='item-amount'>${formatarNumero(v.amount)}x</div>
						<div id='item-weight'>${(v.weight * v.amount).toFixed(2)}Kg</div>
						<div id='item-icon'><img href='#' src='${data.imageService}/${v.index}.png'></div>
					</div>
				`;
				$('#chesthome-personal-items').append(item);
			} else {
				const item = `
					<div class='item empty' data-slot='${slot}'></div>
				`;
				$('#chesthome-personal-items').append(item);
			}
		}
		$('#chesthome-items').html('');
		const nameList2 = data.chesthome.sort((a, b) => (a.slot > b.slot) ? 1 : -1);
		for (let x = 1; x <= data.maxslotshome; x++) {
			const slot = x.toString();
			if (nameList2[x - 1] !== undefined) {
				const v = nameList2[x - 1];
				const item = `
					<div class='item populated' data-item-key='${v.key}' data-name-key='${v.name}' data-id='${v.id}' data-amount='${v.amount}' data-weight='${v.weight}' data-slot='${slot}'>
						<div id='item-name'>${v.name}</div>
						<div id='item-amount'>${formatarNumero(v.amount)}x</div>
						<div id='item-weight'>${(v.weight * v.amount).toFixed(2)}Kg</div>
						<div id='item-icon'><img href='#' src='${data.imageService}/${v.index}.png'></div>
					</div>
				`;
				$('#chesthome-items').append(item);
			} else {
				const item = `<div class='item empty' data-slot='${slot}'></div>`;
				$('#chesthome-items').append(item);
			}
		}
		updateDrag();
	});
}

const formatarNumero = n => {
	var n = n.toString();
	var r = '';
	var x = 0;
	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}
	return r.split('').reverse().join('');
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
	document.getElementById('popup-1').classList.toggle('active');
	typeOfValue = null
	valueOne = null
	valueTwo = null
	updateAll();
}
  
function simAceita() {
	document.getElementById('popup-1').classList.toggle('active');
	if ($('.amount').val() == '' | parseInt($('.amount').val()) == 0 | parseInt($('.amount').val()) < 0) return updateAll();
	if (typeOfValue == 'drop') {
		$.post('http://zInventory/dropItem', JSON.stringify({
			item: valueOne,
			slot: valueTwo,
			amount: parseInt(Number($(".amount").val()))
		}));
	} else if (typeOfValue == 'take') {
		$.post('http://zInventory/pickupItem', JSON.stringify({
			id: valueOne,
			target: valueTwo,
			amount: parseInt(Number($(".amount").val()))
		}));
	} else if  (typeOfValue == 'send') {
		$.post('http://zInventory/sendItem', JSON.stringify({
			item: valueOne,
			amount: parseInt(Number($(".amount").val()))
		}));
		// Chest
	} else if  (typeOfValue == 'chestStore') {
		$.post('http://zInventory/chestStoreItem', JSON.stringify({
			item: valueOne,
			slot: ui.draggable.data('slot'),
			amount: parseInt(Number($(".amount").val()))
		}));
	} else if  (typeOfValue == 'chestTake') {
		$.post('http://zInventory/chestTakeItem', JSON.stringify({
			item: valueOne,
			slot: valueTwo,
			amount: parseInt(Number($(".amount").val()))
		}));
		// Trunkchest
	} else if  (typeOfValue == 'trunkchestStore') {
		$.post('http://zInventory/trunkchestStoreItem', JSON.stringify({
			item: valueOne,
			slot: valueTwo,
			amount: parseInt(Number($(".amount").val()))
		}));
	} else if  (typeOfValue == 'trunkchestTake') {
		$.post('http://zInventory/trunkchestTakeItem', JSON.stringify({
			item: valueOne,
			slot: valueTwo,
			amount: parseInt(Number($(".amount").val()))
		}));
		// Inspect
	} else if  (typeOfValue == 'inspectStore') {
		$.post('http://zInventory/inspectStoreItem', JSON.stringify({
			item: valueOne,
			slot: valueTwo,
			amount: parseInt(Number($(".amount").val()))
		}));
	} else if  (typeOfValue == 'inspectTake') {
		$.post('http://zInventory/inspectTakeItem', JSON.stringify({
			item: valueOne,
			slot: valueTwo,
			amount: parseInt(Number($(".amount").val()))
		}));
		// ChestHome
	} else if  (typeOfValue == 'chesthomeStore') {
		$.post('http://zInventory/chesthomeStoreItem', JSON.stringify({
			item: valueOne,
			slot: valueTwo,
			amount: parseInt(Number($(".amount").val()))
		}));
	} else if  (typeOfValue == 'chesthomeTake') {
		$.post('http://zInventory/chesthomeTakeItem', JSON.stringify({
			item: valueOne,
			slot: valueTwo,
			amount: parseInt(Number($(".amount").val()))
		}));
	}
	typeOfValue = null
	valueOne = null
	valueTwo = null
	updateDrop();
}