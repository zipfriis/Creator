extends Effect

class_name AddCardToHand

var CardNameORToken: Card = null
var Amount: int = 0

func _init() -> void:
	# inherented from Effect
	Command = "Add Card To Hand" 
	RequiredVars = ["CardNameORToken", "Amount"]
	VarsTypes = [ETypes.Cards, ETypes.Amount]
