let isDelayed = false;

let gameData;

let lifeBar, healBar, damageBar, shieldBar, shieldBarBg, shieldBarGreenBg;

let waitList = [];

let newHp, maxHp, newMaxHp;
let currentHp, currentHpPercent, newHpPercent, healthPercentage;

let newShield, maxShield;
let currentShield, currentShieldPercent, newShieldPercent, shieldPercentage;

let bossAvatar;

const createBossBars = () => {
  shieldBarGreenBg = new ProgressBar.Circle("#shield-circle", {
    strokeWidth: 11,
    color: "#018404"
  });

  shieldBarBg = new ProgressBar.Circle("#shield-circle", {
    strokeWidth: 11,
    color: "#006d96"
  });

  shieldBar = new ProgressBar.Circle("#shield-circle", {
    strokeWidth: 11,
    color: "#00aeef"
  });

  damageBar = new ProgressBar.Circle("#life-circle", {
    strokeWidth: 11,
    color: "#940000"
  });

  healBar = new ProgressBar.Circle("#life-circle", {
    strokeWidth: 11,
    color: "#0BC91D"
  });

  lifeBar = new ProgressBar.Circle("#life-circle", {
    strokeWidth: 11,
    color: "#018404"
  });
}

const hideLifeUi = () => {
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

const hideShieldUi = () => {
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

const textScrolling = () => {
  if ($(".boss-name-container")[0].scrollWidth < $(".boss-name")[0].scrollWidth) {
    $(".boss-name").addClass("scrolling-text");
  } else {
    $(".boss-name").removeClass("scrolling-text");
  }
}

const initBossBars =  () => {
  currentHp = $("#boss-current-hp").text();
  maxHp = $("#boss-max-hp").text();
  currentShield = $("#boss-current-shield").text();
  maxShield = $("#boss-max-shield").text();
  if (currentShield > "0") {
    hideLifeUi();
  }

  textScrolling();

  lifeBar.set(currentHp / maxHp);
  healBar.set(currentHp / maxHp);
  damageBar.set(currentHp / maxHp);
  shieldBar.set(currentShield / maxShield);
  shieldBarBg.set(currentShield / maxShield);
  shieldBarGreenBg.set(1);

  $("#boss-life-percent").text(Math.floor(parseFloat(lifeBar.value()) * 100));
  $("#boss-shield-percent").text(Math.floor(parseFloat(shieldBar.value()) * 100));
}

const healBoss =  (data) => {
  currentHp = $("#boss-current-hp").text();
  if (data["boss_current_hp"] < 0) {
    newHp = 0;
  } else {
    newHp = data["boss_current_hp"];
  }
  $("#boss-current-hp").prop("number", currentHp).animateNumber({number: newHp, easing: "ease"}, 2000);

  maxHp = $("#boss-max-hp").text();

  currentHpPercent = (currentHp / maxHp) * 100;
  newHpPercent = (newHp / maxHp) * 100;
  $("#boss-life-percent").prop("number", currentHpPercent).animateNumber({number: newHpPercent, easing: "ease"}, 2000);

  healthPercentage = newHp / maxHp;

  healBar.set(healthPercentage);
  damageBar.set(healthPercentage);
  lifeBar.animate(healthPercentage, { duration: 2000 }, () =>  {
    isDelayed = false;
    updateBoss();
  });
  healAnim();
}

const damageBoss =  (data) => {
  if ($(".boss-shield-logo").is(":visible")) {
    hideShieldUi();
  }

  currentHp = $("#boss-current-hp").text();
  if (data["boss_current_hp"] < 0) {
    newHp = 0;
  } else {
    newHp = data["boss_current_hp"];
  }
  maxHp = $("#boss-max-hp").text();
  currentHpPercent = (currentHp / maxHp) * 100;
  newHpPercent = (newHp / maxHp) * 100;
  healthPercentage = newHp / maxHp;

  strikeAnim(currentHp - newHp);

  setTimeout(() =>  {
      $(".boss").animateCss("shake");
      $("#boss-current-hp").prop("number", currentHp).animateNumber({number: newHp, easing: "ease"}, 2000);
      $("#boss-life-percent").prop("number", currentHpPercent).animateNumber({number: newHpPercent, easing: "ease"}, 2000);
      healBar.set(healthPercentage);
      lifeBar.set(healthPercentage);
      damageBar.animate(healthPercentage, { duration: 2000 }, () =>  {
        isDelayed = false;
        updateBoss();
      });
    }, 1000
  );
}

const addShield =  (data) => {
  if ($(".boss-life-logo").is(":visible")) {
    hideLifeUi();
  }

  newShield = data["boss_current_shield"];

  currentShield = $("#boss-current-shield").text();
  $("#boss-current-shield").prop("number", currentShield).animateNumber({number: newShield, easing: "ease"}, 2000);

  maxShield = $("#boss-max-shield").text();

  currentShieldPercent = (currentShield / maxShield) * 100;
  newShieldPercent = ( newShield / maxShield) * 100;
  $("#boss-shield-percent").prop("number", currentShieldPercent).animateNumber({number: newShieldPercent, easing: "ease"}, 2000);

  shieldPercentage = newShield / maxShield;
  shieldBarBg.set(shieldPercentage);
  shieldBar.animate(shieldPercentage, { duration: 2000 }, () =>  {
    isDelayed = false;
    updateBoss();
  });
}

const damageShield =  (data) => {
  newShield = data["boss_current_shield"];
  maxShield = $("#boss-max-shield").text();

  currentShield = $("#boss-current-shield").text();
  $("#boss-current-shield").prop("number", currentShield).animateNumber({number: newShield, easing: "ease"}, 2000);

  currentShieldPercent = (currentShield / maxShield) * 100;
  newShieldPercent = (newShield / maxShield) * 100;
  $("#boss-shield-percent").prop("number", currentShieldPercent).animateNumber({number: newShieldPercent, easing: "ease"}, 2000);

  shieldPercentage = newShield / maxShield;
  shieldBar.set(shieldPercentage);
  shieldBarBg.animate(shieldPercentage, { duration: 2000 }, () =>  {
    if ($("#boss-current-shield").text() === "0") {
      hideShieldUi();
    }
    isDelayed = false;
    updateBoss();
  });

  strikeAnim(currentShield - newShield);
  $(".boss").animateCss("shake");
}

const changeBoss =  (data) => {
  $(".boss-name").text(data["boss_name"]);

  textScrolling();

  bossAvatar = data["boss_avatar"];
  if (bossAvatar == null || bossAvatar == "") {
    $(".boss-avatar").css("background-image", "url('https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_300x300.png')");
  } else {
    $(".boss-avatar").css("background-image", "url('" + bossAvatar + "')");
  }

  currentHp = $("#boss-current-hp").text();
  newHp = data["boss_current_hp"];
  $("#boss-current-hp").prop("number", currentHp).animateNumber({number: newHp, easing: "ease"}, 2000);

  maxHp = $("#boss-max-hp").text();
  newMaxHp = data["boss_max_hp"];
  $("#boss-max-hp").prop("number", maxHp).animateNumber({number: newMaxHp, easing: "ease"}, 2000);

  currentHpPercent = (currentHp / maxHp) * 100;
  newHpPercent = (newHp / newMaxHp) * 100;
  $("#boss-life-percent").prop("number", currentHpPercent).animateNumber({number: newHpPercent, easing: "ease"}, 2000);

  maxShield = data["boss_max_shield"];
  $("#boss-max-shield").text(maxShield);

  healBar.set(1);
  damageBar.set(1);
  lifeBar.animate(1, { duration: 2000 }, () =>  {
    isDelayed = false;
    updateBoss();
  });
}

const nameFromDashbord = (data) => {
  $(".boss-name").text(data["boss_name"]);

  textScrolling();

  bossAvatar = data["boss_avatar"];
  if (bossAvatar == null || bossAvatar == "") {
    $(".boss-avatar").css("background-image", "url('https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_300x300.png')");
  } else {
    $(".boss-avatar").css("background-image", "url('" + bossAvatar + "')");
  }
}

const maxShieldHpFromDashboard = (data) => {
  maxHp = data["boss_max_hp"];
  $("#boss-max-hp").text(maxHp);

  maxShield = data["boss_max_shield"];
  $("#boss-max-shield").text(maxShield);
}

const gameDispatch = (gameData) => {
  if (gameData["heal"]) {
    healBoss(gameData);
  } else if (gameData["damages"]) {
    damageBoss(gameData);
  } else if (gameData["add_current_shield"]) {
    addShield(gameData);
  } else if (gameData["damage_current_shield"]) {
    damageShield(gameData);
  } else if (gameData["new_boss"]) {
    changeBoss(gameData);
  } else if (gameData["name_from_dashboard"]) {
    nameFromDashbord(gameData);
  } else if (gameData["max_shield_hp_from_dashboard"]) {
    maxShieldHpFromDashboard(gameData);
  }
}

const updateBoss = () => {
  if (!isDelayed && waitList.length > 0) {
    gameData = waitList.pop();
    isDelayed = true;
    gameDispatch(gameData);
  }
}

const addToWaitlist = (data) => {
  waitList.unshift(data);
  if (!isDelayed && waitList.length > 0) {
    updateBoss();
  }
}
