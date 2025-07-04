$(document).ready(function(){
    window.addEventListener('message',function(event){
        switch(event.data.action){
            case 'selectionMenuOn':
                updateLocalizations();
                $('#selection-menu').fadeIn(500);
                $('#bg-selection').css('display', 'block');
            break;

            case 'selectionMenuOff':
                $('#selection-menu').fadeOut(500);
                $('#bg-selection').css('display', 'none');
            break;
            
            case 'buttomsMenuOn':
                $('#buttoms-menu').fadeIn(500);
            break;
            
            case 'buttomsMenuOff':
                $('#buttoms-menu').fadeOut(500);
            break;

            case 'closeInterface':
                $('#selection-menu').fadeOut(500);
                $('#buttoms-menu').fadeOut(500);
                $('#bg-selection').fadeOut(500);
            break;
        }
    });
});

const updateLocalizations = () => {
    $.post('https://zLogin/requestLocalizations',JSON.stringify({}),(data) => {
        const nameList = data.loc.sort((a,b) => (a.name > b.name) ? 1: -1);
        $('#localizationMenu').html(`
            ${nameList.map((item) => (`
                <li class='localization' data-spawn='${item.index}'>
                    <div class='background-spawn'><img src='${item.photo}'/></div>
                    <h2>${item.name}</h2>
                </li>
            `)).join('')}
            <li class='localization' data-spawn='spawn'>
                <div class='background-spawn'><img src='${data.imgLastLocation}'/></div>
                <h2>Último localização</h2>
            </li>
        `);
    });
}

$(document).on('click','.localization',function(){
	$.post('https://zLogin/spawn', JSON.stringify({ choice: $(this).data('spawn')}));
})

$(document).on('click','.buttom',function(){
	$.post('https://zLogin/spawn', JSON.stringify({ choice: $(this).data('spawn')}));
})