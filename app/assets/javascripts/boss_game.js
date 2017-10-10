var isDelayed = false;

function initBossBars () {
  var bossCurrentHp = $("#boss-current-hp").text();
  var bossMaxHp = $("#boss-max-hp").text();
  var bossCurrentShield = $("#boss-current-shield").text();
  var bossMaxShield = $("#boss-max-shield").text();
  if (bossCurrentShield > "0") {
    $(".boss-life-logo").addClass("hidden");
    $(".boss-life-outter-border").addClass("hidden");
    $(".boss-life-inner-border").addClass("hidden");
    $(".boss-life-fill").addClass("hidden");
    $(".boss-life-text").addClass("hidden");
    $(".boss-shield-logo").removeClass("hidden");
    $(".boss-shield-outter-border").removeClass("hidden");
    $(".boss-shield-inner-border").removeClass("hidden");
    $(".boss-shield-fill").removeClass("hidden");
    $(".boss-shield-text").removeClass("hidden");
  }

  if ($(".boss-name-container")[0].scrollWidth < $(".boss-name")[0].scrollWidth) {
    $(".boss-name").addClass("scrolling-text");
  } else {
    $(".boss-name").removeClass("scrolling-text");
  }

  lifeBar.set(bossCurrentHp / bossMaxHp);
  healBar.set(bossCurrentHp / bossMaxHp);
  damageBar.set(bossCurrentHp / bossMaxHp);
  shieldBar.set(bossCurrentShield / bossMaxShield);
  shieldBarBg.set(bossCurrentShield / bossMaxShield);
  shieldBarGreenBg.set(1);

  $("#boss-life-percent").text(Math.floor(parseFloat(lifeBar.value()) * 100));
  $("#boss-shield-percent").text(Math.floor(parseFloat(shieldBar.value()) * 100));
};

function healBoss (data) {
  var currentHp = $("#boss-current-hp").text();
  if (data["boss_current_hp"] < 0) {
    var newHp = 0;
  } else {
    var newHp = data["boss_current_hp"];
  }
  $("#boss-current-hp").prop("number", currentHp).animateNumber({number: newHp, easing: "ease"}, 2000);

  var maxHp = $("#boss-max-hp").text();

  var currentHpPercent = (currentHp / maxHp) * 100;
  var newHpPercent = (newHp / maxHp) * 100;
  $("#boss-life-percent").prop("number", currentHpPercent).animateNumber({number: newHpPercent, easing: "ease"}, 2000);

  var healthPercentage = newHp / maxHp;

  healBar.set(healthPercentage);
  damageBar.set(healthPercentage);
  lifeBar.animate(healthPercentage, { duration: 2000 }, function () {
    isDelayed = false;
    updateBoss();
  });
  healAnim();
};

function damageBoss (data) {
  if ($(".boss-shield-logo").is(":visible")) {
    $(".boss-shield-logo").addClass("hidden");
    $(".boss-shield-outter-border").addClass("hidden");
    $(".boss-shield-inner-border").addClass("hidden");
    $(".boss-shield-fill").addClass("hidden");
    $(".boss-shield-text").addClass("hidden");
    $(".boss-life-logo").removeClass("hidden");
    $(".boss-life-outter-border").removeClass("hidden");
    $(".boss-life-inner-border").removeClass("hidden");
    $(".boss-life-fill").removeClass("hidden");
    $(".boss-life-text").removeClass("hidden");
  }

  var currentHp = $("#boss-current-hp").text();
  if (data["boss_current_hp"] < 0) {
    var newHp = 0;
  } else {
    var newHp = data["boss_current_hp"];
  }
  var maxHp = $("#boss-max-hp").text();
  var currentHpPercent = (currentHp / maxHp) * 100;
  var newHpPercent = (newHp / maxHp) * 100;
  var healthPercentage = newHp / maxHp;

  strikeAnim(currentHp - newHp);

  setTimeout(function () {
      $(".boss").animateCss("shake");
      $("#boss-current-hp").prop("number", currentHp).animateNumber({number: newHp, easing: "ease"}, 2000);
      $("#boss-life-percent").prop("number", currentHpPercent).animateNumber({number: newHpPercent, easing: "ease"}, 2000);
      healBar.set(healthPercentage);
      lifeBar.set(healthPercentage);
      damageBar.animate(healthPercentage, { duration: 2000 }, function () {
        isDelayed = false;
        updateBoss();
      });
    }, 1000
  );
};

function addShield (data) {
  if ($(".boss-life-logo").is(":visible")) {
    $(".boss-life-logo").addClass("hidden");
    $(".boss-life-outter-border").addClass("hidden");
    $(".boss-life-inner-border").addClass("hidden");
    $(".boss-life-fill").addClass("hidden");
    $(".boss-life-text").addClass("hidden");
    $(".boss-shield-logo").removeClass("hidden");
    $(".boss-shield-outter-border").removeClass("hidden");
    $(".boss-shield-inner-border").removeClass("hidden");
    $(".boss-shield-fill").removeClass("hidden");
    $(".boss-shield-text").removeClass("hidden");
  }

  var newShield = data["boss_current_shield"];

  var currentShield = $("#boss-current-shield").text();
  $("#boss-current-shield").prop("number", currentShield).animateNumber({number: newShield, easing: "ease"}, 2000);

  var maxShield = $("#boss-max-shield").text();

  var currentShieldPercent = (currentShield / maxShield) * 100;
  var newShieldPercent = ( newShield / maxShield) * 100;
  $("#boss-shield-percent").prop("number", currentShieldPercent).animateNumber({number: newShieldPercent, easing: "ease"}, 2000);

  var shieldPercentage = newShield / maxShield;
  shieldBarBg.set(shieldPercentage);
  shieldBar.animate(shieldPercentage, { duration: 2000 }, function () {
    isDelayed = false;
    updateBoss();
  });
};

