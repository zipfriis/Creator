extends Effect

class_name DrawCards

var Amount: int = 0

func _init() -> void:
	# inherented from Effect
	Command = "Draw Card(s)" 
	RequiredVars = ["Amount"]
	VarsTypes = [ETypes.Amount]
