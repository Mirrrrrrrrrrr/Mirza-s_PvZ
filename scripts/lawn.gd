extends Node2D

@onready var timer = $GameTimer
@onready var sunTimer = $SunTimer

@onready var plant1 = null
@onready var plant2 = null
@onready var plant3 = null
@onready var plant4 = null
@onready var plant5 = null
@onready var plant6 = null
@onready var plantList : Array  = [null, plant1, plant2, plant3, plant4, plant5, plant6]

@onready var seedBank = $SeedBank
@onready var lawn_grid = $LawnTile/LawnTileMapLayer
@onready var seedbank_grid = $SeedBank/ShadowBank
@onready var lawn_highlight = $LawnHighlight
@onready var seedbank_highlight = $SeedbankHighlight

@onready var sunValue = $SeedBank/SunAndSeedBank/SunValue/SunValueLabel

@onready var pauseButton = $PauseControl/PauseButton
@onready var pausePanel = $PauseControl/PausePanel
@onready var resumeButton = $PauseControl/ResumeButton
@onready var shovel = $Shovel

@onready var spdx1 = $Speedx1
@onready var spdx2 = $Speedx2

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var occupiedCells : Dictionary  = {}
var currentSun : int            = 100
var currentPlant : Object

# Represent x coordinates
var lanes : Dictionary          = {1: 330, 2: 490, 3: 650, 4: 810, 5: 970}

var LAWN_CELL_SIZE : Vector2
var LAWN_CELL_OFFSET : Vector2i
var SEEDBANK_CELL_SIZE : Vector2
var SEEDBANK_CELL_OFFSET : Vector2i

var seedbankSlotPos : Dictionary = {}
var ptrSlotDict

var shovelPos : Vector2

@onready var lawn_boundary : Dictionary = {"x_min" = 120 * 4 + 1, 
										   "x_max" = 120 * 13, 
										   "y_min" = 160 + 17, 
										   "y_max" = 160 * 6}
@onready var seedbank_boundary : Dictionary = {"x_min" = 90 * 6 + 1, 
											   "x_max" = 90 * 12, 
											   "y_min" = 21, 
											   "y_max" = 120 + 21}

func _ready() -> void:
	sunValue.text = str(currentSun)
	#region - Cells initiation
	LAWN_CELL_SIZE = lawn_grid.tile_set.tile_size
	LAWN_CELL_OFFSET = LAWN_CELL_SIZE / 2.0
	SEEDBANK_CELL_SIZE = seedbank_grid.tile_set.tile_size
	SEEDBANK_CELL_OFFSET = SEEDBANK_CELL_SIZE / 2.0
	seedbank_highlight.modulate = Color(256,256,256,0.3)
	#endregion
	currentPlant = plantList[0]
	assign_plant()

var is_mouse_inside : bool = true
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_MOUSE_ENTER:
			is_mouse_inside = true
		NOTIFICATION_WM_MOUSE_EXIT:
			is_mouse_inside = false
			lawn_highlight.visible = false
			seedbank_highlight.visible = false

func _process(_delta: float) -> void:
	if not is_mouse_inside:
		return
	#region - Lawn cell mouse handler
	var global : Vector2                  = get_global_mouse_position()
	var lawn_local : Vector2              = lawn_grid.to_local(global)
	var lawn_cell : Vector2i              = lawn_grid.local_to_map(lawn_local)
	var lawn_cell_local_pos : Vector2     = lawn_grid.map_to_local(lawn_cell)
	if lawn_cell_local_pos.x >= lawn_boundary["x_min"] && lawn_cell_local_pos.x <= lawn_boundary["x_max"] && lawn_cell_local_pos.y >= lawn_boundary["y_min"] && lawn_cell_local_pos.y <= lawn_boundary["y_max"]:
		lawn_highlight.visible = true
		lawn_highlight.position = Vector2(lawn_cell_local_pos.x, lawn_cell_local_pos.y + 16)
	else: lawn_highlight.visible = false
	#endregion 
	#region - Seedbank cell mouse handler
	var seedbank_local : Vector2          = seedbank_grid.to_local(global)
	var seedbank_cell : Vector2i          = seedbank_grid.local_to_map(seedbank_local)
	var seedbank_cell_local_pos : Vector2 = seedbank_grid.map_to_local(seedbank_cell)
	
	if seedbank_cell_local_pos.x >= seedbank_boundary["x_min"] && seedbank_cell_local_pos.x <= seedbank_boundary["x_max"] && seedbank_cell_local_pos.y >= seedbank_boundary["y_min"] && seedbank_cell_local_pos.y <= seedbank_boundary["y_max"]:
		seedbank_highlight.visible = true
		seedbank_highlight.position = Vector2(seedbank_cell_local_pos.x - 4, seedbank_cell_local_pos.y + 20)
	else: seedbank_highlight.visible = false
	
	
	#endregion

func set_seedbank_slot_pos(slotDict) -> void:
	var plantCount : int = plantList.size()
	for i in plantCount:
		if i == 0: continue
		slotDict = seedbankSlotPos.get_or_add(i, {})
		slotDict["x"] = (5 + i) * SEEDBANK_CELL_SIZE.x + SEEDBANK_CELL_OFFSET.x
		slotDict["y"] = SEEDBANK_CELL_OFFSET.y
		#print(slotDict["x"])
		#print(slotDict["y"])

func assign_plant() -> void:
	var plantCount : int = plantList.size()
	set_seedbank_slot_pos(ptrSlotDict)
	for i in plantCount:
		if plantList[i] == null:
			continue
		var newLabel : Label = Label.new()
		newLabel.text = str(plantList[i])
		newLabel.position = Vector2(seedbankSlotPos[i]["x"],seedbankSlotPos[i]["y"])
		seedBank.add_child(newLabel)

func select_plant(selected_plant) -> void:
	return

func plant_plant() -> void:
	if currentPlant == null:
		return



func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	pausePanel.visible = true
	pauseButton.visible = false
	resumeButton.visible = true

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	pausePanel.visible = false
	pauseButton.visible = true
	resumeButton.visible = false
