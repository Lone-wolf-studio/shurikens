#!/bin/bash

# text colors
red_text=`tput setaf 1`
green_text=`tput setaf 2`


function usage_instruction(){
    echo "bash shurikens.sh -f <framework_name> -p <project_name> -d <database_name>"
    }

while getopts ":f:fv:p:d:" arg; do
    case $arg in
        f) frame_work=$OPTARG;;
        p) project_name=$OPTARG;;
        d) database=$OPTARG;;
        fv) frame_work_version=$OPTARG;;
    esac
done

environment_variable="env"
env_name="${project_name}${environment_variable}"

function create_virtualenvironment(){
    echo "${green_text}creating virtual environment $env_name"
    (cd $HOME ; virtualenv -p python3 ${env_name})
}
	
function install_django(){
    if [ ! -z "$frame_work_version" ]
    then
        echo "${green_text}Installing django version $frame_work_version in environment $env_name"
        $HOME/${env_name}/bin/pip install django==$frame_work_version
    else
        echo "${green_text}Installing update django version in environment: $env_name"
        $HOME/${env_name}/bin/pip install django    
    fi
}    

function create_django_project(){
    echo "${green_text}Creating django project $project_name" 
    (cd $HOME ; django-admin.py startproject ${project_name})   
}


function install_flask(){
    echo "${green_text}Installing flask in environment: $env_name"
    $HOME/${env_name}/bin/pip install flask
}


function main(){
    if  [ ! "$frame_work" ] || [ ! "$project_name" ] || [ ! "$database" ] 
    then
        usage_instruction
        exit 1
    fi    

    create_virtualenvironment 
    case $frame_work in
        django)
            install_django
            create_django_project
            ;;
        flask)
            install_flask    
    esac
    }

main    
