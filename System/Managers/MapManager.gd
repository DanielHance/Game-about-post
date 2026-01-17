extends Node3D

@onready var model_light: DirectionalLight3D = $LighthouseLight
@onready var model_party1: MeshInstance3D = $VampireManor/PartyFlags
@onready var model_party2: MeshInstance3D = $VampireManor/PartyFlags2
@onready var model_party3: MeshInstance3D = $VampireManor/PartyFlags3
@onready var model_grave: MeshInstance3D = $Graveyard/RaveGear

func _ready():
	DialogueManager.mapManagerPointer = self

func lighthouse_light(show: bool = true):
	print("LIGHTHOUSE")
	if show:
		model_light.show()
	else:
		model_light.hide()

func vamp_house_party(show: bool = true):
	if show:
		model_party1.show()
		model_party2.show()
		model_party3.show()
	else:
		model_party1.hide()
		model_party2.hide()
		model_party3.hide()
		
func grave_party(show: bool = true):
	if show:
		model_grave.show()
	else:
		model_grave.hide()
		
func smart_map(type: String, show: bool = true):
	if type == "vamp_house":
		vamp_house_party(show)
	elif type == "lighthouse":
		lighthouse_light(show)
	elif type == "grave_party":
		grave_party(show)
	else:
		print("Error --- smart map does not know " + type)
