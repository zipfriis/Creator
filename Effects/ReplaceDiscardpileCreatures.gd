extends Effect

class_name ReplaceDiscardpileCreatures

var CardNameORToken: Card = null
var Amount: int = 0 

func _init() -> void:
	# inherented from Effect
	Command = "Replace Discardpile Creatures" 
	RequiredVars = ["CardNameORToken", "Amount"]
	VarsTypes = [ETypes.Cards, ETypes.Amount]

func ConvertToJSON() -> Dictionary:
	var Data = {}
	Data["CardNameORToken"] = CardNameORToken
	Data["Amount"] = Amount
	return Data
