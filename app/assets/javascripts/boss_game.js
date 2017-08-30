
function initBossBars () {
  var boss_current_hp = $('#boss-current-hp').text()
  var boss_max_hp = $('#boss-max-hp').text()
  var boss_current_shield = $('#boss-current-shield').text()
  var boss_max_shield = $('#boss-max-shield').text()
  if (boss_current_shield > "0") {
    $('.boss-life-logo').addClass('hidden')
    $('.boss-life-outter-border').addClass('hidden')
    $('.boss-life-inner-border').addClass('hidden')
    $('.boss-life-fill').addClass('hidden')
    $('.boss-life-text').addClass('hidden')
    $('.boss-shield-logo').removeClass('hidden')
    $('.boss-shield-outter-border').removeClass('hidden')
    $('.boss-shield-inner-border').removeClass('hidden')
    $('.boss-shield-fill').removeClass('hidden')
    $('.boss-shield-text').removeClass('hidden')
  }

  if ($('.boss-name-container')[0].scrollWidth < $('.boss-name')[0].scrollWidth) {
    $('.boss-name').addClass('scrolling-text')
  } else {
    $('.boss-name').removeClass('scrolling-text')
  }

  life_bar.set(boss_current_hp / boss_max_hp)
  heal_bar.set(boss_current_hp / boss_max_hp)
  damage_bar.set(boss_current_hp / boss_max_hp)
  shield_bar.set(boss_current_shield / boss_max_shield)
  shield_bar_bg.set(boss_current_shield / boss_max_shield)
  shield_bar_green_bg.set(1)

  $('#boss-life-percent').text(Math.floor(parseFloat(life_bar.value()) * 100))
  $('#boss-shield-percent').text(Math.floor(parseFloat(shield_bar.value()) * 100))
};

function healBoss (data) {
  var current_hp = $('#boss-current-hp').text()
  if (data['boss_current_hp'] < 0) {
    var new_hp = 0
  } else {
    var new_hp = data['boss_current_hp']
  }
  $('#boss-current-hp').prop('number', current_hp).animateNumber({number: new_hp, easing: 'ease'}, 2000)

  var max_hp = $('#boss-max-hp').text()

  var current_hp_percent = (current_hp / max_hp) * 100
  var new_hp_percent = (new_hp / max_hp) * 100
  console.log(new_hp_percent)
  $('#boss-life-percent').prop('number', current_hp_percent).animateNumber({number: new_hp_percent, easing: 'ease'}, 2000)

  var health_percentage = new_hp / max_hp

  heal_bar.set(health_percentage)
  damage_bar.set(health_percentage)
  life_bar.animate(health_percentage, { duration: 2000 })
  healAnim()
};

function damageBoss (data) {
  if ($('.boss-shield-logo').is(':visible')) {
    $('.boss-shield-logo').addClass('hidden')
    $('.boss-shield-outter-border').addClass('hidden')
    $('.boss-shield-inner-border').addClass('hidden')
    $('.boss-shield-fill').addClass('hidden')
    $('.boss-shield-text').addClass('hidden')
    $('.boss-life-logo').removeClass('hidden')
    $('.boss-life-outter-border').removeClass('hidden')
    $('.boss-life-inner-border').removeClass('hidden')
    $('.boss-life-fill').removeClass('hidden')
    $('.boss-life-text').removeClass('hidden')
  }

  var current_hp = $('#boss-current-hp').text()
  if (data['boss_current_hp'] < 0) {
    var new_hp = 0
  } else {
    var new_hp = data['boss_current_hp']
  }
  $('#boss-current-hp').prop('number', current_hp).animateNumber({number: new_hp, easing: 'ease'}, 2000)

  var max_hp = $('#boss-max-hp').text();

  var current_hp_percent = (current_hp / max_hp) * 100
  var new_hp_percent = (new_hp / max_hp) * 100
  console.log(new_hp_percent)
  $('#boss-life-percent').prop('number', current_hp_percent).animateNumber({number: new_hp_percent, easing: 'ease'}, 2000)

  var health_percentage = new_hp / max_hp
  heal_bar.set(health_percentage)
  life_bar.set(health_percentage)
  damage_bar.animate(health_percentage, { duration: 2000 })

  strikeAnim(current_hp - new_hp)
  $('.boss').animateCss('shake')
};

