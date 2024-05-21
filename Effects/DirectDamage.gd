extends Effect

class_name DirectDamage

var Amount: int = 0
var ChildEffect: Effect = null


func _init() -> void:
	# inherented from Effect
	Command = "Direct Damage" 
	RequiredVars = ["Amount", "Command", "If Direct Damage Killed"]
	VarsTypes = [ETypes.Amount, ETypes.EffectCommand, ETypes.EffectOption]

func ConvertToJSON() -> Dictionary:
	var Data = {}
	Data["Command"] = Command
	Data["Command"]["Amount"] = Amount
	return Data
