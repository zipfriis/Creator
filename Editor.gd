extends MarginContainer

signal UpdateCardData(Data: Card)

var ClassData: Class
var EditOfCard: Card
var RootNode: Node 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EditOfCard = Card.new("")
	RootNode = $'../../..'
	RootNode.Get_Storage_Raw()

func LoadEffectBoxes(card: Card):
	$ScrollContainer/General/UnitContainer/MarginContainer/EndOfTurnSpace.EffectOptionList = card.PermissibleEffects
	$ScrollContainer/General/UnitContainer/MarginContainer/EndOfTurnSpace.LimitEffectAmount = -1
	$ScrollContainer/General/UnitContainer/MarginContainer2/WarCrySpace.EffectOptionList = card.PermissibleEffects
	$ScrollContainer/General/UnitContainer/MarginContainer2/WarCrySpace.LimitEffectAmount = -1
	$ScrollContainer/General/UnitContainer/MarginContainer3/WhileSpace.EffectOptionList = card.PermissibleEffects
	$ScrollContainer/General/UnitContainer/MarginContainer3/WhileSpace.LimitEffectAmount = -1
	$ScrollContainer/General/UnitContainer/MarginContainer4/UponDeathSpace.EffectOptionList = card.PermissibleEffects
	$ScrollContainer/General/UnitContainer/MarginContainer4/UponDeathSpace.LimitEffectAmount = -1
	$ScrollContainer/General/UnitContainer/MarginContainer5/StartOppSpace.EffectOptionList = card.PermissibleEffects
	$ScrollContainer/General/UnitContainer/MarginContainer5/StartOppSpace.LimitEffectAmount = -1

func ResetValues():
	$ScrollContainer/General/EssenceCost/EssenceCost.select(0)
	$ScrollContainer/General/EmptyRace.Clear()
	$ScrollContainer/General/SpellContainer/MarginContainer/EffectSpace.Clear()
	$ScrollContainer/General/UnitContainer/MarginContainer/EndOfTurnSpace.Clear()
	$ScrollContainer/General/UnitContainer/MarginContainer2/WarCrySpace.Clear()
	$ScrollContainer/General/UnitContainer/MarginContainer3/WhileSpace.Clear()
	$ScrollContainer/General/UnitContainer/MarginContainer4/UponDeathSpace.Clear()
	$ScrollContainer/General/UnitContainer/MarginContainer5/StartOppSpace.Clear()


func LoadCardData(Data: Card):
	EditOfCard = Data
	ResetValues()
	LoadEffectBoxes(Data)
	if Data.CardType == Card.CardTypes.Unit:
		ShowUnitDetails()
		for EffectItem in Data.EndOfTurnTrigger:
			if EffectItem != null:
				$ScrollContainer/General/UnitContainer/MarginContainer/EndOfTurnSpace.AddNewEffectBlock(EffectItem)
		for EffectItem in Data.WarCryTrigger:
			if EffectItem != null:
				$ScrollContainer/General/UnitContainer/MarginContainer2/WarCrySpace.AddNewEffectBlock(EffectItem)
		for EffectItem in Data.WhileAliveTrigger:
			if EffectItem != null:
				$ScrollContainer/General/UnitContainer/MarginContainer3/WhileSpace.AddNewEffectBlock(EffectItem)
		for EffectItem in Data.UponDeathTrigger:
			if EffectItem != null:
				$ScrollContainer/General/UnitContainer/MarginContainer4/UponDeathSpace.AddNewEffectBlock(EffectItem)
		for EffectItem in Data.StartOppTrigger:
			if EffectItem != null:
				$ScrollContainer/General/UnitContainer/MarginContainer5/StartOppSpace.AddNewEffectBlock(EffectItem)
		$ScrollContainer/General/UnitContainer/HBoxContainer2/AttackDamageOption.select(Data.AttackDamage)
		if Data.Health == 0:
			$ScrollContainer/General/UnitContainer/HBoxContainer/HealthOption.select(0)
		else:
			$ScrollContainer/General/UnitContainer/HBoxContainer/HealthOption.select(Data.Health - 1)
	elif Data.CardType == Card.CardTypes.Spell:
		ShowSpellDetails()
		for EffectItem in Data.Effects:
			if EffectItem != null:
				$ScrollContainer/General/SpellContainer/MarginContainer/EffectSpace.AddNewEffectBlock(EffectItem)
	else:
		ShowNoDetails()
	if Data.Type != "":
		var RaceBlock = load('res://Scenes/Race/Race.tscn').instantiate()
		$ScrollContainer/General/EmptyRace.add_child(RaceBlock)
		RaceBlock.LoadRace(Data.Type)
	$ScrollContainer/General/Description/LineEdit.text = Data.Description
	$ScrollContainer/General/EssenceCost/EssenceCost.select(Data.EssenceCost)
	
	RootNode.Get_Storage_Raw()


