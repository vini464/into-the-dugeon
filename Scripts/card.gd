class_name Card
extends Control

@export var Level : int
@export var CardType : Enums.CardType
@export var Pickable : bool
@export var Id : int
var picked = false
var pos = position


@onready var cardlevel = $Background/VBoxContainer/CardLevel
@onready var cardtitle = $Background/VBoxContainer/CardTitle
@onready var cardImage = $Background/VBoxContainer/CardImage
@onready var foreground = $Foreground

func _ready() -> void:
	foreground.visible = false
	cardlevel.text = str(Level)
	match CardType:
		Enums.CardType.MONSTER:
			cardImage.texture = load("res://Assets/monster.png")
			cardtitle.text = "Monster"
		Enums.CardType.WEAPON:
			cardImage.texture = load("res://Assets/sword.png")
			cardtitle.text = "Weapon"
		Enums.CardType.POTION:
			cardImage.texture = load("res://Assets/health-potion-bottle.png")
			cardtitle.text = "Potion"



func _on_background_gui_input(event: InputEvent) -> void:
	
	if (picked == false and Pickable == true and event is InputEventMouseButton and event.is_pressed()):
		GameManagement.HoldCard(self)
	
	elif (picked == true and event is InputEventMouseButton and event.is_pressed()):
		
		GameManagement.ReleaseCard()
		
