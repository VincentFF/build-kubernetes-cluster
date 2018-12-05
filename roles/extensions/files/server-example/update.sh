#!/bin/bash
cwd=$(cd `dirname $0` || exit 1 && pwd)
vars="$cwd/vars"
appdir="$cwd/app"
projectName="$(cat $vars/project)"

changeVersion() {
	echo -----------------------------edit version-------------------------------
	oldVersion=$(cat $vars/version)
	local old_num=$(echo $oldVersion | cut -d . -f 3)
	local new_num=$(expr ${old_num} + 1)
	echo 1.1.${new_num} > $vars/version || exit 1
    newVersion=1.1.${new_num}
}

copyApps() {
	echo -------------------copy files from test env-------------------------------
	local apps=$vars/apps
	local testServer=$(cat $vars/testserver)
	for line in `cat $apps`
	do
		echo "scp -r root@$testserver/$line $appdir"
		scp -r root@$testServer/$line $appdir || exit 1
	done
}

buildImage() {
	echo ---------------------------build image--------------------------------
	local dockerhub=$(cat $vars/dockerhub)
	image=$dockerhub/$projectName:$newVersion
	docker build -t $image $appdir || exit 1
	docker push $image || exit 1
}

updateServer() {
	echo ---------------update server ${oldVersion} to ${newVersion}-----------------
	echo "$image"
	kubectl --kubeconfig /root/.kube/config -n default set image deployment/${projectName} ${projectName}=${images} --record || exit 1
}

sendMessage() {
	echo -------------------------send message-------------------------------
	local msgtext="线上环境：${projectName}升级 ${oldVersion} ----> ${newVersion}"
	curl 'https://api.potato.im:8443/10000210:458U0Q1G6jh947xRm732hyE1/sendTextMessage' -H 'Content-Type: application/json' -d '{"Chat_type":2,"Chat_id":10030525,"Text":"'$msgtext'"}'
}

main() {
	copyApps
	changeVersion 
	buildImage
	updateServer
	sendMessage
}

main
