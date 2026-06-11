extends Node

var time_elapsed: float = 0
var max_time: float = 150
var damage_taken: int = 0
var key_item_collected: bool = false

const POINT_MULT = 10



func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if GameManager.player_active:
		time_elapsed += delta
	
func get_score():
	return calculate_score(time_elapsed,max_time,damage_taken,key_item_collected)
	
func calculate_score(time_elapsed: float, max_time: float, damage_taken: float, key_item_collected: bool):
	var time_score = (max_time - time_elapsed) * POINT_MULT
	var damage_score = -damage_taken * POINT_MULT
	var collection_score = 300 if key_item_collected else 0
		
	var final_score = time_score + damage_score + collection_score
	print(round(time_elapsed))
	print(round(time_score))
	print(damage_score)
	print(collection_score)
	
	return round(final_score)
		
