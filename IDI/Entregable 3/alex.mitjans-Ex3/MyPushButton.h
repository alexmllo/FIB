#include <QPushButton>

class MyPushButton: public QPushButton {
    Q_OBJECT

    public:
        MyPushButton(QWidget *parent);

    public slots:
        void rotateColor(int dialValue);
        void intensity(int sliderValue);
    
    private:
        QString currentColor;
        int lastValue;
        int currentIntensity;
        int currentColorIndex;
        void parseStyleSheet(int &r, int &g, int &b);
        int colorToIndex(int r, int g, int b);
        void updateColorByIndex(int index);
        void updateColor(int r, int g, int b);
        // void updateColor();
        QString colorToText(int r, int g, int b);
        // QString colorToText(int r, int g, int b);
        int r_i = 255, g_i = 255, b_i = 255;
};