extends Effect

class_name DrawCards

var CardNameORToken: Card = null
var Amount: int = 0

func _init() -> void:
	# inherented from Effect
	Command = "Draw Card(s)" 
	RequiredVars = ["CardNameORToken", "Amount"]
	VarsTypes = [ETypes.Cards, ETypes.Amount]

func ConvertToJSON() -> Dictionary:
	var Data = {}
	Data["Command"] = Command
	Data[Command]["CardNameORToken"] = CardNameORToken
	Data[Command]["Amount"] = Amount
	return Data
