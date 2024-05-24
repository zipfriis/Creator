extends MarginContainer

func _can_drop_data(_at_position: Vector2, Data: Variant) -> bool:
	if Data.has("Node"):
		if Data["Node"].BlockType != null:
			if Data["Node"].BlockType == "CardBlock":
				return true
	return false

func _drop_data(_at_position: Vector2, Data: Variant) -> void:
	print("Dropped Data: " + str(Data))
	$Polygon2D.visible = false
	$'..'.UpdateData(Data["Card"])
