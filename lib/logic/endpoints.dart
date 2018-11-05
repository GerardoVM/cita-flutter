import 'store.dart';

const baseEndpoint = "http://142.93.18.136:4700";

const loginEndpoint = "$baseEndpoint/login";
const signUpEndpoint = "$baseEndpoint/signup";

String videoUri(String filename) => "$baseEndpoint/videos/get-url/$filename";

get userDni => localStorage.getFromStore("user", "dni");

get userEndpoint => "$baseEndpoint/users/$userDni";

get userVideosEndpoint => "$baseEndpoint/users/$userDni/videos";

get userUploadVideoEndpoint => "$baseEndpoint/users/$userDni/save-video";

get authToken => "Bearer ${localStorage.getFromStore("user", "auth_token")}";

String recoveryPassword(String userDni) => "$baseEndpoint/open/$userDni/forgot-password";

String mapboxLocation(double lat, lon) => ('https://api.mapbox.com/geocoding/v5/mapbox.places/' +
    '$lon,$lat.json?' +
    'access_token=pk.eyJ1IjoiYnJlZ3ltciIsImEiOiJjamN4czR1dGMwajVtMnhvMWo3eXB1cTBqIn0.jzAvpZXYYvpqALZvpFEahw');

String mapBoxStaticMap(double lat, lon, zoom, pitch) =>
// mapbox/cj8gg22et19ot2rnz65958fkn
    "https://api.mapbox.com/styles/v1/mapbox/cj8gg22et19ot2rnz65958fkn/static/url-https%3A%2F%2Fimage.ibb.co%2FbHF2D9%2Fmarker.png($lon,$lat)/$lon,$lat,$zoom,0,$pitch/460x260@2x?access_token=pk.eyJ1IjoiYnJlZ3ltciIsImEiOiJjamN4czR1dGMwajVtMnhvMWo3eXB1cTBqIn0.jzAvpZXYYvpqALZvpFEahw";

String mapBoxGeoCodingForward(String query) =>
    "https://api.mapbox.com/geocoding/v5/mapbox.places/${query.replaceAll(" ", "+")}.json?country=pe&access_token=pk.eyJ1IjoiYnJlZ3ltciIsImEiOiJjamN4czR1dGMwajVtMnhvMWo3eXB1cTBqIn0.jzAvpZXYYvpqALZvpFEahw";
