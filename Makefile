.SUFFIXES: .cxx .cu .f90 .o
.PHONY: docs

CUDA_INSTALL_PATH = /usr/local/cuda

#DEVICE  = cpu
DEVICE  = gpu

CXX     = mpiicpc -g -O3 -std=c++11 -fPIC -fopenmp -ffast-math -funroll-loops -rdynamic -Wfatal-errors -I../include
NVCC    = nvcc -Xcompiler "-fopenmp -O3" -std=c++11 -use_fast_math -arch=sm_30 -I../include
FC      = mpiifort -g -O3 -fPIC -fopenmp -funroll-loops -rdynamic -I../include
LFLAGS  = -D$(DEVICE) -lstdc++ -ldl -lm
ifeq ($(DEVICE),gpu)
LFLAGS  += -lcudart
endif
OBJECT  = ../kernel/$(DEVICE)Laplace.o ../kernel/$(DEVICE)BiotSavart.o\
	../kernel/$(DEVICE)Stretching.o ../kernel/$(DEVICE)Gaussian.o\
	../kernel/$(DEVICE)CoulombVdW.o

.cxx.o:
	$(CXX) -c $? -o $@ $(LFLAGS)
.cu.o:
	$(NVCC) -c $? -o $@ $(LFLAGS)
.f90.o:
	$(FC) -c $? -o $@

clean:
	rm -rf `find .. -name "*.o" -o -name "*.out*" -o -name "*.dat" -o -name "*.a"`
	rm -f $(SRC)
