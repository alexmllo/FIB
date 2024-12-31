#include "MyGLWidget.h"
#include <iostream>
#include <stdio.h>

#define printOpenGLError() printOglError(__FILE__, __LINE__)
#define CHECK() printOglError(__FILE__, __LINE__, __FUNCTION__)
#define DEBUG() std::cout << __FILE__ << " " << __LINE__ << " " << __FUNCTION__ << std::endl;

MyGLWidget::MyGLWidget(QWidget *parent = 0) : LL2GLWidget(parent)
{
}

int MyGLWidget::printOglError(const char file[], int line, const char func[])
{
  GLenum glErr;
  int retCode = 0;

  glErr = glGetError();
  const char *error = 0;
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

void MyGLWidget::keyPressEvent(QKeyEvent *event)
{
  makeCurrent();
  switch (event->key())
  {
  case Qt::Key_Up:
  {
    break;
  }
  case Qt::Key_I:
  {
    break;
  }
  case Qt::Key_Left:
  {
    break;
  }
  case Qt::Key_Right:
  {
    break;
  }
  case Qt::Key_C:
  {
    break;
  }
  case Qt::Key_R:
  {
    break;
  }
  default:
    event->ignore();
    break;
  }
  update();
}

void MyGLWidget::creaBuffersTerra()
{
  // VBO amb la posició dels vèrtexs
  glm::vec3 posTerra[4] = {
      glm::vec3(-12.0, 0.0, -8.0),
      glm::vec3(-12.0, 0.0, 8.0),
      glm::vec3(12.0, 0.0, -8.0),
      glm::vec3(12.0, 0.0, 8.0)};

  glm::vec3 c(0.2, 0.6, 0.1);
  glm::vec3 colTerra[4] = {c, c, c, c};

  // VAO
  glGenVertexArrays(1, &VAO_Terra);
  glBindVertexArray(VAO_Terra);

  GLuint VBO_Terra[2];
  glGenBuffers(2, VBO_Terra);

  // geometria
  glBindBuffer(GL_ARRAY_BUFFER, VBO_Terra[0]);
  glBufferData(GL_ARRAY_BUFFER, sizeof(posTerra), posTerra, GL_STATIC_DRAW);
  glVertexAttribPointer(vertexLoc, 3, GL_FLOAT, GL_FALSE, 0, 0);
  glEnableVertexAttribArray(vertexLoc);

  // color
  glBindBuffer(GL_ARRAY_BUFFER, VBO_Terra[1]);
  glBufferData(GL_ARRAY_BUFFER, sizeof(colTerra), colTerra, GL_STATIC_DRAW);
  glVertexAttribPointer(colorLoc, 3, GL_FLOAT, GL_FALSE, 0, 0);
  glEnableVertexAttribArray(colorLoc);

  glBindVertexArray(0);
}

void MyGLWidget::creaBuffersModels()
{
  // Càrrega dels models
  models[PATRICIO].load("./models/Patricio.obj");
  models[PILOTA].load("./models/Pilota.obj");
  models[LEGO].load("./models/legoman.obj");

  // Creació de VAOs i VBOs per pintar els models

  float alcadaDesitjada[NUM_MODELS] = {4, 1, 4};

  for (int i = 1; i < NUM_MODELS; i++)
  {
    glGenVertexArrays(NUM_MODELS, &VAO_models[i]);

    // Calculem la capsa contenidora del model
    calculaCapsaModel(models[i], escalaModels[i], alcadaDesitjada[i], centreBaseModels[i]);

    glBindVertexArray(VAO_models[i]);

    GLuint VBO[2];
    glGenBuffers(2, VBO);

    // geometria
    glBindBuffer(GL_ARRAY_BUFFER, VBO[0]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * models[i].faces().size() * 3 * 3,
                 models[i].VBO_vertices(), GL_STATIC_DRAW);
    glVertexAttribPointer(vertexLoc, 3, GL_FLOAT, GL_FALSE, 0, 0);
    glEnableVertexAttribArray(vertexLoc);

    // color
    glBindBuffer(GL_ARRAY_BUFFER, VBO[1]);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * models[i].faces().size() * 3 * 3,
                 models[i].VBO_matdiff(), GL_STATIC_DRAW);
    glVertexAttribPointer(colorLoc, 3, GL_FLOAT, GL_FALSE, 0, 0);
    glEnableVertexAttribArray(colorLoc);
  }

  glBindVertexArray(0);
}