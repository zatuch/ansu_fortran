!This is part of the analyze_surface toolbox, (C) 2009 A. Klocker
!Partially modified by P. Barker (2010-13)
!Partially modified by S. Riha (2013)
!Principal investigator: Trevor McDougall
!
!Translated to Fortran by S. Riha (2013)

module ncutils_mod
    use netcdf
    implicit none
    public ncwrite
    public ncread
    private check

contains

    subroutine ncwrite(va,fname,vname,mode)
        integer, parameter :: rk = selected_real_kind(14,30)
        real(rk), dimension(:), intent(in) :: va
        character (len = *), intent(in) :: fname
        character (len = *), intent(in) :: vname
        !real(rk), dimension(:,:) :: va2
        integer, intent(in) :: mode
        integer :: ncid, varid, x_dimid, y_dimid, z_dimid
        integer, dimension(1) :: dimids1
        integer, dimension(2) :: dimids2
        integer, dimension(3) :: dimids3
        real(rk) :: zero, fillval

        call check( nf90_create(fname,ior(nf90_netcdf4, nf90_classic_model),ncid))

        if (mode==1) then

            call check( nf90_def_dim(ncid,"x",size(va),x_dimid))
            dimids1 =  (/ x_dimid /)
            call check( nf90_def_var(ncid,vname,NF90_DOUBLE,dimids1,varid))
            call check( nf90_close(ncid) )

            call check( nf90_open(fname, NF90_WRITE, ncid) )
            call check( nf90_put_var(ncid,varid,va))

        else if (mode==2) then

            call check( nf90_def_dim(ncid,"y",43,y_dimid))
            call check( nf90_def_dim(ncid,"x",90,x_dimid))
            dimids2 =  [x_dimid, y_dimid]
            call check( nf90_def_var(ncid,vname,NF90_DOUBLE,dimids2,varid))
            zero=0.0d0
            fillval = zero/ zero
            call check( nf90_put_att(ncid, varid, "_FillValue", fillval) )
            call check( nf90_enddef(ncid) )

            call check( nf90_put_var(ncid,varid,reshape(va,[90,43])))

        else if (mode==3) then

            call check( nf90_def_dim(ncid,"z",101,z_dimid))
            call check( nf90_def_dim(ncid,"y",43,y_dimid))
            call check( nf90_def_dim(ncid,"x",90,x_dimid))
            dimids3 =  [x_dimid, y_dimid, z_dimid]
            call check( nf90_def_var(ncid,vname,NF90_DOUBLE,dimids3,varid))
            call check( nf90_close(ncid) )
            call check( nf90_open(fname, NF90_WRITE, ncid) )
            call check( nf90_put_var(ncid,varid,reshape(va,[90,43,101])))

        endif

        call check( nf90_close(ncid) )

    end subroutine ncwrite


    subroutine ncread(sns,ctns,pns,s,ct,p,e1t,e2t)

        integer, parameter :: rk = selected_real_kind(14,30)

        character (len = *), parameter :: FILE_NAME = "/home/z3439823/mymatlab/omega/ansu_utils/exp100/data/os_input.nc"

        real(rk), dimension(:,:), intent(inout) :: sns, ctns, pns, e1t, e2t
        real(rk), dimension(:,:,:), intent(inout) :: s, ct, p
        integer :: ncid, varid

        call check( nf90_open(FILE_NAME, NF90_NOWRITE, ncid) )

        call check( nf90_inq_varid(ncid, "sns", varid) )
        call check( nf90_get_var(ncid, varid, sns) )

        call check( nf90_inq_varid(ncid, "ctns", varid) )
        call check( nf90_get_var(ncid, varid, ctns) )
        call check( nf90_inq_varid(ncid, "pns", varid) )
        call check( nf90_get_var(ncid, varid, pns) )

        call check( nf90_inq_varid(ncid, "sa", varid) )
        call check( nf90_get_var(ncid, varid, s) )
        call check( nf90_inq_varid(ncid, "ct", varid) )
        call check( nf90_get_var(ncid, varid, ct) )
        call check( nf90_inq_varid(ncid, "p", varid) )
        call check( nf90_get_var(ncid, varid, p) )

        call check( nf90_inq_varid(ncid, "e1t", varid) )
        call check( nf90_get_var(ncid, varid, e1t) )
        call check( nf90_inq_varid(ncid, "e2t", varid) )
        call check( nf90_get_var(ncid, varid, e2t) )

        ! Close
        call check( nf90_close(ncid) )

    end subroutine ncread


    subroutine check(status)
        integer, intent ( in) :: status

        if(status /= nf90_noerr) then
            print *, trim(nf90_strerror(status))
            stop "Stopped"
        end if
    end subroutine check
end module ncutils_mod