const initStripe = (stripeKey) => {
  const stripe = Stripe(stripeKey);
  const elements = stripe.elements({locale: 'auto'});

  const style = {
    base: {
      color: '#32325d',
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
    let pfClass = 'fa-credit-card';
    if (brand in cardBrandToFaClass) {
      pfClass = cardBrandToFaClass[brand];
    }
    for (let i = brandIconElement.classList.length - 1; i >= 0; i--) {
      brandIconElement.classList.remove(brandIconElement.classList[i]);
    }
    brandIconElement.classList.add('fa');
    brandIconElement.classList.add(pfClass);
  }

  const card = elements.create('cardNumber', {style: style});
  card.mount('#card-number');
  console.log(card.classList);
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

  const stripeTokenHandler = (token) => {
    let form = document.getElementById('subscription-form');
    let hiddenInput = document.createElement('input');
    hiddenInput.setAttribute('type', 'hidden');
    hiddenInput.setAttribute('name', 'stripeToken');
    hiddenInput.setAttribute('value', token.id);
    form.appendChild(hiddenInput);
    form.submit();
  }


  submitBtn.addEventListener('click', (event) => {
    event.preventDefault();
    
    let submitBtn = document.getElementById('stripe-submit');
    let form = document.getElementById('subscription-form');

    let userFirstName = document.getElementById("user_first_name").value;
    let userLastName = document.getElementById("user_last_name").value;
    let userFullName = `${userFirstName} ${userLastName}`;

    let userAddress = document.getElementById("user_address").value;
    let userCity = document.getElementById("user_city").value;
    let userZip = document.getElementById("user_postal_code").value;
    let userCountry = document.getElementById("user_country").value;

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
      } else {
        stripeTokenHandler(result.token);
      }
    });
  });
};
