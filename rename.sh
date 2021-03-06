#!/usr/bin/env bash

#/*============================================================================
#
#  GOICPZ: A software package for globally optimal implementations of the iterative closest point algorithm.
#
#  Copyright (c) University College London (UCL). All rights reserved.
#
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.
#
#  See LICENSE.txt in the top level directory for details.
#
#============================================================================*/

# Script which changes generic name GoICPz, namespace goicpz etc to a project name of your choice.
# USAGE: Just change the variables prefixed by NEW below to an appropriate name then run the script.

######################################################
##                 EDIT THIS PART                   ##
######################################################

NEW_PROJECT_NAME_CAMEL_CASE='GoICPz'
NEW_PROJECT_NAME_LOWER_CASE='goicpz'
NEW_PROJECT_NAME_CAPS='GOICPZ'
NEW_SHORT_DESCRIPTION='A software package for globally optimal implementations of the iterative closest point algorithm.'
NEW_NAMESPACE='goicpz'


######################################################

# Strings to replace
OLD_DIR_NAME='CMakeCatchTemplate'
OLD_PROJECT_NAME_CAMEL_CASE='GoICPz'
OLD_PROJECT_NAME_LOWER_CASE='goicpz'
OLD_PROJECT_NAME_CAPS='GOICPZ'
OLD_DOXYGEN_INTRO='A software package for globally optimal implementations of the iterative closest point algorithm.'
OLD_SHORT_DESCRIPTION='A software package for globally optimal implementations of the iterative closest point algorithm.'
OLD_NAMESPACE='mp'

#### Replacements ###

find_and_replace_string(){
    find . -type f | grep -v "[.]git" > $HOME/tmp.$$.files.txt
    for f in `cat $HOME/tmp.$$.files.txt`
    do
      wc1=`file $f | grep text | wc -l`
      wc2=`file --mime $f | grep "application/xml" | wc -l`
      if [ ${wc1} -gt 0 -o ${wc2} -gt 0 ]; then
        cat $f | sed s/"${1}"/"${2}"/g > $HOME/tmp.$$.file.txt
        mv $HOME/tmp.$$.file.txt $f
      fi
    done
    rm $HOME/tmp.$$.files.txt
}

find_and_replace_filename(){
    find . -name "*$1*" > $HOME/tmp.$$.files.txt
    wc=`cat $HOME/tmp.$$.files.txt | wc -l`
    if [ $wc -gt 0 ]; then
      cat $HOME/tmp.$$.files.txt | sed -e "p;s/$1/$2/" | xargs -n2 git mv --force
    fi
}

find_and_replace_filename_and_string(){
    find_and_replace_filename $1 $2
    find_and_replace_string $1 $2
}

# Change comment at top of each file describing project
find_and_replace_string "${OLD_SHORT_DESCRIPTION}" "${NEW_SHORT_DESCRIPTION}"

# Change Doxygen intro
find_and_replace_string "${OLD_DOXYGEN_INTRO}" "${NEW_SHORT_DESCRIPTION}"

# Replace name GoICPz, goicpz, GOICPZ etc.
find_and_replace_string "$OLD_PROJECT_NAME_CAMEL_CASE" "$NEW_PROJECT_NAME_CAMEL_CASE"
find_and_replace_string "$OLD_PROJECT_NAME_LOWER_CASE" "$NEW_PROJECT_NAME_LOWER_CASE"
find_and_replace_string "$OLD_PROJECT_NAME_CAPS" "$NEW_PROJECT_NAME_CAPS"

# namespace
find_and_replace_string "namespace $OLD_NAMESPACE" "namespace $NEW_NAMESPACE"
find_and_replace_string "${OLD_NAMESPACE}::" "${NEW_NAMESPACE}::"

# Filename replacements
find_and_replace_filename "$OLD_PROJECT_NAME_CAMEL_CASE" "$NEW_PROJECT_NAME_CAMEL_CASE"
find_and_replace_filename "$OLD_PROJECT_NAME_LOWER_CASE" "$NEW_PROJECT_NAME_LOWER_CASE"
find_and_replace_filename "$OLD_PROJECT_NAME_CAPS" "$NEW_PROJECT_NAME_CAPS"

# mp prefixes
nc=`echo ${OLD_NAMESPACE} | wc -c | tr -d '[:space:]'`
for g in .h .cpp .ui
do
  find . -name "${OLD_NAMESPACE}*${g}" > $HOME/tmp.$$.${OLD_NAMESPACE}.${g}.txt
  for f in `cat $HOME/tmp.$$.${OLD_NAMESPACE}.${g}.txt`
  do
    basename $f $g | cut -c ${nc}-10000 >> $HOME/tmp.$$.prefixes.txt
  done
  rm $HOME/tmp.$$.${OLD_NAMESPACE}.${g}.txt
done
cat $HOME/tmp.$$.prefixes.txt | sort -u > $HOME/tmp.$$.prefixes.sorted.txt
for f in `cat $HOME/tmp.$$.prefixes.sorted.txt`
do
  echo "${f}\.cpp" >> $HOME/tmp.$$.prefixes.all.txt
  echo "${f}_h" >> $HOME/tmp.$$.prefixes.all.txt
  echo "${f}\.h" >> $HOME/tmp.$$.prefixes.all.txt
  echo "${f}\.ui" >> $HOME/tmp.$$.prefixes.all.txt
  echo "${f}" >> $HOME/tmp.$$.prefixes.all.txt
done

declare -a file_names=(`cat $HOME/tmp.$$.prefixes.all.txt`)
for i in "${file_names[@]}"
do
    find_and_replace_filename_and_string "${OLD_NAMESPACE}${i}" "${NEW_NAMESPACE}${i}"
done
rm $HOME/tmp.$$.prefixes.txt
rm $HOME/tmp.$$.prefixes.sorted.txt
rm $HOME/tmp.$$.prefixes.all.txt


