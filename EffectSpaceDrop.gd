extends MarginContainer

func _can_drop_data(_at_position: Vector2, Data: Variant) -> bool:
	if Data.has("BlockType"):
		if Data["BlockType"] == "EffectBlock":
			if Data["Effect"]["Command"] in $'../..'.EffectOptionList:
				return true
	return false


func _drop_data(_at_position: Vector2, Data: Variant) -> void:
	var EfffectBlock: Effect = Data["Effect"]
	$'../..'.AddNewEffectBlock(EfffectBlock)
	print(EfffectBlock.ConvertToJSON())

