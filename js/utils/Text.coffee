class Text
	toColor: (text, saturation=30, lightness=40) ->
		hash = 0
		for i in [0..text.length-1]
			hash += text.charCodeAt(i)*i
			hash = hash % 1777
		return "hsl(" + (hash % 360) + ",#{saturation}%,#{lightness}%)";

window.Text = new Text()
