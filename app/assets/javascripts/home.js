function oauthRedir(){
  location.assign("oauth2");
}

function logoutRedir(){
  location.assign("logout")
}


var loadHomePage = function(){
  var session;
  //check for session
  $.ajax({
    url: '/session',
    type: 'GET',
    dataType: 'JSON',
    cache: false
  })
  .done(function(response) {
    if(response.first_name !== null){
      console.log("Currently in Session");
      session = response;
      new Date().getTime(); //prevent caching
      $(".oauth-btn").toggle();
      $(".button-container").append("<h2>Welcome<br>"+response.first_name+"!</h2>");
      $(".event-form").removeClass("hidden");
      $(".logout-container").css("display","inline-block")
      $("nav").append('<div class="prof-pic"> <img src="'+response.picture+'"></div>')
    }
    // $(".content-container").append('')
  })
  .fail(function() {
    console.log("error");
  })



  L.mapbox.accessToken = 'pk.eyJ1IjoiY2ViYWxsb3MzOTIiLCJhIjoiSFBRbkZ4ZyJ9.s1aM5qDZ1IRBccNCgwPE1Q';

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


  $(document).on('click', '.delete-btn',function(){

    var eventID = $(this).parent().parent().find("#event-id").text();
    var userID= session.uuid;
    thisEvent= $(this);
    $.ajax({
      url: '/users/'+ userID + '/events/'+ eventID,
      type: 'DELETE',

    })
    .done(function(response) {
      $(thisEvent).parent().parent().remove()
    })
    .fail(function() {
      console.log("error");
    })

  });

//Edit
  $(document).on('click', '.edit-btn', function(){
    $(this).closest(".event").find(".edit-form").removeClass("hidden").addClass('active-edit');
    $(this).closest(".event-content").toggle();

  });

//Instruction Modal
  $(document).on('click','.submit-btn', function(){
    console.log('hit submit')
    console.log($('#thankYouModal'))
    $('#thankYouModal').show
  })


}


$(document).ready(loadHomePage);
$(document).on('page:change', loadHomePage);

