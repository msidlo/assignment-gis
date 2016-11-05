// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on('turbolinks:load', function() {

    L.mapbox.accessToken = mapbox_acces_token;

    var map = L.mapbox.map('map', 'mapbox.streets').setView([48.805864, 19.093416], 8);
    var featureLayer = L.mapbox.featureLayer().addTo(map);

    $('#districts_population').on('click', function () {
        $('#server_communication').show();
        var params = {};
        params["regions"] = $('#regions option:selected').text();
        params["year"] = $('#year option:selected').text();
        params["population"] = $('#population_number').slider('getValue');
        $.ajax({
            type: 'POST',
            url: "/map/pop_district",
            data: params,
            success: function (result) {
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
                featureLayer.setGeoJSON(geojson);
                //L.geoJson(geojson, {style: L.mapbox.simplestyle.style}).addTo(map);
                $('#server_communication').hide();
            },
            error: function (result) {
                alert('Nastala chyba v komunikacii so serverom');
                $('#server_communication').hide();
            }
        });
    });

    $('#wage_unemployment').on('click', function () {
        $('#server_communication').show();
        var params = {};
        params["regions"] = $('#regions option:selected').text();
        params["year"] = $('#year option:selected').text();
        params["wage"] = $('#min_wage').slider('getValue');
        params["unemployment"] = $('#unemployment').slider('getValue');
        $.ajax({
            type: 'POST',
            url: "/map/wage_in_regions",
            data: params,
            success: function (result) {
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
                featureLayer.setGeoJSON(geojson);
                //L.geoJson(geojson, {style: L.mapbox.simplestyle.style}).addTo(map);
                $('#server_communication').hide();
            },
            error: function (result) {
                alert('Nastala chyba v komunikacii so serverom');
                $('#server_communication').hide();
            }
        });
    });

    //$('#population_number').slider('getValue');
    $('#population_number').slider({
        formatter: function(value) {
            $('#pop_value').text(value);
            return + value;
        }
    });
    $('#min_wage').slider({
        formatter: function(value) {
            $('#wage_value').text(value + " €");
            return + value;
        }
    });
    $('#unemployment').slider({
        formatter: function(value) {
            $('#unemployment_value').text(value + " %");
            return + value;
        }
    });


    //toggling the menu
    $('#show_menu').on('click',function () {
        // $("#menu_placeholder").hide();
        // $('#menu').show();
        $("#menu_placeholder").toggle();
        $('#menu').toggle();
    });
    $('#hide_menu').on('click',function () {
        $('#menu').toggle();
        $("#menu_placeholder").toggle();
    });


});