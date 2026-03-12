#!/bin/bash

inlistName="inlist"

path="./inlist_nochange_os"

line=$(sed ${1}!d sobol_os.txt)
parameters=(${line})
mass=${parameters[0]}
z=${parameters[1]}
y=${parameters[2]}
MLa=${parameters[3]}
eta=${parameters[4]}
fov=${parameters[5]}

echo "&star_job" >> $inlistName
echo "    read_extra_star_job_inlist(1) = .true." >> $inlistName
echo "    extra_star_job_inlist_name(1) = '$path'" >> $inlistName
echo "/ " >> $inlistName
echo "" >> $inlistName
echo "&eos" >> $inlistName
echo "/ " >> $inlistName
echo "" >> $inlistName
echo "&kap" >> $inlistName
echo "    Zbase = $z" >> $inlistName
echo "" >> $inlistName
echo "    read_extra_kap_inlist(1) = .true." >> $inlistName
echo "    extra_kap_inlist_name(1) = '$path'" >> $inlistName
echo "/ " >> $inlistName
echo "" >> $inlistName
echo "&controls" >> $inlistName
echo "    log_directory = 'LOGS_${1}'" >> $inlistName
echo "" >> $inlistName
echo "    initial_mass = $mass ! in Msun units" >> $inlistName
echo "    initial_z = $z" >> $inlistName
echo "    initial_y = $y" >> $inlistName
echo "    Reimers_scaling_factor = $eta " >> $inlistName
echo "    overshoot_f(1) = $fov" >> $inlistName
echo "    overshoot_f0(1) = 0.004" >> $inlistName
echo "    mixing_length_alpha = $MLa" >> $inlistName
echo "" >> $inlistName
echo "    read_extra_controls_inlist(1) = .true." >> $inlistName
echo "    extra_controls_inlist_name(1) = '$path'" >> $inlistName
echo "/ " >> $inlistName
