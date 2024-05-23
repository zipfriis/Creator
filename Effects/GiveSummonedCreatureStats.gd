extends Effect

class_name GiveSummonedCreatureStats

var Health: int = 0 
var AttackDamage: int = 0 

func _init() -> void:
	# inherented from Effect
	Command = "Give Summoned Creature Stats" 
	RequiredVars = ["Health", "AttackDamage"]
	VarsTypes = [ETypes.Amount, ETypes.Amount]
