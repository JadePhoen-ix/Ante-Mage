class_name WeightedTable


var items: Array[Dictionary]
var weight_sum := 0
var size: int:
	get:
		return items.size()


func add_item(item: Variant, weight: int) -> void:
	items.append({ "item": item, "weight": weight })
	weight_sum += weight


func change_item_weight(item_to_change: Variant, new_weight: int) -> void:
	if not has(item_to_change):
		push_warning(item_to_change, " not found in table, adding as new item.")
		add_item(item_to_change, new_weight)
	
	for item in items:
		if item["item"] == item_to_change:
			item["weight"] = new_weight
	
	update_weight_sum()


func get_item_index(search_item: Variant) -> int:
	if size == 0:
		return -1
	
	for i in size:
		if items[i]["item"] == search_item:
			return i
	
	push_warning(search_item, " not found in table, returning -1.")
	return -1


func has(search_item: Variant) -> bool:
	for item in items:
		if item["item"] == search_item:
			return true
	
	return false


func pick_item(exclude: Array = []) -> Variant:
	var adjusted_items: Array[Dictionary] = items
	var adjusted_weight_sum := weight_sum
	
	# Checks exclusion array for items and stores non-excluded items in adjusted_items
	if exclude.size() > 0:
		adjusted_items = []
		adjusted_weight_sum = 0
		for item in items:
			if item["item"] in exclude:
				continue
			adjusted_items.append(item)
			adjusted_weight_sum += item["weight"]
	
	var chosen_weight := randi_range(1, adjusted_weight_sum)
	var iteration_sum := 0
	
	for item in adjusted_items:
		iteration_sum += item["weight"]
		if chosen_weight <= iteration_sum:
			return item["item"]
	
	push_warning("Warning: No item found in weighted table.")
	return null


func remove_item(item_to_remove: Variant) -> void:
	items = items.filter(func(item): return item["item"] != item_to_remove)
	update_weight_sum()


func update_weight_sum() -> void:
	weight_sum = 0
	for item in items:
		weight_sum += item["weight"]



