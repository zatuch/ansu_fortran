FORT=gfortran
NCDIR = /home/z3439823/programs/netcdf
#GSWDIR= /home/z3439823/fortran/gsw_fortran_v3_02
GSWDIR= /home/z3439823/eclipse/workspace/gsw_fortran
LSQRDIR= /home/z3439823/eclipse/workspace/ansu/third_party/lsqr2

#FLAGS= -g -O 
FLAGS= -O3
#FLAGS= -pg -O3

# Note on LLFLAGS: options preceeding "-Wl' are for linking at compile time, 
# succeeding ones are for linking at load time (or runtime). In 
# case a netcdf library is installed in a default location, but I want
# to use one located in my home directory, then omitting the succeeding
# options will cause the program TO COMPILE AGAINST against the library 
# in my home dir, but TO MAKE A RUN-TIME CALL to the default library (check with ldd).

LLFLAGS = -L$(NCDIR)/lib -lnetcdff -Wl,-rpath,$(NCDIR)/lib
INCFLAGS = -I$(NCDIR)/include -I$(LSQRDIR)


$(LSQRDIR)/%.o : $(LSQRDIR)/%.f90 ; ${FORT} ${FLAGS} -c -o $@ $< -J $(LSQRDIR)
%.o : %.f90 ; ${FORT} ${FLAGS} -c -o $@ $< $(INCFLAGS)


lsqrdeps= $(LSQRDIR)/lsqrDataModule.o $(LSQRDIR)/lsqrblas.o \
$(LSQRDIR)/lsqrblasInterface.o 

files = $(lsqrdeps) $(LSQRDIR)/lsqrModule.o definitions.o ncutils.o ansu.o run.o

run: run.o $(files)
	$(FORT) $(FLAGS) -o $@  $(files) \
	$(GSWDIR)/gsw_oceanographic_toolbox.o $(LLFLAGS)


$(LSQRDIR)/lsqrModule.o: $(lsqrdeps)

ansu.o: definitions.o $(LSQRDIR)/lsqrModule.o

ncutils.o: definitions.o

run.o:  ncutils.o ansu.o 

clean:
	rm -f *.o *.mod
	rm -f $(LSQRDIR)/*.o $(LSQRDIR)/*.mod
	rm run
	rm *nc
	
