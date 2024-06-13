extends Node

signal ClassHasLoaded

@export var JSON_Save: Dictionary = {}

@export var Type_Record: Array[String]
@export var Classes: Array[Class]
var ClassLoaded: bool

var MetaGeneralEffectList: Array[Effect] = [AllEnemyDebuff.new(), KillRandomEnemies.new(), OccupyBattleField.new(), ClearBoard.new(), DrawSpecificCards.new(), DrawCardByType.new(), AddCardToHand.new(), AddCardToDeck.new(), ReturnToHand.new(), LookAtTopOfDeck.new(),  AllFriendlyBuff.new(), SpecificCreatureBuff.new(), PermaAllFriendlyBuff.new(), DrawCards.new(), Summon.new(), SummonForOpponent.new(), ChooseCardByType.new(), FriendlyCreaturesAOEDamage.new(), EnemyCreaturesAOEDamage.new(), GiveSummonedCreatureStats.new(), AddChosenEnemyStatstoSpecificCreature.new(), KillCenteredEnemies.new()]
@export var GeneralEffectList: Array[Effect] = [AllEnemyDebuff.new(), KillRandomEnemies.new(), OccupyBattleField.new(), ClearBoard.new(), DrawSpecificCards.new(), DrawCardByType.new(), IfBoardControl.new(MetaGeneralEffectList), RevealOpponentsCards.new(), AddCardToHand.new(), AddCardToDeck.new(), ReturnToHand.new(), LookAtTopOfDeck.new(),  AllFriendlyBuff.new(), SpecificCreatureBuff.new(), PermaAllFriendlyBuff.new(), DrawCards.new(), Summon.new(), SummonForOpponent.new(), ChooseCardByType.new(), FriendlyCreaturesAOEDamage.new(), EnemyCreaturesAOEDamage.new(), GiveSummonedCreatureStats.new(), AddChosenEnemyStatstoSpecificCreature.new(), KillCenteredEnemies.new()]
@export var TargetEffectList: Array[Effect] = [DirectDamage.new(), IfDirectDamageKilled.new(GeneralEffectList)]
@export var BerserkerEffectList: Array[Effect] = [NordicGods.new(GeneralEffectList), ForcesOfChaos.new(GeneralEffectList)]

func _ready() -> void:
	LoadSave()
	emit_signal("ClassHasLoaded")
	ClassLoaded = true

func LoadClasses(Data: Array[Class]):
	Classes = Data
	Save()

func LoadTypeRecord(List: Array[String]):
	Type_Record = List
	Save()

func GetCardByName(CardName: String) -> Card:
	for ClassThing: Dictionary in JSON_Save["Classes"]:
		var j = 0
		for CardINClass in ClassThing["Cards"]:
			if CardINClass["Name"] == CardName:
				var NewCard = CardFromDict(CardINClass)
				return NewCard
			j = j + 1
		j = 0
		for CardINClass in ClassThing["Tokens"]:
			if CardINClass["Name"] == CardName:
				var NewCard = CardFromDict(CardINClass)
				NewCard.Token = true
				return NewCard
			j = j + 1
	return null


func GetClassByName(Name: String) -> Class:
	LoadSave()
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
	var file = FileAccess.open("user://Config.save", FileAccess.WRITE)
	file.store_string(JSON.stringify(JSON_Save))
	file.close()


func SaveCard(Data: Card):
	print("Pre Save TO Disk: " + str(Data.ConvertToJSON()))
	var i = 0
	for ClassThing: Dictionary in JSON_Save["Classes"]:
		if ClassThing["Name"] == Data.ClassName:
			var j = 0
			for CardINClass in ClassThing["Cards"]:
				if CardINClass["Name"] == Data.Name:
					ClassThing["Cards"][j] = Data.ConvertToJSON()
				j = j + 1
			j = 0
			for CardINClass in ClassThing["Tokens"]:
				if CardINClass["Name"] == Data.Name:
					ClassThing["Tokens"][j] = Data.ConvertToJSON()
				j = j + 1
			JSON_Save["Classes"][i] = ClassThing
		i = i + 1
	print("Pre Save TO Disk After: " + str(JSON_Save["Classes"]))
	Save()

