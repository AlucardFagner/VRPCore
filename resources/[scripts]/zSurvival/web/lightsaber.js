$(function () {
  window.addEventListener('message', function (event) {
    var convertedMinutes = event.data.deathtimer
    var convertedSeconds = event.data.deathtimer

    convertedMinutes = Math.floor(event.data.deathtimer / 60)
    convertedSeconds = Math.floor(event.data.deathtimer % 60)

    var item = event.data;
 
    if (item.setDisplay) {
      $('#fainting').css('display', 'block');
      $('#clocktexto').html(`Você temﾠﾠㅤㅤﾠde vida.`)
      $('#clock').html(`${convertedMinutes}:${convertedSeconds}`);
    } else {
      $('#fainting').css('display', 'none');
    }

    if (item.setDisplayDead) {
      $('#Death').css('display', 'block');
      $('#clock').html(``);
    } else {
      $('#Death').css('display', 'none');
    }

    if (item.deathButton) {
      location.reload()
    }
  });
});

const DeathV = document.querySelector('#DeathB');

DeathV.addEventListener('click', event => {
  $.post('https://zSurvival/ButtonRevive')
});

function abrirModal() {
  document.getElementById('popup-1').classList.toggle('active');
}

function fecharModal() {
  document.getElementById('popup-1').classList.toggle('active');
}

function simAceita() {
  document.getElementById('popup-1').classList.toggle('active');
  $.post('https://zSurvival/ButtonRevive');
  $('.container').hide();
}