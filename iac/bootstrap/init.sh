#!/bin/bash
ls -F ../environments/ | grep \/$ | sed "s/\///" > environments.info
ls -F ../modules | grep \/$ | sed "s/\///" > modules.info

for e in `cat environments.info`; do 
  for m in infra; do #`cat modules.info| grep -v -E "(boostrap|envvars|functions)"`; do 
    if ! [[ "root" == "$e" ]]
    then
      if ! [[ "bootstrap" == "$m" ]] 
      then
        terraform -chdir=.. workspace new $m-$e
      fi 
    fi
  done
done

