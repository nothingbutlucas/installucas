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
DPKG_S="dpkg -s"
SLEEP="sleep 0.5"
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
    install-zsh
    install-nvim
    install-vim-plug
    install-ycm-conf-file
    install-ycm-requirements
    install-git-delta
    install-bat
    install-fzf
    install-lsd
    install-ranger
    install-nvim-plug
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
        echo -e "${CYAN_COLOUR}[ ~ ]El nvim ya existe, sigo con otra cosa${END_COLOUR}"
    fi
}

function install-vim-plug(){

    if [ ! -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then 
        
        echo -e "${YELLOW_COLOUR}[ ~ ]Voy a instalar vim-plug${END_COLOUR}"

        curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 

        echo -e "${GREEN_COLOUR}[ + ]Ya instale el vim-plug"
    else
        echo -e "${CYAN_COLOUR}[ ~ ]Plug-vim ya existe, sigo con otra cosa${END_COLOUR}"
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
        echo -e "${CYAN_COLOUR}[ ~ ]El archivo ${GLOBAL_EXTRA_CONF} ya existe, sigo con otra cosa${END_COLOUR}"
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
    
    tput civis
    banner
    make-installation
}

# Si el usuario es root se ejecuta la función anterior sin problema. Caso contrario, se ejecuta la función, pero se le hace un print diciendole que necesita ejecutar la herramienta como root

if [ "$(id -u)" == "0" ]; then
        
        echo -e "\n${RED_COLOUR}[!] Si ejecutas la herramienta como root, se va a instalar toda la paqueteria para tu usuario root..."
        echo -e "La instalacion comenzara en 10 segundos, podes cancelarla con Ctrl + c${END_COLOUR}"
        sleep 10
        main
        tput cnorm
        exit 0
else
        
        main
        tput cnorm
        exit 0 
fi

