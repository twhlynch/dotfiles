
if [[ $OSTYPE == darwin* ]]; then

	# fix new macos file default being fucked
	ulimit -n 2048

fi

