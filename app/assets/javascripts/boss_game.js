function initBossBars() {
  var boss_current_hp = $('#boss-current-hp').text();
  var boss_max_hp = $('#boss-max-hp').text();
  var boss_shield = $('#boss-shield').text()
  updateBossBars(boss_current_hp, boss_max_hp, boss_shield)
};

function updateBossBars(current_hp, max_hp, shield) {
  var health_percentage = (current_hp / max_hp) * 100
  var health_width = health_percentage + '%'
  $('.boss-card-content-bottom-top-life-current').animate({width: health_width}, 1000, function() {});

  var shield_percentage = (shield / max_hp) * 100
  var shield_width = shield_percentage + '%'
  $('.boss-card-content-bottom-bottom-shield-current').animate({width: shield_width}, 1000, function() {});
};

function updateBoss(data) {
  var name = $('#boss-name').text()
  if (name != data['boss_name']) {
    $('#boss-name').text(data['boss_name']);
  }

  var current_hp = $('#boss-current-hp').text();
  $('#boss-current-hp').prop('number', current_hp).animateNumber({number: data['boss_current_hp'], easing: 'ease',}, 'slow');

  var max_hp = $('#boss-max-hp').text();
  $('#boss-max-hp').prop('number', max_hp).animateNumber({number: data['boss_max_hp'], easing: 'ease',}, 'slow');

  var shield = $('#boss-shield').text();
  $('#boss-shield').prop('number', shield).animateNumber({number: data['boss_shield'], easing: 'ease',}, 'slow');

  updateBossBars(data['boss_current_hp'], data['boss_max_hp'], data['boss_shield']);

  var boss_avatar = data['boss_avatar'];
  if (boss_avatar == null || boss_avatar == '') {
    var src = 'https://www.wallstreetotc.com/wp-content/uploads/2014/10/facebook-anonymous-app.jpg';
  } else {
    var src = boss_avatar;
  }
  $('#boss-avatar').attr('src', src);
}

$(document).ready(function() {
  initBossBars();
});
