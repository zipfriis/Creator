extends Effect

class_name RevealOpponentsCards

func _init() -> void:
	Command = "Reveal Opponents Card(s)"
	RequiredVars = ["Amount"]
	VarsTypes = [ETypes.Amount]
