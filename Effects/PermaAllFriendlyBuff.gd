extends Effect

class_name PermaAllFriendlyBuff

var Health: int = 0
var AttackDamage: int = 0

func _init() -> void:
	# inherented from Effect
	Command = "Perma All Friendly Buff"
	RequiredVars = ["Health", "AttackDamage"]
	VarsTypes = [ETypes.Amount, ETypes.Amount]
