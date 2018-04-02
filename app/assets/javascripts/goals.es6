let subGoalBar, bitsGoalBar;

const initSubGoalBar = () => {
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
  console.log(current);
  console.log(required);
  console.log(current > required);

  if (current > required) {
    subGoalBar.set(1);
  } else {
    subGoalBar.set(current / required);
  }
};

const initBitsGoalBar = () => {
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

  if (current > required) {
    bitsGoalBar.set(1);
  } else {
    bitsGoalBar.set(current / required);
  }
};

const updateSubGoal = ({ title, current, required, status }) => {
  const titleLine = document.getElementById("sub-goal-title");
  if (status === "in_progress") {
    titleLine.innerHTML = title;
    if (current <= required) {
      subGoalBar.animate(current / required);
    }
  }
};

const updateBitsGoal = ({ title, current, required, status }) => {
  const titleLine = document.getElementById("bits-goal-title");
  if (status === "in_progress") {
    titleLine.innerHTML = title;
    if (current <= required) {
      bitsGoalBar.animate(current / required);
    }
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
