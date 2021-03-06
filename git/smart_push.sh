#!/bin/zsh
# @author  Jerry <superzcj_001@163.com>
# @version 0.1.6

AUTHOR='Jerry'
VERSION='0.1.6'

echo -e ' \033[36m@ \033[34m欢迎使用智能推代码脚本\033[0m'
echo -e " \033[36m@ \033[32m作者 \033[35m${AUTHOR}\033[0m"
echo -e " \033[36m@ \033[32m版本 \033[35m${VERSION}\033[0m"

REMOTE=$(git remote)
BRANCH=$(git symbolic-ref --short -q HEAD)
STATUS=$(git status --porcelain 2> /dev/null | grep -E '[MADR]{1} ')

echo
echo -e " \033[36m@ 本地: \033[32m"$BRANCH"\033[0m"
echo -e " \033[36m@ 远程: \033[31m"$REMOTE/$BRANCH"\033[0m"

if [[ -n $STATUS ]]; then
	echo
	echo -e ' \033[36m@ 存在未提交改动，准备贮藏...\033[0m'
	echo
	git stash
	echo
	echo -e ' \033[36m@ 已贮藏\033[0m'
fi

remote_branch_count=$(git ls-remote --heads 2>/dev/null | grep "heads/feature/${BRANCH}$" | wc -l)
if [[ $remote_branch_count -gt 0 ]]; then
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
		echo
		echo -e ' \033[36m@ 无差异，跳过拉取代码\033[0m'
	fi

	echo
	echo -e ' \033[36m@ 准备推送\033[0m'
	echo
	git push $REMOTE $BRANCH
	echo
	echo -e ' \033[36m@ 推送完成\033[0m'
else
	echo
	echo -e ' \033[36m@ 准备推送\033[0m'
	echo
	git push --set-upstream $REMOTE $BRANCH
	echo
	echo -e ' \033[36m@ 推送完成\033[0m'
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
