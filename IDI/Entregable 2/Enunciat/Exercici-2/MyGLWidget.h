#include "LL2GLWidget.h"

#include <vector>

#include <QTimer>

class MyGLWidget : public LL2GLWidget
{
  Q_OBJECT

public:
  MyGLWidget(QWidget *parent);
  ~MyGLWidget();

protected:
  virtual void keyPressEvent(QKeyEvent *event);

  virtual void creaBuffersTerra();

  virtual void void creaBuffersModels();

private:
  int printOglError(const char file[], int line, const char func[]);
};
