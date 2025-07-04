let account = ''

$('#actionmenu').html(`
    <div class="subpage" id="new_account">
        <div class="title_background">
            <h1 class="title">zBank</h1>
        </div>
        <p class="description_text">
            Olá seja bem-vindo(a) ao Banco Z! Já criamos uma conta para você e agora você só precisa definir usuário e senha para sua conta!
        </p>
        <div id="new_account_form">
            <input class="subpage_form_itens" id="new_account_form_username" name="username" type="text" placeholder="Usuário" required>
            <input class="subpage_form_itens" id="new_account_form_password" type="password" placeholder="Senha" required>
            <input class="subpage_form_itens" id="new_account_form_repassword" type="password" placeholder="Confirme a senha" required>
            <div class="button" id="new_account_new">
                <div class="button_after">CRIAR CONTA</div>
                <button class="button_before" data-action="new_account" type="submit">
                    <div class="button_before_text">CRIAR</div>
                </button>
            </div>
        </div>
        <div class="button" id="exit">
            <div class="button_after">SAIR</div>
            <button class="button_before" data-action="exit" type="submit">
                <div class="button_before_text">SAIR</div>
            </button>
        </div>
    </div>

    
    <div class="subpage" id="reset">
        <div class="title_background">
            <h1 class="title">zBank</h1>
        </div>
        <p class="description_text">
            Já identificamos sua conta e vamos lhe ajudar a recuperar a sua senha!
        </p>
        <div id="reset_form">
            <input class="subpage_form_itens" id="reset_form_password" type="password" placeholder="Senha" required>
            <input class="subpage_form_itens" id="reset_form_repassword" type="password" placeholder="Confirme a senha" required>
            <div class="button" id="reset_reset">
                <div class="button_after">ALTERAR SENHA</div>
                <button class="button_before" data-action="reset_password" id="reset_password_confirm" type="submit">
                    <div class="button_before_text">CONFIRMAR</div>
                </button>
            </div>
        </div>
        <div class="button" id="exit">
            <div class="button_after">SAIR</div>
            <button class="button_before" data-action="exit" type="submit">
                <div class="button_before_text">SAIR</div>
            </button>
        </div>
    </div>


    <div class="subpage" id="login">
        <div class="title_background">
            <h1 class="title">zBank</h1>
        </div>
        <p class="description_text">
            Mais que um banco, o seu banco Z!
        </p>
        <div id="form_login">
            <input class="subpage_form_itens" id="form_login_username" name="username" type="text" placeholder="Usuário" required>
            <input class="subpage_form_itens" id="form_login_password" name="password" type="password" placeholder="Senha" required>
            <div class="button" id="login_login">
                <div class="button_after">ACESSAR CONTA</div>
                <button class="button_before" data-action="login" type="submit">
                    <div class="button_before_text">ENTRAR</div>
                </button>
            </div>
        </div>
        <div class="button" id="exit">
            <div class="button_after">SAIR</div>
            <button class="button_before" data-action="exit" type="submit">
                <div class="button_before_text">SAIR</div>
            </button>
        </div>
        <p class="recovery_password_text">Esqueceu sua senha? <a id="reset_password_click">Clique aqui.</a></p>
    </div>


    <div class="page" id="home">
        <div class="title_background">
            <h1 class="title">zBank</h1>
        </div>
        <div class="cards">
            <div class="cards_title">EMPRÉSTIMO</div>
            <h3 id="loan_available"></h3>
            <p id="loan_contracted"></p>
        </div>
        <div class="cards">
            <div class="cards_title">CRÉDITO</div>
            <h3 id="credit_available"></h3>
            <p id="credit_used"></p>
        </div>
        <div id="balances">
            <div id="balance_data_info">Seu saldo:</div>
            <h1 id="balance_data"></h1>
            <p id="all_debits"></p>
            <div id="text_score"></div>
            <div class="chart" id="graph" data-percent="0"></div>
            <h3 id="score-text">Seu score:</h3>
        </div>
        <div id="last_transactions_title">Últimas transações:</div>
        <div id="last_transactions"></div>
        <div id="buttons">
            <div class="button_home" data-page="pay">
                <div class="button_img" id="action-pay-img"></div>
                <p class="button_desc">pagar</p>
            </div>
            <div class="button_home" data-page="withdraw">
                <div class="button_img" id="action-withdraw-img"></div>
                <p class="button_desc">saque</p>
            </div>
            <div class="button_home" data-page="deposit">
                <div class="button_img" id="action-deposit-img"></div>
                <p class="button_desc">depositar</p>
            </div>
            <div class="button_home" data-page="transfers">
                <div class="button_img" id="action-pix-img"></div>
                <p class="button_desc">pix</p>
            </div>
            <div class="button_home" data-page="loan">
                <div class="button_img" id="action-loan-img"></div>
                <p class="button_desc">empréstimo</p>
            </div>
            <div class="button_home" data-page="credit">
                <div class="button_img" id="action-credit-img"></div>
                <p class="button_desc">cartões</p>
            </div>
        </div>
    </div>


    <div class="page" id="credit">
        <div class="title_background">
            <h1 class="title">CRÉDITO</h1>
        </div>
        <div id="pages_balance">Seu saldo: <b class="page_balance"></b></div>
        <div class="button" id="button_pay_back">
            <div class="button_after">INÍCIO</div>
            <button class="button_before" data-action="back" data-page="credit">
                <div class="button_before_text">VOLTAR</div>
            </button>
        </div>
        <div class="left_content">
            Você pode parcelar o suas compras em até 12 vezes
        </div>
        <div class="credits_data" id="credit_available">
            <p>Crédito disponível:</p>
            <h3 id="credit_available_value"></h3>
        </div>
        <div class="credits_data" id="credit_contracted">
            <p>Crédito em uso:</p>
            <h3 id="credit_used_value"></h3>
        </div>
        <div id="credit_installments_title">Faturas</div>
        <div id="credit_installments"></div>
        <div class="button" id="button_credit_card">
            <div class="button_after">EMITIR CARTÃO</div>
            <button class="button_before" data-action="credit_card" id="button_credit_card_confirm" type="submit">
                <div class="button_before_text">CONFIRMAR</div>
            </button>
        </div>
    </div>


    <div class="page" id="withdraw">
        <div class="title_background">
            <h1 class="title">SACAR</h1>
        </div>
        <div id="pages_balance">Seu saldo: <b class="page_balance"></b></div>
        <div class="button" id="button_pay_back">
            <div class="button_after">INÍCIO</div>
            <button class="button_before" data-action="back" data-page="withdraw">
                <div class="button_before_text">VOLTAR</div>
            </button>
        </div>
        <div class="withdraw_form">
            <input id="withdraw_form_value" type="number" placeholder="Valor do saque" required>
            <div class="button" id="withdraw_form_withdraw">
                <div class="button_after">SACAR</div>
                <button class="button_before" data-action="withdraw" type="submit">
                    <div class="button_before_text">CONFIRMAR</div>
                </button>
            </div>
        </div>
    </div>


    <div class="page" id="deposit">
        <div class="title_background">
            <h1 class="title">DEPÓSITO</h1>
        </div>
        <div id="pages_balance">Seu saldo: <b class="page_balance"></b></div>
        <div class="button" id="button_pay_back">
            <div class="button_after">INÍCIO</div>
            <button class="button_before" data-action="back" data-page="deposit">
                <div class="button_before_text">VOLTAR</div>
            </button>
        </div>
        <div class="deposit_form">
            <input id="deposit_form_value" type="number" placeholder="Valor do depósito" required>
            <div class="button" id="deposit_form_deposit">
                <div class="button_after">DEPOSITAR</div>
                <button class="button_before" data-action="deposit" type="submit">
                    <div class="button_before_text">CONFIRMAR</div>
                </button>
            </div>
        </div>
    </div>


    <div class="page" id="transfers">
        <div class="title_background">
            <h1 class="title">TRANSFERÊNCIA</h1>
        </div>
        <div id="pages_balance">Seu saldo: <b class="page_balance"></b></div>
        <div class="button" id="button_pay_back">
            <div class="button_after">INÍCIO</div>
            <button class="button_before" data-action="back" data-page="transfers">
                <div class="button_before_text">VOLTAR</div>
            </button>
        </div>
        <div id="transfers_form">
            <input class="transfers_form_itens" id="transfers_form_pix" type="text" placeholder="Chave pix" required>
            <input class="transfers_form_itens" id="transfers_form_value" type="number" placeholder="Valor da transferência" required>
            <div class="button" id="button_transfers_transfers">
                <div class="button_after">TRANFERIR</div>
                <button class="button_before" data-action="transfers" type="submit">
                    <div class="button_before_text">CONFIRMAR</div>
                </button>
            </div>
        </div>
        <div id="transfer_key_title">Minha chave pix:</div>
        <div id="transfers_key_form"></div>
    </div>


    <div class="page" id="loan">
        <div class="title_background">
            <h1 class="title">EMPRÉSTIMO</h1>
        </div>

        <div id="pages_balance">Seu saldo: <b class="page_balance"></b></div>

        <div class="button" id="button_pay_back">
            <div class="button_after">INÍCIO</div>
            <button class="button_before" data-action="back" data-page="loan">
                <div class="button_before_text">VOLTAR</div>
            </button>
        </div>

        <div class="left_content">
            Você pode parcelar o seu empréstimo em até 36 vezes
        </div>

        <div class="left_content">
            Em até 12 vezes, juros de 3,6%</br>
            Em até 24 vezes, juros de 7%</br>
            Em até 36 vezes, juros de 14%</br>
        </div>

        <div class="left_content">
            Ao contratar um empréstimo, seu score será afetado por questões de segurança financeira
        </div>

        <div class="left_content">
            Contrate seu empréstimo sem medo e começe a pagar somente daqui 5 meses
        </div>

        <div class="loans_data" id="loan_available">
            <p>Empréstimo disponível:</p>
            <h3 id="loan_available_value"></h3>
        </div>

        <div class="loans_data" id="loan_contracted">
            <p>Empréstimo contratado:</p>
            <h3 id="loan_contracted_value"></h3>
        </div>

        <div id="loan_installments_title">Parcelas</div>
            
        <div id="loan_installments"></div>

        <div id="loan_form">
            <input class="loan_form_itens" id="loan_form_installments" type="number" placeholder="Dividir em até 36 vezes" required>
            <input class="loan_form_itens" id="loan_form_value" type="number" placeholder="Valor a contratar" required>
            <div class="button" id="button_loan_contract">
                <div class="button_after">CONTRATAR</div>
                <button class="button_before" data-action="loan" id="button_loan_contract_confirm" type="submit">
                    <div class="button_before_text">CONFIRMAR</div>
                </button>
            </div>
        </div>
    </div>


    <div class="page" id="pay">
        <div class="title_background">
            <h1 class="title">FATURAS</h1>
        </div>

        <div id="pages_balance">Seu saldo: <b class="page_balance"></b></div>

        <div class="button" id="button_pay_back">
            <div class="button_after">INÍCIO</div>
            <button class="button_before" data-action="back" data-page="pay">
                <div class="button_before_text">VOLTAR</div>
            </button>
        </div>

        <div id="invoices-info">
            ⠀Emissor:⠀⠀⠀⠀⠀⠀⠀⠀⠀Descrição:⠀⠀⠀⠀⠀⠀⠀⠀⠀Data de vencimento:⠀⠀⠀⠀⠀⠀⠀⠀⠀Valor a pagar:
        </div>

        <div id="invoices"></div>
    </div>
`);