# gets to user saved file
func LoadSave():
	if FileAccess.file_exists("user://Config.save"):
		var data = JSON.parse_string(FileAccess.get_file_as_string("user://Config.save"))
		JSON_Save = data
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
	var Data: Dictionary = {}
	Data["Classes"] = [] 
	for ClassObj: Class in Classes:
		Data["Classes"].append(ClassObj.ConvertToJSON())
	Data["Type_Record"] = Type_Record
	return JSON.stringify(Data)


func CardFromDict(Contructor: Dictionary) -> Card:
	var NewCard: Card = Card.new("") #new card object
	# it will return null, if dict dont have a name for card
	if Contructor.has("Block"):
		NewCard.Block = Contructor["Block"]
	if Contructor.has("Name"):
		if Contructor["Name"] != "":
			NewCard.Name = Contructor["Name"]
		else:
			return null
	else:
		return null
	# it will return null, if dict dont have a Class for card
	if Contructor.has("Class"):
		if Contructor["Class"] != "":
			NewCard.ClassName = Contructor["Class"]
		else:
			return null
	else:
		return null
	# use data if there is any..
	if Contructor.has("Description"):
		NewCard.Description = Contructor["Description"]
	if Contructor.has("Type"):
		NewCard.Type = Contructor["Type"]
	NewCard.EssenceCost = Contructor["EssenceCost"]
	if Contructor.has("Health"):
		NewCard.Health = Contructor["Health"]
	if Contructor.has("AttackDamage"):
		NewCard.AttackDamage = Contructor["AttackDamage"]
	# effects if card is clas berserker
	if NewCard.ClassName == "Berserker":
		for EffectForBerserker in Global.BerserkerEffectList:
			NewCard.PermissibleEffects.append(EffectForBerserker.Command)
	# Converting Trigger Effects
	if Contructor["CardType"] == "Unit":
		NewCard.CardType = Card.CardTypes.Unit
		for EffectForUnit in Global.GeneralEffectList:
			NewCard.PermissibleEffects.append(EffectForUnit.Command)
		if Contructor.has("End Of Turn"):
			if len(Contructor["End Of Turn"]) != 0:
				for EndOfTurn: Dictionary in Contructor["End Of Turn"]:
					NewCard.EndOfTurnTrigger.append(EffectFromDict(EndOfTurn))
		if Contructor.has("War Cry"):
			if len(Contructor["War Cry"]) != 0:
				for WarCryDict: Dictionary in Contructor["War Cry"]:
					NewCard.WarCryTrigger.append(EffectFromDict(WarCryDict))
		if Contructor.has("Upon Death"):
			if len(Contructor["Upon Death"]) != 0:
				for UponDeathEffect: Dictionary in Contructor["Upon Death"]:
					NewCard.UponDeathTrigger.append(EffectFromDict(UponDeathEffect))
		if Contructor.has("While Alive"):
			if len(Contructor["While Alive"]) != 0:
				for WhileAlive: Dictionary in Contructor["While Alive"]:
					NewCard.WhileAliveTrigger.append(EffectFromDict(WhileAlive))
		if Contructor.has("Start Of Opponent Turn"):
			if len(Contructor["Start Of Opponent Turn"]) != 0:
				for StartOfOppTurn: Dictionary in Contructor["Start Of Opponent Turn"]:
					NewCard.StartOppTrigger.append(Global.EffectFromDict(StartOfOppTurn))
	elif Contructor["CardType"] == "Spell":
		for EffectForUnit in Global.GeneralEffectList:
			NewCard.PermissibleEffects. append(EffectForUnit.Command)
		for EffectForUnit in Global.TargetEffectList:
			NewCard.PermissibleEffects. append(EffectForUnit.Command)
		NewCard.CardType = Card.CardTypes.Spell
		if Contructor.has("Effects"):
			if len(Contructor["Effects"]) != 0:
				for EffectDict: Dictionary in Contructor["Effects"]:
					NewCard.Effects.append(Global.EffectFromDict(EffectDict))
	else:
		NewCard.CardType = Card.CardTypes.Nothing
	if str(NewCard) != JSON.stringify(Contructor):
		push_error("loading change the card data, something is wrong")
		print("Error: " + str(NewCard) + "  Before: " + JSON.stringify(Contructor))
	return NewCard


