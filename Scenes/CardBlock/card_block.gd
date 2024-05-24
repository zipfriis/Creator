extends Control

signal UpdatedCardData(Data: Card)

var BlockType: String = "CardBlock"
var data: Card
var Handler: Node
var hover: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SetSize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if hover == true:
		if get_global_mouse_position() < global_position:
			$CardBlock/HBoxContainer/Edit.visible = false
		elif get_global_mouse_position() > global_position:
			$CardBlock/HBoxContainer/Edit.visible = false
	

func LoadData(Data: Card):
	data = Data
	%CardName.text = Data.Name
	SetSize()

func UpdateData(Data: Dictionary):
	LoadData(Global.CardFromDict(Data))
	emit_signal("UpdatedCardData", Global.CardFromDict(Data))
	if Handler != null:
		Handler.UpdateCardData(Global.CardFromDict(Data))
		

func AddText(text: String):
	$Label.visible = true
	$Label.text = text


func SetSize():
	var BaseVector = $CardBlock.size
	var point0 = Vector2(BaseVector.y / 4, 0)
	var point1 = Vector2(BaseVector.x - BaseVector.y / 4, 0)
	var point2 = Vector2(BaseVector.x, BaseVector.y / 2)
	var point3 = Vector2(BaseVector.x - BaseVector.y / 4, BaseVector.y)
	var point4 = Vector2(BaseVector.y / 4, BaseVector.y)
	var point5 = Vector2(0, BaseVector.y / 2)
	var PointArray: PackedVector2Array = PackedVector2Array([point0, point1, point2, point3, point4, point5])
	$CardBlock/Polygon2D.polygon = PointArray


func _on_resized() -> void:
	SetSize()


func _on_card_block_resized() -> void:
	SetSize()


func _on_label_resized() -> void:
	SetSize()
