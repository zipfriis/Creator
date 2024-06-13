extends HBoxContainer

signal NewOptionSelected(OptionName: String, Option: String)

var BlockType: String
var OptionName: String


func Select(Value: int):
	$Amount.select(Value)


func SetText(Text: String):
	OptionName = Text
	$Label.text = Text + ": "


func NumberOptions(StartNum: int, StopNum: int):
	if StartNum <= StopNum:
		var Iterator = StartNum
		while Iterator != StopNum:
			$Amount.add_item(str(Iterator))
			Iterator = Iterator + 1


func _on_amount_item_selected(index: int) -> void:
	emit_signal("NewOptionSelected", OptionName, str($Amount.get_item_text(index)))

