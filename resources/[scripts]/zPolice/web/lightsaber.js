$(function () {
    Everest.init();
});
var htmlOriginal = $(".body").html();
var time = 20000;
var bloq = false;
var passaporteAtual = 0;

var Everest = {}
Everest = {
    init: function () {
        window.addEventListener('message', function (event) {
            if (event.data.type === "abrirTablet") {
                $("#painel_control_people").fadeIn();
            }
            if (event.data.type === "fecharTablet") {
                $("#painel_control_people").fadeOut();
            }
            if (event.data.type === "setPassaporte") {
                Everest.setPassaporte(event.data.identity, event.data.multas);
                Swal.close();   // ativei
            }
            if (event.data.type === "reloadPassaporte") {
                this.setTimeout(Everest.getPassaporte(), 1000);
            }
            if (event.data.type === "setListaMultas") {
                Everest.setListaMultas(event.data.multas, false);
            }
            if (event.data.type === "setListaPrisoes") {
                Everest.getFichaCriminal(event.data.prisoes, false);
            }
            if (event.data.type === "getListafugitives") {
                Everest.getListafugitives(event.data.lista, false);
            }
            if (event.data.type === "getListaOcorrencias") {
                Everest.getListaOcorrencias(event.data.lista, false);
            }
        });

        document.onkeyup = function (data) {
            if (data.which == 27) {
                Everest.sendData("ButtonClick", { action: "fecharTablet" }, false);
            }
        }

        $("#painel_control_people .body").height($('#painel_control_people').height() - $(".header").height());
        window.onresize = function () {
            $("#painel_control_people .body").height($('#painel_control_people').height() - $(".header").height());
        }

        $('.modal').on('hidden.bs.modal', function () {
            $('.modal .modal-body').html("");
        });
    },
    getPassaporte: function () {
        var passaporte = $("input[name=passaporte]").val();
        Everest.sendData("ButtonClick", { action: "getPassaporte", passaporte: passaporte });
    },
    setPassaporte: function (identity, multas) {

        if (identity == null) {
            Everest.Alert("danger", "Passaporte inválido!", true);
            return false;
        }
        var dados = htmlOriginal;
        if (identity.fugitive == 1) {
            dados = dados.replace("{NOME}", identity.name + " " + identity.firstname + " <span class=\"label label-default label-danger\">PROCURADO</span>");
        } else {
            dados = dados.replace("{NOME}", identity.name + " " + identity.firstname);
        }
        let id = event.data.user_id
        dados = dados.replace("{PASSAPORTE}", id);
        dados = dados.replace("{RG}", identity.registration);
        dados = dados.replace("{TELEFONE}", identity.phone);
        dados = dados.replace("{TOTALMULTAS}", multas);
        dados = dados.replace("{fugitive}", identity.fugitive);
        
        $("#painel_control_people .body").show();
        $(".body").html(dados);
        Everest.AlertClose();
    },
    setMulta: function () {
        Swal.mixin({
            input: 'text',
            confirmButtonText: 'Próximo &rarr;',
            showCancelButton: true,
            progressSteps: ['1', '2']
        }).queue([
            {
                title: 'Etapa 1',
                text: 'Informe o motivo da multa!',
                input: 'textarea',
            },
            {
                title: 'Etapa 2',
                text: 'Informe o valor da multa!',
                input: 'number',
            },

        ]).then((result) => {
            Everest.Alert("info", "Aguarde...");
            var passaporte = $("input[name=passaporte]").val();

            if (passaporte === "") {

                $(".body").html("");
                return false;
            }
            setTimeout(function () {
                Everest.Alert("success", "Multa aplicada com sucesso!", true);
                Everest.sendData("ButtonClick", {
                    action: "setMulta",
                    passaporte: passaporte,
                    descricao: result.value[0].replace(/\r\n|\r|\n/g, "<br />"),
                    valor: parseInt(result.value[1]),
                }, true);
                Swal.close();
                return false;
            }, 500);
        });
    },
    setOcorrencia: async function () {
        var passaporte = $("input[name=passaporte]").val();

        if (passaporte === "") {

            $(".body").html("");
            return false;
        }

        const { value: text } = await Swal.fire({
            input: 'textarea',
            inputPlaceholder: 'Escreva a ocorrência aqui!',
            inputAttributes: {
                'aria-label': 'Escreva a ocorrência aqui'
            },
            showCancelButton: true
        });

        Everest.Alert("info", "Aguarde...");

        setTimeout(function () {
            Everest.saveOcorrencia(passaporte, text, "");
        }, 500);
    },
    saveOcorrencia: function (passaporte, msg, img) {
        var passaporte = $("input[name=passaporte]").val();

        if (passaporte === "") {

            $(".body").html("");
            return false;
        }

        Everest.Alert("success", "Ocorrência efetuada com sucesso!", true);
        Everest.sendData("ButtonClick", {
            action: "setOcorrencia",
            passaporte: passaporte,
            descricao: msg.replace(/\r\n|\r|\n/g, "<br />"),
            valor: 0,
            pena: 0,
        }, false);
    },
    setPrisao: function () {
        Swal.mixin({
            input: 'text',
            confirmButtonText: 'Próximo &rarr;',
            showCancelButton: true,
            progressSteps: ['1', '2', '3']
        }).queue([
            {
                title: 'Etapa 1',
                text: 'Informe detalhes da prisão!',
                input: 'textarea',
            },
            {
                title: 'Etapa 2',
                text: 'Informe o valor da multa!',
                input: 'number',
            },
            {
                title: 'Etapa 3',
                text: 'Informe os meses  de prisão!',
                input: 'number',
                footer: 'No máximo 600 meses!'
            },

        ]).then((result) => {
            Everest.Alert("info", "Aguarde...");
            var passaporte = $("input[name=passaporte]").val();
            if (passaporte === "") {
    
                $(".body").html("");
                return false;
            }
            setTimeout(function () {
                Everest.savePrisao(passaporte, result, null);
            }, 500);
        });
    },
    savePrisao: function (passaporte, result, img) {
        var passaporte = $("input[name=passaporte]").val();
        if (passaporte === "") {

            $(".body").html("");
            return false;
        }
        Everest.Alert("success", "Prisão efetuada com sucesso!", true);
        Everest.sendData("ButtonClick", {
            action: "setPrisao",
            passaporte: passaporte,
            descricao: result.value[0].replace(/\r\n|\r|\n/g, "<br />"),
            multa: parseInt(result.value[1]),
            pena: parseInt(result.value[2]),
        }, false);
    },

    setfugitive: function (status) {
        var passaporte = $("input[name=passaporte]").val();
        if (passaporte === "") {

            $(".body").html("");
            return false;
        }
        var text = "Você está prestes a incluir este cidadão na lista de procurados!";
        if (status == 1) {
            text = "Remover da lista de procurados?";
        }
        Swal.fire({
            title: 'Atenção?',
            text: text,
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            // cancelButtonColor: '#d33',
            cancelButtonText: 'Cancelar',
            confirmButtonText: 'Sim, continuar!'
        }).then(async (result) => {
            if (result.value) {
                Everest.Alert("success", "Atualizado na lista de Procurados!", true);
                setTimeout(function () {
                    Everest.sendData("ButtonClick", {
                        action: "setfugitive",
                        passaporte: passaporte,
                        descricao: text.replace(/\r\n|\r|\n/g, "<br />"),
                        multa: 0,
                        valor: status,
                    }, false);
                }, 500);
            }
        });
    },
   
    getFichaCriminal: function (prisoes, request) {
        var htmlprisoes = '<div class="row" id="multa_{ID}">' +
            '<div class="col-sm-12">' +
            '<div class="thumbnail">' +
            '<div class="caption">' +
            '<strong>Motivo:</strong> {MOTIVO}' +
            '<br><strong>Oficial:</strong> {POLICIAL}' +
            '<br><strong>Data:</strong> {DATA}' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        if (request) {
            var passaporte = $("input[name=passaporte]").val();
            Everest.sendData("ButtonClick", { action: "getPrisoes", passaporte: passaporte }, true);
        } else {
            if (prisoes.length == 0) {
                Everest.newModal("Ficha Criminal", "<strong>Nada Encontrado</strong>");
            } else {
                var htmlAux = "";
                $(prisoes).each(function (index, data) {
                    var html = htmlprisoes;

                    html = html.replace("{ID}", index);
                    html = html.replace("{MOTIVO}", data.prisonDesc);
                    html = html.replace("{POLICIAL}", data.oficialnameprison);
                    html = html.replace("{DATA}", data.datePrison);
                    htmlAux += html;
                });
                Everest.newModal("Ficha Criminal", htmlAux);
            }
        }
    },
    setListaMultas: function (multas, request) {
        if (request) {
            var passaporte = $("input[name=passaporte]").val();

            if (passaporte === "") {

                $(".body").html("");
                return false;
            }

            Everest.sendData("ButtonClick", { action: "getMultas", passaporte: passaporte });
        } else {
            Everest.AlertClose();
            if (multas.length == 0) {
                Everest.newModal("Multas", "<strong>Nada Encontrado</strong>");
            } else {
                var htmlAux = "";
                $(multas).each(function (index, data) {
                    var html = '<div class="row" id="multa_{ID}">' +
                    '<div class="col-sm-12">' +
                    '<div class="thumbnail">' +
                    // '{IMG}' +
                    '<div class="caption">' +
                    '<strong>Valor:</strong> $ {VALOR}' +
                    '<br><strong>Motivo:</strong> {MOTIVO}' +
                    '<br><strong>Oficial:</strong> {POLICIAL}' +
                    '<br><strong>Data:</strong> {DATA}' +
                    '</div>' +
                    '</div>' +
                    '</div>' +
                    '</div>';

                    html = html.replace("{ID}", multas.id);
                    html = html.replace("{VALOR}", data.price);
                    html = html.replace("{MOTIVO}", data.text);
                    html = html.replace("{POLICIAL}", data.name);
                    html = html.replace("{DATA}", data.date);

                    htmlAux += html;
                });
                Everest.newModal("Multas", htmlAux);
            }
            Swal.close();   
        }
    },

    getListafugitives: function (multas, request) {

        if (request) {
            Everest.sendData("ButtonClick", { action: "getListafugitives" }, true);
        } else {
            Everest.AlertClose();

            if (multas.length == 0) {
                Everest.newModal("PESSOAS PROCURADAS", "<strong>Nada Encontrado</strong>");
            } else {
                var htmlAux = "";
                $(multas).each(function (index, data) {
                    var html = '<div class="row" id="multa_{ID}">' +
                        '<div class="col-sm-4">' +
                        '<div class="thumbnail">' +
                        '</div>' +
                        '</div>' +
                        '<div class="col-sm-8">' +
                        '<strong>Nome:</strong> {NOME_fugitive}' +
                        '<br><strong>Oficial Responsável:</strong> {POLICIAL}' +
                        '<br><strong>Data:</strong> {DATA}' +
                        '</div>' +
                        '</div><div class="row"><div class="col-sm-12"><hr></div></div>';

                    html = html.replace("{ID}", index);
                    html = html.replace("{NOME_fugitive}", data.fugitivename + ' ' + data.fugitiveid);
                    html = html.replace("{MOTIVO}", data.dvalue);
                    html = html.replace("{POLICIAL}", data.oficialname + " " + data.oficialid);
                    html = html.replace("{DATA}", data.date);
                    htmlAux += html;
                });
                Everest.newModal("LISTA DE PROCURADOS", htmlAux);
            }


            Swal.close();
        }
    },

    getListaOcorrencias: function (multas, request, passaporte) {
        var passaporte = $("input[name=passaporte]").val();

        if (passaporte === "") {
            passaporte = false
        }
        if (request) {
            Everest.sendData("ButtonClick", { action: "getListaOcorrencias", passaporte: passaporte}, true);
        } else {
            Everest.AlertClose();

            if (multas.length == 0) {
                Everest.newModal("Ocorrências", "<strong>Nada Encontrado</strong>");
            } else {
                var htmlAux = "";
                $(multas).each(function (index, data) {
                    var html = '<div class="row" id="multa_{ID}">' +
                        '<div class="col-sm-4">' +
                        '<div class="thumbnail">' +
                        '</div>' +
                        '</div>' +
                        '<div class="col-sm-8">' +
                        '<strong>Nome: {NOME_fugitive} ' +
                        '<br><strong>Motivo:</strong> {MOTIVO}' +
                        '<br><strong>Oficial Responsável:</strong> {POLICIAL}' +
                        '<br><strong>Data:</strong> {DATA}' +
                        '</div>' +
                        '</div><div class="row"><div class="col-sm-12"><hr></div></div>';

                    html = html.replace("{NOME_fugitive}", data.fugitivename + ' | ' + data.fugitiveid);
                    html = html.replace("{MOTIVO}", data.desc);
                    html = html.replace("{POLICIAL}", data.oficialname + ' | ' + data.oficialid);
                    html = html.replace("{DATA}", data.date);
                    htmlAux += html;
                });
                Everest.newModal("Ocorrências", htmlAux);
            }


            Swal.close();   
        }
    },

    Alert: function (type, msg, bloquear) {
        if (bloq == false) {
            bloq = (bloquear == null ? false : bloquear);

            $("#alert").html(msg).removeClass().addClass(type).fadeIn();

            setTimeout(function () {
                $("#alert").fadeOut();
                bloq = false;
            }, 10000);
        }
    },
    AlertClose: function () {

        setTimeout(function () {
            if (bloq === false) {
                $("#alert").fadeOut();
            }
        }, 500);

    },
    sendData: function (name, data, load) {
        var time = 0;
        if (load !== false) {
            Everest.Alert("info", "Aguarde...");
            time = 500;
        }
        setTimeout(function () {
            $.post("http://zPolice/" + name, JSON.stringify(data));
        }, time);
    },
    newModal:function(title, html) {
        var random = Math.floor((Math.random() * 100) + 1);
        var modalHtml = '<div class="modal" tabindex="-1" role="dialog" id="modal'+random+'">'+
                        '<div class="modal-dialog modal-md" role="document">'+
                            '<div class="modal-content">'+
                            '<div class="modal-header">'+
                                '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>'+
                                    '<h4 class="modal-title">'+title+'</h4>'+
                                    '</div>'+
                                '<div class="modal-body">'+html+'</div>'+
                                '</div>'+
                            '</div>'+
                        '</div>';

        $("#modals").append(modalHtml);
        $('#modal'+random).modal("show");
        $('#modal'+random).on('hidden.bs.modal', function () {
            $(this).remove();
        });
    }
}