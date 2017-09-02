function strikeAnim (amount) {
  var power1 = [
    'http://i.imgur.com/axWaf1G.gif',
    'http://i.imgur.com/vrkWxrQ.gif',
    'http://i.imgur.com/T2RFqm3.gif',
    'http://i.imgur.com/bIUYT4E.gif'
  ]

  var power100 = [
    'http://i.imgur.com/qIGLfo8.gif',
    'http://i.imgur.com/AxTcMpu.gif',
    'http://i.imgur.com/ueYVt9V.gif',
    'http://i.imgur.com/p8Wxr0m.gif'
  ]

  var power500 = [
    'http://i.imgur.com/TQPP9xT.gif',
    'http://i.imgur.com/bvG9kkm.gif',
    'http://i.imgur.com/QRI0GE5.gif',
    'http://i.imgur.com/JpuqYpk.gif'
  ]

  var power1000 = [
    'http://i.imgur.com/A6EIUy1.gif',
    'http://i.imgur.com/ddgxLpl.gif',
    'http://i.imgur.com/DBjwiB3.gif',
    'http://i.imgur.com/Btlkt1D.gif'
  ]

  var power3000 = [
    'http://i.imgur.com/koNnePN.gif',
    'http://i.imgur.com/0HU0GFx.gif',
    'http://i.imgur.com/f8aQMPt.gif',
    'http://i.imgur.com/LCYgixP.gif'
  ]

  if (amount < 100) {
    var animLink = power1[Math.floor(Math.random() * power1.length)]
  } else if (amount < 500) {
    var animLink = power100[Math.floor(Math.random() * power100.length)]
  } else if (amount < 1000) {
    var animLink = power500[Math.floor(Math.random() * power500.length)]
  } else if (amount < 3000) {
    var animLink = power1000[Math.floor(Math.random() * power1000.length)]
  } else {
    var animLink = power3000[Math.floor(Math.random() * power3000.length)]
  }

  var img_tag = '<img src="' + animLink + '?a=' + Math.random() + '" id="strike-anim" style="position: absolute; z-index: 100; height: 150%; width: 150%;" alt="">'
  $('.boss').prepend(img_tag)
};

function healAnim () {
  var img_tag = '<img src="http://i.imgur.com/fOvRfRk.gif?a=' + Math.random() + '" id="heal-anim" style="position: absolute; z-index: 100; height: 150%; width: 150%;" alt="">'
  $('.boss').prepend(img_tag)
  setTimeout(function () { $('#heal-anim').remove() }, 1000)
};
