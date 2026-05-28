#!/usr/bin/env bash

# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>

CPU=$(smctemp -c -f)
GPU=$(smctemp -g -f)

CPU_INT=${CPU%.*}
GPU_INT=${GPU%.*}

COLOR=""

if [ "$CPU_INT" -ge 100 ] || [ "$GPU_INT" -ge 100 ]; then
	COLOR="#F85148"
elif [ "$CPU_INT" -ge 90 ] || [ "$GPU_INT" -ge 90 ]; then
	COLOR="#FFA657"
fi

if [ -n "$COLOR" ]; then
	echo "${CPU_INT}° ${GPU_INT}° | size=10 color=$COLOR"
else
	echo "${CPU_INT}° ${GPU_INT}° | size=10"
fi

echo "---"
echo "CPU: ${CPU}°C"
echo "GPU: ${GPU}°C"
