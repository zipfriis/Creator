extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _get_drag_data(at_position: Vector2) -> Variant:
	var data = {}
	data["Node"] = $'..'
	data["Card"] = $'..'.data
	$HBoxContainer/Edit.visible = false
	set_drag_preview($'..'.duplicate())
	return data


func _can_drop_data(at_position:Vector2, data:Variant) -> bool:
	return true
 
