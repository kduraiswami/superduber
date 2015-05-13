function oauthRedir(){
  location.assign("oauth2");
}



var loadHomePage = function(){
  //check for session
  $.ajax({
    url: '/session',
    type: 'GET',
    dataType: 'JSON',
  })
  .done(function(response) {
    if(response != null){
      new Date().getTime(); //prevent caching
      $(".oauth-btn").text("Create an Event");
      $(".oauth-btn").attr("href", "/events");
      $(".oauth-btn").prop("onclick", null);
      $(".content-container").prepend('<form class="event-form" novalidate ng-controller="HomeController" action="#" ng-submit="submitForm(form)"><label>Name</label><input class= "name" type="text" ng-model="form.name"> </input><label>Depart Address</label><input class="dep-addr" type="text" ng-model="form.depart_address"> </input><label>Arrive Address</label><input class="arr-addr" type="text" ng-model="form.arrival_address"> </input><label>Date</label><input class="arr-date" type="text" ng-model="form.arrival_datetime"> </input><input type="submit"></form>')

      $("nav").append('<div class="prof-pic"> <img src="'+response.picture+'"></div>')
    }

    // $(".content-container").append('')
  })
  .fail(function() {
    console.log("error");
  })



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
    //Persist background image for faster load times
    $("head").append('<style>#map{background-image: url("http://api.tiles.mapbox.com/v4/ceballos392.7f2001a9/'+longitude+','+latitude+',13/1280x800.png?access_token=pk.eyJ1IjoiY2ViYWxsb3MzOTIiLCJhIjoiSFBRbkZ4ZyJ9.s1aM5qDZ1IRBccNCgwPE1Q"); background-repeat: no-repeat; background-size: auto;}</style>');

    // var map = new mapboxgl.Map({
    //   container: 'map',
    //   style: 'https://www.mapbox.com/mapbox-gl-styles/styles/dark-v7.json',
    //   center: [latitude, longitude],
    //   zoom: 10,
    //   // causes pan & zoom handlers not to be applied, similar to
    //   // .dragging.disable() and other handler .disable() funtions in Leaflet.
    //   interactive: false
    // });

    // HANDLE RESIZING OF WINDOW
    // window.onresize = function(event){
    //   map.resize()
    // };
  }



}


$(document).ready(loadHomePage);
$(document).on('page:change', loadHomePage);

