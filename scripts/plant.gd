@abstract
class_name Plant extends Node2D

signal plant_died(cell_coords: Vector2i)

@export var plant_name : String        = ""
@export var max_hp : int               = 0
@export var sun_cost : int             = 0
@export var cooldown : float           = 0
@export var initial_cooldown : float   = 0

var cell_coords: Vector2i
var lane_ID: int
var current_hp : int

func _ready() -> void:
	current_hp = max_hp
	_on_plant_spawned()

func take_damage(amount: int) -> void:
	current_hp -= amount
	if current_hp <= 0:
		die()

func die() -> void:
	plant_died.emit(cell_coords)
	queue_free()

@abstract
func _on_plant_spawned() -> void
