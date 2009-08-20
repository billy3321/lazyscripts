#!/bin/bash


function select_repo () {
    DISTRO_NAME="$DISTRO_ID"
    AVAILABLE_REPO=($(cat conf/repository.conf  | grep "${DISTRO_NAME}" | cut -d " " -f 1 | grep "^[git].*[git]$"))
    if [ ${#AVAILABLE_REPO[@]} -eq 1 ];then
        USE_REPO=(${AVAILABLE_REPO})
        REPO_URL=(${AVAILABLE_REPO})
    else
        SHOW_REPO=$(for uri in ${AVAILABLE_REPO[*]} ; do echo -n "FALSE $uri " ; done)
        USE_REPO=`zenity --list --title="Choice Scripts Repository You Want to Use" --radiolist --column "" --column "Repository URL" ${SHOW_REPO}`
        REPO_URL=(${USE_REPO/|/ })
    fi
    export REPO_URL
    export REPO_NUM=${#REPO_URL[@]}
    echo "REPO_URL=(${USE_REPO/|/ })" >> $ENV_EXPORT_SCRIPT
    echo "export REPO_URL" >> $ENV_EXPORT_SCRIPT
    echo "export REPO_NUM=${#REPO_URL[@]}" >> $ENV_EXPORT_SCRIPT
    echo 'for ((num=0;num<${REPO_NUM};num=$num+1)); do 
        REPO_DIR[$num]="./scriptspoll/`./lzs repo sign ${REPO_URL[${num}]}`"
        if [ -d ${REPO_DIR[$num]} ];then
            rm -rf ${REPO_DIR[$num]}
        fi
        git clone ${REPO_URL[$num]} ${REPO_DIR[$num]}
        ./lzs list build ${REPO_URL[$num]}
    done' >> $ENV_EXPORT_SCRIPT
    echo "export REPO_DIR" >> $ENV_EXPORT_SCRIPT
}


