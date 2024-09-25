#!/bin/zsh

############################################################################
# zsh script which offers interactive selection menu
#
# based on the answer by Guss on https://askubuntu.com/a/1386907/1771279

function choose_from_menu() {
    local prompt="$1" outvar="$2"
    shift
    shift
    # count had to be assigned the pure number of arguments
    local options=("$@") cur=1 count=$# index=0
    local esc=$(echo -en "\033") # cache ESC as test doesn't allow esc codes                                                                                                                                                                                                                                                                    
    # echo "\033[38;2;5;255;193m                                         “ÓÓÒ‹                                          "
    # echo "\033[38;2;0;245;197m                  Ý·                      ÓÓÓÓ˜                               ua        "
    # echo "\033[38;2;0;235;200m                  nÓŸ                     ÓÓÓÓ˜                            •ÓÓÓî        "
    # echo "\033[38;2;0;223;201m                   ÓÓÓv                   ÓÓÓÓ         ®                  cÓÓÓ£         "
    # echo "\033[38;2;0;212;202m                    ÓÓÓ;                  áÓÓÞ         ÓF                ;ÓÓÓO          "
    # echo "\033[38;2;0;201;200m                    jÓÓÒ                  \ÓÓå         ÓÓŸ               ÓÓÓ¥           "
    # echo "\033[38;2;0;190;198m                     ÓÓÓ³   3Ó£            ÓÓá         ÓÓÓÇ             áÓÓÓ            "
    # echo "\033[38;2;0;179;195m †Ó4•~            •‚ ºÓÓÓ  ;×9ÓÓ’          ÓÓá        üÓÓÓI            JÓÓÓ¦            "
    # echo "\033[38;2;0;169;192m   ÓÓÓÓÓÓÓü1†     0ÓÒ   ÓÝ ´üÓiÝZ          ÓÓÓÓÓÓáÓÓÓÓÓÓÓÓ* Ó\        ~ÓÓÓ†‚<=<¸        "
    # echo "\033[38;2;0;159;187m    [‡½üÓÓÓÓÓÓÓÓÓ¢ xÓÓZ5§Ó(¬ÿ+0Ó<          ÎÓÓ<   ÿÓJ å½ÎÓ‚ƒÓÓV       ÓÓÓ½=žn‡î’     ª™s"
    # echo "\033[38;2;0;148;183m         +9ÓÓÓÿÓÓO  ¥ÓáOPÓÓÓÓÓb “          ‹Ó9   ÓÓÓ´ “ÓÓ& ÓÓÓ°  /7¤ÇÓÓ<³vJö     •®ÓÓ*  "
    # echo "\033[38;2;0;138;178m              ÿÓ1    Óà      ÓÓÓ£   °ÓÓÓÓ   3   ÓÓÓ3  ÓÓÓÍ ÓÓÓ xÓÓÓÓÓÓÓÓÓÇ³  °ÓÓÓ&’     "
    # echo "\033[38;2;0;128;172m              ºÓ¥    ¬Óó     ÏÓÓb               ÓÓÿ    Ó’ áÓÓ´(ÓÓÓÒÓÓÓ÷   –ÓÓÓ{         "
    # echo "\033[38;2;0;118;168m           !(†IÓÓÓÓÓÓ‘±Ó      ÓÓÓÓÓÓÓÓå   °ÓÓZ  ÓÓ/      åÓÓ {ÓÓn  ÓÓu                  "
    # echo "\033[38;2;0;108;160m         CÓÓÓÓÓÓÓ¢            ¯Ó¥ ?ÓÓ÷ òÓÓÓ(    ÓÓ     …ÓÓ×·ÓÓÓ‹  ÓÓ                    "
    # echo "\033[38;2;0;98;150m         £Ý™~                   Ó¾ ×t            Ó     –ÓÓ+ÓÓû    Óá                     "
    # echo "\033[38;2;6;88;140m                                   ––            –    vÓc ò=     †                       "
    # echo "\033[38;2;24;78;129m                                                    I0                                  "
    echo -n "$prompt\n"
    # measure the rows of the menu, needed for erasing those rows when moving
    # the selection
    menu_rows=$#
    total_rows=$(($menu_rows + 1))
    while true
    do
        index=1 
        for o in "${options[@]}"
        do
            if [[ "$index" == "$cur" ]] 
            then echo -e " \033[38;2;5;255;193m\033[1m>\033[0m\033[38;2;0;169;192m\033[1m$o\033[0m" # mark & highlight the current option
            else echo "  $o" 
            fi
            index=$(( $index + 1 ))
        done
        printf "\n"
        # set mark for cursor
        printf "\033[s"
        # read in pressed key (differs from bash read syntax)
        read -s -r -k key
        if [[ $key == w ]] # move up
        then cur=$(( $cur - 1 ))
            [ "$cur" -lt 1 ] && cur=1 # make sure to not move out of selections scope
        elif [[ $key == s ]] # move down
        then cur=$(( $cur + 1 ))
            [ "$cur" -gt $count ] && cur=$count # make sure to not move out of selections scope
        elif [[ "${key}" == $'\n' || $key == '' ]] # zsh inserts newline, \n, for enter - ENTER
        then break
        fi
        # move back to saved cursor position
        printf "\033[u"
        # erase all lines of selections to build them again with new positioning
        for ((i = 0; i < $total_rows; i++)); do
            printf "\033[2k\r"
            printf "\033[F"
        done
    done
    # pass choosen selection to main body of script
    eval $outvar="'${options[$cur]}'"
}
# explicitly declare selections array makes it safer
declare -a selections
selections=(
# "Exit!"
"Teleport to Projects"
"Teleport to Python"
"Teleport to Algorithims"
"Teleport to Class Files"
"Teleport to Downloads"
"Teleport to Desktop"
"Exit!"
# "Git repo setup"
)

# call function with arguments: 
# $1: Prompt text. newline characters are possible
# $2: Name of variable which contains the selected choice
# $3: Pass all selections to the function
choose_from_menu "\033[38;2;255;143;252m\033[1mWhere would you like to go?\033[0m" selected_choice "${selections[@]}"


case $selected_choice in
    "Exit!") echo "\033[38;2;255;143;252m\033[1m Exiting!"; return;;
    "Teleport to Projects") echo "\033[38;2;255;143;252m\033[1mTeleporting to Projects directory!"; cd ~/Documents/Projects;;
    "Teleport to Python") echo "\033[38;2;255;143;252m\033[1mTeleporting to Python directory!"; cd ~/Documents/Projects/Python ;;
    "Teleport to Algorithims") echo "\033[38;2;255;143;252m\033[1mTeleporting to Algorithims directory!"; cd ~/Documents/Projects/Algorithims ;;
    "Teleport to Class Files") echo "\033[38;2;255;143;252m\033[1mTeleporting to your Class Files directory!"; cd ~/Documents/Projects/Random\ Class\ Files ;;
    "Teleport to Downloads") echo "\033[38;2;255;143;252m\033[1mTeleporting to your Downloads directory!"; cd ~/Downloads ;;
    "Teleport to Desktop") echo "\033[38;2;255;143;252m\033[1mTeleporting to Desktop directory!"; cd ~/Desktop ;;
esac

# echo "\033[38;2;255;143;252m\033[1mSelected choice: $selected_choice"
