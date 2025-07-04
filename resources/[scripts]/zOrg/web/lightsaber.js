let org = '';

$(document).ready(function () {
    window.addEventListener('message', function (event) {
        org = event.data.org;
        switch (event.data.action) {
            case 'showInterface':
                update()
                setTimeout(function(){
                    $('#actionmenu').fadeIn(100);
                    $('#home').fadeIn(100);
                }, 220);
            break;

            case 'hideInterface':
                update()
                $('#actionmenu').fadeOut(100);
                $('#home').fadeOut(100);
                org = '';
            break;
        }
    });

    document.onkeydown = function(event){
        if(event.keyCode == 27){
			$.post('http://zOrg/closeInterface', JSON.stringify({}));
		}
    }
});

const update = () => {
    $.post('http://zOrg/requestData', JSON.stringify({org: org}), (data) => {
        const playersData = data.players.sort((a,b) => (a.name > b.name) ? 1: -1);
        const membersData = data.members.sort((a,b) => (a.name > b.name) ? 1: -1);

        $('.top').html(`
            <h1 class='org-text'>${data.orgname}</h1>
            <button id='manage'>GERENCIAR ORGANIZAÇÃO</button>
		`);

        $('#player-list').html(`
			${playersData.map((player) => (`
                <div class='player' data-player-id='${player.passport}'>
                    <div id='player-id'>${player.passport}</div>
                    <div id='player-name'>${player.name} ${player.firstname}</div>
                    <button id='invite' data-member-id='${player.passport}'>CONVIDAR</button>
                </div>
			`)).join('')}
		`);

        $('#member-list').html(`
			${membersData.map((member) => (`
                <div class='player' data-player-id='${member.passport}'>
                    <div id='member-id'>${member.passport}</div>
                    <div id='member-name'>${member.name}</div>
                    <button id='edit' data-member-id='${member.passport}'>GERENCIAR</button>
                </div>
			`)).join('')}
		`);
    });
}

const updateMember = (id) => {
    $.post('http://zOrg/requestDataMember', JSON.stringify({id: id, org: org}), (data) => {
        $('.top').html(`
            <h1 class='org-text'>${data.orgname}</h1>
            <button id='back'>VOLTAR</button>
		`);

        $('#member-managed').html(`
            <h3 id='member-namess'><n>${data.name}</n></h3>
            <button id='updateRole' data-member-id='${data.id}'>PROMOVER</button>
            <button id='dongradeRole' data-member-id='${data.id}'>REBAIXAR</button>
            <input class='amount' id='amount' type='number' placeholder='$${data.paycheck}'/>
            <button id='update' data-member-id='${data.id}'>ATUALIZAR</button>
		`);
    });
}

const updateOrg = () => {
    $.post('http://zOrg/requestDataOrg', JSON.stringify({org: org}), (data) => {
        $('.top').html(`
            <h1 class='org-text'>${data.orgname}</h1>
            <button id='back'>VOLTAR</button>
		`);

        $('#withdraw').html(`
            <h3 id='member-count'>Membros: <n>${data.members}</n></h3>
            <h3 id='vault-balance'>Saldo em cofre: <n>$${data.balance}</n></h3>
            <input class='amount' id='amount' type='number' placeholder='$0'/>
            <button id='withdraw-b'>SACAR</button>
            <button id='deposit-b'>DEPOSITAR</button>
		`);
    });
}

$(document).on('click','#withdraw-b',function(){
    if (Number($("#amount").val()) == '' | parseInt(Number($("#amount").val())) == 0 | parseInt(Number($("#amount").val())) < 0) return;
	$.post('http://zOrg/withdraw', JSON.stringify({
        amount: parseInt(Number($("#amount").val())),
        org: org
	}))
    updateOrg()
})

$(document).on('click','#deposit-b',function(){
    if (Number($("#amount").val()) == '' | parseInt(Number($("#amount").val())) == 0 | parseInt(Number($("#amount").val())) < 0) return;

	$.post('http://zOrg/deposit', JSON.stringify({
        amount: parseInt(Number($("#amount").val())),
        org: org
	}))
    updateOrg()
})

$(document).on('click','#back',function(){
    update()
    $('#home').css('display', 'block');
    $('#manager').css('display', 'none');
    $('#manage-member').css('display', 'none');
})

$(document).on('click','#manage',function(){
    updateOrg()
    $('#home').css('display', 'none');
    $('#manager').css('display', 'block');
    $('#manage-member').css('display', 'none');
})

$(document).on('click','#updateRole',function(){
	data = { key: $(this).data('member-id') };
	if (data.key === undefined) return;
	$.post('http://zOrg/updateRole', JSON.stringify({
		id: data.key,
        org: org
	}))
    updateMember(data.key);
})

$(document).on('click','#dongradeRole',function(){
	data = { key: $(this).data('member-id') };
	if (data.key === undefined) return;
	$.post('http://zOrg/dongradeRole', JSON.stringify({
		id: data.key,
        org: org
	}))
    updateMember(data.key);
})

$(document).on('click','#update',function(){
	data = { key: $(this).data('member-id') };
	if (data.key === undefined) return;

    if (Number($("#amount").val()) == '' | parseInt(Number($("#amount").val())) == 0 | parseInt(Number($("#amount").val())) < 0) return;

	$.post('http://zOrg/updatePaycheck', JSON.stringify({
		id: data.key,
        amount: parseInt(Number($("#amount").val())),
        org: org
	}))
})

$(document).on('click','#invite',function(){
	data = { key: $(this).data('member-id') };
	if (data.key === undefined) return;
	$.post('http://zOrg/inviteMember', JSON.stringify({
		id: data.key,
        org: org
	}))
})

$(document).on('click','#edit',function(){
	data = { key: $(this).data('member-id') };
	if (data.key === undefined) return;
    updateMember(data.key);
    $('#home').css('display', 'none');
    $('#manager').css('display', 'none');
    $('#manage-member').css('display', 'block');
})