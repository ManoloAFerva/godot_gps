extends Control

onready var lat = $lat
onready var lon = $lon

func _physics_process(delta):
	lat.text = str(JavaScript.eval("latitude;"))
	lon.text = str(JavaScript.eval("longitude;"))

