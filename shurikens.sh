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
project_root_path="${HOME}/${project_name}"
project_settings_path="${project_root_path}/${project_name}" 

echo "${project_settings_path}"

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
        echo "${green_text}======Installing updated django version in environment: ${env_name}======"
        $HOME/${env_name}/bin/pip install django    
    fi
}

# list of supporting packages needed for a typical django project
function install_django_support_packages(){
    # mysqlclient   
    ($HOME/${env_name}/bin/pip install mysqlclient)
    # Image uploads based operations Pillow
    ($HOME/${env_name}/bin/pip install Pillow)
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
    (source $HOME/${env_name}/bin/activate && $HOME/${env_name}/bin/python3 ./files/django_files/django_settings_template_tweaker.py) 
    sleep 5

    echo "${green_text}======Changing database Settings for ${project_name}======"
    chmod 755 ./files/django_files/django_settings_database_tweaker.py
    (source $HOME/${env_name}/bin/activate && $HOME/${env_name}/bin/python3 ./files/django_files/django_settings_database_tweaker.py)
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

function create_flask_project(){
    echo "${green_text}======Creating flask project ${project_name}======" 
    (cd $HOME ; mkdir ${project_name})   
}

function flask_project_setup(){
    echo "${green_text}======Setting up flask project ${project_name}======"
    (cd $HOME/${project_name} ; cp ./files/flask_files/flask_function_routes.py app.py)
}

function install_fastapi(){
    if [ ! -z "$frame_work_version" ]
    then
        echo "${green_text}======Installing fast api version $frame_work_version in environment ${env_name}======"
        ($HOME/${env_name}/bin/pip install fastapi==$frame_work_version && $HOME/${env_name}/bin/pip install uvicorn)  
    else
        echo "${green_text}======Installing updated fastapi version in environment: ${env_name}======"
        ($HOME/${env_name}/bin/pip install fastapi && $HOME/${env_name}/bin/pip install uvicorn)   
    fi
}

function fastapi_project_setup(){
    echo "${green_text}======Setting up fastapi project ${project_name}======"
    (cd $HOME/${project_name} ; cp .files/fastapi_files/fast_api_routes.py api.py)

function create_database(){
    if ["$database" == mysql]
    then
        echo "${green_text}======Creating Mysql database======"
        mysql -u${mysql_user} -p${mysql_password} -e "create database ${project_name}"
    fi    

}

function export_bash_variables(){

    echo "${green_text}======Exporting path variables======"
    (source $HOME/${env_name}/bin/activate && export $project_name && export $database_name && export $mysql_user && export $mysql_password && export project_root_path="${HOME}/${project_name}" && export project_settings_path="${HOME}/${project_name}/${project_name}")
}

function create_docker_file(){
    (cd $HOME/${project_name} ; echo "FROM ubuntu:18.04" > Dockerfile)
}

function create_requirements_dot_txt_file(){
    (cd $HOME/${project_name} ; echo "pip3 freeze" > requirements.txt)
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
            ;;    
        fastapi)
            install_fastapi    
    esac
    }

main    
