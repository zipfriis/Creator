extends Effect

class_name EndOfTurn

@export var CardNameORToken: Card
@export var Amount: int

func _init(GeneralEffectList: Array[Effect]) -> void:
	# inherented from Effect
	Command = "End Of Turn" 
	RequiredVars = ["Command"]
	VarsTypes = [ETypes.EffectCommand]
	for EffectOption: Effect in GeneralEffectList:
		RequiredVars.append(EffectOption.Command)
		VarsTypes.append(Effect.ETypes.EffectOption)
