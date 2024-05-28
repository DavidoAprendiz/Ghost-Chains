extends Line2D

var fila : Array
var FILA_MAX : float = 420.0 / 10.0


func _process(_delta):
	# Trail Line
	fila.push_front(get_parent().position)
	if fila.size() > FILA_MAX:
		fila.pop_back()
	clear_points()
	for i in fila:
		add_point(i)
