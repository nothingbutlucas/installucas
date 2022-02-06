#!/bin/bash

# COLORS

GREEN_COLOUR="\e[0;32m\033[1m"
END_COLOUR="\033[0m\e[0m"
RED_COLOUR="\e[0;31m\033[1m"
BLUE_COLOUR="\e[0;34m\033[1m"
YELLOW_COLOUR="\e[0;33m\033[1m"
PURPLE_COLOUR="\e[0;35m\033[1m"
CYAN_COLOUR="\e[0;36m\033[1m"
GRAY_COLOUR="\e[0;37m\033[1m"

# CONSTANTES

NVIM="$HOME/.local/bin/nvim.appimage"
GLOBAL_EXTRA_CONF="$HOME/global_extra_conf.py"
YCM_REQUIREMENTS="build-essential cmake vim-nox python3-dev mono-complete golang nodejs default-jdk npm"
DPKG_S="dpkg -s"
SLEEP="sleep 0.1"
LITTLE_SLEEP="sleep 0.05"
ZSH="$HOME/.zshrc"
TERMINAL_COLS="$(tput cols)"
TERMINAL_ROWS="$(tput lines)"


trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${RED_COLOUR}[ X ] Cancelando instalación...\n${END_COLOUR}"
    tput rmcup
    tput cnorm
	exit 0
}

# print-centered function provided by TrinityCoder
# https://gist.github.com/TrinityCoder/911059c83e5f7a351b785921cf7ecdaa

