#!/bin/bash
execPath=`pwd`
declare -A k v store
echo -e  "Fork role - basepath\n\n"


input_serialised=$1



#echo ${store[@]}
taxSerial="${store[c]}--c--${store[o]}--o--${store[f]}--f--${store[g]}--g--${store[s]}--s"
taxSerialShort="${store[c]}--c--${store[o]}--o--${store[f]}--f--${store[g]}"
taxPath="${store[c]}--c/${store[o]}--o/${store[f]}--f/${store[g]}"

## GIT
        cd $execPath/../products
        git clone ./_ontology_template/.git ./$taxPath
        cd $execPath/../products/$taxPath

        git add -u :/
        grep -rl --exclude-dir=.git class--c--order--o--family--f--genus--g--main--s ./ | xargs sed -i "s/class--c--order--o--family--f--genus--g--main--s/${store[c]}--c--${store[o]}--o--${store[f]}--f--${store[g]}--g--${store[s]}--s/g"
        grep -rl --exclude-dir=.git class--c--order--o--family--f--genus ./ | xargs sed -i "s/class--c--order--o--family--f--genus/${store[c]}--c--${store[o]}--o--${store[f]}--f--${store[g]}/g"
        grep -rl --exclude-dir=.git genus--g ./ | xargs sed -i "s/genus--g/${store[g]}--g/g"

        find . -not -path "./.git/*" -type f -name *class--c--order--o--family--f--genus--g--main--s* -exec bash -c 'for file in $@; do mv $file ${file/class--c--order--o--family--f--genus--g--main--s/'$taxSerial'}; done' bash {} +

## OBS
        cd $execPath/../products
        obsArray=("${store[c]}--c" "${store[c]}--c:${store[o]}--o" "${store[c]}--c:${store[o]}--o:${store[f]}--f")
        for obs in ${obsArray[*]}; do   
            cp $execPath/obs_project.xml /tmp/obs_project.xml
            sed -i "s/{PROJECT}/$obs/g" /tmp/obs_project.xml
            osc meta prj home:conecenter:rev5a1:ontology:$obs  -F /tmp/obs_project.xml
        done


        cp $execPath/obs_package.xml /tmp/obs_package.xml
        sed -i "s/{PROJECT}/$obs/g" /tmp/obs_package.xml
        sed -i "s/{NAME}/${store[g]}/g" /tmp/obs_package.xml
        cd $execPath/../products/$taxPath/rev5/1_build/obs/
        osc co -u home:conecenter:rev5a1:ontology:$obs
        mv home:conecenter:rev5a1:ontology:$obs/.osc ./ && rm -rf home:conecenter:rev5a1:ontology:$obs
        #
        osc meta pkg home:conecenter:rev5a1:ontology:$obs ${store[g]} -F /tmp/obs_package.xml
        osc up -u
        
        cd $execPath/../products/$taxPath
        git add * && git commit  -m "777"