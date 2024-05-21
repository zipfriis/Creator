extends MarginContainer

@export var Name: String
@export var data: Effect
var Hover: bool
var Dragging: bool 
var FirstPos: Vector2
var BlockType: String = "EffectBlock"
var Handler: Node

func DataSet(Block: Node, Data: Variant):
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
		elif effect.VarsTypes[i] == Effect.ETypes.Cards:
			var CardBlock = load('res://Scenes/CardBlock/empty_card_block.tscn').instantiate()
			InfoBlocks.add_child(CardBlock)
			CardBlock.AddText("Card: ")
		elif effect.VarsTypes[i] == Effect.ETypes.Type:
			var RaceBlock = load('res://Scenes/Race/empty_race.tscn').instantiate()
			InfoBlocks.add_child(RaceBlock)
		elif effect.VarsTypes[i] == Effect.ETypes.EffectCommand:
			var EffectBlock = load('res://effect_space.tscn').instantiate()
			InfoBlocks.add_child(EffectBlock)
			InitOfEffectBlock = EffectBlock
			EffectBlock.Handler = self
		elif effect.VarsTypes[i] == Effect.ETypes.EffectOption:
			if InitOfEffectBlock != null:
				InitOfEffectBlock.EffectOptionList.append(effect.RequiredVars[i])
		i = i + 1


func NewEffectData(Data: Array[Effect]):
	data.Effects = Data

func NewOptionData(option: int):
	print("new Option: " + str(option))

func NewRaceName(Name: String):
	print("new race name: " + str(Name))

func UpdateCardData(Data: Card):
	print("New Card")

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
