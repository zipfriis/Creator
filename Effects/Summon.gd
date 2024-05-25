extends Effect

class_name Summon

@export var CardNameORToken: String
@export var Amount: int

func _init() -> void:
	# inherented from Effect
	Command = "Summon"
	RequiredVars = ["CardNameORToken", "Amount"]
	VarsTypes = [ETypes.Cards, ETypes.Amount]

func ConvertToJSON() -> Dictionary:
	var Data = {}
	Data["Command"] = Command
	Data[Command] = {}
	if CardNameORToken != null:
		Data[Command]["CardNameORToken"] = CardNameORToken
	Data[Command]["Amount"] = Amount
	return Data
