#!/bin/bash
ip=$1
ssh=$(ssh $ip 2>&1 > /dev/null)
err='Unable to negotiate with ${ip} port 22: no matching key exchange method found. Their offer: diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1'
diffies=('diffie-hellman-group-exchange-sha1' 'diffie-hellman-group1-sha1')
algos=('aes128-cbc' '3des-cbc' 'blowfish-cbc' 'cast128-cbc' 'arcfour' 'aes192-cbc' 'aes256-cbc' 'rijndael128-cbc' 'rijndael192-cbc' 'rijndael256-cbc' 'rijndael-cbc@lysator.liu.se')
success='Are you sure you want to continue connecting'
if [[ $ssh == *"diffie"*  || $ssh == *"refused"* ]];
then
	echo "ssh no good or refused"
	echo "trying different algorithm ....."
	for diffi in $diffies
	do
		echo "trying ${diffi}"
		stest=$(ssh $ip -oKexAlgorithms=$diffi 2>&1 > /dev/null)

		if [[ $stest == *"Unable"* ]];
		then
			for algo in $algos
			do
				echo "trying command: ssh $ip -oKexAlgorithms=$diffi -c $algo"
				 ssh -tt $ip -oKexAlgorithms=$diffi -c $algo
			done
		fi
			
	done
fi
