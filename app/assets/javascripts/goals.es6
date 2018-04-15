let subGoalBar, bitsGoalBar;

const initSubGoalBar = status => {
  subGoalBar = new ProgressBar.Line("#sub-goal-card", {
    strokeWidth: 11,
    easing: "easeInOut",
    color: "#018404",
    trailColor: "#eee",
    trailWidth: 11,
    svgStyle: { width: "100%", height: "100%" }
  });

  const subGoal = document.getElementById("sub-goal-card");
  const current = parseInt(subGoal.dataset.current);
  const required = parseInt(subGoal.dataset.required);

  if (status === "paused") {
    subGoalBar.path.setAttribute("stroke", "#6c6c6c");
  }

  if (current > required) {
    subGoalBar.set(1);
  } else {
    subGoalBar.set(current / required);
  }
};

const initBitsGoalBar = status => {
  bitsGoalBar = new ProgressBar.Line("#bits-goal-card", {
    strokeWidth: 11,
    easing: "easeInOut",
    color: "#018404",
    trailColor: "#eee",
    trailWidth: 11,
    svgStyle: { width: "100%", height: "100%" }
  });

  const bitsGoal = document.getElementById("bits-goal-card");
  const current = parseInt(bitsGoal.dataset.current);
  const required = parseInt(bitsGoal.dataset.required);

  if (status === "paused") {
    bitsGoalBar.path.setAttribute("stroke", "#6c6c6c");
  }

  if (current > required) {
    bitsGoalBar.set(1);
  } else {
    bitsGoalBar.set(current / required);
  }
};

const updateSubGoal = ({ title, current, required, status }) => {
  const titleLine = document.getElementById("sub-goal-title");
  if (titleLine) {
    titleLine.innerHTML = title;
  }

  const subGoalInfos = document.querySelector(".sub-goal-infos");
  const currentText = subGoalInfos.querySelector(".current-goal");
  const currentValue = parseInt(currentText.textContent);
  const requiredText = subGoalInfos.querySelector(".required-goal");
  const requiredValue = parseInt(requiredText.textContent);

  if (status !== "paused") {
    if (current <= required) {
      subGoalBar.path.setAttribute("stroke", "#018404");
      subGoalBar.animate(current / required);
      $("div.sub-goal-infos > p > span.current-goal").prop("number", currentValue).animateNumber({number: current, easing: "ease"});
      $("div.sub-goal-infos > p > span.required-goal").prop("number", requiredValue).animateNumber({number: required, easing: "ease"});
    } else if (current > required) {
      subGoalBar.animate(1);
    }
  } else {
    subGoalBar.path.setAttribute("stroke", "#6c6c6c");
  }
};

const updateBitsGoal = ({ title, current, required, status }) => {
  const titleLine = document.getElementById("bits-goal-title");
  if (titleLine) {
    titleLine.innerHTML = title;
  }

  const bitsGoalInfos = document.querySelector(".bits-goal-infos");
  const currentText = bitsGoalInfos.querySelector(".current-goal");
  const currentValue = parseInt(currentText.textContent);
  const requiredText = bitsGoalInfos.querySelector(".required-goal");
  const requiredValue = parseInt(requiredText.textContent);

  console.log(status);

  if (status !== "paused") {
    if (current <= required) {
      bitsGoalBar.path.setAttribute("stroke", "#018404");
      bitsGoalBar.animate(current / required);
      $("div.bits-goal-infos > p > span.current-goal").prop("number", currentValue).animateNumber({number: current, easing: "ease"});
      $("div.bits-goal-infos > p > span.required-goal").prop("number", requiredValue).animateNumber({number: required, easing: "ease"});
    } else if (current > required) {
      bitsGoalBar.animate(1);
    }
  } else {
    bitsGoalBar.path.setAttribute("stroke", "#6c6c6c");
  }
};

const resetSubGoal = () => {
  console.log("resetSubGoal");
  const titleLine = document.getElementById("sub-goal-title");
  titleLine.innerHTML = "No Sub goal yet!";
  bitsGoalBar.animate(0);
};

const resetBitsGoal = () => {
  const titleLine = document.getElementById("bits-goal-title");
  titleLine.innerHTML = "No Bits goal yet!";
  bitsGoalBar.animate(0);
};
