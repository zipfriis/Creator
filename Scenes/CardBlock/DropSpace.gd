extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _can_drop_data(at_position: Vector2, Data: Variant) -> bool:
	if Data.has("Node"):
		if Data["Node"].BlockType != null:
			if Data["Node"].BlockType == "CardBlock":
				return true
	return false

func _drop_data(at_position: Vector2, Data: Variant) -> void:
	$Polygon2D.visible = false
	$'..'.UpdateData(Data["Card"])
