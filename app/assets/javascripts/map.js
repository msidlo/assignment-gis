// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on('turbolinks:load', function() {

    L.mapbox.accessToken = mapbox_acces_token;

    var map = L.mapbox.map('map', 'mapbox.streets').setView([48.805864, 19.093416], 8);

    $('#tn').on('click', function () {
        $('#server_communication').show();
        $.ajax({
            type: 'POST',
            url: "/map",
            data: "wueeeeeej",
            success: function (result) {
                console.log(result);
                geojson = [{
                    "type": "Feature",
                    "geometry": result,
                    "properties": {
                        "stroke": "#0000cc",
                        "fill": "#8282cc",
                        "fill-opacity": 0.2,
                        "stroke-width": 1
                    }
                }];
                L.geoJson(geojson, {style: L.mapbox.simplestyle.style}).addTo(map);
                $('#server_communication').hide();
            },
            error: function (result) {
                alert('Nastala chyba v komunikacii so serverom');
                $('#server_communication').hide();
            }
        });
    });

});