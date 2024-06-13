extends Effect

class_name AddChosenEnemyStatstoSpecificCreature

var CardNameORToken: Card = null

func _init() -> void:
	# inherented from Effect
	Command = "Add Chosen Enemy Stats to Specific Creature" 
	RequiredVars = ["CardNameORToken"]
	VarsTypes = [ETypes.Cards]
