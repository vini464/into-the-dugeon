extends Node

var Deck = []
var RoomCards = []
var SkippedLastRoom : bool
var EnteredRoom : bool
var GameTurn : int
var PlayerLife : int

var dungeon : Dungeon
var holdingCard : Card

func _init() -> void:
	newgame()


func newgame() -> void:
	dungeon = null
	holdingCard = null
	PlayerLife = 0
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
	


func NewRoom(currentdungeon : Dungeon):
	if (dungeon == null):
		dungeon = currentdungeon
	while (RoomCards.size() < 4 and Deck.size() > 0):
		var card = Deck.pop_front()
		RoomCards.append(card)
	
	dungeon.RemoveRoomCards()
	dungeon.SetRoomCards(RoomCards)



func SkipRoom():
	if (!SkippedLastRoom):
		
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
	pass
