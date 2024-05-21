extends Effect

class_name Summon

@export var CardNameORToken: Card
@export var Amount: int

func _init() -> void:
	# inherented from Effect
	Command = "Summon"
	RequiredVars = ["CardNameORToken", "Amount"]
	VarsTypes = [ETypes.Cards, ETypes.Amount]

func ConvertToJSON() -> Dictionary:
	var Data = {}
	Data["Command"] = Command
	Data[Command]["CardNameORToken"] = CardNameORToken
	Data[Command]["Amount"] = Amount
	return Data
