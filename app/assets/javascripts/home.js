var loadHomePage = function(){

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
