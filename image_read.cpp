#include "image_read.h"
#include "Cuda_historgram.h"



using namespace cv;


image_read::image_read() {
        Mat img2 = imread("segment.png");
        uchar3 n ;
        n=img2.at<uchar3>(1,1);
        std::cout<<int(n.z)<<std::endl;

        resize(img2, img, Size(640,270), 0, 0, INTER_LINEAR);
        width = img.rows;
        height = img.cols;
        num_pixels = width * height;
        //input = new uchar[num_pixels];
        input = img.data;
}