function addShield (data) {
  if ($('.boss-life-logo').is(':visible')) {
    $('.boss-life-logo').addClass('hidden')
    $('.boss-life-outter-border').addClass('hidden')
    $('.boss-life-inner-border').addClass('hidden')
    $('.boss-life-fill').addClass('hidden')
    $('.boss-life-text').addClass('hidden')
    $('.boss-shield-logo').removeClass('hidden')
    $('.boss-shield-outter-border').removeClass('hidden')
    $('.boss-shield-inner-border').removeClass('hidden')
    $('.boss-shield-fill').removeClass('hidden')
    $('.boss-shield-text').removeClass('hidden')
  }

  var new_shield = data['boss_shield']

  var current_shield = $('#boss-current-shield').text()
  $('#boss-current-shield').prop('number', current_shield).animateNumber({number: new_shield, easing: 'ease'}, 2000)

  var max_shield = $('#boss-max-shield').text();

  var current_shield_percent = (current_shield / max_shield) * 100
  var new_shield_percent = ( new_shield / max_shield) * 100
  $('#boss-shield-percent').prop('number', current_shield_percent).animateNumber({number: new_shield_percent, easing: 'ease'}, 2000)

  var shield_percentage = new_shield / max_shield
  shield_bar_bg.set(shield_percentage)
  shield_bar.animate(shield_percentage, { duration: 2000 })
};

function damageShield (data) {
  var new_shield = data['boss_shield']
  var max_shield = $('#boss-max-shield').text()

  var current_shield = $('#boss-current-shield').text()
  $('#boss-current-shield').prop('number', current_shield).animateNumber({number: new_shield, easing: 'ease'}, 2000)

  var current_shield_percent = (current_shield / max_shield) * 100
  var new_shield_percent = (new_shield / max_shield) * 100
  $('#boss-shield-percent').prop('number', current_shield_percent).animateNumber({number: new_shield_percent, easing: 'ease'}, 2000)

  var shield_percentage = new_shield / max_shield;
  shield_bar.set(shield_percentage);
  shield_bar_bg.animate(shield_percentage, { duration: 2000 }, function () {
    if ($('#boss-current-shield').text() === '0') {
      $('.boss-shield-logo').addClass('hidden')
      $('.boss-shield-outter-border').addClass('hidden')
      $('.boss-shield-inner-border').addClass('hidden')
      $('.boss-shield-fill').addClass('hidden')
      $('.boss-shield-text').addClass('hidden')
      $('.boss-life-logo').removeClass('hidden')
      $('.boss-life-outter-border').removeClass('hidden')
      $('.boss-life-inner-border').removeClass('hidden')
      $('.boss-life-fill').removeClass('hidden')
      $('.boss-life-text').removeClass('hidden')
    }
  });

  strikeAnim(current_hp - new_hp)
  $('.boss').animateCss('shake')
};

function changeBoss (data) {
  $('.boss-name').text(data['boss_name']);

  if ($('.boss-name-container')[0].scrollWidth < $('.boss-name')[0].scrollWidth) {
    $('.boss-name').addClass('scrolling-text')
  } else {
    $('.boss-name').removeClass('scrolling-text')
  }

  var boss_avatar = data['boss_avatar']
  if (boss_avatar == null || boss_avatar == '') {
    $('.boss-avatar').css('background-image', "url('https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_300x300.png')")
  } else {
    $('.boss-avatar').css('background-image', "url('" + boss_avatar + "')")
  }

  var current_hp = $('#boss-current-hp').text();
  var new_hp = data['boss_current_hp'];
  $('#boss-current-hp').prop('number', current_hp).animateNumber({number: new_hp, easing: 'ease'}, 2000)

  var max_hp = $('#boss-max-hp').text();
  var new_max_hp = data['boss_max_hp']
  $('#boss-max-hp').prop('number', max_hp).animateNumber({number: new_max_hp, easing: 'ease'}, 2000)

  var current_hp_percent = (current_hp / max_hp) * 100
  var new_hp_percent = (new_hp / new_max_hp) * 100
  console.log(new_hp_percent)
  $('#boss-life-percent').prop('number', current_hp_percent).animateNumber({number: new_hp_percent, easing: 'ease'}, 2000)

  heal_bar.set(1)
  damage_bar.set(1)
  life_bar.animate(1, { duration: 2000 })
};

function updateBoss (data) {
  if (data['heal']) {
    healBoss(data)
  } else if (data['damages']) {
    damageBoss(data)
  } else if (data['add_shield']) {
    addShield(data)
  } else if (data['damage_shield']) {
    damageShield(data)
  } else if (data['new_boss']) {
    changeBoss(data)
  }
};
