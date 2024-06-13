extends Effect

class_name SpecificCreatureBuff

@export var CardNameORToken: Card
@export var Health: int
@export var AttackDamage: int

func _init() -> void:
	# inherented from Effect
	Command = "Specific Creature Buff"
	RequiredVars = ["CardNameORToken", "Health", "AttackDamage"]
	VarsTypes = [ETypes.Cards, ETypes.Amount, ETypes.Amount]

