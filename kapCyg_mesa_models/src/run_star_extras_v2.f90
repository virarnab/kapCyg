module run_star_extras

use star_lib
use star_def
use const_def
use math_lib
use gyre_mesa_m 


implicit none

real(dp)              :: xtra_np(30)
real(dp)              :: xtra_l0(30)
real(dp)              :: xtra_I0(30)
real(dp)              :: xtra_l1(30)
real(dp)              :: xtra_I1(30)
real(dp)              :: xtra_l2(30)
real(dp)              :: xtra_I2(30)

contains
   subroutine extras_controls(id, ierr)
   integer, intent(in) :: id
   integer, intent(out) :: ierr
   type (star_info), pointer :: s
   ierr = 0
   call star_ptr(id, s, ierr)
   if (ierr /= 0) return
   
   s% extras_startup => extras_startup
   s% extras_start_step => extras_start_step
   s% extras_check_model => extras_check_model
   s% extras_finish_step => extras_finish_step
   s% extras_after_evolve => extras_after_evolve
   s% how_many_extra_history_columns => how_many_extra_history_columns
   s% data_for_extra_history_columns => data_for_extra_history_columns
   s% how_many_extra_profile_columns => how_many_extra_profile_columns
   s% data_for_extra_profile_columns => data_for_extra_profile_columns  

   s% how_many_extra_history_header_items => how_many_extra_history_header_items
   s% data_for_extra_history_header_items => data_for_extra_history_header_items
   s% how_many_extra_profile_header_items => how_many_extra_profile_header_items
   s% data_for_extra_profile_header_items => data_for_extra_profile_header_items

end subroutine extras_controls


