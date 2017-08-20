var life_bar, heal_bar, damage_bar, shield_bar;

function initBossBars() {
  var boss_current_hp = $('#boss-current-hp').text();
  var boss_max_hp = $('#boss-max-hp').text();
  var boss_current_shield = $('#boss-current-shield').text()
  var boss_max_shield = $('#boss-max-shield').text()
  life_bar.set(boss_current_hp / boss_max_hp);
  heal_bar.set(boss_current_hp / boss_max_hp);
  damage_bar.set(boss_current_hp / boss_max_hp);
  shield_bar.set(boss_current_shield / boss_max_shield)
  $('#boss-life-percent').text(Math.floor(parseFloat(life_bar.value()) * 100));
  $('#boss-shield-percent').text(Math.floor(parseFloat(shield_bar.value()) * 100));
};

function healBoss(current_hp, max_hp, shield) {
  var health_percentage = current_hp / max_hp
  heal_bar.set(health_percentage)
  damage_bar.set(health_percentage)
  life_bar.animate(health_percentage, { duration: 2000 })
}

function damageBoss(current_hp, max_hp, shield) {
  var health_percentage = current_hp / max_hp
  heal_bar.set(health_percentage)
  life_bar.set(health_percentage)
  damage_bar.animate(health_percentage, { duration: 2000 })
}

function updateBoss(data) {
  var name = $('#boss-name').text()
  if (name != data['boss_name']) {
    $('#boss-name').text(data['boss_name']);
  }

  var current_hp = $('#boss-current-hp').text();
  $('#boss-current-hp').prop('number', current_hp).animateNumber({number: data['boss_current_hp'], easing: 'ease',}, 2000);

  var max_hp = $('#boss-max-hp').text();
  $('#boss-max-hp').prop('number', max_hp).animateNumber({number: data['boss_max_hp'], easing: 'ease',}, 2000);

  var current_percent = (current_hp / max_hp) * 100
  var new_percent = (parseInt(data['boss_current_hp']) / parseInt(data['boss_max_hp'])) * 100
  $('#boss-life-percent').prop('number', current_percent).animateNumber({number: new_percent, easing: 'ease',}, 2000);

  var shield = $('#boss-shield').text();
  $('#boss-shield').prop('number', shield).animateNumber({number: data['boss_shield'], easing: 'ease',}, 2000);


  if (data['heal']) {
    healBoss(data['boss_current_hp'], data['boss_max_hp'], data['boss_shield']);
  } else if (data['damages']) {
    damageBoss(data['boss_current_hp'], data['boss_max_hp'], data['boss_shield']);
  }

  var boss_avatar = data['boss_avatar'];
  if (boss_avatar == null || boss_avatar == '') {
    var src = 'https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_300x300.png';
  } else {
    var src = boss_avatar;
  }
  $('#boss-avatar').attr('src', src);
}

$(document).ready(function() {
  shield_bar = new ProgressBar.Circle('#shield-circle', {
    strokeWidth: 20,
    color: '#00aeef'
  });

  damage_bar = new ProgressBar.Circle('#life-circle', {
    strokeWidth: 10,
    color: '#940000'
  });

  heal_bar = new ProgressBar.Circle('#life-circle', {
    strokeWidth: 10,
    color: '#0BC91D'
  });

  life_bar = new ProgressBar.Circle('#life-circle', {
    strokeWidth: 10,
    color: '#018404'
  });

  initBossBars();
});
