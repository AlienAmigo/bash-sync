# Bash
alias c='clear'
alias pro='cd ~/Projects/'
alias proex='cd ~/Projects/_EX/'
alias grep='grep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'

# Быстрый переход в домашнюю директорию
alias ~='cd ~'
alias home='cd ~'

# Возврат в предыдущую директорию
alias -- -='cd -'

# Просмотр директорий с цветами
#alias ls='ls -hF -1 --color=tty --sort=extension' # альтернативный вариант ls
alias ls='ls -cvA --block-size=K --group-directories-first -1 --color=always'
alias ll='ls -lah'
alias la='ls -A'

# Безопасные операции
alias rm='rm -i'      # запрос подтверждения
alias cp='cp -i'      # запрос подтверждения
alias mv='mv -i'      # запрос подтверждения

#VSCode
# alias vsc='/c/Users/maest/AppData/Local/Programs/Microsoft\ VS\ Code/Code.exe' $*

# Node.js
alias i='npm i' $*
alias ci='npm ci' $*
alias s='npm start'
alias sd='npm start deploy'
alias list='npm list -depth=0'
alias is='i && s'

# Vite
alias dv='npm run dev' $*
alias idv='i && dv' $*

# Git.bash
alias a='git add .'
alias gcom='git commit -m' $*
alias agcom='a && git commit -m' $*
alias gf='git fetch' $*
alias gs='git status'
alias gl='git log --pretty=format:"%C(yellow)%h %C(magenta)%ad %C(blue)| %C(white)%s%d %C(green)[%an]" --date=short --graph --max-count=40 $*'
alias gp='git push' $*
alias gpom='git push origin master'
alias gpsu='git push --set-upstream ' $*
alias gpsuo='git push --set-upstream origin ' $*
alias gpl='git pull' $*
alias grb='git rebase' $*
alias grbs='git pull --rebase' $*
alias gck='git checkout' $*
alias gckb='git checkout -b' $*
alias gsw='git switch' $*
alias gswc='git switch -c' $*
alias gb='git branch' $*
alias gbd='git branch -d' $*
alias grv='git review' $*
alias gcoma='git commit --amend'
alias agcoma='a && gcoma'
alias gupm='gck master && grbs'
alias grbm='grb master'
alias grch='git rm --cached' $* # удаляем файл из индекса, оставляя его в рабочем каталоге
alias grchf='git rm -r --cached' $* # удаляем каталог из индекса, оставляя его в рабочем каталоге

alias gcherry='git cherry -v master && git cherry -v master | wc -l'
alias gsq='git rebase -i HEAD~'$*
alias agrbc='a && git rebase --continue'$*
alias grba='git rebase --abort'$*

#PolyTsifra
# Marketplace
alias osmohub='pro && cd stroybase/apps/osmohub'
alias stroybase='pro && cd stroybase'
alias gckam='git checkout marketplace_' $* # переключаемся на актуальную ветку
alias gckdev='git checkout dev'
alias osmostart='stroybase && ./start.sh front' $*
alias osmorun='stroybase && docker compose exec node npm run dev' $*
alias osmoser='osmohub && docker compose exec node npm run chat-server'
alias osmobook='docker compose exec node npm run storybook'
alias osmostart='stroybase && ./start.sh front'
alias osmoswag='stroybase && docker compose exec app php artisan l5-swagger:generate'
alias osmoseed='stroybase && docker compose exec app php artisan migrate:fresh --seed'
# TSUS Mobile
alias mob='pro && cd mptsus/' $* # папка моблильного приложения ЦУС
alias mobcls='mob && npm cache clean --force && rm -rf node_modules && npm install && npx expo start --clear' $*
alias mobs='mob && npx expo start --clear' $*
alias mobupd='mob && gf && gpl'


alias dev='ssh progs@dev.osmohub.ru -t "cd /home/www/engine2/dev/; bash --login"'

alias docker-up='docker compose up -d --build'
alias docker-down='docker compose down'
alias docker-restart='docker-down && docker-up'
alias docker-stop='docker stop $(docker ps -qa) && docker rm $(docker ps -qa)'
alias docker-migrate='docker compose exec app php artisan migrate:fresh --seed && docker compose exec app-chat php artisan migrate:fresh --seed'

alias composer-install='composer install && chat-composer install'
# alias npm-install='npm ci && npm run build'
alias migrate-fresh='php artisan migrate:fresh --seed && chat-php artisan migrate:fresh --seed'
