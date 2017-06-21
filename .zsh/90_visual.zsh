# Change prompt depends on environments
color_end="%{[0m%}"
case ${UID} in
    # root
    0)
        PROMPT_USER="%{[38;5;196m%}%n${color_end}"
        ;;

    # other
    *)
        PROMPT_USER="%{[38;5;046m%}%n${color_end}"
        ;;

esac

if [ -n "${REMOTEHOST}${SSH_CONNECTION}" ]; then
    # remote connection
    PROMPT_PATH="%{[38;5;202m%}%m:%(5~,.../%3~,%~)${color_end}"
else
    # local
    PROMPT_PATH="%{[38;5;045m%}%m:%(5~,.../%3~,%~)${color_end}"
fi

PROMPT=$'\n'"${PROMPT_USER}@${PROMPT_PATH} > "
RPROMPT="%{[38;5;242m%}%y [%D{%m/%d} %*]${color_end}"
PROMPT2="%_%% "


