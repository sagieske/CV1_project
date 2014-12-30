html_begin="<!DOCTYPE html><head><title>Classified list</title><style>.resize{width:200px}</style></head><body><h2>Settings:</h2>"
html_end="</body></html>"

f = open('ranked_list.txt', 'r')
table = "<table style='border:1px solid black'><tr><td><b>Airplanes</b></td><td><b>Cars</b></td><td><b>Faces</b></td><td><b>Motorbikes</b></td></tr>"
airplanes_list = []
cars_list = []
faces_list = []
motorbikes_list = []
current_type = ""
current_list = ""
face_counter = 0
root = "CV1 Project/data/"
apms =[]
for i in f:
	if(len(i.split(',')) == 5):
		for setting in i.split(','):
			html_begin += "<p>" + setting + "</p>"
		html_begin += table
	#IF A LIST IS FOUND	
	elif(i.split(" ")[0] == "SVM"):
		
		#IF CARS LIST
		if(i.split(" ")[-1] == "cars:\n"):
			current_type = "cars"
		#IF AIRPLANES LIST
		elif(i.split(" ")[-1] == "airplanes:\n"):
			current_type = "airplanes"
		#IF FACES LIST
		elif(i.split(" ")[-1] == "faces:\n"):
			current_type="faces"
		#IF MOTORBIKES LIST
		elif(i.split(" ")[-1] == "motorbikes:\n"):
			current_type="motorbikes"
	elif(len(i.split(":"))>1):
		original_image_type = i.split(" ")[0].split(":")[0]
		image_file = i.split(":")[1].strip()
		image_location = root + original_image_type + "_test/" + image_file
		image_html = "<img src='" + image_location + "' class='resize'>" 
		if current_type =="cars":
			cars_list.append(image_html)
		elif current_type =="airplanes":
			airplanes_list.append(image_html)
		elif current_type =="motorbikes":
			motorbikes_list.append(image_html)
		elif current_type =="faces":
			face_counter+=1
			faces_list.append(image_html)
	elif(i.split('=')[0] == "amp"):
		apms.append(i.split('=')[1])

html_begin += "<tr>"
for apm in apms:
	html_begin += "<td>AMP=" + apm + "</td>"
html_begin += "</tr>"

for image in range(0, face_counter):

	local_html = "<tr>"
	local_html += "<td>" + airplanes_list[image] + "</td>"
	local_html += "<td>" + cars_list[image] + "</td>"
	local_html += "<td>" + faces_list[image] + "</td>"
	local_html += "<td>" + motorbikes_list[image] + "</td>"
	local_html += "</tr>"
	html_begin += local_html
html_begin += "</table>"

f.close()
g = open('html_list.html', 'w')
g.write(html_begin+html_end)
g.close()
