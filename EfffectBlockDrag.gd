extends MarginContainer


func _get_drag_data(_at_position: Vector2) -> Variant:
	var data = {}
	data["Node"] = $'..'
	data["BlockType"] = $'..'.BlockType
	data["Effect"] = $'..'.data
	var NewEffect = load('res://Effect.tscn').instantiate()
	NewEffect.LoadEffect($'..'.data)
	set_drag_preview(NewEffect)
	return data


func _can_drop_data(_at_position:Vector2, data:Variant) -> bool:
	return true
