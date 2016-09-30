#!/bin/bash
execPath=`pwd`
productsPath="/form/technologies"
declare -A k v store
echo -e  "Form -> technologies - basepath\n\n"


input_serialised=$1

if [[ $input_serialised =~ --g--.*.--s ]]; then 

    arr=(${input_serialised//--/ }) 
    i=0
    for pairs in ${arr[*]}; do
        if [[ $pairs != ? ]]; then 
            v[${i}]=${pairs}
        else
            k[${i}]=${pairs}
            (( ++i))
        fi
    done
    
    i=0
    for kv in ${k[*]}; do   
        store[${kv}]=${v[$i]}
               (( ++i))
   done

else
    echo  "Enter Class :"
    read c; store["c"]=$c
    echo  "Enter Order :"
    read o; store["o"]=$o
    echo  "Enter Family :"
    read f; store["f"]=$f
    echo  "Enter Genus :"
    read g; store["g"]=$g
    echo  "Enter Species ('main' if ommitted) :"
    read s; store["s"]=$s
    
fi

#echo ${store[@]}
taxSerial="${store[c]}--c--${store[o]}--o--${store[f]}--f--${store[g]}--g--${store[s]}--s"
taxSerialShort="${store[c]}--c--${store[o]}--o--${store[f]}--f--${store[g]}"
taxPath="${store[c]}--c/${store[o]}--o/${store[f]}--f/${store[g]}"

## GIT
        cd $execPath/../$productsPath
        git clone ./_template/.git ./$taxPath
        cd $execPath/../$productsPath/$taxPath

        git add -u :/
        grep -rl --exclude-dir=.git class--c--order--o--family--f--genus--g--main--s ./ | xargs sed -i "s/class--c--order--o--family--f--genus--g--main--s/${store[c]}--c--${store[o]}--o--${store[f]}--f--${store[g]}--g--${store[s]}--s/g"
        grep -rl --exclude-dir=.git class--c--order--o--family--f--genus ./ | xargs sed -i "s/class--c--order--o--family--f--genus/${store[c]}--c--${store[o]}--o--${store[f]}--f--${store[g]}/g"
        grep -rl --exclude-dir=.git genus--g ./ | xargs sed -i "s/genus--g/${store[g]}--g/g"

        find . -not -path "./.git/*" -type f -name *class--c--order--o--family--f--genus--g--main--s* -exec bash -c 'for file in $@; do mv $file ${file/class--c--order--o--family--f--genus--g--main--s/'$taxSerial'}; done' bash {} +

## OBS
        cd $execPath/../$productsPath
        obsArray=("${store[c]}--c" "${store[c]}--c:${store[o]}--o" "${store[c]}--c:${store[o]}--o:${store[f]}--f")
        for obs in ${obsArray[*]}; do   
            cp $execPath/obs_project.xml /tmp/obs_project.xml
            sed -i "s/{PROJECT}/$obs/g" /tmp/obs_project.xml
            osc meta prj home:conecenter:in4:form:technologies:$obs  -F /tmp/obs_project.xml
        done


        cp $execPath/obs_package.xml /tmp/obs_package.xml
        sed -i "s/{PROJECT}/$obs/g" /tmp/obs_package.xml
        sed -i "s/{NAME}/${store[g]}/g" /tmp/obs_package.xml
        cd $execPath/../$productsPath/$taxPath/in4/1_build/obs/
        osc co -u home:conecenter:in4:form:technologies:$obs
        mv home:conecenter:in4:form:technologies:$obs/.osc ./ && rm -rf home:conecenter:in4:form:technologies:$obs
        #
        osc meta pkg home:conecenter:in4:form:technologies:$obs ${store[g]} -F /tmp/obs_package.xml
        osc up -u
        
        cd $execPath/../$productsPath/$taxPath
        git add * && git commit  -m "777"
