let imgTag = null;

const getAnimLink = (amount, power1, power100, power500, power1000, power3000) => {
  if (amount < 100) {
    return power1[Math.floor(Math.random() * power1.length)];
  } else if (amount < 500) {
    return power100[Math.floor(Math.random() * power100.length)];
  } else if (amount < 1000) {
    return power500[Math.floor(Math.random() * power500.length)];
  } else if (amount < 3000) {
    return power1000[Math.floor(Math.random() * power1000.length)];
  } else {
    return power3000[Math.floor(Math.random() * power3000.length)];
  }
}

const strikeAnim = (amount) => {
  let animLink;

  const power1 = [
    "https://i.imgur.com/axWaf1G.gif",
    "https://i.imgur.com/vrkWxrQ.gif",
    "https://i.imgur.com/T2RFqm3.gif",
    "https://i.imgur.com/bIUYT4E.gif"
  ];

  const power100 = [
    "https://i.imgur.com/qIGLfo8.gif",
    "https://i.imgur.com/AxTcMpu.gif",
    "https://i.imgur.com/ueYVt9V.gif",
    "https://i.imgur.com/p8Wxr0m.gif"
  ];

  const power500 = [
    "https://i.imgur.com/TQPP9xT.gif",
    "https://i.imgur.com/bvG9kkm.gif",
    "https://i.imgur.com/QRI0GE5.gif",
    "https://i.imgur.com/JpuqYpk.gif"
  ];

  const power1000 = [
    "https://i.imgur.com/A6EIUy1.gif",
    "https://i.imgur.com/ddgxLpl.gif",
    "https://i.imgur.com/DBjwiB3.gif",
    "https://i.imgur.com/Btlkt1D.gif"
  ];

  const power3000 = [
    "https://i.imgur.com/koNnePN.gif",
    "https://i.imgur.com/0HU0GFx.gif",
    "https://i.imgur.com/f8aQMPt.gif",
    "https://i.imgur.com/LCYgixP.gif"
  ];

  animLink = getAnimLink(amount, power1, power100, power500, power1000, power3000);

  imgTag = "<img src='" + animLink + "?a=" + Math.random() + "' id='strike-anim' style='position: absolute; z-index: 100; height: 150%; width: 150%;' alt=''>";
  $(".boss").prepend(imgTag);
}

const healAnim = () => {
  imgTag = "<img src=''https://i.imgur.com/fOvRfRk.gif?a=" + Math.random() + "' id='heal-anim' style='position: absolute; z-index: 100; height: 150%; width: 150%;' alt=''>";
  $(".boss").prepend(imgTag);

  setTimeout(function () { $("#heal-anim").remove(); }, 1000);
}
