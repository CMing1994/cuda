

#ifndef IMAGEread_H_
#define IMAGEread_H_

#include <iostream>
#include <numeric>
#include <stdlib.h>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>

using namespace cv;

class image_read {
public:
	Mat img;
	uchar *input;
	int height, width, num_pixels;
	image_read();

};

#endif /* IMAGEread_H_ */

