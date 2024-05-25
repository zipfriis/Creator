extends MarginContainer

@export var Race: String
signal NewRaceName(Name: String)
var Handler: Node

func Clear():
	for RaceChild in $Dropped.get_children():
		$Dropped.remove_child(RaceChild)

func NewRace(Name: String):
	Race = Name
	emit_signal("NewRaceName", Name)
	if Handler != null:
		Handler.NewRaceName(Name)
