
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "Cuda_historgram.h"
#include <cuda.h>
#include <device_functions.h>
#include <opencv2/opencv.hpp>
#include <iostream>

#include "freshman.h"
using namespace cv;
//__global__ void Sum(int *sum, int size, int* index)
//
//{
//
//	atomicAdd(sum, 1);
//    __syncthreads();
//}

//
//int main(void)
//
//{
//
//	cuda_historgram  cuda_Hist;
//	int Sum=0;
//	double hist_plot[256];
//	for (int i = 0; i < 256; ++i) {
//			std::cout<<cuda_Hist.Hist[i]<<std::endl;
//			Sum+=cuda_Hist.Hist[i];
//            hist_plot[i]=cuda_Hist.Hist[i]/300;
//
//		}
//	std::cout<<Sum<<std::endl;
//	Mat histImage( 300, 256, CV_8UC3, Scalar( 0,0,0) );
//
//	// rows cols
//
//	for(int i=1;i<256;i++)
//	{
//		line(histImage,Point( i-1, 300 - cvRound(hist_plot[i-1])) ,
//                Point( i, 300 - cvRound(hist_plot[i])) ,
//                Scalar( 255, 0, 0), 1, 8,0);
//
//
//	}
//	imshow("hist",histImage);
//	waitKey(0);
//	return 0;
//}

int main(void)

{     initDevice(0);

	double iStart=cpuSecond();
	cuda_historgram_rgb  cuda_Hist_rgb;
	double iElaps=cpuSecond()-iStart;
	 printf(" Time elapsed %f sec\n",iElaps);
	int Sum=0;
	double hist_plot[NUM_BINS*NUM_PART];
	for (int i = 0; i < NUM_BINS*NUM_PART; ++i) {
			std::cout<<cuda_Hist_rgb.Hist[i]<<std::endl;
			Sum+=cuda_Hist_rgb.Hist[i];
            hist_plot[i]=cuda_Hist_rgb.Hist[i]/100;

		}
	std::cout<<Sum<<std::endl;
	Mat histImage(512, 1024, CV_8UC3, Scalar( 255,255,255) );

	// rows cols

	for(int i=1;i<NUM_BINS*NUM_PART;i++)
	{
	  if(i<NUM_BINS)
		 line(histImage,Point( i*4, 512 ),
                Point( i*4, 512 - cvRound(hist_plot[i])) ,
                Scalar( 255,0,0), 4, 8,0);
	  else if (i<2*NUM_BINS)
		line(histImage,Point(( i-NUM_BINS)*4, 512 ),
		                Point( (i-NUM_BINS)*4, 512- cvRound(hist_plot[i])) ,
		                Scalar( 0,255, 0), 4, 8,0);
	  else
		line(histImage,Point(( i-NUM_BINS*2)*4, 512),
		                Point( (i-NUM_BINS*2)*4, 512 - cvRound(hist_plot[i])) ,
		                Scalar( 0, 0, 255), 4, 8,0);

	}

	imshow("hist",histImage);
	waitKey(0);

	return 0;
}
