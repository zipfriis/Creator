extends Effect

class_name AddCardToDeck

var CardNameORToken: Card = null
var Amount: int = 0 

func _init() -> void:
	# inherented from Effect
	Command = "Add Card To Deck" 
	RequiredVars = ["CardNameORToken", "Amount"]
	VarsTypes = [ETypes.Cards, ETypes.Amount]
