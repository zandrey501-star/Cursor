#!/bin/bash

# Скрипт установки RAG ассистента

echo "🚀 Установка RAG ассистента"
echo "============================"
echo ""

# Проверка Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 не найден. Установите Python 3.11 или выше."
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
echo "✅ Найден Python $PYTHON_VERSION"

# Создание виртуального окружения
echo ""
echo "📦 Создание виртуального окружения..."
if [ -d "venv_py311" ]; then
    echo "⚠️  Виртуальное окружение уже существует"
else
    python3 -m venv venv_py311
    echo "✅ Виртуальное окружение создано"
fi

# Активация виртуального окружения
echo ""
echo "🔌 Активация виртуального окружения..."
source venv_py311/bin/activate

# Обновление pip
echo ""
echo "⬆️  Обновление pip..."
pip install --upgrade pip

# Установка зависимостей
echo ""
echo "📚 Установка зависимостей..."
pip install -r requirements.txt

echo ""
echo "✅ Установка завершена!"
echo ""
echo "📝 Следующие шаги:"
echo "1. Создайте файл .env в корне проекта с содержимым:"
echo "   OPENAI_API_KEY=your-openai-api-key-here"
echo ""
echo "2. Активируйте виртуальное окружение:"
echo "   source venv_py311/bin/activate"
echo ""
echo "3. Запустите приложение:"
echo "   cd assistant_api && python app.py"
echo ""

