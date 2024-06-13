extends Effect

class_name AllEnemyDebuff

var Health: int = 0
var AttackDamage: int = 0

func _init() -> void:
	# inherented from Effect
	Command = "All Enemy Debuff" 
	RequiredVars = ["Health", "AttackDamage"]
	VarsTypes = [ETypes.Amount, ETypes.Amount]
