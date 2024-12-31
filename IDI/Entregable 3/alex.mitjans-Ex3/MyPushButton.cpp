#include "MyPushButton.h"

MyPushButton::MyPushButton(QWidget *parent)
    : QPushButton(parent), lastValue(3), currentIntensity(255) {
}

void MyPushButton::rotateColor(int dialValue) {
    int r, g, b;
    parseStyleSheet(r, g, b);

    int steps = dialValue - lastValue;
    const int colorCount = 6;

    int currentColorIndex = colorToIndex(r, g, b);
    int newColorIndex = (currentColorIndex + steps + colorCount) % colorCount;

    updateColorByIndex(newColorIndex);

    lastValue = dialValue;
}

void MyPushButton::intensity(int sliderValue) {
    int r, g, b;
    parseStyleSheet(r, g, b);
    if (currentIntensity == 0) {
        if (r_i != 0) {
            r = sliderValue;
        }
        else {
            r = 0;
        }
        if (g_i != 0) {
            g = sliderValue;
        }
        else {
            g = 0;
        }
        if (b_i != 0) {
            b = sliderValue;
        }
        else {
            b = 0;
        }
        updateColor(r, g, b);
    }
    else {
        if (r != 0) {
            r = sliderValue;
        } 
        if (g != 0) {
            g = sliderValue;
        }
        if (b != 0) {
            b = sliderValue;
        }
        updateColor(r, g, b);
    }
    currentIntensity = sliderValue;
    if (sliderValue != 0) {
        r_i = r;
        g_i = g;
        b_i = b;
    }
}

void MyPushButton::parseStyleSheet(int &r, int &g, int &b) {
    QString currentStyle = styleSheet();
    int start = currentStyle.indexOf("rgb(");
    if (start != -1) {
        start += 4;
        int end = currentStyle.indexOf(")", start);
        if (end != -1) {
            QStringList values = currentStyle.mid(start, end - start).split(",");
            if (values.size() == 3) {
                r = values[0].trimmed().toInt();
                g = values[1].trimmed().toInt();
                b = values[2].trimmed().toInt();
                return;
            }
        }
    }
    r = g = b = 0;
}

int MyPushButton::colorToIndex(int r, int g, int b) {
    if (r == currentIntensity && g == 0 && b == 0) return 0; // Rojo
    if (r == currentIntensity && g == currentIntensity && b == 0) return 1; // Amarillo
    if (r == 0 && g == currentIntensity && b == 0) return 2; // Verde
    if (r == 0 && g == currentIntensity && b == currentIntensity) return 3; // Cian
    if (r == 0 && g == 0 && b == currentIntensity) return 4; // Azul
    if (r == currentIntensity && g == 0 && b == currentIntensity) return 5; // Magenta
    return 0;
}

void MyPushButton::updateColorByIndex(int index) {
    int r = 0, g = 0, b = 0;
    switch (index) {
        case 0: r = currentIntensity; g = 0; b = 0; break; // Rojo
        case 1: r = currentIntensity; g = currentIntensity; b = 0; break; // Amarillo
        case 2: r = 0; g = currentIntensity; b = 0; break; // Verde
        case 3: r = 0; g = currentIntensity; b = currentIntensity; break; // Cian
        case 4: r = 0; g = 0; b = currentIntensity; break; // Azul
        case 5: r = currentIntensity; g = 0; b = currentIntensity; break; // Magenta
    }
    updateColor(r, g, b);
    setText(colorToText(r, g, b));
}

void MyPushButton::updateColor(int r, int g, int b) {
    setStyleSheet(QString("background-color: rgb(%1, %2, %3);").arg(r).arg(g).arg(b));
}

QString MyPushButton::colorToText(int r, int g, int b) {
    if (r == currentIntensity && g == 0 && b == 0) return "Rojo";
    if (r == currentIntensity && g == currentIntensity && b == 0) return "Amarillo";
    if (r == 0 && g == currentIntensity && b == 0) return "Verde";
    if (r == 0 && g == currentIntensity && b == currentIntensity) return "Cian";
    if (r == 0 && g == 0 && b == currentIntensity) return "Azul";
    if (r == currentIntensity && g == 0 && b == currentIntensity) return "Magenta";
    return "";
}