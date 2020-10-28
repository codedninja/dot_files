#!/bin/bash

SP_ID=""		#Add your API Client ID here
SP_SECRET=""	#Add your API Client Secret here

SP_B64ID=$(echo -n "$SP_ID:$SP_SECRET"|base64 -w 0)
SP_B64ID=$(echo $SP_B64ID | sed 's/ //g')

TOKEN_FILE=~/.scripts/spotify/token

# Check if token file exists
if [ ! -f "$TOKEN_FILE" ]; then
    # Generate New Token
    echo "https://accounts.spotify.com/authorize?client_id=$SP_ID&response_type=code&redirect_uri=http://localhost:8888/callback&scope=user-read-playback-position"

    read -p "Redirected URL:" SPURL

    # Parse token 
    CODE=$(echo $SPURL | cut -d "=" -f 2)

    RESPONSE=$(curl -H "Authorization: Basic $SP_B64ID" -d grant_type=authorization_code -d code=$CODE -d redirect_uri="http://localhost:8888/callback" https://accounts.spotify.com/api/token --silent)

    echo $RESPONSE > $TOKEN_FILE

    ACCESS_TOKEN=$(echo $RESPONSE | jq '.access_token' -r)

else
    REFRESH_TOKEN=$(cat $TOKEN_FILE | jq '.refresh_token' -r)

    ACCESS_TOKEN=$(curl -H "Authorization: Basic $SP_B64ID" -d grant_type=refresh_token -d refresh_token=$REFRESH_TOKEN -d redirect_uri="http://localhost:8888/callback" https://accounts.spotify.com/api/token --silent | jq '.access_token' -r)


    # Save new token
    cat $TOKEN_FILE | jq --arg a "${ACCESS_TOKEN}" '.access_token = $a' > /tmp/spotify_token && mv /tmp/spotify_token $TOKEN_FILE

fi

function getbearer {
    SP_BEARER=$(curl -H "Authorization: Basic $SP_B64ID" -d grant_type=client_credentials https://accounts.spotify.com/api/token --silent\
    | jq '.access_token' -r)
}

function gettrack {
    require curl
    require jq

    # Get bearer
    getbearer

    # Get song info response
    SP_RESPONSE=$(curl -H "Authorization: Bearer $ACCESS_TOKEN" "https://api.spotify.com/v1/tracks/$TRACK_ID" --silent)

    TRACK_NAME=$(echo $SP_RESPONSE | jq '.name' -r)
    ARTIST_NAME=$(echo $SP_RESPONSE | jq '.album.artists[0].name' -r)
}

function getepisode {
    require curl
    require jq

    # Get bearer
    getbearer

    # Get song info response
    SP_RESPONSE=$(curl -H "Authorization: Bearer $ACCESS_TOKEN" "https://api.spotify.com/v1/episodes/$TRACK_ID" --silent)

    EPISODE_NAME=$(echo $SP_RESPONSE | jq '.name' -r)
    SHOW_NAME=$(echo $SP_RESPONSE | jq '.show.name' -r)
}

function getcurrentlyplaying {
    case "$TRACK_TYPE" in
        "track")
            gettrack
            echo "$TRACK_NAME - $ARTIST_NAME" > ~/.scripts/spotify/currently-playing
            ;;
        "podcast")
            getepisode
            echo "$EPISODE_NAME - $SHOW_NAME" > ~/.scripts/spotify/currently-playing
            ;;
        *)
            echo "Done"
            ;;
    esac
}

case "$PLAYER_EVENT" in
    "playing")
        getcurrentlyplaying
        polybar-msg hook test 1
        ;;
    "changed")
        getcurrentlyplaying
        polybar-msg hook test 1
        ;;
    "started")
        getcurrentlyplaying
        polybar-msg hook test 1
        ;;
    "paused")
        polybar-msg hook test 2
        ;;
    "stopped")
        polybar-msg hook test 3
        ;;
    *)
        echo "None"
        ;;
esac

