# Jerry's shells
>用脚本辅助工作，解放生产力，发展生产力

# Basic

请确定你使用的是 zsh
如果使用的是 bash, 可以手动将脚本首行的
``` bash
#!/bin/zsh`
```

改为

``` bash
#!/bin/bash
```

# Usage

``` bash
DIR=$(pwd)

cd ~
git clone https://github.com/Jerry-Nil/shells.git shells

# 如果使用bash
# 将 echo 内容重定向至 .bashrc
echo 'alias push="~/shells/common/git/smart_push.sh"' >> .zshrc
echo 'alias pull="~/shells/common/git/smart_pull.sh"' >> .zshrc

cd $DIR
```
