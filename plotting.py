import matplotlib.pyplot as plt
import numpy as np

def feature_histograms():
	'''
	Plotting for effect different training sizes feature histograms
	'''
	n_groups = 5

	means_airplanes = (0.1394, 0.1394, 0.6563, 0.6447, 0.6749)
	means_cars = (0.3118, 0.3118, 0.9534, 0.9053, 0.9157)
	means_faces = (0.1924, 0.9124, 0.9191, 0.9510, 0.9631)
	means_motorbikes = (0.1394, 0.1394, 0.7830, 0.7516, 0.7798)
	average_means = (0.1958, 0.1958, 0.8280, 0.8132, 0.8334)

	fig, ax = plt.subplots()

	index = np.arange(n_groups)
	bar_width = 0.15

	opacity = 0.5
	error_config = {'ecolor': '0.3'}

	rects1 = plt.bar(index, means_airplanes, bar_width,
	                 alpha=opacity,
	                 color='b',
	                 label='Airplanes')

	rects2 = plt.bar(index + bar_width, means_cars, bar_width,
	                 alpha=opacity,
	                 color='r',
	                 label='Cars')

	rects3 = plt.bar(index + bar_width*2, means_faces, bar_width,
	                 alpha=opacity,
	                 color='g',
	                 label='Faces')

	rects4 = plt.bar(index + bar_width*3, means_motorbikes, bar_width,
	                 alpha=opacity,
	                 color='c',
	                 label='Motorbikes')

	rects5 = plt.bar(index + bar_width*4, average_means, bar_width,
	                 alpha=opacity,
	                 color='m',
	                 label='Average Mean Precision')

	plt.xlabel('Training size')
	plt.ylabel('Average precision')
	plt.title('Training sizes for feature histogram')
	plt.xticks(index + bar_width*2, ('30', '50', '70', '75', '90'))
	plt.legend(loc=2)

	plt.tight_layout()
	plt.show()

feature_histograms()