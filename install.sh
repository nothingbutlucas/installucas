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

NVIM="$HOME/.local/bin/nvim.appimage"
GLOBAL_EXTRA_CONF="$HOME/global_extra_conf.py"
YCM_REQUIREMENTS="build-essential cmake vim-nox python3-dev mono-complete golang nodejs default-jdk npm"
BAT="bat"
GIT_DELTA="git-delta"
DPKG_S="dpkg -s"
SLEEP="sleep 0.5"
FZF="fzf"
ZSH="$HOME/.zshrc"
trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${RED_COLOUR}[ X ] Cancelando instalación...\n${END_COLOUR}"
	tput cnorm
	exit 0
}

function banner(){

echo -e "${PURPLE_COLOUR}    ____              __          __ __                         ${END_COLOUR}"
echo -e "${PURPLE_COLOUR}   /  _/____   _____ / /_ ____ _ / // /__  __ _____ ____ _ _____${END_COLOUR}"
echo -e "${PURPLE_COLOUR}   / / / __ \ / ___// __// __  // // // / / // ___// __  // ___/${END_COLOUR}"
echo -e "${PURPLE_COLOUR} _/ / / / / /(__  )/ /_ / /_/ // // // /_/ // /__ / /_/ /(__  ) ${END_COLOUR}"
echo -e "${PURPLE_COLOUR}/___//_/ /_//____/ \__/ \__,_//_//_/ \__,_/ \___/ \__,_//____/  ${END_COLOUR}"

echo -e "\n"
echo -e "${PURPLE_COLOUR}made by nothingbutlucas - 2022${END_COLOUR}\n"
sleep 1 
}


function make-installation(){
echo -e "${YELLOW_COLOUR}[ ~ ]Vamos a instalar las cosas...${END_COLOUR}"
${SLEEP}

if [ ! -f "$ZSH"]; then

    echo -e "${YELLOW_COLOUR}[ ~ ]Voy a instalar la zsh${END_COLOUR}"
    

if [ ! -f "$NVIM" ]; then
        
    echo -e "${YELLOW_COLOUR}[ ~ ]Voy a instalar el nvim${END_COLOUR}"
    ${SLEEP}
    mkdir -p "/home/$USER/.local/bin"

    curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage && chmod u+x nvim.appimage && mv nvim.appimage ~/.local/bin"

    echo -e "${GREEN_COLOUR}[ + ]Ya instale el nvim${END_COLOUR}"

else
    echo -e "${CYAN_COLOUR}[ ~ ]El archivo $NVIM ya existe, sigo con otra cosa${END_COLOUR}"
fi
if [ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then 
    
    echo -e "${YELLOW_COLOUR}[ ~ ]Voy a instalar vim-plug${END_COLOUR}"

    curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 

    echo -e "${GREEN_COLOUR}[ + ]Ya instale el vim-plug"
else
    echo -e "${CYAN_COLOUR}[ ~ ]Plug-vim ya existe, sigo con otra cosa${END_COLOUR}"
fi


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

dpkg -s ${BAT} &> /dev/null

if [ $? -ne 0 ]; then

    echo -e "${YELLOW_COLOUR}[ ~ ]Voy a instalar el ${BAT}${END_COLOUR}"
    curl -LO "https://github.com/sharkdp/bat/releases/download/v0.19.0/bat_0.19.0_amd64.deb"
    sudo dpkg -i "bat_0.19.0_amd64.deb"
    dpkg -s ${BAT} &> /dev/null 
    if [ $? -ne 0 ]; then

        echo -e ${RED_COLOUR}[ - ]No pude instalar ${BAT}, intentalo manualmente:\n${END_COLOUR}
        echo -e "curl -LO https://github.com/sharkdp/bat/releases/download/v0.19.0/bat_0.19.0_amd64.deb"
        echo -e "sudo dpkg -i bat_0.19.0_amd64.deb"
        rm "bat_0.19.0_amd64.deb"  
    else
        echo -e "${GREEN_COLOUR}[ + ]El ${BAT} esta instalado${END_COLOUR}"
    fi
else
    echo -e "${CYAN_COLOUR}[ ~ ]El ${BAT} ya esta instalado${END_COLOUR}"
fi

dpkg -s git-delta &> /dev/null

if [ $? -ne 0 ]; then

    echo -e "${YELLOW_COLOUR}[ ~ ]Voy a instalar el ${GIT_DELTA}${END_COLOUR}"
    curl -LO "https://github.com/dandavison/delta/releases/download/0.11.3/git-delta_0.11.3_amd64.deb"
    sudo dpkg -i git-delta_0.11.3_amd64.deb
    dpkg -s git-delta &> /dev/null
    
    if [ $? -ne 0 ]; then

        echo -e "${RED_COLOUR}[ - ]No pude instalar ${GIT_DELTA}, intentalo manualmente:\n${END_COLOUR}"
        echo -e "curl -LO https://github.com/dandavison/delta/releases/download/0.11.3/git-delta_0.11.3_amd64.deb"
        echo -e "dpkg -i git-delta_0.11.3_amd64.deb"
        rm "git-delta_0.11.3_amd64.deb"
    else
        echo -e "${GREEN_COLOUR}[ + ]El git-delta esta instalado${END_COLOUR}"
    fi
else
    echo -e "${CYAN_COLOUR}[ ~ ]El git-delta ya esta instalado${END_COLOUR}"
fi

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
    echo -e "${CYAN_COLOUR}[ ~ ]El fzf ya esta instalado"
fi
}

function install_nvim_plug(){

echo -e "${YELLOW_COLOUR}[ ~ ]Vamos a instalar los plugs de nvim${END_COLOUR}"

${NVIM} +:pluginstall +:pluginstall +:pluginstall +:q! +:q!

echo -e "${GREEN_COLOUR}[ + ]Ya instale los plugs de nvim${END_COLOUR}"
}

function main(){
    banner
    make-installation
    install_nvim_plug
}

# Si el usuario es root se ejecuta la función anterior sin problema. Caso contrario, se ejecuta la función, pero se le hace un print diciendole que necesita ejecutar la herramienta como root

if [ "$(id -u)" == "0" ]; then
	echo -e "\n${RED_COLOUR}[!] Si ejecutas la herramienta como root, se va a instalar toda la paqueteria para tu usuario root..."
    echo -e "La instalacion comenzara en 10 segundos, podes cancelarla con Ctrl + c${END_COLOUR}"
    sleep 10
    tput civis
    main
    tput cnorm
    exit 0
else
    main
    tput cnorm
    exit 0 
fi

