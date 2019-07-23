#!/bin/csh -f

## I am changed the CUBE/EASE logic
## if CUBE we produce 2D
## anything else, SMAP and other offline grids we produce tile space

setenv    LSM_CHOICE $1
setenv    AEROSOL_DEPOSITION $2
setenv    GRID $3
setenv    GRIDNAME $4
setenv    HISTRC $5
setenv    RUN_IRRIG $6
setenv    ASSIM  $7

echo $GRIDNAME

if($GRID == CUBE) then
   sed -i '/^\#EASE/d' $HISTRC
   sed -i 's|\#CUBE|''|g' $HISTRC
   sed -i 's|GRIDNAME|'"$GRIDNAME"'|g' $HISTRC
else
   sed -i '/^\#CUBE/d' $HISTRC
   sed -i 's|\#EASE|''|g' $HISTRC
endif

if($LSM_CHOICE == 1) then
   set GridComp = CATCH
   sed -i '/^>>>HIST_CATCHCN<<</d' $HISTRC
endif

if($LSM_CHOICE == 2) then
   set GridComp = CATCHCN
   sed -i 's/>>>HIST_CATCHCN<<</''/g' $HISTRC
endif

if($ASSIM == 1) then
   sed -i 's|\#ASSIM|''|g' $HISTRC
   set GridComp = ENSAVG
   sed -i 's|VEGDYN|'VEGDYN0000'|g' $HISTRC
   sed -i 's|DATAATM|'DATAATM0000'|g' $HISTRC
else
   sed -i '/^\#ASSIM/d' $HISTRC
endif

sed -i 's|GridComp|'$GridComp'|g' $HISTRC

if($AEROSOL_DEPOSITION == 0) then
   sed -i '/^>>>HIST_AEROSOL<<</d' $HISTRC
else
   sed -i 's/>>>HIST_AEROSOL<<</''/g' $HISTRC
endif

if($RUN_IRRIG == 0) then
   sed -i '/^>>>HIST_IRRIG<<</d' $HISTRC
else
   sed -i 's/>>>HIST_IRRIG<<</''/g' $HISTRC
endif