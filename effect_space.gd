extends MarginContainer

signal NewEffectData(Data: Array[Effect], VarName)

var VariableName: String
var EffectAmount: int = 0
var LimitEffectAmount: int = -1 # Should at least have a limit of 1, to warent its use.
var EffectOptionList: Array[String] # Commands of all effects that should be able to be placed
var EffectList: Array[Effect] = []
var Data: Array[Dictionary]


func Clear() -> void:
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


func On_NewEffectChange(EffectData: Effect, EffectNode: Node):
	EffectList[EffectNode.get_index()] = EffectData
	Data[EffectNode.get_index()] = EffectData.ConvertToJSON()
	print(EffectData)
	emit_signal("NewEffectData", EffectList, VariableName)
	


func _on_effects_child_entered_tree(node: Node) -> void:
	node.UpdateOfEffectData.connect(On_NewEffectChange)
	EffectAmount = $VBoxContainer/Effects.get_child_count()
	CheckEffectAmount()
	emit_signal("NewEffectData", EffectList, VariableName)


func _on_effects_child_exiting_tree(EffectNode: Node) -> void:
	EffectAmount = $VBoxContainer/Effects.get_child_count() - 1
	EffectList.remove_at(EffectNode.get_index())
	Data.remove_at(EffectNode.get_index())
	emit_signal("NewEffectData", EffectList, VariableName)



# visual Shit
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