$(document).on('click','.button_before',function(){
    data = {action: $(this).data('action')};
    if(data.action == 'exit') {
        $.post('http://zBank/closeInterface', JSON.stringify({}));
    
    } else if(data.action == 'back'){
        data = {page: $(this).data('page')};
        $(`#${data.page}`).fadeOut(100);
        $(`#home`).fadeIn(100);
    } else if(data.action == 'new_account'){
        let username = document.getElementById('new_account_form_username')
        let password = document.getElementById('new_account_form_password')
        let repassword = document.getElementById('new_account_form_repassword')
        
        if(username.value == ''){
            return 
        }

        if(username.length < 3){
            return 
        }
        
        if(password.value == repassword.value){
            $.post('http://zBank/createAccount', JSON.stringify({username: username.value, password: password.value}))
        } else {
            $.post('http://zBank/notify' , JSON.stringify({status: 'negado', text: 'As senhas não coincidem!'}))
        }
    } else if(data.action == 'reset_password'){
        let password = document.getElementById('reset_form_password')
        let repassword = document.getElementById('reset_form_repassword')

        if(password.value == repassword.value){
            $.post('http://zBank/updatePassword', JSON.stringify({password: password.value}))
        } else {
            $.post('http://zBank/notify' , JSON.stringify({status: 'negado', text: 'As senhas não coincidem!'}))
        }
    } else if(data.action == 'login'){
        let username = document.getElementById('form_login_username')
        let password = document.getElementById('form_login_password')
        $.post('http://zBank/login', JSON.stringify({username: username.value, password: password.value}))
    } else if(data.action == 'pay'){
        data = {invoice: $(this).data('invoice')};
	    $.post('http://zBank/payInvoice', JSON.stringify({account: account, invoice: data.invoice})) 
    }  else if(data.action == 'withdraw'){
        let amount = document.getElementById('withdraw_form_value')
        $.post('http://zBank/withdraw' , JSON.stringify({account: account, amount: amount.value}))
    } else if(data.action == 'deposit'){
        let amount = document.getElementById('deposit_form_value')
        $.post('http://zBank/deposit' , JSON.stringify({account: account, amount: amount.value}))
    }  else if(data.action == 'update_pix'){
        let key = document.getElementById('transfers_key_form_my')
        $.post('http://zBank/update_pix_key' , JSON.stringify({account: account, key: key.value}))
    } else if(data.action == 'transfers'){
        let key = document.getElementById('transfers_form_pix')
        let amount = document.getElementById('transfers_form_value')
        $.post('http://zBank/transfer' , JSON.stringify({account: account, key: key.value, amount: amount.value}))
    } else if(data.action == 'credit_card'){
        $.post('http://zBank/credit_card' , JSON.stringify({}))
    }
})

