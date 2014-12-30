import matplotlib.pyplot as plt
import numpy as np


def feature_histograms():
	'''
	Plotting for effect different training sizes feature histograms
	'''

	n_groups = 5

	means_airplanes = (0.1394, 0.1394, 0.6563, 0.6447, 0.6749)
	means_cars = (0.3118, 0.3118, 0.9534, 0.9053, 0.9157)
	means_faces = (0.1924, 0.1924, 0.9191, 0.9510, 0.9631)
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
	                 label='MAP')

	plt.xlabel('Training size')
	plt.ylabel('Average precision')
	plt.title('Training sizes for feature histogram')
	plt.xticks(index + bar_width*2, ('30', '50', '70', '75', '90'))
	plt.legend(loc=2)

	plt.tight_layout()
	plt.show()

def cluster_sizes():
	'''
	Plotting for effect different cluster sizes in feature histogram
	'''
	n_groups = 7

	means_airplanes = (0.6868,0.6663, 0.6447, 0.6424, 0.6438, 0.6367, 0.6430)
	means_cars = (0.9152,0.9408, 0.9053, 0.5067, 0.3115, 0.7253, 0.5311)
	means_faces = (0.9843,0.9824, 0.9510, 0.9602, 0.8410, 0.3357, 0.1837)
	means_motorbikes = (0.8395,0.8454, 0.7516, 0.5667, 0.5361, 0.1926, 0.4956)
	average_means = (0.8564,0.8587, 0.8132, 0.6690, 0.5831, 0.4726, 0.4634)

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
	                 label='MAP')

	plt.xlabel('Cluster size')
	plt.ylabel('Average precision')
	plt.title('Cluster sizes for feature histogram')
	plt.xticks(index + bar_width*2, ('100', '200', '400', '800', '1600', '2000', '4000'))
	plt.legend()

	plt.tight_layout()
	plt.show()	

def svm_sizes():
	'''
	Plotting for effect different training sizes SVM
	'''

	n_groups = 5

	means_airplanes = (0.6647,0.6484,0.6531,0.6447,0.6426)
	means_cars = (0.8898,0.9096,0.8441,0.9053,0.8697)
	means_faces = (0.3772,0.8780,0.7156,0.9510,0.5227)
	means_motorbikes = (0.5184,0.6627,0.7590,0.7516,0.6963)
	average_means = (0.6125,0.7747,0.7429,0.8132,0.6828)

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
	                 label='MAP')

	plt.xlabel('Training size')
	plt.ylabel('Average precision')
	plt.title('Training sizes for SVM')
	plt.xticks(index + bar_width*2, ('30', '50', '70', '75', '90'))
	plt.legend()

	plt.tight_layout()
	plt.show()	

svm_sizes()