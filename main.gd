extends Node2D

# Array to store our district buttons and their superposition states
var districts = []
var is_collapsed = [false, false, false, false]
var timer = 0.0

func _ready():
	# Ensure your Scene Tree has these exact paths:
	# CenterContainer/GridContainer/District1 (2, 3, 4)
	# And a Label node named StatusText
	districts.append($CenterContainer/GridContainer/District1)
	districts.append($CenterContainer/GridContainer/District2)
	districts.append($CenterContainer/GridContainer/District3)
	districts.append($CenterContainer/GridContainer/District4)
	
	# Connect button signals to the Measurement (Collapse) function
	for i in range(districts.size()):
		districts[i].pressed.connect(self._on_district_pressed.bind(i))
		districts[i].text = "???" # Initial superposition state

func _process(delta):
	# Handle the visual flickering of unresolved districts (Superposition effect)
	timer += delta
	if timer > 0.1: # Change color every 0.1 seconds
		timer = 0.0
		for i in range(districts.size()):
			if not is_collapsed[i]:
				# Randomly flicker between grey and light blue
				var random_state = randi() % 2
				if random_state == 0:
					districts[i].modulate = Color(0.8, 0.8, 0.8) # Greyish
				else:
					districts[i].modulate = Color(0.5, 0.8, 1.0) # Quantum blue

func _on_district_pressed(index: int):
	# Ignore click if the district state has already been observed (collapsed)
	if is_collapsed[index]:
		return
		
	# Quantum Collapse occurs here (Observation)
	is_collapsed[index] = true
	
	# 50/50 chance for a successful Eco outcome or a Smog crisis
	var outcome = randi() % 2
	if outcome == 0:
		# Positive outcome: Green Eco-district
		districts[index].modulate = Color(0.0, 1.0, 0.0) # Green
		districts[index].text = "SAFE\n(Eco)"
		$StatusText.text = "AUDIT COMPLETE: Eco-friendly district confirmed."
	else:
		# Negative outcome: Red Smog crisis
		districts[index].modulate = Color(1.0, 0.0, 0.0) # Red
		districts[index].text = "CRISIS\n(Smog)"
		$StatusText.text = "AUDIT COMPLETE: High pollution levels detected!"
		
	# Disable the button to finalize the state
	districts[index].disabled = true
