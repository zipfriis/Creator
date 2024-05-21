extends Effect

class_name GiveSummonedCreatureStats

func _init() -> void:
	# inherented from Effect
	Command = "Give Summoned Creature Stats" 
	RequiredVars = ["Health", "AttackDamage"]
	VarsTypes = [ETypes.Amount, ETypes.Amount]
