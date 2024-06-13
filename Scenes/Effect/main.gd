extends MarginContainer

signal UpdateOfEffectData(Data: Effect, node: Node)

@export var Name: String
@export var data: Effect
var Hover: bool
var Dragging: bool 
var FirstPos: Vector2
var BlockType: String = "EffectBlock"
var Handler: Node

func DataSet(Block: Node, _Data: Variant):
	if Block.BlockType == "":
		pass


func LoadEffect(effect: Effect):
	data = effect
	$MarginContainer/VBoxContainer/Name.text = data.Command
	var InfoBlocks = $MarginContainer/VBoxContainer/InfoBlocks
	var i = 0
	var InitOfEffectBlock: Node = null
	for Var in effect.RequiredVars:
		if effect.VarsTypes[i] == Effect.ETypes.Amount:
			var OptionBlock = load('res://option_block.tscn').instantiate()
			InfoBlocks.add_child(OptionBlock)
			OptionBlock.SetText(Var)
			OptionBlock.NumberOptions(0, 10)
			if effect.Variables.has(Var):
				OptionBlock.Select(effect.Variables[Var])
			OptionBlock.NewOptionSelected.connect(_On_OptionsBlockData)
		elif effect.VarsTypes[i] == Effect.ETypes.Cards:
			var CardBlock = load('res://Scenes/CardBlock/empty_card_block.tscn').instantiate()
			InfoBlocks.add_child(CardBlock)
			CardBlock.AddText("Card: ")
			print("Loaded Card Name: " + str(effect.Variables))
			CardBlock.VarName = effect.RequiredVars[i] # Setting the Key name
			if effect.Variables.has("CardNameORToken"):
				if effect.Variables["CardNameORToken"] != "":
					CardBlock.LoadCardByName(effect.Variables["CardNameORToken"])
			CardBlock.UpdatedCardData.connect(_On_CardBlockData)
		elif effect.VarsTypes[i] == Effect.ETypes.Type:
			# only adds the raceblock instance, data gets loaded later
			var RaceBlock = load('res://Scenes/Race/empty_race.tscn').instantiate()
			InfoBlocks.add_child(RaceBlock)
			RaceBlock.VarName = effect.RequiredVars[i]
			if effect.Variables.has(Var):
				RaceBlock.LoadRace(effect.Variables[Var])
			RaceBlock.NewRaceName.connect(_On_RaceNameData)
		elif effect.VarsTypes[i] == Effect.ETypes.EffectCommand:
			
			
			var EffectBlock = load('res://effect_space.tscn').instantiate()
			InfoBlocks.add_child(EffectBlock)
			InitOfEffectBlock = EffectBlock
			EffectBlock.VariableName = "Effects"
			EffectBlock.NewEffectData.connect(On_NewEffectData)
		
		elif effect.VarsTypes[i] == Effect.ETypes.EffectOption:
			if InitOfEffectBlock != null:
				InitOfEffectBlock.EffectOptionList.append(effect.RequiredVars[i])
		i = i + 1
	# effects with child effects
	if effect.Command == "Forces Of Chaos":
		if InitOfEffectBlock != null:
			for EffectObj: Effect in effect.Effects:
				if EffectObj != null:
					print("Forces THing: " + str(EffectObj.ConvertToJSON()))
					InitOfEffectBlock.AddNewEffectBlock(EffectObj)
	elif effect.Command == "Nordic Gods":
		if InitOfEffectBlock != null:
			for EffectObj: Effect in effect.Effects:
				if EffectObj != null:
					InitOfEffectBlock.AddNewEffectBlock(EffectObj)

func _On_CardBlockData(Data: Card, VarName: String):
	data.Variables[VarName] = Data.Name
	print(data.Variables)
	emit_signal("UpdateOfEffectData", data, self)

func _On_OptionsBlockData(OptionName: String, Option: String):
	data.Variables[OptionName] = int(Option)
	print("OptionBlockData: " + str(data.Variables))
	emit_signal("UpdateOfEffectData", data, self)

func _On_RaceNameData(RaceName: String, VarName: String):
	data.Variables[VarName] = RaceName
	print("RaceNameData: " + str(data.Variables))
	emit_signal("UpdateOfEffectData", data, self)

func On_NewEffectData(Data: Array[Effect], VarName: String):
	data.Variables[VarName] = Data
	data.Effects = Data
	print("NewEffectData: " + str(data.Variables))
	emit_signal("UpdateOfEffectData", data, self)
	


func SetPolygon():
	var NewPolygon: PackedVector2Array = []
	NewPolygon.append(Vector2(0,0))
	NewPolygon.append(Vector2(15,0))
	NewPolygon.append(Vector2(25,-10))
	NewPolygon.append(Vector2(50,-10))
	NewPolygon.append(Vector2(60,0))
	NewPolygon.append(Vector2(size.x,0))
	NewPolygon.append(size)
	NewPolygon.append(Vector2(60,size.y))
	NewPolygon.append(Vector2(50,size.y -10))
	NewPolygon.append(Vector2(25,size.y -10))
	NewPolygon.append(Vector2(15,size.y))
	NewPolygon.append(Vector2(0,size.y))
	$Polygon2D.polygon = NewPolygon

func SetBorder():
	var NewPolygon: PackedVector2Array = []
	NewPolygon.append(Vector2(0,-2))
	NewPolygon.append(Vector2(15,-2))
	NewPolygon.append(Vector2(25,-12))
	NewPolygon.append(Vector2(50,-12))
	NewPolygon.append(Vector2(60,-2))
	NewPolygon.append(Vector2(size.x,-2))
	NewPolygon.append(Vector2(size.x,0))
	NewPolygon.append(Vector2(60,0))
	NewPolygon.append(Vector2(50,-10))
	NewPolygon.append(Vector2(25,-10))
	NewPolygon.append(Vector2(15,0))
	NewPolygon.append(Vector2(0,0))
	$Border.polygon = NewPolygon

func _on_resized() -> void:
	SetPolygon()
	SetBorder()
