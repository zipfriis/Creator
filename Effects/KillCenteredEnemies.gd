extends Effect

class_name KillCenteredEnemies

var Amount: int = 0

func _init() -> void:
	# inherented from Effect
	Command =  "Kill Centered Enemie(s)" 
	RequiredVars = ["Amount"]
	VarsTypes = [ETypes.Amount]
