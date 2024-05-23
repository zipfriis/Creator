extends MarginContainer

signal NewEffectData(Data: Array[Effect])

var EffectAmount: int = 0
var LimitEffectAmount: int = -1 # Should at least have a limit of 1, to warent its use.
var EffectList: Array[Effect] = []
var EffectOptionList: Array[String]
var Handler: Node
var Data: Array[Dictionary]


func Clear():
	for ChildEffect in $VBoxContainer/Effects.get_children():
		$VBoxContainer/Effects.remove_child(ChildEffect)


func AddNewEffectBlock(EffectObj: Effect) -> void:
	EffectList.append(EffectObj)
	Data.append(EffectObj.ConvertToJSON())
	var NewEffectBlock = load('res://Effect.tscn').instantiate()
	NewEffectBlock.LoadEffect(EffectObj)
	$VBoxContainer/Effects.add_child(NewEffectBlock)


func CheckEffectAmount() -> void:
	if EffectAmount == LimitEffectAmount:
		$VBoxContainer/EmptySpace.visible = false
	else:
		$VBoxContainer/EmptySpace.visible = true


func ReloadEffectList(IgnoreNodes: Array[Node]) -> void:
	# resetting lists
	EffectList = []
	Data = []
	for EffectItem in $VBoxContainer/Effects.get_children():
		if EffectItem not in IgnoreNodes:
			var EffectObj: Effect = EffectItem.data
			EffectList.append(EffectObj)
			Data.append(EffectObj.ConvertToJSON())
	print("New effect list: " + str(Data))
	emit_signal("NewEffectData", EffectList)
	if Handler != null:
		Handler.NewEffectData(EffectList)

func _on_resized() -> void:
	SetPolygon($VBoxContainer/EmptySpace, $VBoxContainer/EmptySpace/Polygon2D)
	SetPolygon($'.', $Polygon2D)


func SetPolygon(ContainerBox: Node, Polygon: Polygon2D):
	var Box = ContainerBox
	var NewPolygon: PackedVector2Array = []
	NewPolygon.append(Vector2(0,0))
	NewPolygon.append(Vector2(15,0))
	NewPolygon.append(Vector2(25,-10))
	NewPolygon.append(Vector2(50,-10))
	NewPolygon.append(Vector2(60,0))
	NewPolygon.append(Vector2(Box.size.x,0))
	NewPolygon.append(Box.size)
	NewPolygon.append(Vector2(60,Box.size.y))
	NewPolygon.append(Vector2(50,Box.size.y -10))
	NewPolygon.append(Vector2(25,Box.size.y -10))
	NewPolygon.append(Vector2(15,Box.size.y))
	NewPolygon.append(Vector2(0,Box.size.y))
	Polygon.polygon = NewPolygon


func _on_effects_child_entered_tree(node: Node) -> void:
	EffectAmount = $VBoxContainer/Effects.get_child_count()
	CheckEffectAmount()
	ReloadEffectList([])


func _on_effects_child_exiting_tree(node: Node) -> void:
	EffectAmount = $VBoxContainer/Effects.get_child_count() - 1
	CheckEffectAmount()
	ReloadEffectList([node])


