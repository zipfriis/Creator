extends MarginContainer

var RaceNode: Node

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data.has("Node"):
		if data["Node"].BlockType == "RaceBlock":
			return true
	return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	print(data["Race"])
	$'..'.emit_signal("NewRaceName",data["Race"])
	$'..'.NewRace(data["Race"])
	RaceNode = data["Node"]
	$'../Dropped'.add_child(data["Node"].duplicate())
	$Label.visible = false
