extends Effect

class_name DrawCardByType

var Type: String = "null"

func _init() -> void:
	# inherented from Effect
	Command =  "Draw Card By Type" 
	RequiredVars = ["Type"]
	VarsTypes = [ETypes.Type]

func ConvertToJSON() -> Dictionary:
	var Data = {}
	Data["Command"] = Command
	Data[Command]["Type"] = Type
	return Data
