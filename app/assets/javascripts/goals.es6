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
  const current = subGoal.dataset.current;
  const required = subGoal.dataset.required;

  subGoalBar.set(current / required);
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
  const current = bitsGoal.dataset.current;
  const required = bitsGoal.dataset.required;

  bitsGoalBar.set(current / required);
};
