#ifndef UNITYSUBVARIC_H
#define UNITYSUBVARIC_H

#include "InitialCondition.h"

class UnitySubVarIC;

template <>
InputParameters validParams<UnitySubVarIC>();

class UnitySubVarIC : public InitialCondition
{
public:
  UnitySubVarIC(const InputParameters & parameters);
  virtual ~UnitySubVarIC();

  virtual Real value(const Point & p);

protected:
  unsigned int _num_eta;
  std::vector<const VariableValue *> _etas;
};

#endif
