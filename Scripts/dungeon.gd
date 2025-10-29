class_name Dungeon

extends Node2D

@onready var Room = $roomBox/room
var CardTemplate = preload("res://Scenes/card_2.tscn")

func _ready() -> void:
	GameManagement.NewRoom(self)

func _process(delta: float) -> void:
	$deck/DeckSize.text = str(GameManagement.Deck.size())
	$LifePoints/TextureRect/lifetotal.text = str(GameManagement.PlayerLife)
	if (GameManagement.SkippedLastRoom and !GameManagement.EnteredRoom):
		$RunButton.disabled = true
	else:
		$RunButton.disabled = false
	

func RemoveRoomCards():
	print("removing cards")
	var children = Room.get_children().duplicate()
	for child in children:
		Room.remove_child(child)
	
	print("done")

func SetRoomCards(cards : Array):
	print("adding cards")
	for card in cards:
		var child = CardTemplate.instantiate()
		child.Level = card["level"]
		child.CardType = card["type"]
		child.Id = card["id"]
		child.Pickable = true
		Room.add_child(child)
	
	print("done")

func RemoveRoomCard(card : Card):
	Room.remove_child(card)

func RemoveWeapon():
	var children = $Weapon.get_children().duplicate()
	if (children.size() > 0):
		for child in children:
			$Weapon.remove_child(child)
	

func SetWeapon(weapon : Card):
	RemoveWeapon()
	$Weapon.add_child(weapon)

func SetLastMonster(monster : Card):
	RemoveLastMonster()
	$LastMonster.add_child(monster)

func RemoveLastMonster():
	var children = $LastMonster.get_children().duplicate()
	if (children.size() > 0):
		for child in children:
			$LastMonster.remove_child(child)

func _on_run_button_pressed() -> void:
	GameManagement.SkipRoom()

func _on_next_button_pressed() -> void:
	GameManagement.NewRoom(self)

func _on_life_points_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.is_pressed()):
		GameManagement.UseSelectedCard()


func _on_retry_pressed() -> void:
	RemoveLastMonster()
	RemoveRoomCards()
	RemoveWeapon()
	
	GameManagement.newgame()
	GameManagement.NewRoom(self)
