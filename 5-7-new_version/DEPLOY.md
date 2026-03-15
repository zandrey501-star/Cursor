# Развёртывание на виртуальном сервере

Инструкция по установке и запуску RAG-ассистента с Telegram ботом на сервере (например, IP: 193.233.174.124).

## Требования на сервере

- Linux (Ubuntu 22.04 / Debian 12 или аналог)
- Python 3.10+
- Доступ по SSH

---

## 1. Подключение к серверу

```bash
ssh root@193.233.174.124
# или
ssh ваш_пользователь@193.233.174.124
```

---

## 2. Установка зависимостей системы (если нужно)

```bash
sudo apt update
sudo apt install -y python3 python3-pip python3-venv git
```

---

## 3. Клонирование проекта

Рекомендуется разместить проект в каталоге пользователя:

```bash
cd ~
git clone https://github.com/zandrey501-star/Cursor.git cursor-repo
cd cursor-repo/5-7-new_version
```

Либо если клонируете только этот репозиторий:

```bash
cd ~
git clone https://github.com/MrGAN12009/5-7-new_version.git
cd 5-7-new_version
```

---

## 4. Виртуальное окружение и зависимости Python

```bash
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

---

## 5. Настройка переменных окружения

Создайте файл `.env` из примера и заполните ключи:

```bash
cp env.example .env
nano .env   # или vim .env
```

Обязательно укажите:

- `OPENAI_API_KEY=sk-...` — ключ OpenAI
- `TELEGRAM_BOT_TOKEN=...` — токен бота от @BotFather

Сохраните файл (в nano: Ctrl+O, Enter, Ctrl+X).

---

## 6. Первый запуск (проверка)

Запуск только Telegram бота (без интерактивного меню):

```bash
source venv/bin/activate
python main.py --telegram
```

В терминале должно появиться: «Бот готов к работе! Нажмите Ctrl+C для остановки.»  
Проверьте бота в Telegram. Остановка: Ctrl+C.

---

## 7. Запуск в фоне (screen или nohup)

### Вариант A: screen (удобно смотреть логи)

```bash
screen -S rag-bot
source venv/bin/activate
python main.py --telegram
# Отсоединиться: Ctrl+A, затем D
# Вернуться: screen -r rag-bot
```

### Вариант B: nohup (простой фоновый запуск)

```bash
cd ~/cursor-repo/5-7-new_version   # или ваш путь
source venv/bin/activate
nohup python main.py --telegram > bot.log 2>&1 &
echo $!   # запомните PID для остановки: kill <PID>
```

---

## 8. Автозапуск через systemd (рекомендуется)

Бот будет запускаться при загрузке сервера и перезапускаться при сбоях.

### 8.1. Создание службы

В репозитории есть пример файла: `deploy/rag-telegram-bot.service.example`. Скопируйте его на сервер и отредактируйте:

```bash
sudo cp deploy/rag-telegram-bot.service.example /etc/systemd/system/rag-telegram-bot.service
sudo nano /etc/systemd/system/rag-telegram-bot.service
```

Либо создайте файл вручную (замените `YOUR_USER` и путь к проекту при необходимости):

```ini
[Unit]
Description=RAG Telegram Bot
After=network.target

[Service]
Type=simple
User=YOUR_USER
WorkingDirectory=/home/YOUR_USER/cursor-repo/5-7-new_version
Environment="PATH=/home/YOUR_USER/cursor-repo/5-7-new_version/venv/bin"
ExecStart=/home/YOUR_USER/cursor-repo/5-7-new_version/venv/bin/python main.py --telegram
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Пример для пользователя `root` и пути `/root/cursor-repo/5-7-new_version`:

- `User=root`
- `WorkingDirectory=/root/cursor-repo/5-7-new_version`
- `Environment="PATH=/root/cursor-repo/5-7-new_version/venv/bin"`
- `ExecStart=/root/cursor-repo/5-7-new_version/venv/bin/python main.py --telegram`

### 8.2. Включение и запуск

```bash
sudo systemctl daemon-reload
sudo systemctl enable rag-telegram-bot
sudo systemctl start rag-telegram-bot
sudo systemctl status rag-telegram-bot
```

### 8.3. Полезные команды

| Действие        | Команда |
|-----------------|---------|
| Статус          | `sudo systemctl status rag-telegram-bot` |
| Логи            | `sudo journalctl -u rag-telegram-bot -f` |
| Перезапуск      | `sudo systemctl restart rag-telegram-bot` |
| Остановка       | `sudo systemctl stop rag-telegram-bot`    |

---

## 9. Обновление проекта на сервере

```bash
cd ~/cursor-repo/5-7-new_version   # или ваш путь
git pull
source venv/bin/activate
pip install -r requirements.txt
sudo systemctl restart rag-telegram-bot
```

---

## 10. Проверка

- В Telegram найдите своего бота и отправьте ему сообщение или команду `/start`.
- На сервере: `sudo systemctl status rag-telegram-bot` — должно быть `active (running)`.
- Логи: `sudo journalctl -u rag-telegram-bot -f` — не должно быть ошибок при старте.

Если что-то не работает, проверьте:

1. В `.env` указаны корректные `OPENAI_API_KEY` и `TELEGRAM_BOT_TOKEN`.
2. В unit-файле указаны правильные пути и пользователь.
3. Сервер имеет доступ в интернет (для OpenAI и Telegram API).
