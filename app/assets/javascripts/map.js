// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on('turbolinks:load', function () {

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
                featureLayer.setGeoJSON(get_geojson(result));
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
            url: "/map/wage_in_districts",
            data: params,
            success: function (result) {
                featureLayer.setGeoJSON(get_geojson(result));
                $('#server_communication').hide();
            },
            error: function (result) {
                alert('Nastala chyba v komunikacii so serverom');
                $('#server_communication').hide();
            }
        });
    });

    $('#deaths').on('click', function () {
        $('#server_communication').show();
        var params = {};
        params["regions"] = $('#regions option:selected').text();
        params["year"] = $('#year option:selected').text();
        params["deaths_rate"] = $('#deaths_rate').slider('getValue');
        $.ajax({
            type: 'POST',
            url: "/map/deaths_hospitals",
            data: params,
            success: function (result) {
                geojsons = [];
                result.forEach(function (g) {
                    geojsons.push(get_geojson(JSON.parse(g["geom"]),
                        "Najvzdialenejší bod od nemocnici: " + g["max"] + " km\nPočet zachynutých osob: " + g["value"]));
                });
                featureLayer.setGeoJSON({
                    type: "FeatureCollection",
                    features: geojsons
                });
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
        formatter: function (value) {
            $('#pop_value').text(value);
            return +value;
        }
    });
    $('#min_wage').slider({
        formatter: function (value) {
            $('#wage_value').text(value + " €");
            return +value;
        }
    });
    $('#unemployment').slider({
        formatter: function (value) {
            $('#unemployment_value').text(value + " %");
            return +value;
        }
    });
    $('#deaths_rate').slider({
        formatter: function (value) {
            $('#unemployment_value').text(value);
            return +value;
        }
    });


    //toggling the menu
    $('#show_menu').on('click', function () {
        // $("#menu_placeholder").hide();
        // $('#menu').show();
        $("#menu_placeholder").toggle();
        $('#menu').toggle();
    });
    $('#hide_menu').on('click', function () {
        $('#menu').toggle();
        $("#menu_placeholder").toggle();
    });


});

function get_geojson(geometry, description) {
    geojson = {
        "type": "Feature",
        "geometry": geometry,
        "properties": {
            "stroke": "#0000cc",
            "fill": "#8282cc",
            "fill-opacity": 0.2,
            "stroke-width": 1,
            "description": description
        }
    };
    return geojson;
}