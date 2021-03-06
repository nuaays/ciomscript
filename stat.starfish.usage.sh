#!/bin/bash 
#
source $CIOM_SCRIPT_HOME/ciom.util.sh

lastDays=$1
orgId=${2:-71028353-7246-463f-ab12-995144fb4cb2}
fileMergedLog="qidaapi.evt.log"
fileHZMergedLog="hz.qidaapi.evt.log"

main() {
	execRemoteCmd 10.10.198.61 22 'rm -rf /tmp/$fileMergedLog; find /data/ -mtime -$lastDays -name event.*.log -exec cat {} >> /tmp/$fileMergedLog \;'
	execRemoteCmd 10.10.198.61 22 "grep -P '/v1/figures.*$orgId.$' /tmp/$fileMergedLog > /tmp/$fileHZMergedLog"
	execRemoteCmd 10.10.198.61 22 "grep -P '/v1/orgs/$orgId/todo' /tmp/$fileMergedLog >> /tmp/$fileHZMergedLog"

	execRemoteCmd 10.10.177.221 22 'rm -rf /tmp/$fileMergedLog; find /data/ -mtime -$lastDays -name event.*.log -exec cat {} >> /tmp/$fileMergedLog \;'
	execRemoteCmd 10.10.177.221 22 "grep -P '/v1/figures.*$orgId.$' /tmp/$fileMergedLog > /tmp/$fileHZMergedLog"
	execRemoteCmd 10.10.177.221 22 "grep -P '/v1/orgs/$orgId/todo' /tmp/$fileMergedLog >> /tmp/$fileHZMergedLog"

	rm -rf ./$fileHZMergedLog _1 _2

	scp root@10.10.198.61:/tmp/$fileHZMergedLog _1
	scp root@10.10.177.221:/tmp/$fileHZMergedLog _2

	cat _1 >> $fileHZMergedLog
	cat _2 >> $fileHZMergedLog

	pwd
	python $CIOM_SCRIPT_HOME/get.org.user.profile.csv.py $orgId

	#grep -P -o '[\w-]+(?=","[\w-]+"$)' $fileHZMergedLog | sort | uniq -c | sort -nr > hz.imapi.todo.userid.times.result

	perl $CIOM_SCRIPT_HOME/stat.imapi.usage.pl $orgId

	fileDatedUsage=usage-$(getDatestamp).csv
	/bin/cp -rf ./usage.csv /sdb/ciompub/starfish/$fileDatedUsage


	echo 
	echo
	echo "------------------------------------------------------------------------------------------------"	
	cat ./usage.csv
	echo "------------------------------------------------------------------------------------------------"
	echo
	echo
	echo "click to download excel report:"
	echo "http://172.17.128.240/ciompub/starfish/$fileDatedUsage"
	echo 
	echo

}

main
