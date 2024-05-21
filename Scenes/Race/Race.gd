extends MarginContainer

var RaceName: String
var BlockType: String = "RaceBlock"

func LoadRace(Name: String):
	$MarginContainer/Label.text = Name
	RaceName = Name
