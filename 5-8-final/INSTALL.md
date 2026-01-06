# Инструкция по установке RAG ассистента

## 📋 Предварительные требования

1. **Python 3.11 или выше**
   - Проверка версии: `python3 --version` или `python --version`
   - Если Python не установлен, скачайте с [python.org](https://www.python.org/downloads/)

2. **OpenAI API ключ**
   - Зарегистрируйтесь на [platform.openai.com](https://platform.openai.com)
   - Создайте API ключ в разделе API Keys
   - Сохраните ключ в безопасном месте

## 🚀 Автоматическая установка

### Linux/Mac

```bash
# Перейдите в директорию проекта
cd /path/to/5-8-final

# Запустите скрипт установки
chmod +x setup.sh
./setup.sh
```

### Windows

```cmd
REM Перейдите в директорию проекта
cd C:\path\to\5-8-final

REM Запустите скрипт установки
setup.bat
```

## 🔧 Ручная установка

### Шаг 1: Создание виртуального окружения

**Windows:**
```cmd
py -3.11 -m venv venv_py311
```

**Linux/Mac:**
```bash
python3.11 -m venv venv_py311
```

Если Python 3.11 не установлен, используйте доступную версию:
```bash
python3 -m venv venv_py311
```

### Шаг 2: Активация виртуального окружения

**Windows (PowerShell):**
```powershell
.\venv_py311\Scripts\Activate.ps1
```

**Windows (CMD):**
```cmd
venv_py311\Scripts\activate
```

**Linux/Mac:**
```bash
source venv_py311/bin/activate
```

После активации в начале строки терминала должно появиться `(venv_py311)`.

### Шаг 3: Обновление pip

```bash
python -m pip install --upgrade pip
```

### Шаг 4: Установка зависимостей

```bash
pip install -r requirements.txt
```

Это может занять несколько минут, так как устанавливаются все необходимые библиотеки.

### Шаг 5: Настройка переменных окружения

**Вариант 1: Файл .env (рекомендуется)**

1. Скопируйте файл `env.example` в `.env`:
   
   **Linux/Mac:**
   ```bash
   cp env.example .env
   ```
   
   **Windows:**
   ```cmd
   copy env.example .env
   ```

2. Откройте файл `.env` в текстовом редакторе

3. Замените `your-openai-api-key-here` на ваш реальный API ключ:
   ```env
   OPENAI_API_KEY=sk-proj-xxxxxxxxxxxxxxxxxxxxx
   ```

**Вариант 2: Переменная окружения системы**

**Windows (PowerShell):**
```powershell
$env:OPENAI_API_KEY='sk-proj-xxxxxxxxxxxxxxxxxxxxx'
```

**Windows (CMD):**
```cmd
set OPENAI_API_KEY=sk-proj-xxxxxxxxxxxxxxxxxxxxx
```

**Linux/Mac:**
```bash
export OPENAI_API_KEY='sk-proj-xxxxxxxxxxxxxxxxxxxxx'
```

> ⚠️ **Важно:** При использовании переменной окружения системы её нужно устанавливать каждый раз при открытии нового терминала. Файл `.env` более удобен.

## ✅ Проверка установки

После установки проверьте, что всё работает:

```bash
# Перейдите в директорию assistant_api
cd assistant_api

# Запустите приложение
python app.py
```

Если всё настроено правильно, вы увидите приветственный баннер и сможете задавать вопросы.

## 🐛 Решение проблем

### Проблема: "python3.11: command not found"

**Решение:** Используйте доступную версию Python:
```bash
python3 -m venv venv_py311
```

### Проблема: "Permission denied" при создании venv

**Решение:** Убедитесь, что у вас есть права на запись в директорию проекта.

### Проблема: Ошибки при установке зависимостей

**Решение:**
1. Обновите pip: `pip install --upgrade pip`
2. Убедитесь, что используете активированное виртуальное окружение
3. Попробуйте установить зависимости по одной для выявления проблемы

### Проблема: "OPENAI_API_KEY не установлен"

**Решение:**
1. Убедитесь, что файл `.env` существует в корне проекта
2. Проверьте, что в `.env` указан правильный ключ без кавычек
3. Перезапустите приложение после создания `.env`

### Проблема: Ошибки с ChromaDB

**Решение:** Удалите директорию `chroma_db` и перезапустите приложение - коллекция будет создана заново.

## 📝 Следующие шаги

После успешной установки:

1. Прочитайте [README.md](README.md) для понимания работы системы
2. Добавьте свои документы в `assistant_api/data/docs.txt`
3. Запустите приложение и задайте вопросы
4. Используйте команду `stats` для просмотра статистики
5. Запустите `evaluate_ragas.py` для оценки качества системы

## 💡 Полезные команды

```bash
# Активация окружения (каждый раз при открытии терминала)
source venv_py311/bin/activate  # Linux/Mac
venv_py311\Scripts\activate     # Windows

# Деактивация окружения
deactivate

# Просмотр установленных пакетов
pip list

# Обновление зависимостей
pip install --upgrade -r requirements.txt
```

---

**Успешной установки!** 🎉

