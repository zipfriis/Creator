extends Panel


func _can_drop_data(at_position:Vector2, data:Variant) -> bool:
	return true

func _drop_data(at_position:Vector2, data:Variant)->void:
	var DataNode: Node = data['Node'] # Effect Node
	DataNode.get_parent().remove_child(DataNode)
