class_name Dungeon

extends Node2D

@onready var Room = $roomBox/room
var CardTemplate = preload("res://Scenes/card_2.tscn")


func _process(delta: float) -> void:
	$deck/DeckSize.text = str(GameManagement.Deck.size())
	if (GameManagement.SkippedLastRoom and !GameManagement.EnteredRoom):
		$RunButton.disabled = true
	else:
		$RunButton.disabled = false
	
	if (Room.get_children().size() <= 1):
		GameManagement.NewRoom(self)

func RemoveRoomCards():
	print("removing cards")
	var children = Room.get_children()
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

func _on_lifepointd_mouse_entered() -> void:
	print("mouse entered life")
	pass # Replace with function body.


func _on_lifepointd_mouse_exited() -> void:
	print("mouse exited life")
	pass # Replace with function body.


func _on_weapon_area_mouse_entered() -> void:
	print("mouse entered weapon")
	pass # Replace with function body.


func _on_weapon_area_mouse_exited() -> void:
	print("mouse exited weapon")
	pass # Replace with function body.


func _on_run_button_pressed() -> void:
	GameManagement.SkipRoom()
