extends Node2D

export(PackedScene) var sceneRoot
export var totalWaves = 2
export var tileSize = 64
export var rangeTilesX = Vector2(1, 10)
export var spawnTileY = 10
export var timeWaitTime = 5
export var incrementMonstersWave = 5
export var randIncrementWave = 10

var currentWave = 0
var monstersInWave = 2
var monstersSprites
var monstersNumber
var rangeIni
var currentRange = 0

func start_wave():
	if currentRange <= 100:
		currentRange = rangeIni + (randIncrementWave*(currentWave-1)) + 10
		
	monstersInWave += incrementMonstersWave
	currentWave += 1
	$timer.wait_time = timeWaitTime
	$timer.start()

func is_final_wave():
	return (currentWave == totalWaves)

func _ready():
	monstersSprites = sceneRoot.instance()
	monstersNumber = monstersSprites.get_child_count()
	rangeIni = (100 / monstersNumber)
	
	set_process_input(false)

func _process(delta):
	if monstersInWave == 0:
		$timer.stop()

func stop_wave():
	$timer.stop()

func _on_timer_timeout():
	var rnd = (randi() % currentRange) -10
	
	if rnd > 0 and rnd < 101:
		var sprID = (rnd * monstersNumber / 100)
		var spr = monstersSprites.get_child(sprID).duplicate()
		
		if monstersInWave > 0: 
			spr.position = Vector2((int(rand_range(rangeTilesX[0], rangeTilesX[1]))*tileSize) + tileSize/2,(spawnTileY*tileSize) + tileSize/2)
			get_parent().add_child(spr)
			monstersInWave -= 1