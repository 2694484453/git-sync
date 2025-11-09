#!/bin/bash
# #判断～下是否有.netrc文件，没有则拷贝认证信息到～
if [ -f ~/.netrc ]; then
    echo "~/.netrc 文件存在，跳过"
else
    echo "~/.netrc 文件不存在，拷贝.netrc到～/目录"
    cp ./.netrc ~/.netrc
fi

# 检查是否存在jq工具，用于解析JSON
if ! command -v jq &> /dev/null; then
    echo "jq could not be found, please install it."
    exit 1
fi

# 定义JSON配置文件路径
CONFIG_FILE="./config/git-sync-config.json"
# 清除现有的git凭证缓存（可选）
git credential-cache exit
# 读取JSON配置文件中的仓库信息
jq -c '.[]' "$CONFIG_FILE" | while read -r repo; do
    name=$(echo $repo | jq -r '.name')
    type=$(echo $repo | jq -r '.type')
    url=$(echo $repo | jq -r '.url')
    sync_list=$(echo $repo | jq -c '.["sync-list"][]')

    # 如果目录不存在，则克隆主仓库；否则拉取最新代码
    if [ ! -d "$name" ]; then
         echo "克隆仓库：$url to $name"
         git clone $url
         ls -l -a
         cd ..
    else
        cd $name
        git pull origin main
        cd ..
    fi
    echo $sync_list
    # 遍历每个同步目标仓库信息
    for sync_target in $sync_list; do
        sync_name=$(echo $sync_target | jq -r '.name')
        sync_type=$(echo $sync_target | jq -r '.type')
        sync_url=$(echo $sync_target | jq -r '.url')
        echo "推送仓库：$name to $sync_url"
        # 添加或更新远程仓库
        cd $name
        git remote add $sync_type $sync_url

        # 推送到同步目标仓库
        git push $sync_type
    done
done


