#include <QApplication>

#include "Colors.h"

int main (int argc, char **argv) 
{
  QApplication a(argc, argv);
  Colors form;
  form.show();
  return a.exec ();
}