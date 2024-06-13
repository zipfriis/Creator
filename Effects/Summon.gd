extends Effect

class_name Summon

@export var CardNameORToken: String
@export var Amount: int

func _init() -> void:
	# inherented from Effect
	Command = "Summon"
	RequiredVars = ["CardNameORToken", "Amount"]
	VarsTypes = [ETypes.Cards, ETypes.Amount]

