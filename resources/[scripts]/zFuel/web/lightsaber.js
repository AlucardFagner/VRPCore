state = 0

$(document).ready(function(){
	let actionContainer = $("#container");

	window.addEventListener('message',function(event){

		fuel = event.data.fuel
		let item = event.data;
		let amount = event.data.amount;
		let price = event.data.price;
		let tax = event.data.tax;
		let done = event.data.done;

		switch(item.action){
			case 'showMenu':
				actionContainer.fadeIn(500);
				$('.bar').css('width',(fuel*249)/100);
				$(".price").append('<span style="position: absolute; left: 30px; top: 3px">$ '+price+'</span>');
				$('.visor2').children().html('<span class="unique">0.00 L</span>');
				$('.visor1').children().html('<span class="unique">$ 0.00</span>');
				$('#posto').css('display', 'block');
				$('#frontman').css('display', 'none');
				$('.abastecer').children().html(`<p style="position:absolute;top:1px;left:3px;">Abastecer<b>`)
				$('.abastecer').css('background-color', 'rgb(100, 209, 123)')
			break;

			case 'hideMenu':
				actionContainer.fadeOut(500);
			break;

			case 'frontman':
				actionContainer.fadeIn(500);
				showFrontman(fuel);
			break;

			case 'updateVisor':
				if (!done) {
					$('.abastecer').children().html(`<p style="position:absolute;top:1px;left:18px;color:rgb(233, 233, 233);">Parar<b>`)
					$('.abastecer').css('background-color', 'rgb(241, 62, 62)')
				} else {
					state = 0
					$('.abastecer').children().html(`<p style="position:absolute;top:1px;left:3px;">Abastecer<b>`)
					$('.abastecer').css('background-color', 'rgb(100, 209, 123)')
				}
				$('.visor2').children().html('<span class="unique">'+(amount/tax).toFixed(2)+' L</span>');
				$('.visor1').children().html('<span class="unique">$ '+amount.toFixed(2)+'</span>');
				$('.bar').css('width',(fuel*249)/100); 
			break;
		}
	});

	document.onkeyup = function(data){
		if (data.which == 27){
			sendData("ButtonClick","exit")
			state = 0
			setTimeout(() => {  $('#frontman').css('display', 'none'),$('#posto').css('display', 'none') }, 500);
		}
	};
});

const showFrontman = (fuel) => {
	$('#frontman').html(`
		<div class="front-body"></div>
		<div class="front-header"></div>
		<div class="front-header-p">zFUEL</div>
		<div class="fuel-circle"></div>
		<div class="fuel-circle-p">TANQUE</div>
		<div class="fuel-circle-p" style="top:517px;width:210px;left:750px;">Inserir valor:</div>
		<div class="fuel-circle-p" style="top:544px;width:210px;left:753px;color:#0e8f18;font-size: 25px;">$</div>
		<div class="fuel-p">${fuel.toFixed(0) + "%"}</div>
		<div class="button-refuel">
			<p>ABASTECER</p>
		</div>
		<p class="or">OU</p>
		<div class="button-complete">
			<p>COMPLETAR</p>
		</div>
		<div class="fuel-img"></div>
		<input type="number" spellcheck="false" class="vinput">
	`)
	$('#frontman').css('display', 'block');
	$('#posto').css('display', 'none');
}

const sendData = (name,data) => {
	$.post("http://zFuel/"+name,JSON.stringify(data),function(datab){});
}

$(document).on('click','.galao',function(){
	$.post('http://zFuel/buy-jerrycan',JSON.stringify({}));
})

$(document).on('click','.button-complete',function(){
	$.post('http://zFuel/complete',JSON.stringify({}));
})

$(document).on('click','.button-refuel',function(){
	$.post('http://zFuel/partial',JSON.stringify({
		value: $('.vinput').val(),
	}));
})

$(document).on('click','.abastecer',function(){
	if (state == 0) {
		$.post('http://zFuel/refuel',JSON.stringify({}));
		state = 1
	} else {
		state = 0
		$('.abastecer').children().html(`<p style="position:absolute;top:1px;left:3px;">Abastecer<b>`)
		$('.abastecer').css('background-color', 'rgb(100, 209, 123)')
		$.post('http://zFuel/requestFuel',JSON.stringify({}));
	}
})