function print-centered {
     [[ $# == 0 ]] && return 1

     declare -i TERM_COLS="$(tput cols)"
     declare -i str_len="${#1}"
     [[ $str_len -ge $TERM_COLS ]] && {
          echo "$1";
          return 0;
     }

     declare -i filler_len="$(( (TERM_COLS - str_len) / 2 ))"
     [[ $# -ge 2 ]] && ch="${2:0:1}" || ch=" "
     filler=""
     for (( i = 0; i < filler_len; i++ )); do
          filler="${filler}${ch}"
     done

     printf "%s%s%s" "$filler" "$1" "$filler"
     [[ $(( (TERM_COLS - str_len) % 2 )) -ne 0 ]] && printf "%s" "${ch}"
     printf "\n"

     return 0
}

function banner(){
    tput civis
    echo -e "${PURPLE_COLOUR}"
    if [ $TERMINAL_COLS -ge 87 ]; then
        print-centered "██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ██╗   ██╗ ██████╗ █████╗ ███████╗"
        ${LITTLE_SLEEP}
        print-centered "██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██║   ██║██╔════╝██╔══██╗██╔════╝"
        ${LITTLE_SLEEP}
        print-centered "██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     ██║   ██║██║     ███████║███████╗"
        ${LITTLE_SLEEP}
        print-centered "██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██║   ██║██║     ██╔══██║╚════██║"
        ${LITTLE_SLEEP}
        print-centered "██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗╚██████╔╝╚██████╗██║  ██║███████║"
        ${LITTLE_SLEEP}
        print-centered "╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝"

    elif [ $TERMINAL_COLS -ge 64 ]; then
        print-centered "    ____              __          __ __                         "
        ${LITTLE_SLEEP}
        print-centered "   /  _/____   _____ / /_ ____ _ / // /__  __ _____ ____ _ _____"
        ${LITTLE_SLEEP}
        print-centered "   / / / __ \ / ___// __// __  // // // / / // ___// __  // ___/"
        ${LITTLE_SLEEP}
        print-centered " _/ / / / / /(__  )/ /_ / /_/ // // // /_/ // /__ / /_/ /(__  ) "
        ${LITTLE_SLEEP}
        print-centered "/___//_/ /_//____/ \__/ \__,_//_//_/ \__,_/ \___/ \__,_//____/  " 

    elif [ $TERMINAL_COLS -ge 26 ]; then
        print-centered "                          "
        ${LITTLE_SLEEP}
        print-centered " ._   __/__  //   _  _   _"
        ${LITTLE_SLEEP}
        print-centered "// /_\ / /_|///_//_ /_|_\ "
        ${LITTLE_SLEEP}
        print-centered "                          "
    else
        print-centered "installucas"
    fi
    echo -e "\n"
    print-centered "made by nothingbutlucas - 2022"
    echo -e "${END_COLOUR}\n"
    sleep 1 
}

function loading-time(){
    for i in {20..1}
        do
            tput cup 7 0
            
            print-centered "El script va a empezar a correr en $i segundos "

            sleep 1
        done
}

function disclaimer(){
    
    tput civis
    echo -e "${RED_COLOUR}"
    print-centered "[ ! ] ADVERTENCIA [ ! ]"
    print-centered "Este script esta en version de prueba"
    print-centered "Te recomiendo que le tires un cat y leas lo que hace antes de ejecutarlo"
    print-centered "Esta pensado para ejecutarse en un sistema con Ubuntu 20.4 lts, por lo que puede que algunos paquetes y sus versiones no sean las indicadas para TU sistema"
    print-centered "Fijate que onda (Para skipear este mensaje agrega la flag -q)"
    loading-time
    tput rmcup
    clear
}

function make-installation(){

    echo -e "${YELLOW_COLOUR}[ ~ ]Vamos a instalar las cosas...${END_COLOUR}"
    sleep 1
    install-zsh
    ${SLEEP}
    install-nvim
    ${SLEEP}
    install-vim-plug
    ${SLEEP}
    install-ycm-conf-file
    ${SLEEP}
    install-ycm-requirements
    ${SLEEP}
    install-git-delta
    ${SLEEP}
    install-bat
    ${SLEEP}
    install-fzf
    ${SLEEP}
    install-lsd
    ${SLEEP}
    install-ranger
    ${SLEEP}
    install-nvim-plug
    ${SLEEP}
}

function install-zsh(){

    if [ ! -f "${ZSH}" ]; then

        echo -e "${YELLOW_COLOUR}[ ~ ]Voy a instalar la zsh${END_COLOUR}"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
        echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

        if [ ! -f "${ZSH}" ]; then
        
            echo -e "${GREEN_COLOUR}[ + ]Ya instale la zsh${END_COLOUR}"
            echo -e "${YELLOW_COLOUR}[ ~ ]Ahora voy a necesitar acceso root para crear el enlace simbolico del zshrc para el user root"
            sudo ln -s ~/.zshrc /root/.zshrc
        else

            echo -e "${RED_COLOUR}[ - ]No pude instalar la zsh, proba de hacerlo manualmente:\n"
            echo -e "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k"
            echo -e "echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc"
        fi
    else
        
        echo -e "${CYAN_COLOUR}[ ~ ]La zsh ya esta instalada"
    fi

}

function install-nvim(){

    if [ ! -f "$NVIM" ]; then
            
        echo -e "${YELLOW_COLOUR}[ ~ ]Voy a instalar el nvim${END_COLOUR}"
        ${SLEEP}
        mkdir -p "/home/$USER/.local/bin"

        curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage && chmod u+x nvim.appimage && mv nvim.appimage ~/.local/bin"

        echo -e "${GREEN_COLOUR}[ + ]Ya instale el nvim${END_COLOUR}"

    else
        echo -e "${CYAN_COLOUR}[ ~ ]El nvim ya esta instalado${END_COLOUR}"
    fi
}

function install-vim-plug(){

    if [ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then 
        
        echo -e "${YELLOW_COLOUR}[ ~ ]Voy a instalar vim-plug${END_COLOUR}"

        curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 

        echo -e "${GREEN_COLOUR}[ + ]Ya instale el vim-plug"
    else
        echo -e "${CYAN_COLOUR}[ ~ ]Plug-vim ya esta instalado${END_COLOUR}"
    fi
}

function install-ycm-conf-file(){

    if [ ! -f "${GLOBAL_EXTRA_CONF}" ]; then

        echo -e "${PURPLE_COLOUR}[ ~ ]Ahora voy a crear el archivo ${GLOBAL_EXTRA_CONF} para poder executar el ycm${END_COLOUR}"

        echo "def settings( **kwargs ):
          client_data = kwargs[ 'client_data' ]
          return {
            'interpreter_path': client_data[ 'g:ycm_python_interpreter_path' ],
            'sys_path': client_data[ 'g:ycm_python_sys_path' ]
          }" >> ${GLOBAL_EXTRA_CONF} 
        
        echo -e "${GREEN_COLOUR}[ + ]Ya cree el archivo ${GLOBAL_EXTRA_CONF}${END_COLOUR}"

    else
        echo -e "${CYAN_COLOUR}[ ~ ]El archivo ${GLOBAL_EXTRA_CONF} ya existe${END_COLOUR}"
    fi
}

function install-ycm-requirements(){

    dpkg -s ${YCM_REQUIREMENTS} &> /dev/null

    if [ $? -ne 0 ]; then
        echo -e "${YELLOW_COLOUR}[ ~ ]Voy a instalar la paqueteria necesaria para el YCM${END_COLOUR}"
        sudo apt install ${YCM_REQUIREMENTS} -y
        dpkg -s ${YCM_REQUIREMENTS} &> /dev/null

        if [ $? -ne 0 ]; then
            echo -e ${RED_COLOUR}[ - ]No pude instalar la paqueteria de YCM.Intentalo manualmente:\n${END_COLOUR}
            echo -e "sudo apt install ${YCM_REQUIREMENTS}"
        else
            echo -e "${GREEN_COLOUR}[ + ]La paqueteria para el YCM esta instalada ${END_COLOUR}"
        fi
    else
        echo -e "${CYAN_COLOUR}[ ~ ]La paqueteria para el YCM ya esta instalada${END_COLOUR}"
    fi
}

function install-bat(){

    dpkg -s bat &> /dev/null
    
    if [ $? -ne 0 ]; then
        echo -e "${YELLOW_COLOUR}[ ~ ]Voy a instalar el bat${END_COLOUR}"
        curl -LO "https://github.com/sharkdp/bat/releases/download/v0.19.0/bat_0.19.0_amd64.deb"
        sudo dpkg -i "bat_0.19.0_amd64.deb"
        dpkg -s bat &> /dev/null 

        if [ $? -ne 0 ]; then
            echo -e ${RED_COLOUR}[ - ]No pude instalar bat, intentalo manualmente:\n${END_COLOUR}
            echo -e "curl -LO https://github.com/sharkdp/bat/releases/download/v0.19.0/bat_0.19.0_amd64.deb"
            echo -e "sudo dpkg -i bat_0.19.0_amd64.deb"
            rm "bat_0.19.0_amd64.deb"  
        else
            echo -e "${GREEN_COLOUR}[ + ]El bat esta instalado${END_COLOUR}"
        fi
    else
        echo -e "${CYAN_COLOUR}[ ~ ]El bat ya esta instalado${END_COLOUR}"
    fi
}

function install-git-delta(){

    dpkg -s git-delta &> /dev/null

    if [ $? -ne 0 ]; then
        echo -e "${YELLOW_COLOUR}[ ~ ]Voy a instalar el git-delta${END_COLOUR}"
        curl -LO "https://github.com/dandavison/delta/releases/download/0.11.3/git-delta_0.11.3_amd64.deb"
        sudo dpkg -i git-delta_0.11.3_amd64.deb
        dpkg -s git-delta &> /dev/null
        
        if [ $? -ne 0 ]; then
            echo -e "${RED_COLOUR}[ - ]No pude instalar git-delta, intentalo manualmente:\n${END_COLOUR}"
            echo -e "curl -LO https://github.com/dandavison/delta/releases/download/0.11.3/git-delta_0.11.3_amd64.deb"
            echo -e "dpkg -i git-delta_0.11.3_amd64.deb"
            rm "git-delta_0.11.3_amd64.deb"
        else
            echo -e "${GREEN_COLOUR}[ + ]El git-delta esta instalado${END_COLOUR}"
        fi
    else
        echo -e "${CYAN_COLOUR}[ ~ ]El git-delta ya esta instalado${END_COLOUR}"
    fi
}

function install-fzf(){

    dpkg -s fzf &> /dev/null

    if [ $? -ne 0 ]; then
        echo -e "${YELLOW_COLOUR}[ ~ ]Voy a instalar fzf${END_COLOUR}"
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
        dpkg -s fzf &> /dev/null
        
        if [ $? -ne 0 ]; then
            echo -e "${RED_COLOUR}[ - ]No pude instalar el fzf, intentalo manualmente:\n${END_COLOUR}"
            echo -e "git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf" 
            echo -e "~/.fzf/install"
        
        else
            echo -e "${GREEN_COLOUR}[ + ]El fzf esta instalado${END_COLOUR}"
        fi
    else
        echo -e "${CYAN_COLOUR}[ ~ ]El fzf ya esta instalado${END_COLOUR}"
    fi
}

function install-lsd(){

    dpkg -s lsd &> /dev/null

    if [ $? -ne 0 ]; then
        echo -e "${YELLOW_COLOUR}[ ~ ]Voy a instalar lsd${END_COLOUR}"
        curl -LO https://github.com/Peltoche/lsd/releases/download/0.21.0/lsd_0.21.0_amd64.deb 
        dpkg -i lsd_0.21.0_amd64.deb
        rm lsd_0.21.0_amd64.deb
        
        dpkg -s lsd &> /dev/null
        if [ $? -ne 0 ]; then
            echo -e "${RED_COLOUR}[ - ]No pude instalar el lsd, intentalo manualmente:\n${END_COLOUR}"
            echo -e "curl -LO https://github.com/Peltoche/lsd/releases/download/0.21.0/lsd_0.21.0_amd64.deb"
            echo -e "dpkg -i lsd_0.21.0_amd64.deb"

        else
            echo -e "${GREEN_COLOUR}[ + ]El lsd esta instalado${END_COLOUR}"
        fi
    else
        echo -e "${CYAN_COLOUR}[ ~ ]El lsd ya esta instalado${END_COLOUR}"
    fi
}

function install-ranger(){

    dpkg -s ranger &> /dev/null

    if [ $? -ne 0 ]; then
        echo -e "${YELLOW_COLOUR}[ ~ ]Voy a instalar ranger${END_COLOUR}"
        sudo apt install ranger
        dpkg -s ranger &> /dev/null

        if [ $? -ne 0 ]; then
            echo -e "${RED_COLOUR}[ - ]No pude instalar el ranger, intentalo manualmente:\n${END_COLOUR}"
            echo -e "sudo apt install ranger"
        else
            echo -e "${GREEN_COLOUR}[ + ]El ranger esta instalado${END_COLOUR}"
        fi
    else
        echo -e "${CYAN_COLOUR}[ ~ ]El ranger ya esta instalado${END_COLOUR}"
    fi
}

function install-nvim-plug(){

    echo -e "${YELLOW_COLOUR}[ ~ ]Vamos a instalar los plugs de nvim${END_COLOUR}"

    ${NVIM} +:PlugInstall +:PlugInstall +:PlugInstall +:PlugUpdate +:q! +:q!

    echo -e "${GREEN_COLOUR}[ + ]Ya instale los plugs de nvim${END_COLOUR}"
}

function main(){
    banner
    make-installation
    exit-program
}

function exit-program(){
    tput cnorm
    exit 0
}

# Main Program Logic

quiet='false'
while getopts q flag
do
    case "${flag}" in
        q) quiet='true' ;;
        *) error "Unexpected option ${flag}" ;;
    esac
done
if [[ $quiet = 'false' ]];then
    disclaimer
fi 

if [ "$(id -u)" == "0" ]; then       
        echo -e "${RED_COLOUR}"
        print-centered "\n[!] Si ejecutas la herramienta como root, se va a instalar toda la paqueteria para tu usuario root..."
        print-centered "La instalacion comenzara en 10 segundos, podes cancelarla con Ctrl + c"
        echo -e "${END_COLOUR}"
        sleep 10
        main
else 
    main
fi

