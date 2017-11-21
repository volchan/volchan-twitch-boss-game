const style = {
  base: {
    color: '#495057',
    lineHeight: '24px',
    fontFamily: '"Open Sans", Helvetica, sans-serif',
    fontSmoothing: 'antialiased',
    fontSize: '16px',
    '::placeholder': {
      color: '#aab7c4'
    }
  },
  invalid: {
    color: '#EE5F5B',
    iconColor: '#EE5F5B'
  }
};

const setBrandIcon = (brand) => {
  let cardBrandToFaClass = {
    'visa': 'fa-cc-visa',
    'mastercard': 'fa-cc-mastercard',
    'amex': 'fa-cc-american-express',
    'discover': 'fa-cc-discover',
    'diners': 'fa-cc-diners',
    'jcb': 'fa-cc-jcb',
    'unknown': 'fa-credit-card',
  };

  let brandIconElement = document.getElementById('brand-icon');
  let faClass = 'fa-credit-card';
  if (brand in cardBrandToFaClass) {
    faClass = cardBrandToFaClass[brand];
  }
  for (let i = brandIconElement.classList.length - 1; i >= 0; i--) {
    brandIconElement.classList.remove(brandIconElement.classList[i]);
  }
  brandIconElement.classList.add('fa');
  brandIconElement.classList.add(faClass);
};

const buildCard = (elements) => {
  const card = elements.create('cardNumber', {style: style});
  card.mount('#card-number');
  card.addEventListener('change', (e) => {
    let displayError = document.getElementById('card-number-error');

    if (e.brand) {
      setBrandIcon(e.brand);
    }

    if (e.error) {
      displayError.textContent = e.error.message;
    } else {
      displayError.textContent = '';
    }
  });

  card.on('focus', () => {
    let ibput = document.getElementById("card-input");
    ibput.classList.add("form-focus");
  });

  card.on('blur', () => {
    let ibput = document.getElementById("card-input");
    ibput.classList.remove("form-focus");
  });

  return card;
};

const buildCardExpiry = (elements) => {
  const cardExpiry = elements.create('cardExpiry', {style: style});
  cardExpiry.mount('#card-expiry');
  cardExpiry.addEventListener('change', ({error}) => {
    let displayError = document.getElementById('card-expiry-error');
    if (error) {
      displayError.textContent = error.message;
    } else {
      displayError.textContent = '';
    }
  });
  cardExpiry.on('focus', () => {
    let input = document.getElementById("card-expiry");
    input.classList.add("form-focus");
  });
  cardExpiry.on('blur', () => {
    let input = document.getElementById("card-expiry");
    input.classList.remove("form-focus");
  });

  return cardExpiry;
};

const buildCardCvc = (elements) => {
  const cardCvc = elements.create('cardCvc', {style: style});
  cardCvc.mount('#card-cvc');
  cardCvc.addEventListener('change', ({error}) => {
    let displayError = document.getElementById('card-cvc-error');
    if (error) {
      displayError.textContent = error.message;
    } else {
      displayError.textContent = '';
    }
  });
  cardCvc.on('focus', () => {
    let input = document.getElementById("card-cvc");
    input.classList.add("form-focus");
  });
  cardCvc.on('blur', () => {
    let input = document.getElementById("card-cvc");
    input.classList.remove("form-focus");
  });

  return cardCvc;
};

const formValidations = (form) => {
  $.validator.addMethod("validateName", (value, element) => {
    return /^[A-zÀ-ÿ\s\-]+$/.test(value);
  }, "Please enter a valid First Name");

  $(form).validate({
    rules : {
      "user[first_name]": "validateName",
      "user[last_name]": "validateName"
    },
    errorElement: 'label',
    errorPlacement: (error, element) => {
      error.insertAfter(element);
    }
  });
};

const stripeTokenHandler = (token) => {
  let form = document.getElementById('subscription-form');
  let hiddenInput = document.createElement('input');
  hiddenInput.setAttribute('type', 'hidden');
  hiddenInput.setAttribute('name', 'stripeToken');
  hiddenInput.setAttribute('value', token.id);
  form.appendChild(hiddenInput);

  form.submit();
};

const loadingBtn = () => {
  let submitBtn = document.getElementById("stripe-submit");
  submitBtn.disabled = true;
  submitBtn.innerHTML = "<span class='loader'><span></span><span></span><span></span></span> Processing Subscription";
}

const normalBtn = () => {
  let submitBtn = document.getElementById("stripe-submit");
  submitBtn.disabled = false;
  submitBtn.innerHTML = "<i aria-hidden='true' class='fa fa-lock'></i> Finish and Subscribe";
}

const doneBtn = () => {
  let submitBtn = document.getElementById("stripe-submit");
  submitBtn.classList.remove("btn-primary");
  submitBtn.classList.add("btn-success");
  submitBtn.innerHTML = "<i aria-hidden='true' class='fa fa-check'></i> Done, Thank you";
}

const initStripe = (stripeKey) => {
  const stripe = Stripe(stripeKey);
  const elements = stripe.elements({locale: 'en'});

  const card = buildCard(elements);
  const cardExpiry = buildCardExpiry(elements);
  const cardCvc = buildCardCvc(elements);

  let form = document.getElementById('subscription-form');
  formValidations(form);
  form.addEventListener('submit', (event) => {
    event.preventDefault();
    if ($(form).valid()) {
      let userFirstName = document.getElementById("user_first_name").value;
      let userLastName = document.getElementById("user_last_name").value;
      let userFullName = `${userFirstName} ${userLastName}`;

      let userAddress = document.getElementById("user_address").value;
      let userCity = document.getElementById("user_city").value;
      let userZip = document.getElementById("user_postal_code").value;
      let userCountry = document.getElementById("user_country").value;

      loadingBtn();

      stripe.createToken(card, {
        name: userFullName,
        address_line1: userAddress,
        address_city: userCity,
        address_zip: userZip,
        address_country: userCountry
      }).then((result) => {
        if (result.error) {
          let errorElement = document.getElementById('card-number-error');
          errorElement.textContent = result.error.message;
          normalBtn();
        } else {
          doneBtn();
          stripeTokenHandler(result.token);
        }
      });
    }
  });
};
