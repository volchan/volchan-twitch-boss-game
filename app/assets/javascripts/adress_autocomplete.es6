let autocomplete;

const onPlaceChanged = () => {
  console.log(autocomplete);
  let place = autocomplete.getPlace();
  console.log(place);
  let components = getAddressComponents(place);

  console.log(components);

  let addressInput = document.getElementById("address-input");
  addressInput.blur();
  addressInput.value = components.formatted_address;

  document.getElementById("user_address").value = components.address;
  document.getElementById("user_city").value = components.city;
  document.getElementById("user_postal_code").value = components.zip_code;

  if (components.country_code) {
    let selector = '#user_country option[value="' + components.country_code + '"]';
    document.querySelector(selector).selected = true;
  }
};

const getAddressComponents = (place) => {
  // If you want lat/lng, you can look at:
  // - place.geometry.location.lat()
  // - place.geometry.location.lng()

  if (window.console && typeof console.log === "function") {
    console.log(place);
  }

  let street_number = null;
  let route = null;
  let zip_code = null;
  let city = null;
  let country_code = null;
  let formatted_address = place.formatted_address;
  for (let i in place.address_components) {
    let component = place.address_components[i];
    for (let j in component.types) {
      let type = component.types[j];
      if (type === 'street_number') {
        street_number = component.long_name;
      } else if (type === 'route') {
        route = component.long_name;
      } else if (type === 'postal_code') {
        zip_code = component.long_name;
      } else if (type === 'locality') {
        city = component.long_name;
      } else if (type === 'postal_town' && city === null) {
        city = component.long_name;
      } else if (type === 'country') {
        country_code = component.short_name;
      }
    }
  }

  return {
    formatted_address: formatted_address,
    address: street_number === null ? route : (street_number + ' ' + route),
    zip_code: zip_code,
    city: city,
    country_code: country_code
  };
}

const geolocate = () => {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition((position) => {
      let geolocation = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };
      let circle = new google.maps.Circle({
        center: geolocation,
        radius: position.coords.accuracy
      });
      autocomplete.setBounds(circle.getBounds());
    });
  }
};

document.addEventListener("DOMContentLoaded", () => {
  let flatAddress = document.getElementById('address-input');

  if (flatAddress) {
    autocomplete = new google.maps.places.Autocomplete(flatAddress, { types: ['geocode'] });
    google.maps.event.addListener(autocomplete, 'place_changed', onPlaceChanged);
    google.maps.event.addDomListener(flatAddress, 'keydown', (event) => {
      if (event.key === "Enter") {
        event.preventDefault();
      }
    });
  }
});
