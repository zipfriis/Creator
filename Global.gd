extends Node

signal ClassHasLoaded

@export var Type_Record: Array[String]
@export var Classes: Array[Class]
var ClassLoaded: bool

@export var GeneralEffectList: Array[Effect] = [KillRandomEnemies.new(), OccupyBattleField.new(), ClearBoard.new(), DrawSpecificCards.new(), DrawCardByType.new(), AddCardToHand.new(), AddCardToDeck.new(), ReturnToHand.new(), AllFriendlyBuff.new(), SpecificCreatureBuff.new(), PermaAllFriendlyBuff.new(), DrawCards.new(), Summon.new(), ChooseCardByType.new(), FriendlyCreaturesAOEDamage.new(), EnemyCreaturesAOEDamage.new(), GiveSummonedCreatureStats.new(), AddChosenEnemyStatstoSpecificCreature.new(), KillCenteredEnemies.new()]
@export var TargetEffectList: Array[Effect] = [DirectDamage.new(), IfDirectDamageKilled.new(GeneralEffectList)]
@export var BerserkerEffectList: Array[Effect] = [NordicGods.new(GeneralEffectList), ForcesOfChaos.new(GeneralEffectList)]

func _ready() -> void:
	LoadSave()
	emit_signal("ClassHasLoaded")
	ClassLoaded = true


func GetClasses() -> Array[Class]:
	if ClassLoaded == false:
		await ClassHasLoaded
	return Classes


func Save():
	var Data: Dictionary
	Data["Classes"] = [] 
	for ClassObj: Class in Classes:
		Data["Classes"].append(ClassObj.ConvertToJSON())
	Data["Type_Record"] = Type_Record
	var file = FileAccess.open("user://Config.save", FileAccess.WRITE)
	file.store_string(JSON.stringify(Data))
	file.close()


# gets to user saved file
func LoadSave():
	if FileAccess.file_exists("user://Config.save"):
		var data = JSON.parse_string(FileAccess.get_file_as_string("user://Config.save"))
		if typeof(data) == TYPE_DICTIONARY:
			print("Raw Data: " + str(data))
			for ClassDict: Dictionary in data["Classes"]:
				var ClassObj = Class.new(ClassDict["Name"])
				ClassObj.LoadClassDict(ClassDict)
				Classes.append(ClassObj)
			for TypeString in data["Type_Record"]:
				Type_Record.append(TypeString)
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")


func GetRaw() -> String:
	var Data: Dictionary
	Data["Classes"] = [] 
	for ClassObj: Class in Classes:
		Data["Classes"].append(ClassObj.ConvertToJSON())
	Data["Type_Record"] = Type_Record
	return str(Data)


func EffectFromDict(Contructer: Dictionary):
	if Contructer.has("Command"):
		match Contructer["Command"]:
			"Active Fear Status All Enemies":
				return ActivateFearStatusAllEnemies.new()
			"Add Card To Deck":
				return AddCardToDeck.new()
			"Add Card To Hand":
				return AddCardToHand.new()
			"Add Chosen Enemy Stats to Specific Creature":
				return AddChosenEnemyStatstoSpecificCreature.new()
			"All Friendly Buff":
				return AllFriendlyBuff.new()
			"Choose Card By Type":
				return ChooseCardByType.new()
			"Clear Board":
				return ClearBoard.new()
			"Direct Damage":
				return DirectDamage.new()
			"Draw Card By Type":
				return DrawCardByType.new()
			"Draw Card(s)":
				return DrawCards.new()
			"Draw Specific Card(s)":
				return DrawSpecificCards.new()
			"Eat Discardpile":
				return EatDiscardpile.new()
			"Occupy BattleField":
				return OccupyBattleField.new()
			"Kill Random Enemie(s)":
				return KillRandomEnemies.new()
			# Berserker Class effects
			"Nordic Gods":
				var NewEffect = NordicGods.new(Global.GeneralEffectList)
				for ChildEffect: Dictionary in Contructer["Nordic Gods"]["Effects"]:
					NewEffect.Effects.append(EffectFromDict(ChildEffect))
				return NewEffect
			"Forces Of Chaos":
				var NewEffect = ForcesOfChaos.new(Global.GeneralEffectList)
				for ChildEffect: Dictionary in Contructer["Forces Of Chaos"]["Effects"]:
					NewEffect.Effects.append(EffectFromDict(ChildEffect))
					print("Forces Of Chaos Child: " + str(ChildEffect) + " " + str(NewEffect.Effects))
				return NewEffect
