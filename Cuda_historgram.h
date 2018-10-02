#include <iostream>
#include <numeric>
#include <stdlib.h>
#include <opencv2/core/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <device_functions.h>
#include <cstdio>
#include <ctime>
#include <cuda.h>
#include <cuda_runtime.h>
#include "image_read.h"
#include <string>
#include <cuda_profiler_api.h>

#define NUM_BINS 256
#define NUM_PART 3
class cuda_historgram{
public:
	cuda_historgram();
	~cuda_historgram();
	unsigned int Hist[256];
private:
	uchar *d_A;
	unsigned int *Out_His;
	unsigned int *End_Hist;

};
class cuda_historgram_rgb{
public:
	cuda_historgram_rgb();
	~cuda_historgram_rgb();
	unsigned int Hist[NUM_BINS*NUM_PART];
private:
	uchar3 *d_A;
	unsigned int *Out_His;
	unsigned int *End_Hist;

};
