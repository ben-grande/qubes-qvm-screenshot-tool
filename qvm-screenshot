#!/bin/bash

# Take screenshot in Qubes Dom0, auto copy to AppVM, upload to imgurl service

# Copyright (C) 2017-2020 EvaDogStar <evastar@protonmail.com>

program="$(basename "$0")"
version="@VERSION@"
DOM0_SHOTS_DIR=$HOME/Pictures
# get the Pictures path in the VM
APPVM_SHOTS_DIR="\$(xdg-user-dir PICTURES)"
# get home dir in the VM
IMGURL_LOG="\$HOME/imgurl.log"
LAST_ACTION_LOG_CONFIG="$HOME/.config/qvm-screenshot-lastaction.cfg"

rightdom0dir=$(xdg-user-dir PICTURES)
if [[ "$rightdom0dir" =~ ^/home/user* ]]; then
    DOM0_SHOTS_DIR=$rightdom0dir
fi

TEMPEDITORFILE="$DOM0_SHOTS_DIR/0000-SAVE-EDITED-SHOT-HERE-TO-PROCESS.png"

UPLOADHELPER=$(cat <<'EOFFILE'
#!/bin/bash
# Eva Dog Star imgurl uploader
imgur_anon_id="ea6c0ef2987808e"
# check arguments
if [ $# == 0 ]; then
    echo "[ERROR] No file specified" >&2
    exit 16
fi
    # check curl is available
    type curl >/dev/null 2>/dev/null || {
    echo "[ERROR] Couln't find curl, which is required at AppVM." >&2
    exit 17
}
file="$1"
logfile="$2"
# check file exists
if [ ! -f "$file" ]; then
    echo "[ERROR] file '$file' doesn't exist at AppVM" >&2
    exit 18
fi
response="$(curl --compressed --connect-timeout "7" -m "250" --retry "1" -fsSL --stderr - -H "Authorization: Client-ID ${imgur_anon_id}" -F "image=@$file" https://api.imgur.com/3/image)"
if egrep -q '"success":\s*true' <<<"${response}"; then
    img_id="$(egrep -o '"id":\s*"[^"]+"' <<<"${response}" | cut -d "\"" -f 4)"
    img_ext="$(egrep -o '"link":\s*"[^"]+"' <<<"${response}" | cut -d "\"" -f 4 | rev | cut -d "." -f 1 | rev)" # "link" itself has ugly '\/' escaping and no https!
    del_id="$(egrep -o '"deletehash":\s*"[^"]+"' <<<"${response}" | cut -d "\"" -f 4)"
    imgurl="https://i.imgur.com/${img_id}.${img_ext}"
    imgdeleteurl="https://imgur.com/delete/${del_id}"
    echo -e "Image url:\n$imgurl\n\nDelete image url: \n$imgdeleteurl\n\n \nQubes Screenshot Tool - EvaDogStar 2016" > $logfile
    echo "[success] imgurl: $imgurl" >&2
    echo "[success] delete url: $imgdeleteurl" >&2
else # upload failed
    err_msg="$(egrep -o '"error":\s*"[^"]+"' <<<"${response}" | cut -d "\"" -f 4)"
    test -z "${err_msg}" && err_msg="${response}"
    echo "[ERROR] $err_msg"
    echo "[RESPONSE] $response"
    echo -e "Error: \n\n$err_msg \n\nImgurl Server response: \n\n$response\n\n\n \nQubes Screenshot Tool - EvaDogStar 2016" > $logfile
    #echo ${err_msg}
fi
(which xclip &>/dev/null && echo -n "$imgurl" | xclip -selection clipboard ) || echo "[NOTE] no xclip at AppVM"

EOFFILE
)

print_help()
{
    echo "qvm-screenshot-tool version $version"
    echo "Usage: $(basename "$0") OPTIONS [[--imgurl|--vm-nautilus] --vm APPVMNAME]"
    echo "  -h | --help"
    echo "  FIRST DIALOG OPTIONS:"
    echo "  -r | --region-only"
    echo "  --fullscreen"
    echo "  --lastdialog"
    echo "  SECOND DIALOG OPTIONS:"
    echo "  --upload-to-appvm-only"
    echo "  --imgurl (request -vm NAME)"
    echo "  --vm-nautilus (request -vm NAME)"
    echo "  --keep-screenshot-at-dom0"
    echo "  SECOND DIALOG OPTIONS:"
    echo "  -vm | --virtualmachine NAME"
    exit 1
}


write_last_action_config()
{
    touch "$LAST_ACTION_LOG_CONFIG"
    cat <<EOF > "$LAST_ACTION_LOG_CONFIG"
# last app vm used to upload image
appvm=\"$appvm\"
EOF
}

read_last_action_config()
{

# shellcheck disable=SC1090
    [ -e "$LAST_ACTION_LOG_CONFIG" ] && source "$LAST_ACTION_LOG_CONFIG"


    if [ "$appvm" == "" ]; then
        printf "Last action not available \n"
        zenity --info --modal --text "Last action not available. Please, upload some image with this AppVM first." &>/dev/null
        exit 1
    fi

    open_imgulr_upload_dialog_at_destination_appvm

    exit 0
}

open_imgulr_upload_dialog_at_destination_appvm()
{
    qvm-run "$appvm" "zenity --text-info --width=500 --height=180 --modal --filename=\"$IMGURL_LOG\" --text Ready"
}

# check dependencies
command -v zenity >/dev/null || {
    warn="[FATAL] \"zenity\" tool not found."
    printf "%s\n" "$warn"
    exit 1
}

command -v display >/dev/null || {
    warn="[EXIT] \"ImageMagic\" (display) not found."
    zenity --info --modal --text "$warn" &>/dev/null
    exit 1
}

start_ksnapshoot()
{
    PID="$(pgrep ksnapshot)"
    if [ "$PID" == "" ]; then
        ksnapshot &
        sleep 1
    fi
    # setGrabMode notes: 0=full-screen, 1=window, 2=region
    #kstart ksnapshot
    #kdialog --radiolist "Now you can user Snapshot tool to make screenshots. When and only when you will be ready with screenshot (check preview area) click OKEY. Confirm only if you are ready!" READY READY READY --default continue --title "$program" --nograb --noxim
    zenity --question --text "Move this window away and make screenshot. When you are ready to upload image click OK"

    # while [ "$PID" == "" ]; do PID="$(pgrep -n ksnapshot)"; done

    # ksnap pid changed after using region selection tool
    PID="$(pgrep ksnapshot)"
    program="org.kde.ksnapshot-${PID}"
    qdbus "$program" /KSnapshot save "$2"
    printf "[+] ksnapshot saved at: %s\n" "$2"
    qdbus "$program" /KSnapshot exit
}

shotslist=""

mkdir -p "$DOM0_SHOTS_DIR" ||exit 1
d=$(date +"%Y-%m-%d-%H%M%S")
shotname="$d.png"

# check ksnapshoot exists
ksnapshottxt="FALSE Ksnapshot"

command -v ksnapshot >/dev/null || {
    ksnapshottxt=""
}

# PROCESS COMMAND LINE ARGS
ans=""
anssecond=""
appvm=""

## GETTING OPTIONS START
declare -a TEMPARR

while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        -h|--help)
            print_help
            exit 1
        ;;
        -r|--region-only)
            ans="Region or Window"
        ;;
        -f|--fullscreen)
            ans="Fullscreen"
        ;;
        -l|--lastdialog)
            ans="Open last dialog"
        ;;
        -vm|--vm|--virtualmachine)
            shift
            appvm="$1"
        ;;
        --upload-to-appvm-only)
            TEMPARR=("${TEMPARR[@]}" "Upload to AppVM only")  # Add an element
        ;;
        --editscreenshot)
            TEMPARR=("${TEMPARR[@]}" "Edit Screenshot")  # Add an element
        ;;
        --imgurl)
            TEMPARR=("${TEMPARR[@]}" "Upload to Imgurl")  # Add an element
        ;;
        --vm-nautilus)
            TEMPARR=("${TEMPARR[@]}" "Start Nautilus at AppVM")  # Add an element
        ;;
        --keep-screenshot-at-dom0)
            TEMPARR=("${TEMPARR[@]}" "Keep screenshot at dom0")  # Add an element
        ;;

        ## This is an arg=value type option. Will catch -o=value or --output-file=value
        ##-o=*|--output-file=*)
        ## No need to shift here since the value is part of the same string
        ##OUTPUTFILE="${key#*=}"
        ##;;
        *)
            # Do whatever you want with extra options
            echo "Unknown option '$key'"
            exit 1
        ;;
    esac
    # Shift after checking all the cases to get the next option
    shift
