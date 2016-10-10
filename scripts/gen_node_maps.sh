#!/bin/bash                                                                      
                                                                                 
if [[ $1 == "-h" ]];                                                             
then                                                                             
  echo "gen_mapfiles.sh <numSample> <max_size 0 - 4> <dst_folder>"
  exit 0                                                                         
fi                                                                               
                                                                                 
numSample=$1                                                                     
max_size=$2                                                                      
dest_folder=$3
                                                                   
dfly="7 4 7 1590 1"                                                              
ftree="22 4 22 484 1"                                                            
ht="9 4 9 1200 1"                                                                
slim="15 4 15 722 1"                                                             
                                                                                 
filename="out.multijob.${max_size}"                                              
echo "python ./map_gen.py $max_size $numSample 0 multijob.inp.${max_size} >$filename"
python ./map_gen.py $max_size $numSample 0 multijob.inp.${max_size} >$filename
                                                                                 
cur_count=0                                                                      
cat $filename | while read -r line
do 
  numjobs=`wc -l multijob.inp.${max_size}.${cur_count} | awk '{print $1}'`

  echo "./many_job global.bin 1 $numjobs $line $dfly multijob.inp.${max_size}.${cur_count}"
  ./many_job global.bin 1 $numjobs $line $dfly multijob.inp.${max_size}.${cur_count}
  mkdir -p $dest_folder/node/linear/set_${cur_count}/dfly
  mv global* $dest_folder/node/linear/set_${cur_count}/dfly
  mv job* $dest_folder/node/linear/set_${cur_count}/dfly

  echo "./many_job global.bin 1 $numjobs $line $ftree multijob.inp.${max_size}.${cur_count}"
  ./many_job global.bin 1 $numjobs $line $ftree multijob.inp.${max_size}.${cur_count}
  mkdir -p $dest_folder/node/linear/set_${cur_count}/ftree
  mv global* $dest_folder/node/linear/set_${cur_count}/ftree
  mv job* $dest_folder/node/linear/set_${cur_count}/ftree

  echo "./many_job global.bin 1 $numjobs $line $ht multijob.inp.${max_size}.${cur_count}"
  ./many_job global.bin 1 $numjobs $line $ht multijob.inp.${max_size}.${cur_count}
  mkdir -p $dest_folder/node/linear/set_${cur_count}/ht
  mv global* $dest_folder/node/linear/set_${cur_count}/ht
  mv job* $dest_folder/node/linear/set_${cur_count}/ht

  echo "./many_job global.bin 1 $numjobs $line $slim multijob.inp.${max_size}.${cur_count}"
  ./many_job global.bin 1 $numjobs $line $slim multijob.inp.${max_size}.${cur_count}
  mkdir -p $dest_folder/node/linear/set_${cur_count}/slim
  mv global* $dest_folder/node/linear/set_${cur_count}/slim
  mv job* $dest_folder/node/linear/set_${cur_count}/slim

  #rand placement
  echo "./many_job global.bin 2 $numjobs $line $dfly multijob.inp.${max_size}.${cur_count}"
  ./many_job global.bin 2 $numjobs $line $dfly multijob.inp.${max_size}.${cur_count}
  mkdir -p $dest_folder/node/rand/set_${cur_count}/dfly
  mv global* $dest_folder/node/rand/set_${cur_count}/dfly
  mv job* $dest_folder/node/rand/set_${cur_count}/dfly

  echo "./many_job global.bin 2 $numjobs $line $ftree multijob.inp.${max_size}.${cur_count}"
  ./many_job global.bin 2 $numjobs $line $ftree multijob.inp.${max_size}.${cur_count}
  mkdir -p $dest_folder/node/rand/set_${cur_count}/ftree
  mv global* $dest_folder/node/rand/set_${cur_count}/ftree
  mv job* $dest_folder/node/rand/set_${cur_count}/ftree

  echo "./many_job global.bin 2 $numjobs $line $ht multijob.inp.${max_size}.${cur_count}"
  ./many_job global.bin 2 $numjobs $line $ht multijob.inp.${max_size}.${cur_count}
  mkdir -p $dest_folder/node/rand/set_${cur_count}/ht
  mv global* $dest_folder/node/rand/set_${cur_count}/ht
  mv job* $dest_folder/node/rand/set_${cur_count}/ht

  echo "./many_job global.bin 2 $numjobs $line $slim multijob.inp.${max_size}.${cur_count}"
  ./many_job global.bin 2 $numjobs $line $slim multijob.inp.${max_size}.${cur_count}
  mkdir -p $dest_folder/node/rand/set_${cur_count}/slim
  mv global* $dest_folder/node/rand/set_${cur_count}/slim
  mv job* $dest_folder/node/rand/set_${cur_count}/slim

  (( cur_count++ ))
done 

mv $filename $dest_folder/node
mv multijob.inp.${max_size}.* $dest_folder/node
