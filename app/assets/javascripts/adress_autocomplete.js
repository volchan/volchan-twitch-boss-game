function getAddressComponents(place) {
  // If you want lat/lng, you can look at:
  // - place.geometry.location.lat()
  // - place.geometry.location.lng()

  // if (window.console && typeof console.log === "function") {
  //   console.log(place);
  // }
  //
  var street_number = null;
  var route = null;
  var zip_code = null;
  var city = null;
  var country_code = null;
  for (var i in place.address_components) {
    var component = place.address_components[i];
    for (var j in component.types) {
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
    address: street_number === null ? route : (street_number + ' ' + route),
    zip_code: zip_code,
    city: city,
    country_code: country_code
  };
}

function onPlaceChanged() {
  var place = this.getPlace();
  var components = getAddressComponents(place);

  console.log(components);

  var addressInput = document.getElementById("address-input");
  addressInput.blur();
  addressInput.value = components.address;

  document.getElementById("user_city").value = components.city;
  document.getElementById("user_postal_code").value = components.zip_code;

  if (components.country_code) {
    var selector = '#user_country option[value="' + components.country_code + '"]';
    document.querySelector(selector).selected = true;
  }
};

function initAddressAutocomplete() {
  var addressInput = document.getElementById("address-input");

  var autocomplete = new google.maps.places.Autocomplete(addressInput);

  google.maps.event.addListener(autocomplete, "place_changed", onPlaceChanged);
  google.maps.event.addDomListener(addressInput, 'keydown', (event) => {

    if (event.key === "Enter") {
      event.preventDefault();
    }
  });
};
