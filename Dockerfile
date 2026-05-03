# Этап 1: сборка приложения
FROM golang:1.21-alpine AS builder

# Устанавливаем компилятор для SQLite
RUN apk add --no-cache gcc musl-dev

# Рабочая директория
WORKDIR /app

# Копируем файлы с зависимостями
COPY go.mod go.sum ./

# Скачиваем зависимости
RUN go mod download

# Копируем весь код
COPY . .

# Собираем бинарный файл
RUN go build -o app

# Этап 2: финальный образ
FROM alpine:latest

# Устанавливаем необходимые библиотеки для работы SQLite
RUN apk add --no-cache sqlite-libs

WORKDIR /app

# Копируем бинарник из предыдущего этапа
COPY --from=builder /app/app .

# Запускаем приложение
CMD ["./app"]
