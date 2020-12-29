#!/bin/bash

# text colors
red_text=`tput setaf 1`
green_text=`tput setaf 2`
blue_text=`tput setaf 4`

# credentials
mysql_user="root"
mysql_password="root"

# helper description which will give instructions to run the script
function usage_instruction(){
    echo "bash shurikens.sh -f <framework_name> -p <project_name> -d <database_name>"
    echo "database options are mysql, postgresql, mongodb make sure give the same name after -d" 
    }

while getopts ":f:fv:p:d:" arg; do
    case $arg in
        f) frame_work=$OPTARG;;
        p) project_name=$OPTARG;;
        d) database=$OPTARG;;
        0) orm=$OPTARG;;
        fv) frame_work_version=$OPTARG;;
    esac
done

environment_variable="env"
env_name="${project_name}${environment_variable}"
project_root_path="${HOME}/${project_name}"
project_settings_path="${project_root_path}/${project_name}" 

echo "${project_settings_path}"

# function to create virtualenvironment
function create_virtualenvironment(){
    echo "${blue_text}creating virtual environment $env_name"
    (cd $HOME ; virtualenv -p python3 ${env_name})
}

# function to install django	
function install_django(){
    if [ ! -z "$frame_work_version" ]
    then
        echo "${blue_text}======Installing django version $frame_work_version in environment ${env_name}======"
        $HOME/${env_name}/bin/pip install django==$frame_work_version
    else
        echo "${blue_text}======Installing updated django version in environment: ${env_name}======"
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

# function to create django project
function create_django_project(){
    echo "${blue_text}======Creating django project ${project_name}======" 
    (cd $HOME ; django-admin.py startproject ${project_name})   
}

# function to create django project setup
function django_project_setup(){
    echo "${blue_text}======Setting up django project ${project_name}======"
    (cd $HOME/${project_name} ; mkdir templates && mkdir static)
    (cd $HOME/${project_name}/static ; mkdir js && mkdir img && mkdir css)
    
    echo "${blue_text}======Changing templates Settings for ${project_name}======"
    chmod 755 ./files/django_files/django_settings_template_tweaker.py
    (source $HOME/${env_name}/bin/activate && $HOME/${env_name}/bin/python3 ./files/django_files/django_settings_template_tweaker.py) 
    sleep 5

    echo "${blue_text}======Changing database Settings for ${project_name}======"
    chmod 755 ./files/django_files/django_settings_database_tweaker.py
    (source $HOME/${env_name}/bin/activate && $HOME/${env_name}/bin/python3 ./files/django_files/django_settings_database_tweaker.py)
    sleep 5
}

# function to do databasee migrations for django
function django_database_migrate(){
    (chmod 755 $HOME/${project_name}/manage.py makemigrations && chmod 755 $HOME/${project_name}/manage.py migrate)
}

# function to install flask
function install_flask(){
    if [ ! -z "$frame_work_version" ]
    then
        echo "${blue_text}======Installing flask version ${frame_work_version} in environment ${env_name}======"
        $HOME/${env_name}/bin/pip install flask==$frame_work_version
    else
        echo "${blue_text}======Installing updated flask version in environment: ${env_name}======"
        $HOME/${env_name}/bin/pip install flask    
    fi
    
}

# list of supporting packages needed for a typical flask project
function install_flask_support_packages(){
    #sql alchemy 	
    echo "${blue_text}======Installing sql alchemy======"
    ($HOME/${env_name}/bin/pip install Flask-SQLAlchemy)
    # flask migrate
    echo "${blue_text}======Installing flask migrate======"
    ($HOME/${env_name}/bin/pip install Flask-Migrate)

    case $database in
        mysql)
            echo "${blue_text}======Installing flask mysql======"
            ($HOME/${env_name}/bin/pip install flask-mysql)
            ;;
        postgresql)
            echo "${blue_text}======Installing flask postgresql======"
            ($HOME/${env_name}/bin/pip install psycopg2)
            ;;    
        mongodb)
            echo "${blue_text}======Installing flask pymongo======"
            ($HOME/${env_name}/bin/pip install Flask-PyMongo)    
    esac

}

# function to create flask project
function create_flask_project(){
    echo "${blue_text}======Creating flask project ${project_name}======" 
    (cd $HOME ; mkdir ${project_name})   
}

# function to create flask project setup
function flask_project_setup(){
    echo "${blue_text}======Setting up flask project ${project_name}======"
    cp $PWD/files/flask_files/flask_function_routes.py $HOME/${project_name}/api.py
    echo "${blue_text}======Setting up models boilerplate file for ${project_name}======"
    cp $PWD/files/flask_files/models.py $HOME/${project_name}/models.py
    echo "${blue_text}======Setting up configuration for ${project_name}======"
    cp $PWD/files/flask_files/configuration.py $HOME/${project_name}/configuration.py
    echo "${blue_text}======Setting up errorhandler boilerplate for ${project_name}======"
    cp $PWD/files/flask_files/error_handlers.py $HOME/${project_name}/error_handlers.py
}

function install_fastapi(){
    if [ ! -z "$frame_work_version" ]
    then
        echo "${blue_text}======Installing fast api version $frame_work_version in environment ${env_name}======"
        ($HOME/${env_name}/bin/pip install fastapi==$frame_work_version && $HOME/${env_name}/bin/pip install uvicorn)  
    else
        echo "${blue_text}======Installing updated fastapi version in environment: ${env_name}======"
        ($HOME/${env_name}/bin/pip install fastapi && $HOME/${env_name}/bin/pip install uvicorn)   
    fi
}

function fastapi_project_setup(){
    echo "${blue_text}======Setting up fastapi project ${project_name}======"
    (cd $HOME/${project_name} ; cp .files/fastapi_files/fast_api_routes.py api.py)
    echo "${blue_text}======Setting up models boilerblate file for ${project_name}======"
    (cd $HOME/${project_name} ; cp ./files/flask_files/models.py models.py)
}

function create_database(){
    if ["$database" == mysql]
    then
        echo "${blue_text}======Creating Mysql database======"
        mysql -u${mysql_user} -p${mysql_password} -e "create database ${project_name}"
    fi    
}

function generic_supporting_packages(){
    # locust for load testing
    echo "${blue_text}======Installing locust======"
    ($HOME/${env_name}/bin/pip install locust)
}

function export_bash_variables(){

    echo "${blue_text}======Exporting path variables======"
    (source $HOME/${env_name}/bin/activate && export $project_name && export $database_name && export $mysql_user && export $mysql_password && export project_root_path="${HOME}/${project_name}" && export project_settings_path="${HOME}/${project_name}/${project_name}")
}

function create_docker_file_and_compose_file(){
    echo "${blue_text}======Creating docker file======"
    cp $PWD/files/Dockerfile $HOME/${project_name}/Dockerfile
    echo "${blue_text}======Creating docker-compose file======"
    cp $PWD/files/Dockerfile $HOME/${project_name}/docker-compose.yaml
}

function create_requirements_dot_txt_file(){
    (cd $HOME/${project_name} ; echo "pip3 freeze" > requirements.txt)
}

function create_helper_bash_scripts(){
    cp $PWD/files/flask_files/helper-bash-scripts $HOME/${project_name}/
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
            create_django_project
            django_project_setup
            create_database
            django_database_migrate
            generic_supporting_packages
            ;;
        flask)
            install_flask
            create_flask_project
            flask_project_setup
            install_flask_support_packages
            generic_supporting_packages
            create_requirements_dot_txt_file
            create_docker_file
            ;;    
        fastapi)
            install_fastapi    
            generic_supporting_packages
    esac
    }

main    
