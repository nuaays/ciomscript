#!/bin/bash
#
if [ "$JENKINS_HOME" == "" ]; then
	source $CIOM_HOME/ciom.util.sh
	simulateJenkinsContainer
else 
	source $JENKINS_HOME/workspace/ciom/ciom.util.sh
fi

appName=$1
host=$2
port=$3
tomcatParent=$4
asRoot=${5:-NotAsRoot}

AppPackageFile="$appName.war"
MyWorkspace="$WORKSPACE/$appName/target"
WebappsLocation="$tomcatParent/webapps"

appContextName=$appName

enterWorkspace() {
	execCmd "cd $MyWorkspace"
}

leaveWorkspace() {
	execCmd "cd $MyWorkspace"
}

uploadFiles() {
	upload $AppPackageFile $host $port $tomcatParent/
}

applyAppPackage() {
	execRemoteCmd $host $port "unzip -o $tomcatParent/$AppPackageFile $WebappsLocation/$appContextName"
}

backup() {
	timestamp=$(date +%04Y%02m%02d.%02k%02M%02S)
	execRemoteCmd $host $port "cd $WebappsLocation; tar -czvf $tomcatParent/$AppPackageFile-$timestamp.tgz $appContextName"
}

makeAppAsRoot() {
	execRemoteCmd $host $port "rm -rf $WebappsLocation/ROOT; mv $WebappsLocation/$appContextName $WebappsLocation/ROOT"
}

preDeployApp() {
	stopTomcats $host $port $tomcatParent
}

postDeployApp() {
	if [ $asRoot == "AsRoot" ]; then
		makeAppAsRoot #must be before start tomcats
	fi
	
	startTomcats $host $port $tomcatParent
}

main() {
	enterWorkspace
	preDeployApp
	backup
	uploadFiles
	applyAppPackage
	postDeployApp
	leaveWorkspace
}

main

unsimulateJenkinsContainer