done

# implode an array with params
anssecond="$(printf "%s)|(" "${TEMPARR[@]}")"
anssecond="${anssecond%)|(}"

unset TEMPARR
## GETTING OPTIONS END

# if [ "$1" = "--region-only" ] ; then
#   ans="Region or Window"
#   shift
# elif [ "$1" = "--fullscreen" ]; then
#   ans="Fullscreen"
#   shift
#fi

if [ "$ans" = "" ] ; then
    ans=$(zenity --list --modal --text "Choose capture mode of capturing \n Use:" --radiolist --column "Pick" --column "Option" \
        $ksnapshottxt \
        TRUE "Region or Window" \
        FALSE "Fullscreen" \
        FALSE "Open last dialog" \
    )
fi

#   echo $ans

error_fail() {
    echo "[ERROR] Something has gone wrong and screenshot has not been saved at dom0."
    zenity --info --modal --text "Something has gone wrong and screenshot has NOT been saved at dom0"
}

do_screenshot() {
    local selection="$1"
    local destination="$2"

    if [ -n "$(command -v scrot 2> /dev/null)" ]; then
        if [ "$selection" == "window" ]; then
            scrot -s -b "$destination"
        elif [ "$selection" == "fullscreen" ]; then
            scrot -b "$destination"
        fi
    elif [ -n "$(command -v maim 2> /dev/null)" ]; then
        if [ "$selection" == "window" ]; then
            maim -s -u "$destination"
        elif [ "$selection" == "fullscreen" ]; then
            maim -u -o "$destination"
        fi
    else
        msg="[EXIT] \"scrot\" or \"maim\" tools not found."
        zenity --info --modal --text "$msg" &>/dev/null
        exit 1
    fi
}

trap error_fail ERR

if [ "$ans" == "Ksnapshot" ]; then
    printf "[+] starting ksnapshot..."
    start_ksnapshoot 4 "$DOM0_SHOTS_DIR/$shotname" || exit 1
elif [ "$ans" == "Region or Window" ]; then
    echo "[+] capturing window, click on it to select"
    do_screenshot window "$DOM0_SHOTS_DIR/$shotname" || exit 1
elif [ "$ans" == "Fullscreen" ]; then
    echo "[+] capturing fullscreen desktop"
    do_screenshot fullscreen "$DOM0_SHOTS_DIR/$shotname" || exit 1
elif [ "$ans" == "Open last dialog" ]; then
    echo "[+] opening last dialog at AppVM with uploaded urls if exists"
    read_last_action_config || exit 1
    exit 1
else
    echo "You must select some mode to continue"
    exit 1
fi

if [ -f "$DOM0_SHOTS_DIR/$shotname" ]; then
    echo "[+] Success at dom0. Screenshot saved at $DOM0_SHOTS_DIR/$shotname" || exit 1
else
    echo "[ERROR] Something has gone wrong and screenshot has not been saved at dom0."
    zenity --info --modal --text "Something has gone wrong and screenshot has NOT been saved at dom0"
    exit 12
fi

trap - ERR


shotslist="$shotname"
#shotslist="${shotslist}${shotname}:"

if [ "$anssecond" = "" ] ; then
    anssecond=$(zenity --list --modal --width=200 --height=290 --text "Screenshot saved at dom0 \nWhat do you want to do next?\nSelect or multiselect some options:" --checklist --column "Pick" --column "Options" \
        FALSE Exit \
        FALSE "Upload to AppVM only" \
        FALSE "Edit Screenshot" \
        FALSE "Upload to Imgurl" \
        FALSE "Start Nautilus at AppVM" \
        FALSE "Keep screenshot at dom0"
        )
fi
#echo "xxx $anssecond xxx"

[[ X"$anssecond" == X"" ]] && exit 1

mode_exit=0
mode_onlyupload=0
mode_edit=0
mode_nautilus=0
mode_imgurl=0
mode_not_delete_screen_at_dom=0

IFSDEFAULT=$IFS
IFS='|'; for val in $anssecond; do
    #echo "variable: $val and $1"
    case "$val" in
        'Exit') mode_exit=1; ;;
        'Upload to AppVM only') mode_onlyupload=1;  ;;
        'Edit Screenshot') mode_edit=1;  ;;
        'Upload to Imgurl') mode_imgurl=1;  ;;
        'Start Nautilus at AppVM') mode_nautilus=1;  ;;
        'Keep screenshot at dom0') mode_not_delete_screen_at_dom=1;  ;;
        # -r) mode_region=1;  ;;
        *) echo "Never Good Bye!"; exit 1 ;;
    esac
