extends Resource

class_name Card

enum CardTypes {Unit, Spell, Nothing}

#init info to make card.
@export var Name: String
@export var CardType: CardTypes
@export var ClassName: String

# Set infomation as a Unit type
@export var Description: String
@export var Type: String
@export var EssenceCost: int
@export var Health: int
@export var AttackDamage: int

# unit Trigger effects
@export var EndOfTurnTrigger: Array[Effect]
@export var WarCryTrigger: Array[Effect]
@export var WhileAliveTrigger: Array[Effect]
@export var UponDeathTrigger: Array[Effect]
@export var StartOppTrigger: Array[Effect]

# Spell trigger effects 
@export var Effects: Array[Effect]

# manage of efitor state
@export var PermissibleEffects: Array[String] = []
@export var Token: bool = false


func _init(I_Name: String) -> void:
	Name = I_Name
	CardType = CardTypes.Unit


func LoadCardDict(Data: Dictionary) -> void:
	print("Loaded: " + str(Data))
	
	Name = Data["Name"]
	ClassName = Data["Class"]
	Description = Data["Description"]
	
	if Data.has("Type"):
		Type = Data["Type"]
	EssenceCost = Data["EssenceCost"]
	if Data.has("Health"):
		Health = Data["Health"]
	if Data.has("AttackDamage"):
		AttackDamage = Data["AttackDamage"]
	
	for EffectForBerserker in Global.BerserkerEffectList:
		PermissibleEffects.append(EffectForBerserker.Command)
	print(Global.BerserkerEffectList)
	if Data["CardType"] == "Unit":
		CardType = Card.CardTypes.Unit
		for EffectForUnit in Global.GeneralEffectList:
			PermissibleEffects.append(EffectForUnit.Command)
		# loading the effects 
		if Data.has("End Of Turn"):
			if len(Data["End Of Turn"]) != 0:
				for EndOfTurn: Dictionary in Data["End Of Turn"]:
					EndOfTurnTrigger.append(Global.EffectFromDict(EndOfTurn))
		if Data.has("War Cry"):
			if len(Data["War Cry"]) != 0:
				for WarCryDict: Dictionary in Data["War Cry"]:
					WarCryTrigger.append(Global.EffectFromDict(WarCryDict))
		if Data.has("Upon Death"):
			if len(Data["Upon Death"]) != 0:
				for UponDeathEffect: Dictionary in Data["Upon Death"]:
					UponDeathTrigger.append(Global.EffectFromDict(UponDeathEffect))
		if Data.has("While Alive"):
			if len(Data["While Alive"]) != 0:
				for WhileAlive: Dictionary in Data["While Alive"]:
					WhileAliveTrigger.append(Global.EffectFromDict(WhileAlive))
		if Data.has("Start Of Opponent Turn"):
			if len(Data["Start Of Opponent Turn"]) != 0:
				for StartOfOppTurn: Dictionary in Data["Start Of Opponent Turn"]:
					StartOppTrigger.append(Global.EffectFromDict(StartOfOppTurn))
	elif Data["CardType"] == "Spell":
		for EffectForUnit in Global.GeneralEffectList:
			PermissibleEffects. append(EffectForUnit.Command)
		for EffectForUnit in Global.TargetEffectList:
			PermissibleEffects. append(EffectForUnit.Command)
		CardType = Card.CardTypes.Spell
		# loading the effects 
		if Data.has("Effects"):
			if len(Data["Effects"]) != 0:
				for EffectDict: Dictionary in Data["Effects"]:
					Effects.append(Global.EffectFromDict(EffectDict))
	else:
		CardType = Card.CardTypes.Nothing
	if JSON.stringify(self.ConvertToJSON()) != JSON.stringify(Data):
		push_error("loading change the card data, something is wrong")
		print("Error: " + str(self.ConvertToJSON()) + "  Before: " + str(Data))


func ConvertToJSON() -> Dictionary:
	var Data = {}
	Data["Name"] = Name
	if CardType == CardTypes.Unit:
		Data["CardType"] = "Unit"
		Data["End Of Turn"] = []
		if len(EndOfTurnTrigger) != 0:
			for EffectInList: Effect in EndOfTurnTrigger:
				if EffectInList != null:
					Data["End Of Turn"].append(EffectInList.ConvertToJSON())
		Data["War Cry"] = []
		if len(WarCryTrigger) != 0:
			for EffectInList in WarCryTrigger:
				if EffectInList != null:
					Data["War Cry"].append(EffectInList.ConvertToJSON())
		Data["While Alive"] = []
		if len(WhileAliveTrigger) != 0:
			for EffectInList in WhileAliveTrigger:
				if EffectInList != null:
					Data["While Alive"].append(EffectInList.ConvertToJSON())
		Data["Upon Death"] = []
		if len(UponDeathTrigger) != 0:
			for EffectInList in UponDeathTrigger:
				if EffectInList != null:
					Data["Upon Death"].append(EffectInList.ConvertToJSON())
		Data["Start Of Opponent Turn"] = []
		if len(StartOppTrigger) != 0:
			for EffectInList in StartOppTrigger:
				if EffectInList != null:
					Data["Start Of Opponent Turn"].append(EffectInList.ConvertToJSON())
	elif CardType == CardTypes.Spell:
		Data["CardType"] = "Spell"
		for EffectInList in Effects:
			if EffectInList != null:
				Data["Effects"].append(EffectInList.ConvertToJSON())
	else:
		Data["CardType"] = "Nothing"
	Data["Description"] = Description
	Data["Type"] = Type
	Data["EssenceCost"] = EssenceCost
	Data["Health"] = Health
	Data["AttackDamage"] = AttackDamage
	Data["Class"] = ClassName
	var CardString = JSON.stringify(Data)
	Data = JSON.parse_string(CardString)
	
	return Data
