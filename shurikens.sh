#!/bin/bash

# text colors
red_text=`tput setaf 1`
green_text=`tput setaf 2`


function usage_instruction(){
    echo "bash shurikens.sh -f <framework_name> -p <project_name> -d <database_name>"
    }

while getopts ":f:p:d:" arg; do
    case $arg in
        f) frame_work=$OPTARG;;
        p) project_name=$OPTARG;;
        d) database=$OPTARG;;
    esac
done

environment_variable="env"
env_name="${project_name}${environment_variable}"

function create_virtualenvironment(){
    echo "${green_text}creating virtual environment $env_name"
    (cd $HOME ; virtualenv -p python3 ${env_name})
    }
	
function install_django(){
    echo "${green_text}Installing django in environment: $env_name"
    $HOME/${env_name}/bin/pip install django
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
            ;;
        flask)
            install_flask    
    esac
    }

main    
