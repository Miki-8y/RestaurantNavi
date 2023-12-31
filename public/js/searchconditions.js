function getLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition);
    } else { 
        alert("Geolocation is not supported by this browser.");
    }
}

function showPosition(position) {
    $.ajax({
        type: 'GET',
        url: `https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.coords.latitude},${position.coords.longitude}&sensor=true&key=AIzaSyAJFeKqH32Px6AJ5VDIwuIs8E8Zs-FSjk0&language=en`,
    }).then(function(response){
        console.log(response);
    })
}