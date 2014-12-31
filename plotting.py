import matplotlib.pyplot as plt
import numpy as np


def feature_histograms():
	'''
	Plotting for effect different training sizes feature histograms
	'''

	n_groups = 5

	means_airplanes = (0.1394, 0.6516, 0.6563, 0.6447, 0.6749)
	means_cars = (0.3118, 0.8392, 0.9534, 0.9053, 0.9157)
	means_faces = (0.1924, 0.6716, 0.9191, 0.9510, 0.9631)
	means_motorbikes = (0.1394, 0.7797, 0.7830, 0.7516, 0.7798)
	average_means = (0.1958, 0.7355, 0.8280, 0.8132, 0.8334)

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
	plt.xticks(index + bar_width*2, ('30', '55', '70', '75', '90'))
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

	plt.xlabel('Codebook size')
	plt.ylabel('Average precision')
	plt.title('Codebook sizes for feature histogram')
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

def step_sizes():
	'''
	Plotting for effect different training sizes SVM
	'''

	n_groups = 5

	means_airplanes = (0.6823,0.6447,0.6405,0.6463,0.6539)
	means_cars = (0.8654,0.9053,0.8952,0.8288,0.7360)
	means_faces = (0.9444,0.9510,0.9792,0.8596,0.6791)
	means_motorbikes = (0.6934,0.7516,0.2704,0.7247,0.3673)
	average_means = (0.7964,0.8132,0.6963,0.7648,0.6091)

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

	plt.xlabel('Step size')
	plt.ylabel('Average precision')
	plt.title('Step sizes for dense sampling')
	plt.xticks(index + bar_width*2, ('10', '20', '30', '50', '75'))
	plt.legend()

	plt.tight_layout()
	plt.show()	

def dense_colors():
	'''
	Plotting for effect different color spaces on dense SIFT
	'''

	n_groups = 4

	means_airplanes = (0.6476,0.5743,0.6424,0.6447)
	means_cars = (0.7741,0.3402,0.9726,0.9053)
	means_faces = (0.4292,0.4678,0.8689,0.9510)
	means_motorbikes = (0.8165,0.5646,0.6747,0.7516)
	average_means = (0.6668,0.4867,0.7897,0.8132)

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

	plt.xlabel('Color space')
	plt.ylabel('Average precision')
	plt.title('Different color spaces for dense sampling')
	plt.xticks(index + bar_width*2, ('gray', 'normalizedRGB', 'RGB', 'opponent'))
	plt.legend(loc=2)

	plt.tight_layout()
	plt.show()

def window_sizes():
	'''
	Plotting for effect different window sizes on dense SIFT
	'''

	n_groups = 11

	means_airplanes = (0.6447,0.6809,0.7066,0.7532,0.6698,0.7133,0.7629,0.7719,0.8086,0.7882,0.8042)
	means_cars = (0.9053,0.9505,0.9031,0.9529,0.9511,0.9064,0.9349,0.9803,0.7713,0.9395,0.9782)
	means_faces = (0.9510,0.9945,0.9839,0.9939,0.6400,0.9952,1.0000,0.9981,1.0000,0.9989,0.9770)
	means_motorbikes = (0.7516,0.8955,0.7216,0.4570,0.5987,0.9199,0.9280,0.9927,0.9965,0.9501,0.9223)
	average_means = (0.8132,0.8803,0.8288,0.7893,0.7149,0.8837,0.9065,0.9357,0.8941,0.9192,0.9204)

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

	plt.xlabel('Window sizes')
	plt.ylabel('Average precision')
	plt.title('Different window sizes for dense sampling')
	plt.xticks(index + bar_width*2, ('4,8', '4,12', '8,12', '12,16', '4,8,12', '8,12,16', '12,16,20', '16,20,24', '20,24,28', '16,20,24,28', '20,24,28,32'))
	plt.legend(loc=4)

	plt.tight_layout()
	plt.show()	

def final_model():
	'''
	Plotting for the final model results
	'''

	n_groups = 1

	means_airplanes = (0.9147)
	means_cars = (0.9837)
	means_faces = (0.9996)
	means_motorbikes = (0.9888)
	average_means = (0.9717)

	fig, ax = plt.subplots()

	index = np.arange(n_groups)
	bar_width = 0.15

	opacity = 0.5
	error_config = {'ecolor': '0.3'}

	rects1 = plt.bar(index, means_airplanes, bar_width,
	                 alpha=opacity,
	                 color='b',
	                 label='Airplanes')

	rects2 = plt.bar(index + bar_width*1.5, means_cars, bar_width,
	                 alpha=opacity,
	                 color='r',
	                 label='Cars')

	rects3 = plt.bar(index + bar_width*3, means_faces, bar_width,
	                 alpha=opacity,
	                 color='g',
	                 label='Faces')

	rects4 = plt.bar(index + bar_width*4.5, means_motorbikes, bar_width,
	                 alpha=opacity,
	                 color='c',
	                 label='Motorbikes')

	rects5 = plt.bar(index + bar_width*6, average_means, bar_width,
	                 alpha=opacity,
	                 color='m',
	                 label='MAP')

	plt.xlabel('Class')
	plt.ylabel('Average precision')
	plt.title('Average Precision for final model')
	plt.xticks(index + bar_width, (' '))
	plt.legend()

	plt.tight_layout()
	plt.show()

final_model()