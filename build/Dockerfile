#!/bin/bash

# IBO Phone Docker Support
# Поддержка Docker для запуска IBO Phone в контейнере

FROM ubuntu:22.04

# Установка зависимостей
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    android-sdk \
    cpio \
    syslinux \
    isolinux \
    mkisofs \
    genisoimage \
    wget \
    curl \
    git \
    build-essential \
    qemu-system-arm \
    qemu-system-x86-64 \
    && rm -rf /var/lib/apt/lists/*

# Установка bundletool
RUN mkdir -p /opt/bundletool && \
    cd /opt/bundletool && \
    wget https://github.com/google/bundletool/releases/latest/download/bundletool.jar && \
    chmod +x bundletool.jar

ENV PATH="/opt/bundletool:$PATH"

# Создание рабочей директории
WORKDIR /ibo-phone-iso

# Копирование проекта
COPY . .

# Подготовка системы
RUN bash build/setup-vm.sh

# Команда по умолчанию
CMD ["bash"]

# Инструкции:
# Сборка: docker build -t ibo-phone:latest .
# Запуск: docker run -it -v /path/to/iso:/iso ibo-phone:latest