done

if [ "$mode_exit" -eq 1 ]; then
    exit 0
fi

# editing screenshot with IM
if [ "$mode_edit" -eq 1 ]; then
    echo "[-] editing screenshot started. Click on the image to get the edit menu. Use the tool. When you will be ready save the screenshot to predefined place. Then Exit from IM to continue"

    echo "" > "$TEMPEDITORFILE"
    display "$DOM0_SHOTS_DIR/$shotname"

    # check if user save his image changes to special SAVE slot that we monitor
    size=$(stat --printf="%s" "$TEMPEDITORFILE" )
    # if [ $size -ge 20 ]; then
    #   # user stored new image
    # fi
    if [ "$size" -ge 20 ]; then
        # user stored new image
        echo "[+] changed screenshot found. Continue with it"
        mv "$TEMPEDITORFILE" "$DOM0_SHOTS_DIR/$shotname"
    else
        #clianup tempfile
        rm "$TEMPEDITORFILE"
    fi


    sleep 1
    echo "[-] thanks for editing. Now we continue."
fi

if [ "$mode_edit" -eq 1 ]; then
    echo "[+] Good Bye!"
fi

IFS=$IFSDEFAULT
choiceappvm=$(qvm-ls --raw-list |sed 's/\([^ ]*\)/FALSE \1 /g')
#appvm=`kdialog --radiolist "Select destination AppVM" $choice --title "$program"`
if [ "$appvm" = "" ] ; then
    # shellcheck disable=SC2086
    appvm=$(zenity --list --modal  --width=200 --height=390  --text "Select destination AppVM (unix based):" --radiolist --column "Pick" --column "AppVM" $choiceappvm)
