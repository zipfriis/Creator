extends Effect

class_name SummonForOpponent

@export var CardNameORToken: String
@export var Amount: int

func _init() -> void:
	# inherented from Effect
	Command = "Summon For Opponent"
	RequiredVars = ["CardNameORToken", "Amount"]
	VarsTypes = [ETypes.Cards, ETypes.Amount]
