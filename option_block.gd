extends HBoxContainer

var BlockType: String
var Handler: Node 


func SetText(Text: String):
	if Handler != null:
		Handler.DataSet(self, Text)
	$Label.text = Text + ": "
	new_option_chosen(int(Text))

func NumberOptions(StartNum: int, StopNum: int):
	if StartNum <= StopNum:
		var Iterator = StartNum
		while Iterator != StopNum:
			$Health.add_item(str(Iterator))
			Iterator = Iterator + 1


func new_option_chosen(Option: int) -> void:
	if Handler != null:
		Handler.NewOptionData(Option)
