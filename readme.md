# Bash Configuration Manager

Модульная система конфигурации для bash, обеспечивающая синхронизацию настроек между разными компьютерами через Git.

## 📁 Структура проекта

```
.
├── .bashrc                    # Основной файл конфигурации bash
├── .bashrc_local              # Локальные настройки (не синхронизируется)
├── config/                    # Модульная конфигурация
│   ├── main.sh               # Главный загрузчик
│   ├── config.sh             # Флаги конфигурации
│   ├── paths.sh              # Пути к проектам и директориям
│   ├── messages.sh           # Сообщения и тексты
│   ├── colors.sh             # Цветовые переменные
│   ├── helpers.sh            # Вспомогательные функции
│   ├── aliases.sh            # Алиасы команд
│   ├── git.sh                # Git настройки
│   └── os/                   # OS-specific конфигурации
│       ├── windows.sh
│       ├── linux.sh
│       └── macos.sh
├── install.sh                # Скрипт установки
├── update.sh                 # Скрипт обновления
├── uninstall.sh              # Скрипт удаления
└── README.md                 # Эта документация
```

## 🚀 Быстрый старт

### Установка на новом компьютере

1. **Клонируйте репозиторий:**

```bash
git clone <ваш-репозиторий> ~/dotfiles-bash
cd ~/dotfiles-bash
```

2. **Запустите установку:**

```bash
chmod +x install.sh
./install.sh
```

3. **Настройте локальные параметры:**

```bash
nano ~/.bashrc_local
# Отредактируйте:
# export PROJECTS_ROOT="/ваш/путь/к/проектам"
# export GIT_USER_NAME="Ваше Имя"
# export GIT_USER_EMAIL="ваш@email.com"
```

4. **Примените изменения:**

```bash
source ~/.bashrc
```

## 🔧 Модульная система

### Порядок загрузки модулей

Модули загружаются в следующем порядке:

1. **Базовые настройки** (.bashrc) - история, shell опции
2. **Основные модули**:
   - `config.sh` - флаги конфигурации
   - `colors.sh` - цветовые переменные
   - `messages.sh` - тексты сообщений
   - `helpers.sh` - вспомогательные функции
   - `paths.sh` - пути к проектам
3. **OS-specific модули** (автоматически определяется ОС)
4. **Git конфигурация**
5. **Алиасы команд**

### Основные модули

#### `config.sh`

Управляющие флаги:

```bash
export CFG_IS_LOG_ON=true      # Логирование действий
```

#### `paths.sh`

Основные пути (переопределяются в `.bashrc_local`):

```bash
export PROJECTS_ROOT="/d/Project"
export WORK_ROOT="$PROJECTS_ROOT"
export EXERCISES_ROOT="$PROJECTS_ROOT/_EX"
# и другие...
```

#### `aliases.sh`

Алиасы для:

- Bash (`c`, `..`, `...`)
- Git (`gs`, `gp`, `gck`, и т.д.)
- Node.js (`i`, `s`, `dv`)
- Docker (`docker-up`, `docker-down`)
- Проектные команды (`osmohub`, `stroybase`)

#### `helpers.sh`

Вспомогательные функции:

- `cd_safe()` - безопасный переход в директорию
- `paths()` - показывает текущие пути
- `reload()` - перезагружает конфигурацию
- `edit-config()` - редактирует конфигурацию

## ⚙️ Кастомизация

### Локальные настройки (.bashrc_local)

Файл `~/.bashrc_local` НЕ синхронизируется через Git и предназначен для настроек конкретной машины:

```bash
# Пути к проектам (переопределяют paths.sh)
export PROJECTS_ROOT="$HOME/Projects"          # Linux/Mac
# или
export PROJECTS_ROOT="/c/Users/User/Projects"  # Windows

# Git конфигурация
export GIT_USER_NAME="Ваше Имя"
export GIT_USER_EMAIL="ваш@email.com"

# Секретные ключи (НИКОГДА не коммитьте!)
export DOCKER_HUB_TOKEN="xxxxxx"
export NPM_TOKEN="xxxxxx"

# Машинно-специфичные алиасы
alias mymachine='echo "Это моя личная машина"'
```

