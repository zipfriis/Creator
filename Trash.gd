extends Panel


func _can_drop_data(_at_position:Vector2, _data:Variant) -> bool:
	return true

func _drop_data(_at_position:Vector2, data:Variant)->void:
	var DataNode: Node = data['Node'] # Effect Node
	DataNode.get_parent().remove_child(DataNode)
