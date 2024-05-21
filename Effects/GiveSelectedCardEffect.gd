extends Effect

class_name GiveSelectedCardEffect

@export var EndOfTurn: Array[Effect]
@export var WarCry: Array[Effect]

func _init(GeneralEffectList: Array[Effect]) -> void:
	# inherented from Effect
	Command = "Give Selected Card Effect" 
	RequiredVars = ["End Of Turn", "End Of Turn(Command)", "War Cry", "War Cry(Command)", "While Creature Alive",  "While Creature Alive(Command)", "Upon Death", "Upon Death(Command)", "Start Of Your Opponents Turn"]
	VarsTypes = [ETypes.Category, ETypes.EffectCommand, ETypes.Category, ETypes.EffectCommand, ETypes.Category, ETypes.EffectCommand]
	
	for EffectOption: Effect in GeneralEffectList:
		RequiredVars.append(EffectOption.Command)
		VarsTypes.append(Effect.ETypes.EffectOption)
