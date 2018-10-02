################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CU_SRCS += \
../cuda_historgram.cu \
../cuda_historgram_test.cu 

CPP_SRCS += \
../image_read.cpp 

OBJS += \
./cuda_historgram.o \
./cuda_historgram_test.o \
./image_read.o 

CU_DEPS += \
./cuda_historgram.d \
./cuda_historgram_test.d 

CPP_DEPS += \
./image_read.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-8.0/bin/nvcc -I/usr/local/cuda/include -I/home/neek/Downloads/koolplot1_2 -I/usr/local/include/opencv -G -g -O0 -gencode arch=compute_20,code=sm_20 -gencode arch=compute_60,code=sm_60  -odir "." -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-8.0/bin/nvcc -I/usr/local/cuda/include -I/home/neek/Downloads/koolplot1_2 -I/usr/local/include/opencv -G -g -O0 --compile --relocatable-device-code=false -gencode arch=compute_20,code=compute_20 -gencode arch=compute_60,code=compute_60 -gencode arch=compute_20,code=sm_20 -gencode arch=compute_60,code=sm_60  -x cu -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

%.o: ../%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/usr/local/cuda-8.0/bin/nvcc -I/usr/local/cuda/include -I/home/neek/Downloads/koolplot1_2 -I/usr/local/include/opencv -G -g -O0 -gencode arch=compute_20,code=sm_20 -gencode arch=compute_60,code=sm_60  -odir "." -M -o "$(@:%.o=%.d)" "$<"
	/usr/local/cuda-8.0/bin/nvcc -I/usr/local/cuda/include -I/home/neek/Downloads/koolplot1_2 -I/usr/local/include/opencv -G -g -O0 --compile  -x c++ -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


