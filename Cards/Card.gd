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
@export var Block: bool

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


func _to_string() -> String:
	return JSON.stringify(ConvertToJSON())


func ConvertToJSON() -> Dictionary:
	var Data = {}
	Data["Name"] = Name
	if CardType == CardTypes.Unit:
		Data["Block"] = Block
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
