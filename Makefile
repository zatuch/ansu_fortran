FORT=gfortran
NCDIR = /home/z3439823/programs/netcdf
GSWDIR= /home/z3439823/fortran/gsw_fortran_v3_01

FLAG= -g

LIBFLAGS = -lnetcdff -L$(NCDIR)/lib
LDFLAGS = -I$(NCDIR)/include

OBJS1 = ncutils.o ans.o

OBJS = run.o $(OBJS1)


all: $(OBJS) Makefile
	$(FORT) -o run_exe $(OBJS) $(GSWDIR)/gsw_oceanographic_toolbox.o $(LIBFLAGS) $(LDFLAGS)

clean:
	rm -f 
	
ncutils_mod.mod: ncutils.o ncutils.f90
	$(FORT) $(FLAG) -c ncutils.f90 $(LIBFLAGS) $(LDFLAGS)
	
ans_mod.mod: ans.o ncutils.o ans.f90
	$(FORT) $(FLAG) -c ans.f90 $(LIBFLAGS) $(LDFLAGS)	
		
run.o: run.f90 ncutils_mod.mod ans_mod.mod
	$(FORT) $(FLAG) -c run.f90
    	
ncutils.o: ncutils.f90
	$(FORT) $(FLAG) -c ncutils.f90 $(LIBFLAGS) $(LDFLAGS)
	
ans.o: ans.f90 ncutils_mod.mod
	$(FORT) $(FLAG) -c ans.f90 $(LIBFLAGS) $(LDFLAGS)
	