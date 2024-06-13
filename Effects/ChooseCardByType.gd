extends Effect

class_name ChooseCardByType

var Race: String = ""
var Amount: int = 0

func _init() -> void:
	# inherented from Effect
	Command = "Choose Card By Type" 
	RequiredVars = ["Race", "Amount"]
	VarsTypes = [ETypes.Type, ETypes.Amount]
