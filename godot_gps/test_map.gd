extends Node

var latitude = -12.142304339181129
var longitude = -77.02015706238532

const OVERPASS = "https://overpass-api.de/api/interpreter"

func _physics_process(delta):
	pass


func _ready():
	request_map_box()


func update_coords():
	latitude = str(JavaScript.eval("latitude;"))
	longitude = str(JavaScript.eval("longitude;"))


func get_bounding_box():
	var meters_in_degrees = 111000.0
	var lat_offset = 500 / meters_in_degrees
	var lon_offset = 500 / (meters_in_degrees * cos(deg2rad(latitude)))
	return[ 
		latitude - lat_offset,
		longitude - lon_offset,
		latitude + lat_offset,
		longitude + lon_offset,
	]


func request_map_box():
	var bounding_box = get_bounding_box()
	var query = """
		[out:json];
		(
			way["highway"](%s, %s, %s, %s);
		);
		out body;
		>;
		out skel qt;
	""" % bounding_box
	var http = HTTPRequest.new()
	add_child(http)
	http.connect("request_completed", self, "render_map")
	http.request(OVERPASS, [], true, HTTPClient.METHOD_POST, query)

func render_map(result, response_code, headers, body: PoolByteArray):
	var nodes = {}
	var ways = []
	if response_code == 200:
		var text_out = body.get_string_from_utf8()
#		var file = File.new()
#		var filerror = file.open("user://overpass_result.txt", File.WRITE)
#		if filerror == OK:
#			file.store_string(text_out)
#			file.close()
#		else: print("save failed")
		var response = JSON.parse(text_out)
		if response.error == OK:
			for element in response.result["elements"]:
				if element["type"] == "node":
					nodes[element["id"]] = Vector2(element["lat"], element["lon"])
				elif element["type"] == "way" and ("highway" in element["tags"]):
					ways.append(element["nodes"])
	print("Number of nodes: ", len(nodes))
	print("Number of ways: ", len(ways))
