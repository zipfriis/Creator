extends MarginContainer

var RaceNode: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data.has("Node"):
		if data["Node"].BlockType == "RaceBlock":
			return true
	return false


func _drop_data(at_position: Vector2, data: Variant) -> void:
	print(data["Race"])
	$'..'.emit_signal("NewRaceName",data["Race"])
	$'..'.NewRace(data["Race"])
	RaceNode = data["Node"]
	$'../Dropped'.add_child(data["Node"].duplicate())
	$Label.visible = false
