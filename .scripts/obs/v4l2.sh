DEVICE_NUMBER=50

# Reload v4l2loopback if device doesn't exist
if ! [ -f /dev/video"$DEVICE_NUMBER" ]
then
	# Unload v4l2loopback module
	if ! $(sudo modprobe -r v4l2loopback &> /dev/null)
	then
		echo "Unable to unload v4l2loopback, Close any programs using virtual video devices and try again"
		exit 1
	fi

	# Load v4lwloopback module
	sudo modprobe v4l2loopback video_nr="$DEVICE_NUMBER" 'card_label=Mon2Cam'
fi
