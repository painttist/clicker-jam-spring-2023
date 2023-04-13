extends Resource

class_name ShopItemResource

@export var name: String
@export var price: int

enum EFFECT {
	ADD,
	MULTI
}

@export var effect_forward: EFFECT
@export var amount_forward: int = 1
@export var effect_back: EFFECT
@export var amount_back: int = 1
@export var texture: Texture
