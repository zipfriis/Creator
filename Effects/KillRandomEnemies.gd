extends Effect

class_name KillRandomEnemies

var Amount: int = 0

func _init() -> void:
	# inherented from Effect
	Command =  "Kill Random Enemie(s)" 
	RequiredVars = ["Amount"]
	VarsTypes = [ETypes.Amount]
