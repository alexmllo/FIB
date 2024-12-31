#include "MyGLWidget.h"
#include <iostream>
#include <stdio.h>
#include <QDebug>

#define printOpenGLError() printOglError(__FILE__, __LINE__)
#define CHECK() printOglError(__FILE__, __LINE__,__FUNCTION__)
#define DEBUG() std::cout << __FILE__ << " " << __LINE__ << " " << __FUNCTION__ << std::endl;

MyGLWidget::MyGLWidget(QWidget *parent=0) : LL2GLWidget(parent) 
{
}

int MyGLWidget::printOglError(const char file[], int line, const char func[]) 
{
    GLenum glErr;
    int    retCode = 0;

    glErr = glGetError();
    const char * error = 0;
    switch (glErr)
    {
        case 0x0500:
            error = "GL_INVALID_ENUM";
            break;
        case 0x501:
            error = "GL_INVALID_VALUE";
            break;
        case 0x502: 
            error = "GL_INVALID_OPERATION";
            break;
        case 0x503:
            error = "GL_STACK_OVERFLOW";
            break;
        case 0x504:
            error = "GL_STACK_UNDERFLOW";
            break;
        case 0x505:
            error = "GL_OUT_OF_MEMORY";
            break;
        default:
            error = "unknown error!";
    }
    if (glErr != GL_NO_ERROR)
    {
        printf("glError in file %s @ line %d: %s function: %s\n",
                             file, line, error, func);
        retCode = 1;
    }
    return retCode;
}

MyGLWidget::~MyGLWidget()
{
}

void MyGLWidget::initializeGL() {
  pilotaEnMoviment = true;

  cameraOrtogonal = false;

  LL2GLWidget::initializeGL();

  connect(&timer, SIGNAL(timeout()), this, SLOT(moveBall()));
  timer.start(100);
}

void MyGLWidget::iniEscena() {

  posPorter = glm::vec3(11.0, 0.0, 0.0);  // posició inicial del porter
  posPilota = glm::vec3(9.0, 0.0, 0.0);  // posició inicial de la pilota
  posPatricio = glm::vec3(-11.0, 0.0, 0.0);
  isTwoPlayerMode = false;
  posInicialPilota = posPilota;
  dirInicialPilota();    // direcció inicial de la pilota

  float minx, miny, minz, maxx, maxy, maxz;

  minx = -12; miny = 0; minz = -8;
  maxx = 12; maxy = 4; maxz = 8;

  escenaMinim = glm::vec3(minx,miny,minz);
  escenaMaxim = glm::vec3(maxx, maxy, maxz);
  escenaCentre = glm::vec3((minx+maxx)/2.f, (miny+maxy)/2.f, (minz+maxz)/2.f);

  escenaRadi = glm::distance(escenaCentre, escenaMaxim);
}

void MyGLWidget::iniCamera() {
  FOV = 2*(asin(float(escenaRadi/(2*escenaRadi))));
  raw = 1.0f;

  top = escenaRadi;
  bottom = -escenaRadi;
  left = -escenaRadi;
  right = escenaRadi; 

  zNear = 2*escenaRadi - escenaRadi;
  zFar = 2*escenaRadi + escenaRadi;
  OBS = escenaCentre + 2*escenaRadi+glm::vec3(0., 0., 1.);
  VRP = escenaCentre;
  UP = glm::vec3(0, 1, 0);

  psi = 0;
  theta = M_PI/4;

  projectTransform();
  viewTransform();

}

