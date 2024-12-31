// MyGLWidget.cpp
#include "MyGLWidget.h"
#include <iostream>
#include <stdio.h>

#define printOpenGLError() printOglError(__FILE__, __LINE__)
#define CHECK() printOglError(__FILE__, __LINE__,__FUNCTION__)
#define DEBUG() std::cout << __FILE__ << " " << __LINE__ << " " << __FUNCTION__ << std::endl;

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

MyGLWidget::~MyGLWidget() {
}

void MyGLWidget::initializeGL() {
  // Cal inicialitzar l'ús de les funcions d'OpenGL
  initializeOpenGLFunctions();  

  glClearColor(0.5, 0.7, 1.0, 1.0); // defineix color de fons (d'esborrat)
  glEnable(GL_DEPTH_TEST);
  glEnable(GL_CULL_FACE);
  
  carregaShaders();
  
  creaBuffersMorty();
  creaBuffersFantasma();
  creaBuffersDiscoBall();
  creaBuffersTerraIParets();

  posFocusEscena = glm::vec3(5,10,5);
  colorFocusEscena = glm::vec3(0.4,0.4,0.4);
  glUniform3fv(posFocusEscenaLoc, 1, &posFocusEscena[0]);
  glUniform3fv(colorFocusEscenaLoc, 1, &colorFocusEscena[0]);

  posFocusModel1 = glm::vec3(1.2,0,0);
  colorFocusModel1 = glm::vec3(0.4,0,0);
  glUniform3fv(posFocusModel1Loc, 1, &posFocusModel1[0]);
  glUniform3fv(colorFocusModel1Loc, 1, &colorFocusModel1[0]);

  posFocusModel2 = glm::vec3(-1.2,0,0);
  colorFocusModel2 = glm::vec3(0,0.4,0);  
  glUniform3fv(posFocusModel2Loc, 1, &posFocusModel2[0]);
  glUniform3fv(colorFocusModel2Loc, 1, &colorFocusModel2[0]);

  posFocusModel3 = glm::vec3(0,0,1.2);
  colorFocusModel3 = glm::vec3(0,0,0.4);
  glUniform3fv(posFocusModel3Loc, 1, &posFocusModel3[0]);
  glUniform3fv(colorFocusModel3Loc, 1, &colorFocusModel3[0]);

  posFocusModel4 = glm::vec3(0,0,-1.2);
  colorFocusModel4 = glm::vec3(0.4,0.4,0);
  glUniform3fv(posFocusModel4Loc, 1, &posFocusModel4[0]);
  glUniform3fv(colorFocusModel4Loc, 1, &colorFocusModel4[0]);

  estatFocusModel = 0;

  connect(&timer, SIGNAL(timeout()), this, SLOT(moveBall()));
  timerActiu = false;

  modelTransformFocus();

  iniEscena();
  iniCamera();
}

void MyGLWidget::iniEscena() {
  LL4GLWidget::iniEscena();

  angleDiscoBall = 0.0;
  angleMorty = 0.0;
  angleFantasma = 0.0;
}