$(document).on('click','.button_home',function(){
    data = {page: $(this).data('page')};
    $(`#home`).fadeOut(100);
    $(`#${data.page}`).fadeIn(100);
})

$(document).on('click','#reset_password_click',function(){
	$(`#login`).fadeOut(100);
    $(`#reset`).fadeIn(100);
})

$(document).ready(function () {
    window.addEventListener('message', function (event) {
        account = event.data.account;
        switch (event.data.action) {
            case 'newAccount':
                $('#actionmenu').fadeIn(100);
                $('#new_account').fadeIn(100);
            break;

            case 'showLogin':
                $('#actionmenu').fadeIn(100);
                $('#login').fadeIn(100);
                $(`#new_account`).fadeOut(100);
            break;

            case 'showHome':
                $('#actionmenu').fadeIn(100);
                $('#home').fadeIn(100);
                $(`#login`).fadeOut(100);
                getData(account)
            break;

            case 'update':
                getData(account)
            break;

            case 'hideInterface':
                $('#actionmenu').fadeOut(100);
                $('#new_account').fadeOut(100);
                $('#login').fadeOut(100);
                $('#reset').fadeOut(100);
                $('#home').fadeOut(100);
                $('#withdraw').fadeOut(100);
                $('#deposit').fadeOut(100);
                $('#transfers').fadeOut(100);
                $('#loan').fadeOut(100);
                $('#credit').fadeOut(100);
                $('#pay').fadeOut(100);
                account = ''
            break;
        }
    })

    document.onkeydown = function(event){
		if(event.keyCode == 27){
			$.post('http://zBank/closeInterface', JSON.stringify({}));
		}
	}
})

