extends MarginContainer

@export var Race: String
var VarName: String
signal NewRaceName(Name: String, VarName: String)

func Clear():
	for RaceChild in $Dropped.get_children():
		$Dropped.remove_child(RaceChild)

func NewRace(Name: String):
	Race = Name
	emit_signal("NewRaceName", Name, VarName)


func LoadRace(Name: String): # will be set loading the card data. 
	# only adds the raceblock instance, data gets loaded later
	var RaceBlock = load('res://Scenes/Race/Race.tscn').instantiate()
	$Dropped.add_child(RaceBlock)
	$MarginContainer/Label.visible = false
	RaceBlock.LoadRace(Name)
