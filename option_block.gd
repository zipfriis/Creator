extends HBoxContainer

var BlockType: String
var Handler: Node 
var OptionName: String


func Select(Value: int):
	$Amount.select(Value)


func SetText(Text: String):
	OptionName = Text
	if Handler != null:
		Handler.DataSet(self, Text)
	$Label.text = Text + ": "
	new_option_chosen(int(Text))

func NumberOptions(StartNum: int, StopNum: int):
	if StartNum <= StopNum:
		var Iterator = StartNum
		while Iterator != StopNum:
			$Amount.add_item(str(Iterator))
			Iterator = Iterator + 1


func new_option_chosen(Option: int) -> void:
	if Handler != null:
		Handler.NewOptionData(Option)


func _on_amount_item_selected(index: int) -> void:
	if Handler != null:
		Handler.NewOptionData(int($Amount.get_item_text(index)), OptionName)