### OS-specific настройки

Система автоматически определяет ОС и загружает соответствующий файл:

- **Windows**: `config/os/windows.sh`
- **Linux**: `config/os/linux.sh`
- **macOS**: `config/os/macos.sh`

## 🔄 Управление конфигурацией

### Обновление конфигурации

```bash
cd ~/dotfiles-bash
./update.sh
source ~/.bashrc
```

### Резервное копирование и восстановление

```bash
# Резервное копирование (встроено в helpers.sh)
backup-config

# Восстановление из backup
cp ~/.bash_backup/20240101_120000/.bashrc_local ~/
```

### Удаление

```bash
cd ~/dotfiles-bash
./uninstall.sh
```

## 🛠️ Утилиты

### Проверка конфигурации

```bash
paths        # Показать текущие пути
bshtest      # Базовый тест конфигурации
reload       # Перезагрузить конфигурацию
edit-config  # Редактировать конфигурацию
```

### Рабочие команды

#### Навигация

```bash
pro      # Перейти в корень проектов
proex    # Перейти в папку упражнений
..       # На уровень выше
...      # На два уровня выше
```

#### Git

```bash
gs       # git status
gck      # git checkout
gb       # git branch
gp       # git push
gpl      # git pull
```

#### Docker

```bash
docker-up      # Запустить контейнеры
docker-down    # Остановить контейнеры
docker-restart # Перезапустить контейнеры
```

## 📦 Поддерживаемые системы

- **Windows**: Git Bash, Cmder, WSL
- **Linux**: Ubuntu, Debian, CentOS
- **macOS**: Terminal, iTerm2

## 🔍 Отладка

### Включение режима отладки

```bash
export BASH_CONFIG_DEBUG=true
source ~/.bashrc
```

### Проверка загрузки модулей

```bash
echo "BASH_CONFIG_LOADED: $BASH_CONFIG_LOADED"
echo "BASH_CONFIG_OS: $BASH_CONFIG_OS"
echo "PROJECTS_ROOT: $PROJECTS_ROOT"
```

### Тестовый скрипт

```bash
cd /d/Project/bash_settings
./test_runner.sh
```

## 🐛 Решение проблем

### Конфигурация не загружается

1. Проверьте существование файлов:

```bash
ls -la ~/config/
ls -la ~/.bashrc_local
```

2. Проверьте симлинк:

```bash
ls -la ~/config
# Должно быть: config -> /d/Project/bash_settings/config
```

3. Включите отладку:

```bash
export BASH_CONFIG_DEBUG=true
source ~/.bashrc
```

### PS1 показывает ошибку

Если возникает ошибка с `__git_ps1`, временно отключите git prompt:

```bash
# В .bashrc_local добавьте:
export NO_GIT_PROMPT=1
```

## 📝 Миграция со старой системы

Если у вас уже есть настройки:

1. **Перенесите алиасы** из `~/.bash_aliases` в `config/aliases.sh`
2. **Перенесите пути** в `config/paths.sh`
3. **Создайте** `~/.bashrc_local` с машинно-специфичными настройками
4. **Используйте** `install.sh` для установки

## 🤝 Вклад в проект

1. Форкните репозиторий
2. Создайте ветку для ваших изменений
3. Внесите изменения в соответствующие модули
4. Протестируйте на всех ОС (Windows/Linux/macOS)
5. Отправьте pull request

## 📄 Лицензия

MIT License - свободное использование и модификация.

## 🔗 Полезные ссылки

- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/)
- [Git Documentation](https://git-scm.com/doc)
- [Dotfiles Best Practices](https://dotfiles.github.io/)

---

**Примечание**: Все секретные данные (токены, пароли, ключи) должны храниться только в `~/.bashrc_local`, который НЕ добавляется в Git репозиторий!
