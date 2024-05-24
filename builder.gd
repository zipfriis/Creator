extends Control

var Classes: Dictionary
var SelectedClass: String 

var CardName: String
var CardType: String # "Unit" or "Spell"
var NoneTargetingSpell: bool

var JsonTextLabelPanel: Node 
var JsonDict: Dictionary

var ImporterOpen: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BuildSurface/HBoxContainer/Editor/ScrollContainer/General/HBoxContainer/OptionButton.select(1)
	$BuildSurface/HBoxContainer/Editor.ShowUnitDetails()
	NoneTargetingSpell = false
	LoadEffects()
	var SavedClasses: Array[Class] = await Global.GetClasses()
	if len(SavedClasses) != 0:
		for ClassObj: Class in SavedClasses:
			LoadClass(ClassObj)
	var RaceList: Node = $BuildSurface/HBoxContainer/VBoxContainer/MarginContainer/Races/ScrollContainer/Races
	for Race in Global.Type_Record:
		var RaceBlock = load('res://Scenes/Race/Race.tscn').instantiate()
		RaceList.add_child(RaceBlock)
		RaceBlock.LoadRace(Race)


func LoadEffects():
	var NumberOfEffects: int = 0
	for EffectData: Effect in [ForcesOfChaos.new(Global.GeneralEffectList), NordicGods.new(Global.GeneralEffectList)]:
		NumberOfEffects = NumberOfEffects + 1
		var NodeList = $BuildSurface/HBoxContainer/Effects/VBoxContainer/ScrollContainer/Effects
		var NewEffect = load('res://Effect.tscn').instantiate()
		NodeList.add_child(NewEffect)
		NewEffect.LoadEffect(EffectData)
	for EffectData: Effect in Global.TargetEffectList:
		NumberOfEffects = NumberOfEffects + 1
		var NodeList = $BuildSurface/HBoxContainer/Effects/VBoxContainer/ScrollContainer/Effects
		var NewEffect = load('res://Effect.tscn').instantiate()
		NodeList.add_child(NewEffect)
		NewEffect.LoadEffect(EffectData)
	for EffectData: Effect in Global.GeneralEffectList:
		NumberOfEffects = NumberOfEffects + 1
		var NodeList = $BuildSurface/HBoxContainer/Effects/VBoxContainer/ScrollContainer/Effects
		var NewEffect = load('res://Effect.tscn').instantiate()
		NodeList.add_child(NewEffect)
		NewEffect.LoadEffect(EffectData)
	$BuildSurface/HBoxContainer/Effects/VBoxContainer/Title.text = "Effects: " + str(NumberOfEffects)
	return


func LoadClass(Data: Class):
	if Data != null:
		$BuildSurface/TopBar/Middle/Classes.add_item(Data["Name"])
		SelectedClass = Data.Name
		var CardList: Node = $BuildSurface/HBoxContainer/VBoxContainer/Cards/Cards/ScrollContainer/Cards
		for ChildCard in CardList.get_children():
			CardList.remove_child(ChildCard)
		for CardObj in Data.Cards:
			LoadCard(CardObj)
	else:
		push_error("The class does not exist")


func LoadCard(Data: Card):
	var CardList = $BuildSurface/HBoxContainer/VBoxContainer/Cards/Cards/ScrollContainer/Cards
	var NewCard = load('res://Scenes/CardBlock/card_block.tscn').instantiate()
	print("Class Card: " + str(Data.ConvertToJSON()))
	NewCard.LoadData(Data)
	CardList.add_child(NewCard)


func Get_Storage_Raw():
	$Panel/MarginContainer/RichTextLabel.text = Global.GetRaw()

func UpdateRaw(Data: Card):
	$Panel/MarginContainer/RichTextLabel.text = str(Data.ConvertToJSON())


func _on_save_pressed() -> void:
	print("Save card")


func _on_none_target_toggled(toggled_on: bool) -> void:
	NoneTargetingSpell = toggled_on


func _on_effects_resized() -> void:
	var EffectScrollContianer = $BuildSurface/HBoxContainer/Effects/VBoxContainer/ScrollContainer
	EffectScrollContianer.custom_minimum_size = Vector2(0,EffectScrollContianer.size.y)


func _on_raw_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$AnimationPlayer.play("RawVeiwer")
	else:
		$AnimationPlayer.play_backwards("RawVeiwer")


func _on_import_pressed() -> void:
	if ImporterOpen == false:
		$AnimationPlayer.play("Importer")
		ImporterOpen = true
	else:
		$AnimationPlayer.play_backwards("Importer")
		ImporterOpen = false


func _on_load_pressed() -> void:
	var Content: String = $Import/VBoxContainer/MarginContainer/TextEdit.text
	var JSONDict: Dictionary
	# Parse the JSON string
	JSONDict = JSON.parse_string(Content)
	var NewClassList: Array[Class] = []
	for ClassThing in JSONDict["Classes"]:
		if ClassThing.has("Name"):
			print("Loading Class: " + str(ClassThing["Name"]))
			var NewClass = Class.new(ClassThing["Name"])
			NewClass.LoadClassDict(ClassThing)
			NewClassList.append(NewClass)
	Global.LoadClasses(NewClassList)
	if JSONDict.has("Type_Record"):
		print("Type_Record is here")
		var NewTypeRecord: Array[String] = []
		for TypeThing: String in JSONDict["Type_Record"]:
			if TypeThing != null:
				NewTypeRecord.append(TypeThing)
		Global.LoadTypeRecord(NewTypeRecord)
	else:
		print("i am so fucked ")
		print(Global.Classes)
	Global.Save()


func _on_copy_pressed() -> void:
	DisplayServer.clipboard_set(Global.GetRaw())


func _on_editor_update_card_data(Data: Card) -> void:
	print("Editor Save: " + str(Data.ConvertToJSON()))
	if Data != null:
		Global.SaveCard(Data)
		#LoadClass(Global.GetClassByName(Data.ClassName))
	else:
		push_error("The card is not valid")



func _on_new_race_pressed() -> void:
	var NewRace = $BuildSurface/HBoxContainer/VBoxContainer/MarginContainer/Races/HBoxContainer/LineEdit.text
	if NewRace not in Global.Type_Record:
		Global.Type_Record.append(NewRace)
		Global.Save()
