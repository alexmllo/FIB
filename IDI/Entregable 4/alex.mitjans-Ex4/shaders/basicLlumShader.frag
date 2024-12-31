#version 330 core

in vec3  fmatamb;
in vec3  fmatdiff;
in vec3  fmatspec;
in float fmatshin;
in vec3  fvertex;
in vec3  fnormal;

const vec3 llumAmbient = vec3(0.1, 0.1, 0.1);

uniform mat4 TGfocus;
uniform mat4 Proj;
uniform mat4 View;

uniform vec3 colorFocusEscena;
uniform vec3 posFocusEscena;
uniform vec3 colorFocusModel1;
uniform vec3 posFocusModel1;
uniform vec3 colorFocusModel2;
uniform vec3 posFocusModel2;
uniform vec3 colorFocusModel3;
uniform vec3 posFocusModel3;
uniform vec3 colorFocusModel4;
uniform vec3 posFocusModel4;

out vec4 FragColor;


vec3 Ambient() {
  return llumAmbient*fmatamb;
}

vec3 Difus (vec3 NormSCO, vec3 L, vec3 colFocus)
{
  // Fixeu-vos que SOLS es retorna el terme de Lambert!
  // S'assumeix que els vectors que es reben com a paràmetres estan normalitzats
  vec3 colRes = vec3(0);
  if (dot (L, NormSCO) > 0)
    colRes = colFocus * fmatdiff * dot (L, NormSCO);
  return (colRes);
}

vec3 Especular (vec3 NormSCO, vec3 L, vec3 vertSCO, vec3 colFocus)
{
  // Fixeu-vos que SOLS es retorna el terme especular!
  // Assumim que els vectors estan normalitzats
  vec3 colRes = vec3 (0);
  // Si la llum ve de darrera o el material és mate no fem res
  if ((dot(NormSCO,L) < 0) || (fmatshin == 0))
    return colRes;  // no hi ha component especular

  vec3 R = reflect(-L, NormSCO); // equival a: 2.0*dot(NormSCO,L)*NormSCO - L;
  vec3 V = normalize(-vertSCO); // perquè la càmera està a (0,0,0) en SCO

  if (dot(R, V) < 0)
    return colRes;  // no hi ha component especular

  float shine = pow(max(0.0, dot(R, V)), fmatshin);
  return (colRes + fmatspec * colFocus * shine);
}

void main()
{
    vec4 posFocusEscenaFS = View * vec4(posFocusEscena, 1.0);
    // Normalizar la L del focus Escena
    vec3 LSCOEscena = normalize(posFocusEscenaFS.xyz - fvertex);

    vec4 posFocusModel1FS = View * TGfocus * vec4(posFocusModel1, 1.0);
    // Normalitzar L focus Model1
    vec3 LSCOModel1 = normalize(posFocusModel1FS.xyz - fvertex.xyz);

    vec4 posFocusModel2FS = View * TGfocus * vec4(posFocusModel2, 1.0);
    // Normalitzar L focus Model2
    vec3 LSCOModel2 = normalize(posFocusModel2FS.xyz - fvertex.xyz);

    vec4 posFocusModel3FS = View * TGfocus * vec4(posFocusModel3, 1.0);
    // Normalitzar L focus Model3
    vec3 LSCOModel3 = normalize(posFocusModel3FS.xyz - fvertex.xyz);

    vec4 posFocusModel4FS = View * TGfocus * vec4(posFocusModel4, 1.0);
    // Normalitzar L focus Model4
    vec3 LSCOModel4 = normalize(posFocusModel4FS.xyz - fvertex.xyz);

    // Normalitzar normal
    vec3 normalSCOFS = normalize(fnormal);

    // Focus Escena
    vec3 fcolor = Ambient() +
                  Difus(normalSCOFS, LSCOEscena, colorFocusEscena) +
                  Especular(normalSCOFS, LSCOEscena, fvertex, colorFocusEscena);

    // Focus Model1
    fcolor += Difus(normalSCOFS, LSCOModel1, colorFocusModel1) +
              Especular(normalSCOFS, LSCOModel1, fvertex, colorFocusModel1);

    // Focus Model2
    fcolor += Difus(normalSCOFS, LSCOModel2, colorFocusModel2) +
              Especular(normalSCOFS, LSCOModel2, fvertex, colorFocusModel2);
    
    // Focus Model3
    fcolor += Difus(normalSCOFS, LSCOModel3, colorFocusModel3) + 
              Especular(normalSCOFS, LSCOModel3, fvertex, colorFocusModel3);

    // Focus Model4
    fcolor += Difus(normalSCOFS, LSCOModel4, colorFocusModel4) +
              Especular(normalSCOFS, LSCOModel4, fvertex, colorFocusModel4);

    FragColor = vec4(fcolor, 1);
}