void MyGLWidget::paintGL () 
{
  // En cas de voler canviar els paràmetres del viewport, descomenteu la crida següent i
  // useu els paràmetres que considereu (els que hi ha són els de per defecte)
  // glViewport (0, 0, ample, alt);
  
  // Esborrem el frame-buffer i el depth-buffer
  glClear (GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  // TERRA
  glBindVertexArray (VAO_Terra);
  modelTransformTerra ();
  glDrawArrays(GL_TRIANGLES, 0, 30);
  
  // MORTY
  glBindVertexArray (VAO_Morty);
  modelTransformMorty ();
  glDrawArrays(GL_TRIANGLES, 0, morty.faces().size()*3);
  
  // FANTASMA 1
  glBindVertexArray (VAO_Fantasma);
  modelTransformFantasma (1.0f);
  glDrawArrays(GL_TRIANGLES, 0, fantasma.faces().size()*3);

  // FANTASMA 2
  glBindVertexArray (VAO_Fantasma);
  modelTransformFantasma (9.0f);
  glDrawArrays(GL_TRIANGLES, 0, fantasma.faces().size()*3);

  // DISCO BALL
  glBindVertexArray (VAO_DiscoBall);
  modelTransformDiscoBall ();
  glDrawArrays(GL_TRIANGLES, 0, discoBall.faces().size()*3);
  
  glBindVertexArray(0);
}

void MyGLWidget::modelTransformMorty ()
{
  glm::mat4 TG;
  TG = glm::translate(glm::mat4(1.f), glm::vec3(5,0,5));
  TG = glm::scale(TG, glm::vec3(escalaMorty, escalaMorty, escalaMorty));
  TG = glm::rotate(TG, angleMorty, glm::vec3(0,1,0));
  TG = glm::translate(TG, -centreBaseMorty);
  
  glUniformMatrix4fv (transLoc, 1, GL_FALSE, &TG[0][0]);
}

void MyGLWidget::modelTransformFantasma (float posX)
{
  glm::mat4 TG;
  TG = glm::translate(glm::mat4(1.0f), glm::vec3(posX,0.5,5));
  TG = glm::scale(TG, glm::vec3(escalaFantasma, escalaFantasma, escalaFantasma));
  TG = glm::rotate(TG, angleFantasma, glm::vec3(0,1,0));
  TG = glm::translate(TG, -centreBaseFantasma);
  
  glUniformMatrix4fv (transLoc, 1, GL_FALSE, &TG[0][0]);
}

void MyGLWidget::modelTransformDiscoBall() {
  glm::mat4 TG;
  TG = glm::translate(glm::mat4(1.f), glm::vec3(5,5,5));
  TG = glm::scale(TG, glm::vec3(escalaDiscoBall, escalaDiscoBall, escalaDiscoBall));
  TG = glm::rotate(TG, angleDiscoBall, glm::vec3(0,1,0));
  TG = glm::translate(TG, -centreBaseDiscoBall);
  
  glUniformMatrix4fv (transLoc, 1, GL_FALSE, &TG[0][0]);
}

void MyGLWidget::modelTransformFocus() {
  glm::mat4 TG(1.0);
  TG = glm::translate(glm::mat4(1.f), glm::vec3(5,5,5));
  TG = glm::rotate(TG, angleDiscoBall, glm::vec3(0, 1, 0));

  glUniformMatrix4fv (TGFocusLoc, 1, GL_FALSE, &TG[0][0]);
}

void MyGLWidget::mouseMoveEvent(QMouseEvent *e)
{
  makeCurrent();
  // Aqui cal que es calculi i s'apliqui la rotacio o el zoom com s'escaigui...
  if (DoingInteractive == ROTATE)
  {
    // Fem la rotació
    angleY += (e->x() - xClick) * M_PI / ample;
    viewTransform ();
  }

  xClick = e->x();
  yClick = e->y();

  update ();
}

void MyGLWidget::updateFocusModels() {
  switch (estatFocusModel) {
    case 0: // Apaga focus 1
      colorFocusModel1 = glm::vec3(0, 0, 0);
      glUniform3fv(colorFocusModel1Loc, 1, &colorFocusModel1[0]);
      break;
    case 1: // Apaga focus 2
      colorFocusModel2 = glm::vec3(0, 0, 0);
      glUniform3fv(colorFocusModel2Loc, 1, &colorFocusModel2[0]);
      break;
    case 2: // Apaga focus 3
      colorFocusModel3 = glm::vec3(0, 0, 0);
      glUniform3fv(colorFocusModel3Loc, 1, &colorFocusModel3[0]);
      break;
    case 3: // Apaga focus 4
      colorFocusModel4 = glm::vec3(0, 0, 0);
      glUniform3fv(colorFocusModel4Loc, 1, &colorFocusModel4[0]);
      break;
    case 4: // Encen focus 1
      colorFocusModel1 = glm::vec3(0.4, 0, 0); // Vermell
      glUniform3fv(colorFocusModel1Loc, 1, &colorFocusModel1[0]);
      break;
    case 5: // Encen focus 2
      colorFocusModel2 = glm::vec3(0, 0.4, 0); // Verd
      glUniform3fv(colorFocusModel2Loc, 1, &colorFocusModel2[0]);
      break;
    case 6: // Encen focus 3
      colorFocusModel3 = glm::vec3(0, 0, 0.4); // Blau
      glUniform3fv(colorFocusModel3Loc, 1, &colorFocusModel3[0]);
      break;
    case 7: // Encen focus 4
      colorFocusModel4 = glm::vec3(0.4, 0.4, 0); // Groc
      glUniform3fv(colorFocusModel4Loc, 1, &colorFocusModel4[0]);
      break;
  }
  // 0 -> 1 -> 2 -> ... → 7 -> 0
  estatFocusModel = (estatFocusModel + 1) % 8;
}

void MyGLWidget::keyPressEvent(QKeyEvent* event) {
  makeCurrent();
  switch (event->key()) {
  case Qt::Key_A: {
      angleMorty += glm::radians(45.0f);
    break;
	}
  case Qt::Key_D: {
      angleFantasma -= glm::radians(45.0f);
    break;
	}
  case Qt::Key_E: {
      if (focusEscena) focusEscena = false;
      else focusEscena = true;

      if (!focusEscena) colorFocusEscena = glm::vec3(0.4, 0.4, 0.4);
      else colorFocusEscena = glm::vec3(0,0,0);
      glUniform3fv(colorFocusEscenaLoc, 1, &colorFocusEscena[0]);
    break;
	}
  case Qt::Key_B: {
      updateFocusModels();
    break;
	}	
  case Qt::Key_R: {
      angleDiscoBall += glm::radians(5.0f);
      modelTransformDiscoBall();
      modelTransformFocus();
   
    break;
	}
  case Qt::Key_S: {
      if (timerActiu) {
        timer.stop();
        timerActiu = false;
      }
      else {
        timer.start(100);
        timerActiu = true;
      }
    break;
	}	
  default: LL4GLWidget::keyPressEvent(event); break;
  }
  update();
}

void MyGLWidget::moveBall() {
  makeCurrent();

    angleDiscoBall += glm::radians(5.0f);
    modelTransformDiscoBall();
    modelTransformFocus();

  update();
}

void MyGLWidget::carregaShaders() {
  LL4GLWidget::carregaShaders();

  colorFocusEscenaLoc = glGetUniformLocation (program->programId(), "colorFocusEscena");
  posFocusEscenaLoc = glGetUniformLocation (program->programId(), "posFocusEscena");
  colorFocusModel1Loc = glGetUniformLocation (program->programId(), "colorFocusModel1");
  posFocusModel1Loc = glGetUniformLocation (program->programId(), "posFocusModel1");
  colorFocusModel2Loc = glGetUniformLocation (program->programId(), "colorFocusModel2");
  posFocusModel2Loc = glGetUniformLocation (program->programId(), "posFocusModel2");
  colorFocusModel3Loc = glGetUniformLocation (program->programId(), "colorFocusModel3");
  posFocusModel3Loc = glGetUniformLocation (program->programId(), "posFocusModel3");
  colorFocusModel4Loc = glGetUniformLocation (program->programId(), "colorFocusModel4");
  posFocusModel4Loc = glGetUniformLocation (program->programId(), "posFocusModel4");
  TGFocusLoc = glGetUniformLocation (program->programId(), "TGfocus");
}
