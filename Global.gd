extends Node

signal ClassHasLoaded

@export var Type_Record: Array[String]
@export var Classes: Array[Class]
var ClassLoaded: bool

@export var GeneralEffectList: Array[Effect] = [AllEnemyDebuff.new(), KillRandomEnemies.new(), OccupyBattleField.new(), ClearBoard.new(), DrawSpecificCards.new(), DrawCardByType.new(), AddCardToHand.new(), AddCardToDeck.new(), ReturnToHand.new(), AllFriendlyBuff.new(), SpecificCreatureBuff.new(), PermaAllFriendlyBuff.new(), DrawCards.new(), Summon.new(), ChooseCardByType.new(), FriendlyCreaturesAOEDamage.new(), EnemyCreaturesAOEDamage.new(), GiveSummonedCreatureStats.new(), AddChosenEnemyStatstoSpecificCreature.new(), KillCenteredEnemies.new()]
@export var TargetEffectList: Array[Effect] = [DirectDamage.new(), IfDirectDamageKilled.new(GeneralEffectList)]
@export var BerserkerEffectList: Array[Effect] = [NordicGods.new(GeneralEffectList), ForcesOfChaos.new(GeneralEffectList)]

func _ready() -> void:
	LoadSave()
	emit_signal("ClassHasLoaded")
	ClassLoaded = true


func GetClassByName(Name: String) -> Class:
	for ClassObj: Class in Classes:
		print("Class Name: " + str(ClassObj.Name) + " " + str(Name))
		if ClassObj.Name == Name:
			return ClassObj
	return null


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


func SaveCard(Data: Card):
	var i = 0
	for ClassThing: Class in Global.Classes:
		if Data.ClassName == ClassThing.Name:
			print("Correct class for save  of card")
			var j = 0
			for CardINClass in ClassThing.Cards:
				if CardINClass.Name == Data.Name:
					print("Correct Name for save of card")
					ClassThing.Cards[j] = Data
				j = j + 1
		Classes[i] = ClassThing # saving the new class data
		i = i + 1
	Save()


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
	return JSON.stringify(Data)


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
				var NewEffect = AllFriendlyBuff.new()
				NewEffect.AttackDamage = Contructer["All Friendly Buff"]["AttackDamage"]
				NewEffect.Health = Contructer["All Friendly Buff"]["Health"]
				return NewEffect
			"All Enemy Debuff":
				var NewEffect = AllEnemyDebuff.new()
				NewEffect.AttackDamage = Contructer["All Enemy Debuff"]["AttackDamage"]
				NewEffect.Health = Contructer["All Enemy Debuff"]["Health"]
				return NewEffect
			"Choose Card By Type":
				return ChooseCardByType.new()
			"Clear Board":
				return ClearBoard.new()
			"Direct Damage":
				var NewEffect = DirectDamage.new()
				NewEffect.Amount = Contructer["Direct Damage"]["Amount"]
				return NewEffect
			"Draw Card By Type":
				var NewEffect =  DrawCardByType.new()
				NewEffect.Type = Contructer["Draw Card By Type"]["Type"]
				return NewEffect
			"Draw Card(s)":
				return DrawCards.new()
			"Draw Specific Card(s)":
				var NewEffect = DrawSpecificCards.new()
				NewEffect.Amount = Contructer["Draw Specific Card(s)"]["Amount"]
				return NewEffect
			"Eat Discardpile":
				return EatDiscardpile.new()
			"Occupy BattleField":
				return OccupyBattleField.new()
			"Kill Random Enemie(s)":
				var NewEffect = KillRandomEnemies.new()
				NewEffect.Amount = Contructer["Kill Random Enemie(s)"]["Amount"]
				return NewEffect
			# Berserker Class effects
			"Nordic Gods":
				var NewEffect = NordicGods.new(Global.GeneralEffectList)
				for ChildEffect: Dictionary in Contructer["Nordic Gods"]["Effects"]:
					NewEffect.Effects.append(EffectFromDict(ChildEffect))
				return NewEffect
			"Forces Of Chaos":
				print("Forces Thing: " + str(Contructer))
				var NewEffect = ForcesOfChaos.new(Global.GeneralEffectList)
				for ChildEffect: Dictionary in Contructer["Forces Of Chaos"]["Effects"]:
					NewEffect.Effects.append(EffectFromDict(ChildEffect))
				print("Forces Thing: " + str(NewEffect.ConvertToJSON()))
				return NewEffect
