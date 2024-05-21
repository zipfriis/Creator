extends Effect

class_name ChooseCardByType

var Race: String = ""

func _init() -> void:
	# inherented from Effect
	Command = "Choose Card By Type" 
	RequiredVars = ["Race"]
	VarsTypes = [ETypes.Type]

func ConvertToJSON() -> Dictionary:
	var Data = {}
	Data["Race"] = Race
	return Data
