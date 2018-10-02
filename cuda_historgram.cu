#include "Cuda_historgram.h"


__global__ void historgram_shared(uchar *a, int height, int width,
		unsigned int *Out_His) {

	int y = blockIdx.y * blockDim.y + threadIdx.y;
	int x = blockIdx.x * blockDim.x + threadIdx.x;

	// grid dimensions
	int nx = blockDim.x * gridDim.x;
	int ny = blockDim.y * gridDim.y;

	// linear thread index within 2D block
	int t = threadIdx.x + threadIdx.y * blockDim.x;

	// total threads in 2D block
	int nt = blockDim.x * blockDim.y;

	// linear block index within 2D grid
	int g = blockIdx.x + blockIdx.y * gridDim.x;

	__shared__ unsigned int  smem[NUM_BINS];
         if(t<256) smem[t]=0;
   __syncthreads();
   //every block has a histogram
   for (int col = x; col < width; col += nx)
       for (int row = y; row < height; row += ny) {
    	   unsigned int Gray_Bin=(unsigned int)a[row*width+col];
    	   atomicAdd(&smem[Gray_Bin], 1);
       }

	__syncthreads();

    //write partial histogram into the global mem
    Out_His+=g*256;
	if(t<256){Out_His[t]=smem[t];
    }

}
__global__ void histogram_final_accum(const unsigned int *in, int n, unsigned int *out)
{  int i = blockIdx.x*blockDim.x+threadIdx.x;
  if(i<256)
  {

	  for (int j = 0; j < n; j++) {
		  out[i] +=in[i+j*256];
	}

  }

}

cuda_historgram::~cuda_historgram(){

}
cuda_historgram::cuda_historgram() {
	image_read A;

	size_t size = A.height * A.width * sizeof(uchar);
	cudaMalloc((void **)&d_A, size);

	cudaMalloc((void **)&End_Hist,256*sizeof(unsigned int));
	cudaMemcpy(d_A, A.input, size,cudaMemcpyHostToDevice);

	dim3 dimBlock1(32, 16);
	dim3 dimGrid1((A.width-1)/dimBlock1.x+1,(A.height-1)/dimBlock1.y+1);
    int n =dimGrid1.x*dimGrid1.y;
    cudaMalloc((void **)&Out_His,n*256*sizeof(unsigned int));

	historgram_shared<<<dimGrid1,dimBlock1>>>(d_A,A.height,A.width,Out_His);
	dim3 dimBlock2(256);
	dim3 dimGrid2(n);
    histogram_final_accum<<<dimGrid2,dimBlock2>>>(Out_His,n,End_Hist);
    cudaMemcpy(Hist,End_Hist,256*sizeof(unsigned int),cudaMemcpyDeviceToHost);



    cudaFree(Out_His);
    cudaFree(End_Hist);

	cudaFree(d_A);
}

__global__ void historgram_shared_rgb(uchar3 *a, int height, int width,
		unsigned int *Out_His)
{

	int y = blockIdx.y * blockDim.y + threadIdx.y;
	int x = blockIdx.x * blockDim.x + threadIdx.x;

	// grid dimensions
	int nx = blockDim.x * gridDim.x;
	int ny = blockDim.y * gridDim.y;

	// linear thread index within 2D block
	int t = threadIdx.x + threadIdx.y * blockDim.x;

	// total threads in 2D block
	int nt = blockDim.x * blockDim.y;

	// linear block index within 2D grid
	int g = blockIdx.x + blockIdx.y * gridDim.x;

    __shared__ unsigned int  smem[NUM_BINS*NUM_PART];

    for(int i=t;i<NUM_BINS*NUM_PART;i+=nt){
    	smem[i]=0;
    }


   __syncthreads();
   //every block has a histogram
   // if not every pixel was included in the grid
   for (int col = x; col < width; col += nx)
       for (int row = y; row < height; row += ny) {

//   int col = x;
//   int row=y;
//   if(col<width&&row<height)
   {       unsigned int r_Bin=(unsigned int)a[row*width+col].x;
    	   unsigned int g_Bin=(unsigned int)a[row*width+col].y;
    	   unsigned int b_Bin=(unsigned int)a[row*width+col].z;

    	   atomicAdd(&smem[r_Bin], 1);
    	   atomicAdd(&smem[1*NUM_BINS+g_Bin], 1);
    	   atomicAdd(&smem[2*NUM_BINS+b_Bin], 1);}
      }

	__syncthreads();

  //  write partial histogram into the global mem
    Out_His+=g*NUM_BINS*NUM_PART;
    for(int i=t;i<NUM_BINS;i+=nt)
    {
		Out_His[i+NUM_BINS*0]=smem[i+NUM_BINS*0];
		Out_His[i+NUM_BINS*1]=smem[i+NUM_BINS*1];
		Out_His[i+NUM_BINS*2]=smem[i+NUM_BINS*2];

	}


}
/// the histogram of total
__global__ void histogram_final_accum_rgb(const unsigned int *in, int n, unsigned int *out)
{  int i = blockIdx.x*blockDim.x+threadIdx.x;
  if(i<3*NUM_BINS)
  {
       unsigned int total=0;
	  for (int j = 0; j < n; j++) {
		  total +=in[i+j*NUM_BINS*NUM_PART];
	}
   out[i]=total;
  }

}

cuda_historgram_rgb::~cuda_historgram_rgb(){

}
cuda_historgram_rgb::cuda_historgram_rgb() {
	image_read A;
	cudaProfilerStart();
	size_t size = A.height * A.width * sizeof(uchar3);
	cudaMalloc((void **)&d_A, size);
	cudaMemcpy(d_A, A.input, size,cudaMemcpyHostToDevice);
     // the size of the endhist


	dim3 dimBlock1(32, 32);
	dim3 dimGrid1((A.width-1)/dimBlock1.x+1,(A.height-1)/dimBlock1.y+1);
    int n =dimGrid1.x*dimGrid1.y;
    cudaMalloc((void **)&Out_His,n*NUM_PART*NUM_BINS*sizeof(unsigned int));
    cudaMalloc((void **)&End_Hist,NUM_PART*NUM_BINS*sizeof(unsigned int));

	historgram_shared_rgb<<<dimGrid1,dimBlock1>>>(d_A,A.height,A.width,Out_His);
	dim3 dimBlock2(NUM_BINS*NUM_PART);
	dim3 dimGrid2(n);
	cudaFree(d_A);
    histogram_final_accum_rgb<<<dimGrid2,dimBlock2>>>(Out_His,n,End_Hist);
//    cudaMemcpy(Hist,End_Hist,NUM_PART*NUM_BINS*sizeof(unsigned int),cudaMemcpyDeviceToHost);

    cudaMemcpy(Hist,End_Hist,NUM_PART*NUM_BINS*sizeof(unsigned int),cudaMemcpyDeviceToHost);


    cudaFree(Out_His);
    cudaFree(End_Hist);
    cudaProfilerStop();

}
