import sys
import configparser
import os
import pyodbc
from PyQt5.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout, QPushButton,
                             QTableWidget, QTableWidgetItem, QMessageBox, QDialog, QFormLayout,
                             QLineEdit, QComboBox, QDoubleSpinBox)

class ConfigManager:
    @staticmethod
    def create_config():
        config = configparser.ConfigParser()

        if not os.path.exists('app.config'):
            config['ConnectionStrings'] = {
                'PhoneShopDB': 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost;DATABASE=Phone;UID=sa;PWD=Ktq0j1wmb;'
            }

            with open('app.config', 'w') as configfile:
                config.write(configfile)

        return ConfigManager.get_connection_string()

    @staticmethod
    def get_connection_string():
        config = configparser.ConfigParser()
        config.read('app.config')

        return config['ConnectionStrings']['PhoneShopDB']

class PhoneDialog(QDialog):
    def __init__(self, parent=None, phone_data=None):
        super().__init__(parent)
        self.phone_data = phone_data
        self.setWindowTitle("Додавання телефону" if not phone_data else "Редагування телефону")
        self.resize(300, 400)
        self.setup_ui()

    def setup_ui(self):
        layout = QFormLayout()

        self.phone_id_input = QLineEdit()
        if self.phone_data:
            self.phone_id_input.setText(str(self.phone_data[0]))
        layout.addRow("PhoneID:", self.phone_id_input)

        self.manufacturer_input = QLineEdit()
        if self.phone_data:
            self.manufacturer_input.setText(self.phone_data[1])
        layout.addRow("Manufacturer:", self.manufacturer_input)

        self.model_input = QLineEdit()
        if self.phone_data:
            self.model_input.setText(self.phone_data[2])
        layout.addRow("Model:", self.model_input)

        self.specs_input = QLineEdit()
        if self.phone_data:
            self.specs_input.setText(self.phone_data[3])
        layout.addRow("Specifications:", self.specs_input)

        self.price_input = QDoubleSpinBox()
        self.price_input.setRange(0, 1000000)
        self.price_input.setDecimals(2)
        if self.phone_data:
            self.price_input.setValue(float(self.phone_data[4]))
        layout.addRow("Price:", self.price_input)

        self.availability_input = QComboBox()
        self.availability_input.addItems(["В наявності", "На замовлення", "Немає у наявності"])
        if self.phone_data:
            self.availability_input.setCurrentText(self.phone_data[5])
        layout.addRow("Availability:", self.availability_input)

        button_layout = QHBoxLayout()
        self.save_button = QPushButton("Зберегти")
        self.cancel_button = QPushButton("Скасування")

        self.save_button.clicked.connect(self.accept)
        self.cancel_button.clicked.connect(self.reject)

        button_layout.addWidget(self.save_button)
        button_layout.addWidget(self.cancel_button)

        layout.addRow("", button_layout)
        self.setLayout(layout)

    def get_phone_data(self):
        return [
            self.phone_id_input.text(),
            self.manufacturer_input.text(),
            self.model_input.text(),
            self.specs_input.text(),
            str(self.price_input.value()),
            self.availability_input.currentText()
        ]


