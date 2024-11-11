var latitude = 0;
var longitude = 0;
function getGPSLocation() {
       if (navigator.geolocation) {
           navigator.geolocation.watchPosition(
               (position) => {
                    latitude = position.coords.latitude;
                    longitude = position.coords.longitude;
                   
                    // Send coordinates to Godot
                    if (typeof GodotRuntime !== "undefined" && GodotRuntime.instance) {
                       GodotRuntime.instance.callFunction("set_gps_location", latitude, longitude);
                    }
               },
               (error) => {
                   console.error("Error getting location:", error);
               }
           );
       } else {
           console.log("Geolocation is not supported by this browser.");
       }
   }

   // Call the function to fetch GPS location
   getGPSLocation();