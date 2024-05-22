extends Node

class_name Class

@export var Name: String
@export var PassiveName: String
@export var PassiveEffect: Array[Effect]
@export var Cards: Array[Card]
@export var Tokens: Array[Card]

func _init(I_Name: String) -> void:
	if I_Name != "":
		Name = I_Name


func LoadClassDict(Data: Dictionary):
	Name = Data["Name"]
	PassiveName = Data['PassiveName']
	#PassiveEffect = Data['PassiveEffect']
	var CardList: Array[Card] = []
	var ToekenList: Array[Card] = []
	if Data["Cards"]:
		for CardOBJ in Data['Cards']:
			var NewCard: Card
			if CardOBJ.has("CardName"):
				NewCard = Card.new(CardOBJ['CardName'])
			else:
				NewCard = Card.new(CardOBJ['Name'])
			NewCard.LoadCardDict(CardOBJ)
			CardList.append(NewCard)
	if Data["Tokens"]:
		for CardOBJ in Data['Tokens']:
			print(CardOBJ)
			var NewCard: Card
			if CardOBJ.has("TokenName"):
				NewCard = Card.new(CardOBJ['TokenName'])
			else:
				NewCard = Card.new(CardOBJ['Name'])
			NewCard.LoadCardDict(CardOBJ)
			ToekenList.append(NewCard)
	Cards = CardList
	Tokens = ToekenList

func ConvertToJSON() -> Dictionary:
	var Data: Dictionary = {}
	Data["Name"] = Name
	Data["PassiveName"] = PassiveName
	Data["PassiveEffect"] = []
	for EffectObj in PassiveEffect:
		Data["PassiveEffect"].append(EffectObj.ConvertToJSON())
	Data["Cards"] = []
	for CardObj in Cards:
		Data["Cards"].append(CardObj.ConvertToJSON())
	Data["Tokens"] = []
	for CardObj in Tokens:
		Data["Tokens"].append(CardObj.ConvertToJSON())
	return Data