void MyGLWidget::paintGL () {
  glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  // Lego
  glBindVertexArray (VAO_models[LEGO]);
  modelTransformLego ();
  glDrawArrays(GL_TRIANGLES, 0, models[LEGO].faces().size()*3);

  // Pilota
  glBindVertexArray (VAO_models[PILOTA]);
  modelTransformPilota ();
  glDrawArrays(GL_TRIANGLES, 0, models[PILOTA].faces().size()*3);
  
  // Paret 1
  glBindVertexArray (VAO_Cub);
  modelTransformParet1 ();
  glDrawArrays(GL_TRIANGLES, 0, 36);

  // Paret 2
  glBindVertexArray (VAO_Cub);
  modelTransformParet2 ();
  glDrawArrays(GL_TRIANGLES, 0, 36);

  // Paret 3 || Patricio
  if (isTwoPlayerMode) {
    glBindVertexArray(VAO_models[PATRICIO]);
    modelTransformPatricio();
    glDrawArrays(GL_TRIANGLES, 0, models[PATRICIO].faces().size() * 3);
  } else {
    glBindVertexArray (VAO_Cub);
    modelTransformParet3();
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

// Terra
  glBindVertexArray (VAO_Terra);
  modelTransformTerra ();
  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

  glBindVertexArray (0);
}

void MyGLWidget::modelTransformTerra() {
  glm::mat4 TG(1.0f);
  TG = glm::scale(TG, glm::vec3(3., 1., 2.));
  glUniformMatrix4fv (transLoc, 1, GL_FALSE, &TG[0][0]);
}

void MyGLWidget::modelTransformLego() {
  glm::mat4 TG(1.0f);
  TG = glm::translate(TG, posPorter);
  TG = glm::rotate(TG, -float(M_PI/2.), glm::vec3(0,1,0));
  TG = glm::scale(TG, glm::vec3(escalaModels[LEGO]));
  TG = glm::translate(TG, -centreBaseModels[LEGO]);
  glUniformMatrix4fv(transLoc, 1, GL_FALSE, &TG[0][0]);
}

void MyGLWidget::modelTransformParet1 ()
{
  glm::mat4 TG(1.0f);
  TG = glm::translate(TG, glm::vec3(0, 0, -7.9));
  TG = glm::scale(TG, glm::vec3(24, 2, 0.2));
  glUniformMatrix4fv (transLoc, 1, GL_FALSE, &TG[0][0]);
}

void MyGLWidget::modelTransformParet2 ()
{
  glm::mat4 TG(1.0f);
  TG = glm::translate(TG, glm::vec3(0, 0, 7.9));
  TG = glm::scale(TG, glm::vec3(24, 2, 0.2));
  glUniformMatrix4fv (transLoc, 1, GL_FALSE, &TG[0][0]);
}

void MyGLWidget::modelTransformParet3 ()
{
  glm::mat4 TG(1.0f);
  TG = glm::translate(TG, glm::vec3(-11.9, 0, 0));
  TG = glm::scale(TG, glm::vec3(0.2, 2, 16));
  glUniformMatrix4fv (transLoc, 1, GL_FALSE, &TG[0][0]);
}

void MyGLWidget::modelTransformPatricio() {
  glm::mat4 TG(1.0f);
  TG = glm::translate(TG, posPatricio);
  TG = glm::rotate(TG, float(M_PI / 2.0), glm::vec3(0, 1, 0));
  TG = glm::scale(TG, glm::vec3(escalaModels[PATRICIO]));
  TG = glm::translate(TG, -centreBaseModels[PATRICIO]);
  glUniformMatrix4fv(transLoc, 1, GL_FALSE, &TG[0][0]);
}

void MyGLWidget::projectTransform ()
{
  glm::mat4 Proj(1.0f);
  if (cameraOrtogonal) {
    Proj = glm::ortho(left, right, bottom, top, zNear, zFar);
  }
  else {
    Proj = glm::perspective (FOV, raw, zNear, zFar);
  }

  glUniformMatrix4fv (projLoc, 1, GL_FALSE, &Proj[0][0]);
}

void MyGLWidget::viewTransform() {
  glm::mat4 View(1.0f);
  
  if (cameraOrtogonal && !isTwoPlayerMode) {
    View = glm::lookAt(glm::vec3(0, 18, 0), escenaCentre, glm::vec3(-1, 0, 0));
  } else if (cameraOrtogonal && isTwoPlayerMode) {
    View = glm::lookAt(glm::vec3(0, 18, 0), escenaCentre, glm::vec3(0, 0, -1));
  }
  else {
    View = glm::translate(View, glm::vec3(0, 0, -2*escenaRadi));
    View = glm::rotate(View, theta, glm::vec3(1,0,0));
    View = glm::rotate(View, -psi, glm::vec3(0,1,0));
    View = glm::translate(View, glm::vec3(-VRP.x, -VRP.y, -VRP.z));
  }

  glUniformMatrix4fv (viewLoc, 1, GL_FALSE, &View[0][0]);
}

void MyGLWidget::resizeGL (int w, int h) 
{
  // Aquest codi és necessari únicament per a MACs amb pantalla retina.
  #ifdef __APPLE__
    GLint vp[4];
    glGetIntegerv (GL_VIEWPORT, vp);
    ample = vp[2];
    alt = vp[3];
  #else
    ample = w;
    alt = h;
  #endif
    float rav = float(w)/float(h); // rav

    raw = rav;   
    if (!cameraOrtogonal) {
      if (rav < 1){
        FOV = 2*atan(tan(asin(float(escenaRadi/(2*escenaRadi))))/rav);
      }
    }
    else { //resize ortogonal
      if (rav > 1) {
        left = -escenaRadi*rav;
        right = escenaRadi*rav;
      }
      else {
        bottom = -escenaRadi/rav;
        top = escenaRadi/rav;
      }
    }

    factorAngleY = M_PI / ample;
    factorAngleX = M_PI / alt;
    projectTransform();
}

void MyGLWidget::keyPressEvent(QKeyEvent* event) 
{
  makeCurrent();
  switch (event->key()) {
    case Qt::Key_A: {
      if (isTwoPlayerMode && posPatricio.z >= escenaMinim.z + 2.5) {
          posPatricio.z -= 0.5;
      }
      break;
    }
    case Qt::Key_D: {
      if (isTwoPlayerMode && posPatricio.z <= escenaMaxim.z - 2.5) {
          posPatricio.z += 0.5;
      }
      break;
    }
    case Qt::Key_Up: { 
      if (!pilotaEnMoviment) {
        timer.start(100);
        dirInicialPilota();
        pilotaEnMoviment = true;
      }
      break;
    }
    case Qt::Key_I: { 
      posPilota = posInicialPilota;
      dirInicialPilota(); 
      timer.stop();
      pilotaEnMoviment = false;
      break;
    }           
    case Qt::Key_Left: { 
      if (posPorter.z <= escenaMaxim.z - 2) {
        posPorter.z += 0.5;
      }
      break;
    }  
    case Qt::Key_Right: {
      if (posPorter.z >= escenaMinim.z + 2) {
        posPorter.z -= 0.5;
      }
      break;
    }
    case Qt::Key_C: { 
      cameraOrtogonal = !cameraOrtogonal;
      projectTransform();
      viewTransform();
      break;
    }           
    case Qt::Key_R: { 
      resize();
      break;
    }
    case Qt::Key_2: {
      isTwoPlayerMode = true;
      projectTransform();
      viewTransform();
      break;
    }
    case Qt::Key_1: {
      isTwoPlayerMode = false;
      projectTransform();
      viewTransform();
      break;
    }  
    default: event->ignore(); break;
  }
  update();
}

void MyGLWidget::mouseMoveEvent(QMouseEvent *e)
{
  makeCurrent();

  if(DoingInteractive == ROTATE) {
    psi -= (e->x() - xClick) * factorAngleY;
    theta += (e->y() - yClick) * factorAngleX;
  }

  viewTransform();

  xClick = e->x();
  yClick = e->y();

  update ();
}

void MyGLWidget::moveBall() {
  makeCurrent();
  
  posPilota += dirPilota;

  if (rebotaPorter()) {
    canviaDireccio();
  } else if (isTwoPlayerMode && rebotaPatricio()) {
    canviaDireccioPatricio();
  } else {
    rebotaParets();
  }

  update();
}

void MyGLWidget::rebotaParets() {
  float lineaGol = escenaMaxim.x;
  float leftWall = escenaMinim.x;
  float backWall = escenaMinim.z;
  float frontWall = escenaMaxim.z;

  if (!isTwoPlayerMode && posPilota.x <= leftWall + 1.2) {
      dirPilota.x = -dirPilota.x;
  }

  if (posPilota.z <= backWall + 1.2) {
      dirPilota.z = abs(dirPilota.z);
  } else if (posPilota.z >= frontWall - 1.2) {
    dirPilota.z = -abs(dirPilota.z);
  }

  if ((posPilota.x >= lineaGol) || (isTwoPlayerMode && posPilota.x <= leftWall)) {
    timer.stop();
    posPilota = glm::vec3(1000.0f, 1000.0f, 1000.0f);
  }

}

void MyGLWidget::resize() {
  cameraOrtogonal = false;
  posPorter = glm::vec3(11.0, 0.0, 0.0);  // posició inicial del porter
  posPatricio = glm::vec3(-11.0, 0.0, 0.0);

  psi = 0;
  theta = float(M_PI/4.);

  projectTransform();
  viewTransform();
}

bool MyGLWidget::rebotaPatricio() {
  return (posPilota[0] < -9.5) && (posPilota[0] > -10.5) && 
    (posPilota[2] <= posPatricio[2]+2) && (posPilota[2] >= posPatricio[2]-2);

}

void MyGLWidget::canviaDireccioPatricio() {
  dirPilota = posPilota-posPatricio;
}