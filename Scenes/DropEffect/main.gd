extends MarginContainer

var Effects: Array[String] 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _can_drop_data(at_position:Vector2, data:Variant) -> bool:
	if data.has("EffectBlock"):
			if data["EffectBlock"].BlockType == "EffectBlock":
				return true
	return false

func _drop_data(at_position:Vector2, data:Variant)->void:
	var EffectBox = load('res://Effect.tscn').instantiate()
	EffectBox.LoadEffect(data["Effect"])
	$VBoxContainer/VBoxContainer.add_child(EffectBox)
	
