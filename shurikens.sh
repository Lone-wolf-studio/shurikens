#!/bin/bash

# text colors
red_text=`tput setaf 1`
green_text=`tput setaf 2`

# credentials
mysql_user="root"
mysql_password="root"

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
project_root_path="$HOME/${project_name}"
project_settings_path="${project_root_path}/${project_name}" 

function create_virtualenvironment(){
    echo "${green_text}creating virtual environment $env_name"
    (cd $HOME ; virtualenv -p python3 ${env_name})
}
	
function install_django(){
    if [ ! -z "$frame_work_version" ]
    then
        echo "${green_text}======Installing django version $frame_work_version in environment ${env_name}======"
        $HOME/${env_name}/bin/pip install django==$frame_work_version
    else
        echo "${green_text}======Installing update django version in environment: ${env_name}======"
        $HOME/${env_name}/bin/pip install django    
    fi
}    

function create_django_project(){
    echo "${green_text}======Creating django project ${project_name}======" 
    (cd $HOME ; django-admin.py startproject ${project_name})   
}

function django_project_setup(){
    echo "${green_text}======Setting up django project ${project_name}======"
    (cd $HOME/${project_name} ; mkdir templates && mkdir static)
    (cd $HOME/${project_name}/static ; mkdir js && mkdir img && mkdir css)
    
    echo "${green_text}======Changing templates Settings for ${project_name}======"
    chmod 755 ./files/django_files/django_settings_template_tweaker.py 
    sleep 5

    echo "${green_text}======Changing database Settings for ${project_name}======"
    chmod 755 ./files/django_files/django_settings_database_tweaker.py
    sleep 5
}

function django_database_migrate(){
    (chmod 755 $HOME/${project_name}/manage.py makemigrations && chmod 755 $HOME/${project_name}/manage.py migrate)
}


function install_flask(){
    if [ ! -z "$frame_work_version" ]
    then
        echo "${green_text}======Installing flask version ${frame_work_version} in environment ${env_name}======"
        $HOME/${env_name}/bin/pip install flask==$frame_work_version
    else
        echo "${green_text}======Installing updated flask version in environment: ${env_name}======"
        $HOME/${env_name}/bin/pip install flask    
    fi
    
}

function create_database(){
    if ["$database" == mysql]
    then
        echo "${green_text}======Creating Mysql database======"
        mysql -u${mysql_user} -p${mysql_password} -e "create database ${project_name}"
    fi    

}

function export_bash_variables(){
    echo "${green_text}======Exporting path variables======"
    export $project_name
    export $database_name
    export $mysql_user
    export $mysql_password
    export $project_root_path
    export $project_settings_path
}

function main(){
    if  [ ! "$frame_work" ] || [ ! "$project_name" ] || [ ! "$database" ] 
    then
        usage_instruction
        exit 1
    fi    

    create_virtualenvironment 
    export_bash_variables
    case $frame_work in
        django)
            install_django
            sleep 3
            create_django_project
            sleep 3
            django_project_setup
            sleep 3
            create_database
            sleep 3
            django_database_migrate
            ;;
        flask)
            install_flask    
    esac
    }

main    