class PhoneShopApp(QMainWindow):
    def __init__(self):
        super().__init__()
        self.connection_string = ConfigManager.create_config()
        self.setup_ui()

        if not self.test_connection():
            self.load_sample_data()
        else:
            self.load_data()

    def setup_ui(self):
        self.setWindowTitle("Магазин телефонів")
        self.setGeometry(100, 100, 800, 600)

        central_widget = QWidget()
        main_layout = QVBoxLayout()

        self.table = QTableWidget()
        self.table.setColumnCount(6)
        self.table.setHorizontalHeaderLabels(["ID", "Виробник", "Модель",
                                              "Характеристики", "Ціна", "Наявність"])
        self.table.setSelectionBehavior(QTableWidget.SelectRows)
        self.table.setEditTriggers(QTableWidget.NoEditTriggers)
        main_layout.addWidget(self.table)

        button_layout = QHBoxLayout()

        self.btn_load = QPushButton("Завантажити дані")
        self.btn_add = QPushButton("Додати")
        self.btn_edit = QPushButton("Редагувати")
        self.btn_delete = QPushButton("Видалити")

        self.btn_load.clicked.connect(self.load_data)
        self.btn_add.clicked.connect(self.add_phone)
        self.btn_edit.clicked.connect(self.edit_phone)
        self.btn_delete.clicked.connect(self.delete_phone)

        button_layout.addWidget(self.btn_load)
        button_layout.addWidget(self.btn_add)
        button_layout.addWidget(self.btn_edit)
        button_layout.addWidget(self.btn_delete)

        main_layout.addLayout(button_layout)

        central_widget.setLayout(main_layout)
        self.setCentralWidget(central_widget)

        self.btn_config = QPushButton("Показати конфігурацію")
        self.btn_config.clicked.connect(self.show_connection_info)
        button_layout.addWidget(self.btn_config)

        self.btn_test_db = QPushButton("Тест підключення")
        self.btn_test_db.clicked.connect(self.test_connection)
        button_layout.addWidget(self.btn_test_db)

    def load_sample_data(self):
        QMessageBox.information(self, "Тестові дані", "Завантажено тестові дані. БД недоступна")

        sample_data = [
            ["1", "Apple", "iPhone 14", "128GB, Blue", "30799.00", "В наявності"],
            ["2", "Samsung", "Galaxy S23", "256GB, Black", "12699.00", "В наявності"],
            ["3", "Xiaomi", "Mi 13", "128GB, White", "9499.00", "На замовлення"],
            ["4", "Google", "Pixel 7", "128GB, Green", "7599.00", "В наявності"],
            ["5", "OnePlus", "11", "256GB, Blue", "6749.00", "Немає у наявності"]
        ]

        self.populate_table(sample_data)

    def populate_table(self, data):
        self.table.setRowCount(len(data))
        for row_idx, row_data in enumerate(data):
            for col_idx, col_data in enumerate(row_data):
                item = QTableWidgetItem(str(col_data))
                self.table.setItem(row_idx, col_idx, item)

    def load_data(self):
        try:
            conn = pyodbc.connect(self.connection_string)
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM Phone")

            rows = cursor.fetchall()

            self.table.setRowCount(0)
            for row_idx, row_data in enumerate(rows):
                self.table.insertRow(row_idx)
                for col_idx, col_data in enumerate(row_data):
                    item = QTableWidgetItem(str(col_data))
                    self.table.setItem(row_idx, col_idx, item)

            conn.close()
            QMessageBox.information(self, "Успіх", "Дані успішно завантажені з бази даних!")

        except Exception as e:
            QMessageBox.critical(self, "Помилка", f"Неможливо завантажити дані: {str(e)}")
            self.load_sample_data()

    def add_phone(self):
        dialog = PhoneDialog(self)
        if dialog.exec_() == QDialog.Accepted:
            phone_data = dialog.get_phone_data()

            if not phone_data[0] or not phone_data[1] or not phone_data[2]:
                QMessageBox.warning(self, "Попередження", "Заповніть усі обов'язкові поля!")
                return

            for row in range(self.table.rowCount()):
                if self.table.item(row, 0).text() == phone_data[0]:
                    QMessageBox.warning(self, "Попередження", "Телефон із таким ID вже існує!")
                    return

            current_row_count = self.table.rowCount()
            self.table.insertRow(current_row_count)

            for col_idx, col_data in enumerate(phone_data):
                item = QTableWidgetItem(str(col_data))
                self.table.setItem(current_row_count, col_idx, item)

            QMessageBox.information(self, "Успіх", "Телефон успішно доданий!")

    def edit_phone(self):
        selected_row = self.table.currentRow()
        if selected_row < 0:
            QMessageBox.warning(self, "Попередження", "Виберіть телефон для редагування!")
            return

        phone_data = []
        for col in range(self.table.columnCount()):
            phone_data.append(self.table.item(selected_row, col).text())

        dialog = PhoneDialog(self, phone_data)
        if dialog.exec_() == QDialog.Accepted:
            updated_data = dialog.get_phone_data()

            for col_idx, col_data in enumerate(updated_data):
                item = QTableWidgetItem(str(col_data))
                self.table.setItem(selected_row, col_idx, item)

            QMessageBox.information(self, "Успіх", "Телефон успішно оновлено!")

    def delete_phone(self):
        selected_row = self.table.currentRow()
        if selected_row < 0:
            QMessageBox.warning(self, "Попередження", "Виберіть телефон, щоб видалити!")
            return

        phone_id = self.table.item(selected_row, 0).text()
        phone_model = self.table.item(selected_row, 2).text()

        confirm = QMessageBox.question(
            self,
            "Підтвердження",
            f"Ви впевнені, що бажаєте видалити телефон {phone_model} (ID: {phone_id})?",
            QMessageBox.Yes | QMessageBox.No
        )

        if confirm == QMessageBox.Yes:
            self.table.removeRow(selected_row)
            QMessageBox.information(self, "Успіх", "Телефон успішно видалений!")

    def show_connection_info(self):
        QMessageBox.information(self, "Рядок підключення", f"Connection String:\n{self.connection_string}")

    def test_connection(self):
        try:
            conn = pyodbc.connect(self.connection_string)
            cursor = conn.cursor()
            cursor.execute("SELECT 1")
            conn.close()
            QMessageBox.information(self, "Підключення", "Підключення до бази даних успішно!")
            return True
        except Exception as e:
            QMessageBox.warning(self, "Помилка підключення",
                                f"Не вдалося підключитися до БД:\n{str(e)}\n\nПрацюємо з тестовими даними")
            return False


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = PhoneShopApp()
    window.show()
    sys.exit(app.exec_())