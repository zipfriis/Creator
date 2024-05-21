extends Effect

class_name StartOfYourOpponentsTurn

@export var CardNameORToken: Card
@export var Amount: int

func _init(GeneralEffectList: Array[Effect]) -> void:
	# inherented from Effect
	Command = "Start Of Your Opponents Turn" 
	RequiredVars = ["Command"]
	VarsTypes = [ETypes.EffectCommand]
	for EffectOption: Effect in GeneralEffectList:
		RequiredVars.append(EffectOption.Command)
		VarsTypes.append(Effect.ETypes.EffectOption)
