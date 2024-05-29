#!/bin/sh

# zomeID, plan name


PShort='{"free":"free","biz":"buisness","buisness":"buisness","pro":"pro","professional":"pro","ent":"enterprise","enterprise":"enterprise"}'




main() {
    CONFIRM=true
    PARAMS=""
    while (( "$#" )); do
        case "$1" in
            --dontask)
            CONFIRM=false
            shift 1
            ;;
            --) # end argument parsing
            shift
            break
            ;;
            -*|--*=) # unsupported flags
            echo "Error: Unsupported flag $1" >&2
            exit 1
            ;;
            *) # preserve positional arguments
            PARAMS="$PARAMS $1"
            shift
            ;;
        esac
    done
    # set positional arguments in their proper place
    eval set -- "$PARAMS"


    PLAN_DATA=$(curl -s --request GET \
    --url "https://api.cloudflare.com/client/v4/zones/$1/available_plans" \
    --header "X-Auth-Email: $CF_auth_email" \
    --header "X-Auth-Key: $CF_auth_key")

    status=$( echo "$PLAN_DATA" | jq '.success')

    if !($status = "false")
    then
        return 1 #failed to get plans for zone
    fi
    PLANS=$( echo "$PLAN_DATA" | jq '[.result[] | {(.legacy_id):.id}|to_entries|.[]]|from_entries')

    downcased=$(echo "$2" | awk '{print tolower($0)}')
    planName=$( echo "$PShort" | jq ".$downcased")



    planID=$( echo "$PLANS" | jq ".$planName")


    if ($CONFIRM)
    then

zonename=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$1" \
        --header "X-Auth-Email: $CF_auth_email" \
        --header "X-Auth-Key: $CF_auth_key"  | jq ".result.name")


    tmpconfirm=true
    while $tmpconfirm; do    
        read -p "CHANGING ZONE $zonename to $planName plan, are you sure?" yn
        echo
        case $yn in
        [Yy]* ) tmpconfirm=false; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
        esac
    done
fi

    EXECUTE_DATA=$(curl -s --request PATCH \
    --url https://api.cloudflare.com/client/v4/zones/$1 \
    --header 'Content-Type: application/json' \
    --header "X-Auth-Email: $CF_auth_email" \
    --header "X-Auth-Key: $CF_auth_key" \
    --data "$(generate_change_post_data $planID)")

    status=$( echo "$EXECUTE_DATA" | jq '.success')

    if !($status = "false")
    then
        return 1 #failed to get execute change
    fi

}


generate_change_post_data()
{
    cat <<EOF
{
	"plan":{
		"id":$1
	}
}
EOF
}






main "$@"