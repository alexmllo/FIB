// MyGLWidget.h
#include "LL4GLWidget.h"
#include <QTimer>

class MyGLWidget : public LL4GLWidget {
  Q_OBJECT
  public:
    MyGLWidget(QWidget *parent=0) : LL4GLWidget(parent) {}
    ~MyGLWidget();
  protected:
    virtual void mouseMoveEvent(QMouseEvent *e);
    virtual void keyPressEvent(QKeyEvent* event);
    virtual void iniEscena();
    virtual void paintGL();
    virtual void modelTransformMorty();
    virtual void modelTransformDiscoBall();
    virtual void modelTransformFantasma (float posX);
    virtual void initializeGL();
    virtual void carregaShaders();
    virtual void modelTransformFocus();
    virtual void updateFocusModels();

    glm::vec3 maximEsc;

    float angleFantasma;
    float angleMorty;
    float angleDiscoBall;

    GLuint transFocsLoc;

    bool focusEscena = true;

    // Focus escena
    GLuint colorFocusEscenaLoc, posFocusEscenaLoc;
    glm::vec3 colorFocusEscena, posFocusEscena;
    // Focus 1
    GLuint colorFocusModel1Loc, posFocusModel1Loc;
    glm::vec3 colorFocusModel1, posFocusModel1;
    // Focus 2
    GLuint colorFocusModel2Loc, posFocusModel2Loc;
    glm::vec3 colorFocusModel2, posFocusModel2;
    // Focus 3
    GLuint colorFocusModel3Loc, posFocusModel3Loc;
    glm::vec3 colorFocusModel3, posFocusModel3;
    // Focus 4
    GLuint colorFocusModel4Loc, posFocusModel4Loc;
    glm::vec3 colorFocusModel4, posFocusModel4;

    GLuint TGFocusLoc;

    int estatFocusModel;

    QTimer timer;
    bool timerActiu;

  public slots:
    void moveBall();

  private:
    int printOglError(const char file[], int line, const char func[]);
};