subroutine extras_startup(id, restart, ierr)
   integer, intent(in) :: id
   logical, intent(in) :: restart
   integer, intent(out) :: ierr
   type (star_info), pointer :: s
   ierr = 0
   call star_ptr(id, s, ierr)
   if (ierr /= 0) return
   ! ########################################### Initialize GYRE ###########################################
      call init('gyre.in')

      call set_constant('G_GRAVITY', standard_cgrav)
      call set_constant('C_LIGHT', clight)
      call set_constant('A_RADIATION', crad)
      call set_constant('M_SUN', Msun)
      call set_constant('R_SUN', Rsun)
      call set_constant('L_SUN', Lsun)
      call set_constant('GYRE_DIR', TRIM(mesa_dir)//'/gyre/gyre')
end subroutine extras_startup


integer function extras_start_step(id)
   integer, intent(in) :: id
   integer :: ierr
   type (star_info), pointer :: s
   ierr = 0
   call star_ptr(id, s, ierr)
   if (ierr /= 0) return
   extras_start_step = 0
end function extras_start_step


integer function extras_check_model(id)
   integer, intent(in) :: id
   integer :: ierr
   type (star_info), pointer :: s
   ierr = 0
   call star_ptr(id, s, ierr)
   if (ierr /= 0) return
   extras_check_model = keep_going         
   if (.false. .and. s% star_mass_h1 < 0.35d0) then
      extras_check_model = terminate
      return
   end if

   if (extras_check_model == terminate) s% termination_code = t_extras_check_model
end function extras_check_model


integer function how_many_extra_history_columns(id)
   integer, intent(in) :: id
   integer :: ierr
   type (star_info), pointer :: s
   ierr = 0
   call star_ptr(id, s, ierr)
   if (ierr /= 0) return
   how_many_extra_history_columns = 0
   IF (s%x_logical_ctrl(1)) THEN
         how_many_extra_history_columns = 105
      END IF
end function how_many_extra_history_columns


subroutine data_for_extra_history_columns(id, n, names, vals, ierr)
   integer, intent(in) :: id, n
   character (len=maxlen_history_column_name) :: names(n)
   real(dp) :: vals(n)
   integer, intent(out) :: ierr
   integer :: idx
   type (star_info), pointer :: s
   ierr = 0
   call star_ptr(id, s, ierr)
   if (ierr /= 0) return


   IF ((s%x_logical_ctrl(1))) THEN
      do idx = 1,15
      write (names(idx), "('np_',I0)") idx
      vals(idx)= xtra_np(idx)
      write (names(idx+15), "('l0_',I0)") idx
      vals(idx+15)= xtra_l0(idx)
      write (names(idx+30), "('I0_',I0)") idx
      vals(idx+30)= xtra_I0(idx)
      write (names(idx+45), "('l1_',I0)") idx
      vals(idx+  45)= xtra_l1(idx)
      write (names(idx+60), "('I1_',I0)") idx
      vals(idx+ 60)= xtra_I1(idx)
      write (names(idx+75), "('l2_',I0)") idx
      vals(idx+75)= xtra_l2(idx)
      write (names(idx+90), "('I2_',I0)") idx
      vals(idx+90)= xtra_I2(idx)
      end do
   END IF
end subroutine data_for_extra_history_columns


integer function how_many_extra_profile_columns(id)
   integer, intent(in) :: id
   integer :: ierr
   type (star_info), pointer :: s
   ierr = 0
   call star_ptr(id, s, ierr)
   if (ierr /= 0) return
   how_many_extra_profile_columns = 0
end function how_many_extra_profile_columns


subroutine data_for_extra_profile_columns(id, n, nz, names, vals, ierr)
   integer, intent(in) :: id, n, nz
   character (len=maxlen_profile_column_name) :: names(n)
   real(dp) :: vals(nz,n)
   integer, intent(out) :: ierr
   type (star_info), pointer :: s
   integer :: k
   ierr = 0
   call star_ptr(id, s, ierr)
   if (ierr /= 0) return 
end subroutine data_for_extra_profile_columns


integer function how_many_extra_history_header_items(id)
   integer, intent(in) :: id
   integer :: ierr
   type (star_info), pointer :: s
   ierr = 0
   call star_ptr(id, s, ierr)
   if (ierr /= 0) return
   how_many_extra_history_header_items = 0
end function how_many_extra_history_header_items


subroutine data_for_extra_history_header_items(id, n, names, vals, ierr)
   integer, intent(in) :: id, n
   character (len=maxlen_history_column_name) :: names(n)
   real(dp) :: vals(n)
   type(star_info), pointer :: s
   integer, intent(out) :: ierr
   ierr = 0
   call star_ptr(id,s,ierr)
   if(ierr/=0) return
end subroutine data_for_extra_history_header_items


integer function how_many_extra_profile_header_items(id)
   integer, intent(in) :: id
   integer :: ierr
   type (star_info), pointer :: s
   ierr = 0
   call star_ptr(id, s, ierr)
   if (ierr /= 0) return
   how_many_extra_profile_header_items = 0
end function how_many_extra_profile_header_items


subroutine data_for_extra_profile_header_items(id, n, names, vals, ierr)
   integer, intent(in) :: id, n
   character (len=maxlen_profile_column_name) :: names(n)
   real(dp) :: vals(n)
   type(star_info), pointer :: s
   integer, intent(out) :: ierr
   ierr = 0
   call star_ptr(id,s,ierr)
   if(ierr/=0) return
end subroutine data_for_extra_profile_header_items


integer function extras_finish_step(id)
   integer, intent(in) :: id
   integer :: ierr, num
   type (star_info), pointer :: s
   ierr = 0
   call star_ptr(id, s, ierr)
   if (ierr /= 0) return
   extras_finish_step = keep_going

   !########################################### When GYRE saves frequenciess ########################################### 
   IF (s% power_he_burn > 1 .AND. s% mass_conv_core > 0 .AND. ABS(s% delta_nu - 7.4)< 1.) THEN
      s%x_logical_ctrl(1)=.True.
   ELSE
      s%x_logical_ctrl(1)=.false.
   END IF


   if (s%x_logical_ctrl(1))  then
      if (s%x_logical_ctrl(99)) then
         call run_gyre(id, ierr)

      end if

      if (mod(s% model_number, 10) == 0) then
            s% need_to_save_profiles_now = .true.
      else
            s% need_to_save_profiles_now = .false.
      endif

      if ((INDEX(s% star_history_name, 'gyre') == 0)) then 
         read(s% star_history_name, '(A,I1,A)') s% star_history_name(:7), num, s% star_history_name(8:)
         num = num + 1
         write(s% star_history_name, '(A,I0,A)') 'history', num, '_gyre.data'
      end if

      s%x_logical_ctrl(2)=.True.

   else if (s%x_logical_ctrl(2)) Then
      if ((INDEX(s% star_history_name, 'gyre') /= 0)) then 
         read(s% star_history_name, '(A,I1,A)') s% star_history_name(:7), num, s% star_history_name(8:)
         num = num + 1
         write(s% star_history_name, '(A,I0,A)') 'history', num, '.data'

         if (s%x_logical_ctrl(66)) then
            s% need_to_update_history_now = .false.
         end if
      end if

      s% need_to_save_profiles_now = .false.

   else 
      s% star_history_name = 'history1.data'
      if (s%x_logical_ctrl(66)) then
         s% need_to_update_history_now = .false.
         s% need_to_save_profiles_now = .false.
      else if (mod(s% model_number, 10) == 0) then
         s% need_to_update_history_now = .true.
      end if

   endif

   if (extras_finish_step == terminate) s% termination_code = t_extras_finish_step
end function extras_finish_step


subroutine run_gyre (id, ierr)
   integer, intent(in)  :: id
   integer, intent(out) :: ierr
   real(dp), allocatable :: global_data(:)
   real(dp), allocatable :: point_data(:,:)
   integer               :: ipar(0)
   real(dp)              :: rpar(0)
   type (star_info), pointer :: s
   ierr = 0
   call star_ptr(id, s, ierr)
   if (ierr /= 0) return
   ! Pass model data to GYRE
   call star_get_pulse_data(id, 'GYRE', .FALSE., .TRUE., .false., &
      global_data, point_data, ierr)
   if (ierr /= 0) then
      print *,'Failed when calling star_get_pulse_data'
      return
   end if
   call set_model(global_data, point_data, 101)
   xtra_l0(:)=0
   xtra_I0(:)=0
   xtra_l1(:)=0
   xtra_I1(:)=0
   xtra_l2(:)=0
   xtra_I2(:)=0
   s% xtra(1) = 0
   s% xtra(2) = 0
   s% xtra(3) = 0
   call get_modes(0, process_mode, ipar, rpar)
   call get_modes(1, process_mode, ipar, rpar)
   call get_modes(2, process_mode, ipar, rpar)
contains
   subroutine process_mode (md, ipar, rpar, retcode)
      type(mode_t), intent(in) :: md
      integer, intent(inout)   :: ipar(:)
      real(dp), intent(inout)  :: rpar(:)
      integer, intent(out)     :: retcode
      integer :: k ! why?
      integer :: idx_mode0,idx_mode1,idx_mode2
      type (star_info), pointer :: s
      ierr = 0
      call star_ptr(id, s, ierr)
      if (ierr /= 0) return
      if (md%l == 0) then
         idx_mode0 = int(s% xtra(1))
         idx_mode0 = idx_mode0 + 1
         s% xtra(1) = real(idx_mode0)
         xtra_np(idx_mode0) = md%n_p
         xtra_l0(idx_mode0) = REAL(md%freq('HZ'))*10**6
         xtra_I0(idx_mode0) = md%E_norm()
      end if
      if (md%l == 1) then
         idx_mode1 = int(s% xtra(2))
         idx_mode1 = idx_mode1 + 1
         s% xtra(2) = real(idx_mode1)
         xtra_l1(idx_mode1) = REAL(md%freq('HZ'))*10**6
         xtra_I1(idx_mode1) = md%E_norm()
      end if
      if (md%l == 2) then
         idx_mode2 = int(s% xtra(3))
         idx_mode2 = idx_mode2 + 1
         s% xtra(3) = real(idx_mode2)
         xtra_l2(idx_mode2) = REAL(md%freq('HZ'))*10**6
         xtra_I2(idx_mode2) = md%E_norm()
      end if
      retcode = 0
   end subroutine process_mode
end subroutine run_gyre


subroutine extras_after_evolve(id, ierr)
   integer, intent(in) :: id
   integer, intent(out) :: ierr
   type (star_info), pointer :: s
   ierr = 0
   call star_ptr(id, s, ierr)
   if (ierr /= 0) return
end subroutine extras_after_evolve

end module run_star_extras