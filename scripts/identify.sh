host="Host: $(hostname)"
up=$(uptime | sed -e 's/^[[:space:]]*//')
netline=$(ip a | grep inet | sed -e 's/^[[:space:]]*//' | cut -d " " -f-2 | sort)
net=$"$(for i in $netline; do echo ${i}; done)"


if command -v cowsay >/dev/null; then 
	output=$(cowsay "${host} --------------------------------------- ${up} --------------------------------------- ${net}")
else
	output=$(echo "${host} -- ${up}";echo "Addresses:"; echo "${netline}")
fi

if command -v lolcat >/dev/null; then
	lolcat "${output}"
else
	echo "${output}"
fi