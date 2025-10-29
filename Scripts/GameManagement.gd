extends Node

var endscene_packed = preload("res://Scenes/end_scene.tscn")

var Deck = []
var RoomCards = []
var SkippedLastRoom : bool
var EnteredRoom : bool
var GameTurn : int
var PlayerLife : int


var dungeon : Dungeon
var weapon : Card
var holdingCard : Card
var lastMonster : Card

func _init() -> void:
	newgame()
	


func newgame() -> void:
	dungeon = null
	holdingCard = null
	PlayerLife = 20
	GameTurn = 0
	EnteredRoom = false
	SkippedLastRoom = false
	Deck = []
	RoomCards = []
	
	var card : Dictionary
	var id = 0
	for i in range(2, 15):
		card["level"] = i;
		card["type"] = Enums.CardType.MONSTER
		card["id"] = id
		id += 1
		Deck.append(card.duplicate())
		Deck.append(card.duplicate())
		card["type"] = Enums.CardType.WEAPON
		card["id"] = id
		id += 1
		Deck.append(card.duplicate())
		if (i < 11):
			card["type"] = Enums.CardType.POTION
			Deck.append(card.duplicate())
			card["id"] = id
			id += 1
	Deck.shuffle()

func _process(_delta: float) -> void:
	if (RoomCards.size() == 0 and Deck.size() == 0):
		close("You Win!")


func NewRoom(currentdungeon : Dungeon):
	if (dungeon == null):
		dungeon = currentdungeon
	if (RoomCards.size() > 1):
		return
	while (RoomCards.size() < 4 and Deck.size() > 0):
		var card = Deck.pop_front()
		RoomCards.append(card)
	SkippedLastRoom = false
	dungeon.RemoveRoomCards()
	dungeon.SetRoomCards(RoomCards)

func SkipRoom():
	if (!SkippedLastRoom and RoomCards.size() == 4):
		
		while RoomCards.size() > 0:
			Deck.append(RoomCards.pop_back())
		NewRoom(dungeon)
		SkippedLastRoom = true

func HoldCard(card : Card) -> bool:
	if (holdingCard != null):
		ReleaseCard()
	print("holding card: ", card.Id)
	holdingCard = card
	holdingCard.foreground.visible = true
	holdingCard.picked = true
	
	return true

func ReleaseCard():
	holdingCard.foreground.visible = false
	holdingCard.picked = false
	holdingCard = null

func UseSelectedCard():
	if holdingCard == null || (RoomCards.size() < 2 and Deck.size() > 0):
		return
	holdingCard.picked = false
	holdingCard.foreground.visible = false
	match holdingCard.CardType:
		Enums.CardType.MONSTER:
			PlayerLife -= holdingCard.Level
			if (PlayerLife <= 0):
				close("You Lose!")
		Enums.CardType.POTION:
			PlayerLife += holdingCard.Level
			if PlayerLife > 20:
				PlayerLife = 20
		Enums.CardType.WEAPON:
			weapon = holdingCard.duplicate()
			weapon.Pickable = false
			lastMonster = null
			dungeon.SetWeapon(weapon)
			dungeon.RemoveLastMonster()
			
	
	removeHoldingCard()

func FightMonster():
	if (RoomCards.size() < 2  || weapon == null || holdingCard == null):
		return
	if (holdingCard.CardType != Enums.CardType.MONSTER || (lastMonster != null and lastMonster.Level <= holdingCard.Level) ):
		return
	
	var damage = holdingCard.Level - weapon.Level
	if (damage > 0):
		PlayerLife -= damage
	if PlayerLife <= 0:
		close("you lose!")
	else:
		lastMonster = holdingCard.duplicate()
		lastMonster.Pickable = false
		dungeon.SetLastMonster(lastMonster)
		removeHoldingCard()

func removeHoldingCard():
	dungeon.RemoveRoomCard(holdingCard)
	for card in RoomCards:
		if card["id"] == holdingCard.Id:
			RoomCards.erase(card)
			break
	holdingCard = null

func close(msg : String):
	print(msg)
	get_tree().change_scene_to_packed(endscene_packed)
