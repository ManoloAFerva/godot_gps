extends Control

const OVERPASS_URL = "https://overpass-api.de/api/interpreter"

onready var lat = $GpsDisplay/lat
onready var lon = $GpsDisplay/lon
onready var loc = $OsmData/locat

func _physics_process(delta):
	lat.text = str(JavaScript.eval("latitude;"))
	lon.text = str(JavaScript.eval("longitude;"))

func get_location():
	loc.text = "Requesting location data..."
	var query = """
		[out:json];
		is_in(%s,%s)->.a;
		area.a["boundary"="administrative"]["admin_level"="8"];
		out body;
	""" % [lat.text, lon.text]

	var http_req = HTTPRequest.new()
	add_child(http_req)
	http_req.connect("request_completed", self, "display_location")
	http_req.request(OVERPASS_URL, [], true, HTTPClient.METHOD_POST, query)

func display_location(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.parse(body.get_string_from_utf8())
		if json.error == OK:
			var elements = json.result["elements"]
			if elements.size() > 0:
				var city_name = elements[0].tags.get("name", "Unknown")
				loc.text = city_name
			else:
				loc.text = "No city found."

