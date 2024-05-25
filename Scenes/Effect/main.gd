extends MarginContainer

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


func RemoveFromHanlder():
	if Handler != null:
		Handler.RemoveEffect(self)


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
			OptionBlock.Handler = self
			
			# specify all amount Etype of effects. 
			if effect.RequiredVars[i] == "Amount":
				OptionBlock.Select(effect.Amount)
			elif effect.RequiredVars[i] == "Health":
				OptionBlock.Select(effect.Health)
			elif effect.RequiredVars[i] == "AttackDamage":
				OptionBlock.Select(effect.AttackDamage)
			
		elif effect.VarsTypes[i] == Effect.ETypes.Cards:
			var CardBlock = load('res://Scenes/CardBlock/empty_card_block.tscn').instantiate()
			InfoBlocks.add_child(CardBlock)
			CardBlock.AddText("Card: ")
			CardBlock.VarName = effect.RequiredVars[i] # Setting the Key name
			CardBlock.Handler = self
			# Loading card name into the block
			if effect.CardNameORToken != null:
				if effect.CardNameORToken != "":
					var CardObj: Card = Global.GetCardByName(effect.CardNameORToken)
					if CardObj != null:
						CardBlock.LoadName(CardObj.Name, CardObj.Token)
				
		elif effect.VarsTypes[i] == Effect.ETypes.Type:
			var RaceBlock = load('res://Scenes/Race/empty_race.tscn').instantiate()
			InfoBlocks.add_child(RaceBlock)
		elif effect.VarsTypes[i] == Effect.ETypes.EffectCommand:
			var EffectBlock = load('res://effect_space.tscn').instantiate()
			InfoBlocks.add_child(EffectBlock)
			InitOfEffectBlock = EffectBlock
			EffectBlock.SetHandler(self, effect.RequiredVars[i])
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


func NewEffectData(Data: Array[Effect], VarName: String):
	# new
	data.Variables[VarName] = Data
	
	data.Effects = Data

func NewOptionData(Option: int, VarName: String):
	# new
	data.Variables[VarName] = Option
	
	# legacy
	if VarName == "Amount":
		data.Amount = Option
	elif VarName == "Health":
		data.Health = Option
	elif VarName == "AttackDamage":
		data.AttackDamage = Option


func NewRaceName(RaceName: String, VarName: String):
	# new
	data.Variables[VarName] = RaceName
	
	# legacy
	data.Type = RaceName


func UpdateCardData(Data: String, VarName: String):
	# new
	data.Variables[VarName] = Data
	
	# legacy
	data.CardNameORToken = Data


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
