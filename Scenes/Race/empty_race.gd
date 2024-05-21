extends MarginContainer

@export var Race: String
signal NewRaceName(Name: String)
var Handler: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Clear():
	for Race in $Dropped.get_children():
		$Dropped.remove_child(Race)

func NewRace(Name: String):
	Race = Name
	emit_signal("NewRaceName", Name)
	if Handler != null:
		Handler.NewRaceName(Name)
