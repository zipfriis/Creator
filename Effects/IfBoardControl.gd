extends Effect

class_name IfBoardControl

@export var CardNameORToken: String
@export var Effects: Array[Effect]

func _init(GeneralEffectList: Array[Effect]) -> void:
	# inherented from Effect
	Command = "If Board Control" 
	RequiredVars = ["CardNameORToken", "Command"]
	VarsTypes = [ETypes.Cards, ETypes.EffectCommand]
	for EffectOption: Effect in GeneralEffectList:
		RequiredVars.append(EffectOption.Command)
		VarsTypes.append(Effect.ETypes.EffectOption)
	# making a empty list of effects
	Variables["Effects"] = []
