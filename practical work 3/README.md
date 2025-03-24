# Інструкція

## 1. Створення нового тому

### Відкрийте термінал та виконайте наступну команду:

```bash
docker volume create mssql-st
```

Ось як це виглядає в терміналі:

![image](https://github.com/user-attachments/assets/3345eaee-2f4e-4136-bc1a-1ed29cbe3f0d)

Відкрийте Docker Desktop, перейдіть у вкладку Volumes та побачите, що том створено:

![image](https://github.com/user-attachments/assets/f54c31a3-23b0-4dc8-80d1-261393bfe614)

## 2. Запуск контейнера

### Якщо образ Microsoft SQL Server ще не завантажено, виконайте команду:

```bash
docker pull mcr.microsoft.com/mssql/server:2022-latest
```

Результат у терміналі:

![image](https://github.com/user-attachments/assets/160d9475-41b4-4d62-a6c4-9893c4fb3b6c)

### Далі виконайте наступну команду в терміналі, щоб запустити контейнер:

```bash
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrongPassword" -v mssql-storage:/var/opt/mssql -p 1433:1433 --name mssql-st -d mcr.microsoft.com/mssql/server:2022-latest
```

Результат у терміналі:

![image](https://github.com/user-attachments/assets/e27c502f-3e6e-4551-8394-9fcbde99a10d)

Відкрийте Docker Desktop, перейдіть у вкладку Containers та побачите, що контейнер працює:

![image](https://github.com/user-attachments/assets/11feacc6-d0e1-4b0c-a3a8-cfcaec2e3273)

### Щоб зупинити контейнер, виконайте команду:

```bash
docker stop mssql-st
```

Результат:

![image](https://github.com/user-attachments/assets/4952c404-52a2-4f6d-b11e-bac8e3bab76e)


### Щоб видалити контейнер, виконайте:

```bash
docker rm mssql-st
```

Результат:

![image](https://github.com/user-attachments/assets/fb721181-505b-40d1-9e9c-52d91f7f91b2)

