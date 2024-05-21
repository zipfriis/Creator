extends MarginContainer

func _get_drag_data(_at_position: Vector2) -> Variant:
	var Data = {}
	Data["Race"] = $'..'.RaceName
	Data["Node"] = $'..'
	set_drag_preview($'..'.duplicate())
	return Data
