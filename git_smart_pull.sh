#!/bin/zsh

echo -e ' \033[36m@ \033[34m欢迎使用智能拉代码脚本\033[0m'
echo -e ' \033[36m@ \033[32m作者 \033[35mJerry\033[0m'

REMOTE=$(git remote)
BRANCH=$(git symbolic-ref --short -q HEAD)
STATUS=$(git status --porcelain 2> /dev/null | tail -n1)

echo
echo -e " \033[36m@ 本地: \033[32m"$BRANCH"\033[0m"
echo -e " \033[36m@ 远程: \033[31m"$REMOTE/$BRANCH"\033[0m"

if [[ -n $STATUS ]]; then
	echo
	echo -e ' \033[36m@ 存在未提交改动，准备贮藏...\033[0m'
	git stash
	echo -e ' \033[36m@ 已贮藏\033[0m'
fi

echo
echo -e ' \033[36m@ 准备获取远程仓库最新改动\033[0m'
echo

git fetch $REMOTE $BRANCH --prune

echo
echo -e ' \033[36m@ 获取完毕\033[0m'
echo
echo -e ' \033[36m@ 与远程分支比较差异...\033[0m'
DIFF=$(git log $BRANCH..$REMOTE/$BRANCH --oneline 2> /dev/null | tail -n1)

if [[ -n $DIFF ]]; then
	echo -e ' \033[36m@ 存在差异, 准备变基式拉取...\033[0m'
	echo
	git pull $REMOTE $BRANCH --rebase
	echo
	echo -e ' \033[36m@ 拉取完毕\033[0m'
else
	echo -e ' \033[36m@ 无差异，跳过拉取代码\033[0m'
fi

if [[ -n $STATUS ]]; then
	echo
	echo -e ' \033[36m@ 准备恢复已贮藏改动\033[0m'
	echo
	git stash pop
	echo
	echo -e ' \033[36m@ 改动已经恢复到工作区\033[0m'
fi

echo
echo -e ' \033[36m@ 结束\033[0m'
