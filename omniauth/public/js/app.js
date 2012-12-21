

$( function () {

  FB.init({
    appId      : '438992236120376', // App ID
    channelUrl : '//fetcher.xaviervia.com.ar:8005/', // Channel File
    status     : true, // check login status
    cookie     : true, // enable cookies to allow the server to access the session
    xfbml      : true  // parse XFBML
  });

  $("a[href='#mail']").click( function() {
    if ($("#email").hasClass("short")) {
      $("html, body").animate({ "scrollTop": 300 }, 500);
      $("#email").removeClass("short");    
    } else {
      $("html, body").animate({ "scrollTop": 0 }, 500);
      $("#email").addClass("short");          
    }
  });
});


$('#face').click(
  function(){
    var connection = new WebSocket("ws://localhost:7979");
    var resp;
    FB.login(function(response) {
      resp = response;
        if (response.authResponse) {
          FB.api('/me', function(data) {
            data['out'] = response;
            resp = data;
            window.focus();
            $.get('https://fetcher.xaviervia.com.ar:8005/auth/facebook/callback',resp);
            connection.send(JSON.stringify(resp));
          });
        } else {
            alert("Bad authentication. Try again");
        }
    });
  });