fi
#echo $appvm

if [ X"$appvm" != X"" ]; then

echo "[-] start AppVM: $appvm"

qvm-run "$appvm" "mkdir -p \"$APPVM_SHOTS_DIR\""

shot=$shotslist

echo "[-] copying screenshot to \"$APPVM_SHOTS_DIR\"/$shot"
qvm-run --pass-io "$appvm" "cat > \"$APPVM_SHOTS_DIR/$shot\"" < "$DOM0_SHOTS_DIR/$shot"

[[ $mode_not_delete_screen_at_dom -eq 0 ]] && rm -f "$DOM0_SHOTS_DIR/$shot" && echo "[+] Screen at dom0 deleted $DOM0_SHOTS_DIR/$shot"

if [ $mode_nautilus -eq 1 ]; then
    echo "[-] running nautilus in AppVM"
    qvm-run "$appvm" "nautilus \"$APPVM_SHOTS_DIR\""
fi

[[ $mode_onlyupload -eq 1 ]] && exit 1


[[ $mode_imgurl -eq 0 ]] && exit 1

echo "[-] copying imgurl uploader to AppVM $appvm"
#      echo $UPLOADHELPER \
#          | qvm-run --pass-io $appvm "echo $UPLOADHELPER > $APPVM_SHOTS_DIR/autouplodertemp.sh"
uploadername='evauploadermgur.sh'
echo "$UPLOADHELPER" | qvm-run --pass-io "$appvm" "cat > \"$APPVM_SHOTS_DIR/$uploadername\""
qvm-run "$appvm" "chmod +x \"$APPVM_SHOTS_DIR/$uploadername\""
qvm-run --pass-io "$appvm" "$APPVM_SHOTS_DIR/$uploadername \"$APPVM_SHOTS_DIR/$shot\" \"$IMGURL_LOG\""
qvm-run "$appvm" "rm \"$APPVM_SHOTS_DIR/$uploadername\""
#qvm-run $appvm "gedit \"$IMGURL_LOG\""

open_imgulr_upload_dialog_at_destination_appvm

# write AppVM name and log file at AppVM to the dom0 config to open it again
write_last_action_config

#done
else
    echo "[-] no AppVM name provided"
fi

echo "[*] Dom0 say Good Bye"
