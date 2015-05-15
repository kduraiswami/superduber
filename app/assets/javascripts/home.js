var loadHomePage = function(){


  // L.mapbox.accessToken = 'pk.eyJ1IjoiY2ViYWxsb3MzOTIiLCJhIjoiSFBRbkZ4ZyJ9.s1aM5qDZ1IRBccNCgwPE1Q';

  // (function setLocation() {
  //   if (navigator.geolocation) {
  //     navigator.geolocation.getCurrentPosition(setPosition);
  //   } else {
  //     setMap(37.775710, -122.418172);
  //   }
  // })();

  // function setPosition(position) {
  //   userLatitude =  position.coords.latitude;
  //   userLongitude = position.coords.longitude;
  //   setMap(userLatitude, userLongitude);
  // }

  // function setMap(latitude, longitude){
  //   //Persist background image for faster load times
  //   $("head").append('<style>#map{background-image: url("http://api.tiles.mapbox.com/v4/ceballos392.7f2001a9/'+longitude+','+latitude+',13/1280x800.png?access_token=pk.eyJ1IjoiY2ViYWxsb3MzOTIiLCJhIjoiSFBRbkZ4ZyJ9.s1aM5qDZ1IRBccNCgwPE1Q"); background-repeat: no-repeat; background-size: auto;}</style>');
  // }


  //add

  // $(document).on("submit", ".event-form", function(event){
  //   event.preventDefault();
  //   var userID = $("#user-id").text();
  //   //could use serialize
  //   var eventName = $(".event-form .name").val()
  //   var depAddr = $(".event-form .dep-addr").val()
  //   var arrAddr = $(".event-form .arr-addr").val()
  //   var arrDate = $(".event-form .arr-date").val()
  //   var date = $(".event-form .name").val()
  //   var rideType=$(".event-form").serialize()
  //   $.ajax({
  //     url: '/users/'+userID+'/events',
  //     type: 'POST',
  //     dataType: 'JSON',
  //     data: { event:{
  //       name: eventName,
  //       depart_address: depAddr ,
  //       arrival_address: arrAddr,
  //       arrival_datetime: arrDate,
  //       ride_name: rideType.replace(/^(ride-type=)/,"")}
  //     }
  //   })
  //   .done(function() {
  //     console.log("success");
  //   })
  //   .fail(function() {
  //     console.log("error");
  //   })
  //   .always(function() {
  //     console.log("complete");
  //   });


  // });


  //delete

  $(document).on("click", ".delete-btn", function(){
    var result = confirm("Are you sure?");
    if (result){
      var userID = $(this).closest(".event-content").find("#user-id").text()
      var eventID = $(this).closest(".event-content").find("#event-id").text()
      $.ajax({
        url: '/users/'+userID+'/events/'+eventID,
        type: 'DELETE'
      })
      .done(function(response) {
        $("p:contains("+response.deleted_event._id.$oid+")").closest(".event").remove();
      })
      .fail(function() {
        console.log("error");
      })
    }
  })
}


$(document).ready(loadHomePage);
$(document).on('page:change', loadHomePage);

 // $(document).on('click', '.delete-btn',function(){

 //    var eventID = $(this).parent().parent().find("#event-id").text();
 //    var userID= session.uuid;
 //    thisEvent= $(this);
 //    $.ajax({
 //      url: '/users/'+ userID + '/events/'+ eventID,
 //      type: 'DELETE',

 //    })
 //    .done(function(response) {
 //      $(thisEvent).parent().parent().remove()
 //    })
 //    .fail(function() {
 //      console.log("error");
 //    })

 //  });