const getData = (account) => {
    $.post('http://zBank/requestData', JSON.stringify({account: account}), (data) => {
        const transactions = data.transactions.sort((a, b) => (a.key < b.key) ? 1: -1);
        const invoices = data.invoices.sort((a, b) => (a.name > b.name) ? 1: -1);
        const loans = data.loans.sort((a, b) => (a.name > b.name) ? 1: -1);

        $('.page_balance').html(`$${data.balance}`)
        $('#balance_data').html(`$${data.balance}`)
        $('#all_debits').html(`Total de débitos: $${data.debts}`)

        $('#loan_available').html(`Disponível: $${data.loan_available}`)
        $('#loan_contracted').html(`Contratado: <b>$${data.loan_contracted}</b>`)

        $('#loan_available_value').html(`$${data.loan_available}`)
        $('#loan_contracted_value').html(`$${data.loan_contracted}`)

        $('#credit_available_value').html(`Limite: $${data.credit_available}`)
        $('#credit_used_value').html(`Em uso: <b>$${data.credit_used}</b>`)
        
        $('#text_score').html(`${data.score}0`)

        $('#last_transactions').html(`
			${transactions.map((item) => (`
                <div class="last_transaction">
                    <img src='images/${item.type}.png'/>
                    <div class="last_transaction_desc">${item.text}</div>
                    <div class="last_transaction_date">${item.date}</div>
                    <div class="last_transaction_value">$${item.value}</div>
                </div>
			`)).join('')}
		`);

        $('#invoices').html(`
            ${invoices.map((item) => (`
                <div class="invoice" data-invoice-id="${item.key}">
                    <div id="invoice_data">
                        <div class="invoice_data_content" id="invoice_data_issuer">${item.issuer}</div>
                        <div class="invoice_data_content" id="invoice_data_description">${item.text}</div>
                        <div class="invoice_data_content" id="invoice_data_date">${item.date}</div>
                        <div class="invoice_data_content" id="invoice_data_price">$${item.price}</div>
                    </div>
                    <div class="button" id="button_invoice">
                        <div class="button_after">PAGAR FATURA</div>
                        <button class="button_before" data-action="pay" data-invoice="${item.key}">
                            <div class="button_before_text">CONFIRMAR</div>
                        </button>
                    </div>
                </div>
            `)).join('')}
        `);

        $('#transfers_key_form').html(`
            <input id="transfers_key_form_my" type="text" placeholder="${data.pix}" required>
            <div class="button" id="button_key_update">
                <div class="button_after">ALTERAR CHAVE</div>
                <button class="button_before" data-action="update_pix" type="submit">
                    <div class="button_before_text">CONFIRMAR</div>
                </button>
            </div>
        `)

        
        $('#loan_installments').html(`
            ${loans.map((item) => (`
                <div class="loan_installment">
                    <div class="loan_installment_itens" id="loan_installment_id">${item.key}</div>
                    <div class="loan_installment_itens" id="loan_installment_name">${item.text}</div>
                    <div class="loan_installment_itens" id="loan_installment_price">$${item.price}</div>
                </div>
            `)).join('')}
        `)

        $('#credit_installments').html(`
            ${loans.map((item) => (`
                <div class="credit_installment">
                    <div class="credit_installment_itens" id="credit_installment_id">${item.key}</div>
                    <div class="credit_installment_itens" id="credit_installment_price">$${item.price}</div>
                </div>
            `)).join('')}
        `)

        var el = document.getElementById('graph'); // get canvas

        var options = {
            percent:  data.score,
            size: el.getAttribute('data-size') || 120,
            lineWidth: el.getAttribute('data-line') || 15,
            rotate: el.getAttribute('data-rotate') || 0
        }

        var canvas = document.createElement('canvas');
        var span = document.createElement('span');
            
        if (typeof(G_vmlCanvasManager) !== 'undefined') {
            G_vmlCanvasManager.initElement(canvas);
        }

        var ctx = canvas.getContext('2d');
        canvas.width = canvas.height = options.size;

        el.appendChild(span);
        el.appendChild(canvas);

        ctx.translate(options.size / 2, options.size / 2); // change center
        ctx.rotate((-1 / 2 + options.rotate / 180) * Math.PI); // rotate -90 deg

        var radius = (options.size - options.lineWidth) / 2;

        var drawCircle = function(color, lineWidth, percent) {
            percent = Math.min(Math.max(0, percent || 1), 1);
            ctx.beginPath();
            ctx.arc(0, 0, radius, 0, Math.PI * 2 * percent, false);
            ctx.strokeStyle = color;
            ctx.lineCap = 'round'; // butt, round or square
            ctx.lineWidth = lineWidth
            ctx.stroke();
        };

        var color = ''
        let progressValue = 0
        let progressEndValue = options.percent
        let speed = 15

        let progress = setInterval(() => {
            progressValue++
        
            if(progressValue <= 30){
                color = '#D20000'
            } else if(progressValue > 30 && progressValue <= 50){
                color = '#F26100'
            } else if(progressValue > 50 && progressValue <= 70){
                color = '#F2E800'
            } else if(progressValue > 70){
                color = '#00B81C'
            }
        
            drawCircle(color, options.lineWidth, progressValue / 100);
            if (progressValue == progressEndValue) {
                clearInterval(progress)
            }
        }, speed)
        
        drawCircle('#0A0A0A', options.lineWidth, 100 / 100);
    })
}