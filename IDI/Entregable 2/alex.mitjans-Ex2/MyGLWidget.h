#include "LL2GLWidget.h"

#include <vector>

#include <QTimer>

class MyGLWidget : public LL2GLWidget {
  Q_OBJECT

  public:
    MyGLWidget(QWidget *parent);
    ~MyGLWidget();

  protected:

    virtual void initializeGL();

    virtual void iniEscena();

    virtual void iniCamera();

    virtual void paintGL ();

    virtual void resizeGL(int width, int height);
  
    virtual void keyPressEvent (QKeyEvent *event);

    virtual void mouseMoveEvent (QMouseEvent *event);

    virtual void rebotaParets();

    virtual void modelTransformTerra();

    virtual void modelTransformLego();

    virtual void modelTransformParet1();

    virtual void modelTransformParet2();

    virtual void modelTransformParet3();

    virtual void modelTransformPatricio();

    virtual void projectTransform();

    virtual void viewTransform();

    virtual void resize();

    virtual bool rebotaPatricio();

    virtual void canviaDireccioPatricio();



    // Camera

    float FOV;
    float raw;
    float zNear;
    float zFar;
    glm::vec3 OBS;
    glm::vec3 VRP;
    glm::vec3 UP;
    float psi;  // y
    float theta;  // x
    float phi;  // z

    float top;
    float bottom;
    float right;
    float left;


    bool cameraOrtogonal;


    // Escena
    glm::vec3 escenaMinim;
    glm::vec3 escenaMaxim;
    float escenaRadi;
    glm::vec3 escenaCentre;
    


    glm::vec3 posInicialPilota;
    bool pilotaEnMoviment;

    bool isTwoPlayerMode;
    glm::vec3 posPatricio;

  public slots:
    void moveBall();

  private:
  
    int printOglError(const char file[], int line, const char func[]);
   
};
