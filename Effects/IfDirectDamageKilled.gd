extends Effect

class_name IfDirectDamageKilled

func _init(GeneralEffectList: Array[Effect]) -> void:
	# inherented from Effect
	Command = "If Direct Damage Killed" 
	RequiredVars = ["Command"]
	VarsTypes = [ETypes.EffectCommand]
	for EffectOption: Effect in GeneralEffectList:
		RequiredVars.append(EffectOption.Command)
		VarsTypes.append(Effect.ETypes.EffectOption)
