extends Node2D

@export var front_texture :  Texture2D
@export var level : int
@export var card_type : String

func _ready() -> void:
	$front.texture = front_texture
