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
			CardList.append(Global.CardFromDict(CardOBJ))
	if Data["Tokens"]:
		for CardOBJ in Data['Tokens']:
			ToekenList.append(Global.CardFromDict(CardOBJ))
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

