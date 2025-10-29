extends Control


func _ready() -> void:
	if (GameManagement.PlayerLife <= 0):
		$ColorRect/Label.text = "You Lose!"
	else:
		$ColorRect/Label.text = "You Win!"
		
	

func _on_button_pressed() -> void:
	var dungeon = load("res://Scenes/dungeon.tscn")
	GameManagement.newgame()
	get_tree().change_scene_to_packed(dungeon)
	
