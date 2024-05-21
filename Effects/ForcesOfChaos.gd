extends Effect

class_name ForcesOfChaos

@export var Effects: Array[Effect]

func _init(GeneralEffectList: Array[Effect]) -> void:
	# inherented from Effect
	Command = "Forces Of Chaos" 
	RequiredVars = ["Command"]
	VarsTypes = [ETypes.EffectCommand]
	for EffectOption: Effect in GeneralEffectList:
		RequiredVars.append(EffectOption.Command)
		VarsTypes.append(Effect.ETypes.EffectOption)

func ConvertToJSON() -> Dictionary:
	var Data = {}
	Data["Command"] = Command
	Data[Command] = {}
	var ListOfEffects: Array[Dictionary]
	for ChildEffect in Effects:
		if ChildEffect != null:
			ListOfEffects.append(ChildEffect.ConvertToJSON())
	Data[Command]["Effects"] = ListOfEffects
	return Data
