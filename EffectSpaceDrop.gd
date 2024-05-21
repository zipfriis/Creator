extends MarginContainer

func _can_drop_data(_at_position: Vector2, Data: Variant) -> bool:
	if Data.has("BlockType"):
		if Data["BlockType"] == "EffectBlock":
			if Data["Effect"]["Command"] in $'../..'.EffectOptionList:
				return true
	return false


func _drop_data(_at_position: Vector2, Data: Variant) -> void:
	var EfffectBlock: Effect = Data["Effect"]
	print(EfffectBlock.ConvertToJSON())
	var NewEffect = load('res://Effect.tscn').instantiate()
	NewEffect.LoadEffect(EfffectBlock)
	$'../Effects'.add_child(NewEffect)
	NewEffect.Handler = $'../..'
