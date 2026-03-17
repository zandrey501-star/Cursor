# Fine-tuning и запуск моделей с LoRA

Проект содержит:
- скрипт дообучения модели LoRA: `fine_tuning/train.py`
- скрипт запуска чата: `inference/chat.py`
- пример датасета: `example_dataset.json`

## Структура

```text
.
├── fine_tuning/
│   ├── train.py
│   └── README.md
├── inference/
│   ├── chat.py
│   └── README.md
├── example_dataset.json
├── requirements.txt
├── requirements-macos-cpu.txt
└── README.md
```

## Установка

### Важно про Python / PyTorch (macOS)

- На **Python 3.13** `torch` может **не ставиться** (pip пишет `No matching distribution found for torch`).
- Для macOS используйте **Python 3.12** (или 3.11) и отдельный `venv`.
- Для macOS/CPU используйте `requirements-macos-cpu.txt` (без `bitsandbytes`).

### Windows / GPU (Powershell)

Если вы работаете в уже созданном `venv`:

```powershell
python -m pip install --upgrade pip
python -m pip install -r .\requirements.txt
```

Для RTX 5060 можно поставить PyTorch с CUDA 12.8:

```powershell
python -m pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128
```

Проверка:

```powershell
python -c "import torch; print(torch.__version__); print(torch.cuda.is_available())"
```

### macOS / CPU

Рекомендуемый способ через Homebrew + venv:

```bash
brew install python@3.12
/opt/homebrew/bin/python3.12 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements-macos-cpu.txt
```

Примечания для macOS:
- если видите сообщение вида `Disabling PyTorch because PyTorch >= 2.4 is required but found ...` — это означает, что ваша версия `transformers` требует слишком новый PyTorch. На macOS (x86_64) через pip часто доступны только `torch` 2.2.x, поэтому используйте `requirements-macos-cpu.txt`, где зафиксированы совместимые версии `torch==2.2.2` и `transformers==4.39.3`.
- если видите предупреждение про NumPy 2.x и “compiled using NumPy 1.x” — поставьте `numpy<2` (тоже зафиксировано в `requirements-macos-cpu.txt`)
- если видите `ImportError: cannot import name 'EncoderDecoderCache' from 'transformers'` — значит `peft` слишком новый для выбранного `transformers`. В `requirements-macos-cpu.txt` зафиксирован совместимый `peft`.
- если видите `TypeError: Accelerator.__init__() got an unexpected keyword argument 'dispatch_batches'` — значит `accelerate` несовместим с `transformers`. В `requirements-macos-cpu.txt` зафиксирован совместимый `accelerate`.

## Датасет

В репозитории уже есть готовый пример: `example_dataset.json`.

Поддерживаются `.json` и `.jsonl` в форматах:
- `{"text": "..."}`
- `{"instruction": "...", "output": "..."}`
- `{"prompt": "...", "completion": "..."}`
- `{"input": "...", "output": "..."}`

## Быстрый старт

### CPU

```powershell
python .\fine_tuning\train.py --model_name "microsoft/DialoGPT-small" --dataset_path ".\example_dataset.json" --output_dir ".\fine_tuning\lora_model_cpu" --num_train_epochs 3 --per_device_train_batch_size 1 --gradient_accumulation_steps 1 --device cpu
```

### GPU

```powershell
python .\fine_tuning\train.py --model_name "microsoft/DialoGPT-small" --dataset_path ".\example_dataset.json" --output_dir ".\fine_tuning\lora_model_gpu" --use_4bit --num_train_epochs 3 --device cuda
```

Примечания:
- на CPU не используйте `--use_4bit`
- на слабом железе уменьшайте `--per_device_train_batch_size`
- базовая модель скачивается автоматически при первом запуске

## Проверочный запуск на маленькой модели

```powershell
python .\fine_tuning\train.py --model_name "sshleifer/tiny-gpt2" --dataset_path ".\example_dataset.json" --output_dir ".\fine_tuning\tmp_cpu_test" --num_train_epochs 1 --per_device_train_batch_size 1 --gradient_accumulation_steps 1 --max_length 32 --device cpu
```

## Запуск чата после обучения

```powershell
python .\inference\chat.py --base_model "microsoft/DialoGPT-small" --lora_model ".\fine_tuning\lora_model_cpu"
```

## Что важно знать

- `fine_tuning/train.py` теперь поддерживает `--device auto|cpu|cuda`
- если указать `--device cpu`, скрипт автоматически отключит 4-bit quantization
- на Windows/Powershell убраны проблемные Unicode-символы из логов

## Полезные модели для старта

- `microsoft/DialoGPT-small`
- `distilgpt2`
- `gpt2`
- `sshleifer/tiny-gpt2` для smoke-test

