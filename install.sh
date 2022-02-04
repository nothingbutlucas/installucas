#!bin/bash

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

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${RED_COLOUR}[ X ] Cancelando instalación...\n${END_COLOUR}"
	tput cnorm
	exit 0
}

function banner(){

echo -e "${PURPLE_COLOUR}██ ███    ██ ███████ ████████  █████  ██      ██      ██    ██  ██████  █████  ███████ ${END_COLOUR}"
echo -e "${PURPLE_COLOUR}██ ████   ██ ██         ██    ██   ██ ██      ██      ██    ██ ██      ██   ██ ██      ${END_COLOUR}"
echo -e "${PURPLE_COLOUR}██ ██ ██  ██ ███████    ██    ███████ ██      ██      ██    ██ ██      ███████ ███████ ${END_COLOUR}"
echo -e "${PURPLE_COLOUR}██ ██  ██ ██      ██    ██    ██   ██ ██      ██      ██    ██ ██      ██   ██      ██ ${END_COLOUR}"
echo -e "${PURPLE_COLOUR}██ ██   ████ ███████    ██    ██   ██ ███████ ███████  ██████   ██████ ██   ██ ███████ ${END_COLOUR}"
echo -e "\n"
echo -e "${GRAY_COLOUR}made by nothingbutlucas\n\n - 2022${END_COLOUR}"
}


function make-installation(){
echo -e "${YELLOW_COLOUR}Vamos a instalar las cosas...${END_COLOUR}"

if [! -f "$NVIM" ]; then
        
    echo -e "${YELLOW_COLOUR}Voy a instalar el nvim${END_COLOUR}"

    mkdir -p "$HOME/.local/bin"

    curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage && chmod u+x nvim.appimage" && mv "nvim.appimage ~/.local/bin "

    echo -e "${GREEN_COLOUR}Ya instale el nvim${END_COLOUR}"

else
    echo -e "${CYAN_COLOUR}El archivo $NVIM ya existe, sigo con otra cosa${END_COLOUR}"
fi
if [! -d "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim ]; then 
    
    echo -e "${YELLOW_COLOUR}Voy a instalar vim-plug${END_COLOUR}"

    curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
    echo -e "${CYAN_COLOUR}Plug-vim ya existe, sigo con otra cosa${END_COLOUR}"
fi
echo -e "${YELLOW_COLOUR}Vamos a instalar los plugs de nvim${END_COLOUR}"

${NVIM} +:PlugInstall +:PlugInstall +:PlugInstall +:q! +:q!

if [! -f "${GLOBAL_EXTRA_CONF}" ]; then

    echo -e "${PURPLE_COLOUR}Ahora voy a crear el archivo ${GLOBAL_EXTRA_CONF} para poder executar el ycm${END_COLOUR}"

    echo "def settings( **kwargs ):
      client_data = kwargs[ 'client_data' ]
      return {
        'interpreter_path': client_data[ 'g:ycm_python_interpreter_path' ],
        'sys_path': client_data[ 'g:ycm_python_sys_path' ]
      }" >> ${GLOBAL_EXTRA_CONF} 
    
    echo -e "${GREEN_COLOUR}Ya cree el archivo ${GLOBAL_EXTRA_CONF}${END_COLOUR}"

else

    echo -e "${CYAN_COLOUR}El archivo ${GLOBAL_EXTRA_CONF} ya existe${END_COLOUR}"
fi

echo -e "${YELLOW_COLOUR}Voy a instalar la paqueteria necesaria para el YCM${END_COLOUR}"

while [ "dpkg -s "${YCM_REQUIREMENTS}"" ] && [ "echo "$?" -ne 0" ]
do
    sudo apt install "${YCM_REQUIREMENTS}"
done

while [ "dpkg -s "${BAT}"" ] && [ "echo "$?" -ne 0"]
do
    echo -e "${YELLOW_COLOUR}Voy a instalar el ${BAT}${END_COLOUR}"
    curl "-LO https://github.com/sharkdp/bat/releases/download/v0.19.0/bat_0.19.0_amd64.deb"
    sudo "dpkg -i bat_0.19.0_amd64.deb"
done

rm "bat_0.19.0_amd64.deb"  

while [ "dpkg -s "${GIT_DELTA}""] && [ "echo "$?" -ne 0 "]
do
    echo -e "${YELLOW_COLOUR}Voy a instalar el ${GIT_DELTA}${END_COLOUR}"
    curl "-LO https://github.com/dandavison/delta/releases/download/0.11.3/git-delta_0.11.3_amd64.deb"
    sudo "dpkg -i git-delta_0.11.3_amd64.deb"
done

rm "git-delta_0.11.3_amd64.deb"
}

# Si el usuario es root se ejecuta la función anterior sin problema. Caso contrario, se ejecuta la función, pero se le hace un print diciendole que necesita ejecutar la herramienta como root

if [ "$(id -u)" == "0" ]; then
	tput civis
	make-installation

else
	echo -e "\n${RED_COLOUR}[!] Necesitas la herramienta como root para poder instalar las bibliotecas!${END_COLOUR}"
	sleep 1800
fi