function damageShield (data) {
  var newShield = data["boss_current_shield"];
  var maxShield = $("#boss-max-shield").text();

  var currentShield = $("#boss-current-shield").text();
  $("#boss-current-shield").prop("number", currentShield).animateNumber({number: newShield, easing: "ease"}, 2000);

  var currentShieldPercent = (currentShield / maxShield) * 100;
  var newShieldPercent = (newShield / maxShield) * 100;
  $("#boss-shield-percent").prop("number", currentShieldPercent).animateNumber({number: newShieldPercent, easing: "ease"}, 2000);

  var shieldPercentage = newShield / maxShield;
  shieldBar.set(shieldPercentage);
  shieldBarBg.animate(shieldPercentage, { duration: 2000 }, function () {
    if ($("#boss-current-shield").text() === "0") {
      $(".boss-shield-logo").addClass("hidden");
      $(".boss-shield-outter-border").addClass("hidden");
      $(".boss-shield-inner-border").addClass("hidden");
      $(".boss-shield-fill").addClass("hidden");
      $(".boss-shield-text").addClass("hidden");
      $(".boss-life-logo").removeClass("hidden");
      $(".boss-life-outter-border").removeClass("hidden");
      $(".boss-life-inner-border").removeClass("hidden");
      $(".boss-life-fill").removeClass("hidden");
      $(".boss-life-text").removeClass("hidden");
    }
    isDelayed = false;
    updateBoss();
  });

  strikeAnim(currentShield - newShield);
  $(".boss").animateCss("shake");
};

function changeBoss (data) {
  $(".boss-name").text(data["boss_name"]);

  if ($(".boss-name-container")[0].scrollWidth < $(".boss-name")[0].scrollWidth) {
    $(".boss-name").addClass("scrolling-text");
  } else {
    $(".boss-name").removeClass("scrolling-text");
  }

  var bossAvatar = data["boss_avatar"]
  if (bossAvatar == null || bossAvatar == "") {
    $(".boss-avatar").css("background-image", "url('https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_300x300.png')");
  } else {
    $(".boss-avatar").css("background-image", "url('" + bossAvatar + "')");
  }

  var currentHp = $("#boss-current-hp").text();
  var newHp = data["boss_current_hp"];
  $("#boss-current-hp").prop("number", currentHp).animateNumber({number: newHp, easing: "ease"}, 2000);

  var maxHp = $("#boss-max-hp").text();
  var newMaxHp = data["boss_max_hp"];
  $("#boss-max-hp").prop("number", maxHp).animateNumber({number: newMaxHp, easing: "ease"}, 2000);

  var currentHpPercent = (currentHp / maxHp) * 100;
  var newHpPercent = (newHp / newMaxHp) * 100;
  $("#boss-life-percent").prop("number", currentHpPercent).animateNumber({number: newHpPercent, easing: "ease"}, 2000);

  var maxShield = data["boss_max_shield"];
  $("#boss-max-shield").text(maxShield);

  healBar.set(1);
  damageBar.set(1);
  lifeBar.animate(1, { duration: 2000 }, function () {
    isDelayed = false;
    updateBoss();
  });
};

function nameFromDashbord(data) {
  $(".boss-name").text(data["boss_name"]);

  if ($(".boss-name-container")[0].scrollWidth < $(".boss-name")[0].scrollWidth) {
    $(".boss-name").addClass("scrolling-text");
  } else {
    $(".boss-name").removeClass("scrolling-text");
  }

  var bossAvatar = data["boss_avatar"]
  if (bossAvatar == null || bossAvatar == "") {
    $(".boss-avatar").css("background-image", "url('https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_300x300.png')");
  } else {
    $(".boss-avatar").css("background-image", "url('" + bossAvatar + "')");
  }
};

function maxShieldHpFromDashboard(data) {
  var maxHp = data["boss_max_hp"];
  $("#boss-max-hp").text(maxHp);

  var maxShield = data["boss_max_shield"];
  $("#boss-max-shield").text(maxShield);
};

function updateBoss () {
  if (!isDelayed && waitList.length > 0) {
    data = waitList.pop();
    isDelayed = true;
    if (data["heal"]) {
      healBoss(data);
    } else if (data["damages"]) {
      damageBoss(data);
    } else if (data["add_current_shield"]) {
      addShield(data);
    } else if (data["damage_current_shield"]) {
      damageShield(data);
    } else if (data["new_boss"]) {
      changeBoss(data);
    } else if (data["name_from_dashboard"]) {
      nameFromDashbord(data);
    } else if (data["max_shield_hp_from_dashboard"]) {
      maxShieldHpFromDashboard(data);
    }
  }
};
