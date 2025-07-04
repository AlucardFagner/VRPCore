$(document).ready(function () {
	window.addEventListener('message', function (event) {
        let item = event.data;
        switch(item.action){
            case 'showCraft':
                updateCraft();
                $(`#craft`).css('display', 'block');
                $(`#actionmenu`).css('display', 'block');
            break;

            case 'hideMenu':
                $(`#craft`).css('display', 'none');
                $(`#actionmenu`).css('display', 'none');
            break;
        }
    });

    document.onkeyup = data => {
		const key = data.key;
		if (key === 'Escape') {
			$.post('http://zCraft/close', JSON.stringify({}));
		}
	};
});

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

const updateCraft = () => {
    $.post('http://zCraft/requestCrafts',JSON.stringify({}),(data) => {
        const craftItens = data.craft.sort((a, b) => (a.name > b.name) ? 1: -1);
        $('#craft-items').html(`
			${craftItens.map((item) => (`
                <div class='item' data-item-key='${item.key}'>
                    <div id='item-icon'>
                        <img src='${data.imageService}/${item.index}.png'/>
                        <div id='item-amount'>${item.amount}x</div>
                    </div>
                    <div id='top'>
                        <div id='item-name'>${item.name}</div>
                    </div>
                    <div id='bottom'>
                        <div id='item-required'>
                            <div class='required'>
                                <div id='required-icon'><img src='${data.imageService}/${item.required_name_one}.png'/></div>
                                <div id='required-amount'>${item.required_amount_one}x</div>
                            </div>
                            <div class='required'>
                                <div id='required-icon'><img src='${data.imageService}/${item.required_name_two}.png'/></div>
                                <div id='required-amount'>${item.required_amount_two}x</div>
                            </div>
                            <div class='required'>
                                <div id='required-icon'><img src='${data.imageService}/${item.required_name_three}.png'/></div>
                                <div id='required-amount'>${item.required_amount_three}x</div>
                            </div>
                            <div class='required'>
                                <div id='required-icon'><img src='${data.imageService}/${item.required_name_four}.png'/></div>
                                <div id='required-amount'>${item.required_amount_four}x</div>
                            </div>
                        </div>
                        <div id='craft-button' data-item-key='${item.key}'>CRAFTAR</div>
                    </div>
                </div>
			`)).join('')}
		`);
    });
}

$(document).on('click','#craft-button',function(){
	data = {key: $(this).data('item-key')};
	if (data.key === undefined) return;
	$.post('http://zCraft/craftar', JSON.stringify({
		item: data.key
	}))
})