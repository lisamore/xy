#!/usr/bin/env bash
latest_version=$(curl -s "https://api.github.com/repos/XTLS/Xray-core/releases/latest" | sed 'y/,/\n/' | grep 'tag_name' | awk -F '"' '{print substr($4,2)}')
current_version=$(./x version | awk 'NR==1 {print $2}')
if [[ ${latest_version} == ${current_version} ]]
then
    echo 'there is nothing to do'
else
    git config --local user.name 'GitHub Action'
    git config --local user.email 'action@github.com
    git clone https://github.com/XTLS/Xray-core.git 
    cd Xray-core && go mod download
    CGO_ENABLED=0 go build -o x -trimpath -ldflags "-s -w -buildid=" ./main
    mv x ../
    rm -rf ../Xray-core
    git commit -am ${latest_version}
    git push -v --progress
fi