func _on_option_button_item_selected(index: int) -> void:
	if index == 0:
		ShowSpellDetails()
		EditOfCard.CardType = Card.CardTypes.Spell
	elif index == 1:
		ShowUnitDetails()
		EditOfCard.CardType = Card.CardTypes.Unit
	elif index == 2:
		ShowNoDetails()
		EditOfCard.CardType = Card.CardTypes.Nothing
	else:
		push_warning("selecting none valid")
	RootNode.Get_Storage_Raw()


func ShowUnitDetails():
	$ScrollContainer/General/UnitContainer.visible = true
	$ScrollContainer/General/SpellContainer.visible = false

func ShowSpellDetails():
	$ScrollContainer/General/UnitContainer.visible = false
	$ScrollContainer/General/SpellContainer.visible = true


func ShowNoDetails():
	$ScrollContainer/General/UnitContainer.visible = false
	$ScrollContainer/General/SpellContainer.visible = false


# will save give the option of card data under a new name
func _on_new_pressed() -> void:
	$'ScrollContainer/General/Card selection/CardObjContainer/LineEdit'.visible = true
	$'ScrollContainer/General/Card selection/CardObjContainer/SetCard'.visible = true
	$'ScrollContainer/General/Card selection/CardObjContainer/Back'.visible = true
	$'ScrollContainer/General/Card selection/CardObjContainer/New'.visible = false
	$'ScrollContainer/General/Card selection/CardObjContainer/EmptyCardBlock'.visible = false


func _on_back_pressed() -> void:
	$'ScrollContainer/General/Card selection/CardObjContainer/LineEdit'.visible = false
	$'ScrollContainer/General/Card selection/CardObjContainer/SetCard'.visible = false
	$'ScrollContainer/General/Card selection/CardObjContainer/Back'.visible = false
	$'ScrollContainer/General/Card selection/CardObjContainer/New'.visible = true
	$'ScrollContainer/General/Card selection/CardObjContainer/EmptyCardBlock'.visible = true



func _on_empty_card_block_updated_card_data(Data: Card) -> void:
	LoadCardData(Data)


func _on_new_race_pressed() -> void:
	var RaceList: Node = $'../VBoxContainer/MarginContainer/Races/ScrollContainer/Races'
	var NewNameText: String = $'../VBoxContainer/MarginContainer/Races/HBoxContainer/LineEdit'.text
	if NewNameText != "":
		var RaceBlock = load('res://Scenes/Race/Race.tscn').instantiate()
		RaceList.add_child(RaceBlock)
		RaceBlock.LoadRace(NewNameText)
	Global.Type_Record.append(NewNameText)
	Global.Save()
	RootNode.Get_Storage_Raw()


func LoadClass(Data: Class):
	ClassData = Data


func SaveCard():
	emit_signal("UpdateCardData", EditOfCard)


func _on_empty_race_new_race_name(Race: String) -> void:
	EditOfCard.Type = Race
	SaveCard()

func _on_effect_space_new_effect_data(Data: Array[Effect]) -> void:
	EditOfCard.Effects = Data
	SaveCard()

func _on_end_of_turn_space_new_effect_data(Data: Array[Effect]) -> void:
	EditOfCard.EndOfTurnTrigger = Data
	SaveCard()

func _on_war_cry_space_new_effect_data(Data: Array[Effect]) -> void:
	EditOfCard.WarCryTrigger = Data
	SaveCard()

func _on_while_space_new_effect_data(Data: Array[Effect]) -> void:
	EditOfCard.WhileAliveTrigger = Data
	SaveCard()

func _on_upon_death_space_new_effect_data(Data: Array[Effect]) -> void:
	EditOfCard.UponDeathTrigger = Data
	SaveCard()

func _on_start_opp_space_new_effect_data(Data: Array[Effect]) -> void:
	EditOfCard.StartOppTrigger = Data
	SaveCard()


func _on_essence_cost_item_selected(index: int) -> void:
	EditOfCard.EssenceCost = index
	SaveCard()


func _on_save_pressed() -> void:
	SaveCard()


func _on_line_edit_text_changed(new_text: String) -> void:
	EditOfCard.Description = new_text
	SaveCard()


func _on_health_option_item_selected(index: int) -> void:
	EditOfCard.Health = index + 1
	SaveCard()

func _on_attack_damage_option_item_selected(index: int) -> void:
	EditOfCard.AttackDamage = index
	SaveCard()