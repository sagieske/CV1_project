f = open('img_list', 'r')
g = open('ranked_list3.txt', 'w')
images_list = []
for line in f:
	if len(line.split('/')) > 1:
		type_image = line.split('/')[2].split('_')[0]
		image_name = line.split('/')[-1].split('--')[0]
		g.write(type_image + ": " + image_name +"\n")
	elif len(line.split(' ')) > 1:
		if line.split(' ')[1] == "class":
			if line.split(' ')[2].strip() == "1":
				g.write("\nSVM trained to classify airplanes:\n\n")
			elif line.split(' ')[2].strip() == "2":
				g.write("\nSVM trained to classify cars:\n\n")
			elif line.split(' ')[2].strip() == "3":
				g.write("\nSVM trained to classify faces:\n\n")
			elif line.split(' ')[2].strip() == "4":
				g.write("\nSVM trained to classify motorbikes:\n\n")
f.close()
g.close()
