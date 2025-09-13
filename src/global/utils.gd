class_name Utils


static func get_time_string(secs: float)-> String:
	return "%d:%02d.%1d" % [ int(secs / 60), int(secs) % 60, (secs - int(secs)) * 10 ]	
