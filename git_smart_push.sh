#!/bin/zsh

REMOTE=$(git remote)
BRANCH=$(git symbolic-ref --short -q HEAD)
STATUS=$(git status --porcelain 2> /dev/null | tail -n1)

echo -e "\033[36m本地分支\033[0m  \033[32m"$BRANCH"\033[0m"
echo -e "\033[36m远程仓库\033[0m  \033[31m"$REMOTE"\033[0m"

if [[ -n $STATUS ]]; then
	echo
	echo '当前有未提交内容，准备贮藏...'
	git stash
	echo '未提交内容已贮藏'
fi

echo
echo '准备拉取更新'

git fetch $REMOTE $BRANCH --prune

echo
echo '与远程分支比较...'
DIFF=$(git log $BRANCH..$REMOTE/$BRANCH --oneline 2> /dev/null | tail -n1)

if [[ -n $DIFF ]]; then
	echo -e ' \033[36m@ 存在差异, 准备变基式拉取...'
	git pull $REMOTE $BRANCH --rebase
else
fi

echo
echo '准备推送'
git push
echo '推送完成'

if [[ -n $STATUS ]]; then
	echo
	echo '准备弹出已贮藏的未提交内容'
	git stash pop
	echo '贮藏内容已经恢复到工作区'
fi