func EffectFromDict(Contructer: Dictionary) -> Effect:
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
				NewEffect.Variables["AttackDamage"] = Contructer["All Friendly Buff"]["AttackDamage"]
				NewEffect.Variables["Health"] = Contructer["All Friendly Buff"]["Health"]
				return NewEffect
			"All Enemy Debuff":
				var NewEffect = AllEnemyDebuff.new()
				NewEffect.Variables["AttackDamage"] = Contructer["All Enemy Debuff"]["AttackDamage"]
				NewEffect.Variables["Health"] = Contructer["All Enemy Debuff"]["Health"]
				return NewEffect
			"Choose Card By Type":
				var NewEffect = ChooseCardByType.new()
				NewEffect.Variables["Race"] = Contructer["Choose Card By Type"]["Race"]
				NewEffect.Variables["Amount"] = Contructer["Choose Card By Type"]["Amount"]
				return NewEffect
			"Clear Board":
				return ClearBoard.new()
			"Direct Damage":
				var NewEffect = DirectDamage.new()
				NewEffect.Variables["Amount"] = Contructer["Direct Damage"]["Amount"]
				return NewEffect
			"Draw Card By Type":
				var NewEffect =  DrawCardByType.new()
				NewEffect.Variables["Type"] = Contructer["Draw Card By Type"]["Type"]
				return NewEffect
			"Draw Card(s)":
				var NewEffect =  DrawCards.new()
				NewEffect.Variables["Amount"] = Contructer["Draw Card(s)"]["Amount"]
				return NewEffect
			"Draw Specific Card(s)":
				var NewEffect = DrawSpecificCards.new()
				NewEffect.Variables["Amount"] = Contructer["Draw Specific Card(s)"]["Amount"]
			"Eat Discardpile":
				return EatDiscardpile.new()
			"Occupy BattleField":
				return OccupyBattleField.new()
			"Kill Random Enemie(s)":
				var NewEffect = KillRandomEnemies.new()
				NewEffect.Variables["Amount"] = Contructer["Kill Random Enemie(s)"]["Amount"]
				return NewEffect
			"Summon":
				var NewEffect = Summon.new()
				if Contructer["Summon"].has("Amount"):
					NewEffect.Variables["Amount"] = Contructer["Summon"]["Amount"]
				if Contructer["Summon"].has("CardNameORToken"):
					NewEffect.Variables["CardNameORToken"] = Contructer["Summon"]["CardNameORToken"]
				return NewEffect
			"Summon For Opponent":
				var NewEffect = SummonForOpponent.new()
				NewEffect.Variables["Amount"] = Contructer["Summon For Opponent"]["Amount"]
				NewEffect.Variables["CardNameORToken"] = Contructer["Summon For Opponent"]["CardNameORToken"]
				return NewEffect
			"If Board Control":
				print("If Control: " + str(Contructer))
				var NewEffect = IfBoardControl.new(MetaGeneralEffectList)
				NewEffect.Variables["CardNameORToken"] = Contructer["If Board Control"]["CardNameORToken"]
				for ChildEffect: Dictionary in Contructer["If Board Control"]["Effects"]:
					NewEffect.Effects.append(EffectFromDict(ChildEffect))
				return NewEffect
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
				return NewEffect
	return null
