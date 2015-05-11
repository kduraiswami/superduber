// OAuth.initialize('j2tB0yWZSPdySDAy77GBQ3O9wFI');

// OAuth.popup('Uber').done(function(uber){
//   debugger
// }).fail(function(err){

// });


mapboxgl.accessToken = 'pk.eyJ1IjoiY2ViYWxsb3MzOTIiLCJhIjoiSFBRbkZ4ZyJ9.s1aM5qDZ1IRBccNCgwPE1Q';



(function setLocation() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(setPosition);
  } else {
    setMap(37.775710, -122.418172);
  }
})();

function setPosition(position) {
  userLatitude =  position.coords.latitude;
  userLongitude = position.coords.longitude;
  setMap(userLatitude, userLongitude);
}


function setMap(latitude, longitude){

  var map = new mapboxgl.Map({
    container: 'map',
    style: 'https://www.mapbox.com/mapbox-gl-styles/styles/dark-v7.json',
    center: [latitude, longitude],
    zoom: 10,
      // causes pan & zoom handlers not to be applied, similar to
      // .dragging.disable() and other handler .disable() funtions in Leaflet.
      interactive: false
    });

    // HANDLE RESIZING OF WINDOW
    window.onresize = function(event){
      map.resize()
    };
  }
