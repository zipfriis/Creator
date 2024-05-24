extends MarginContainer


func _get_drag_data(_at_position: Vector2) -> Variant:
	var data = {}
	data["Node"] = $'..'
	data["Card"] = $'..'.data
	set_drag_preview($'..'.duplicate())
	return data


func _can_drop_data(_at_position:Vector2, _data:Variant) -> bool:
	return true
 
