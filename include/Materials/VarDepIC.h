#ifndef VARDEPIC_H
#define VARDEPIC_H

#include "InitialCondition.h"


class VarDepIC;

template <>
InputParameters validParams<VarDepIC>();

/**
 *
 */
class VarDepIC : public InitialCondition
{
public:
  VarDepIC(const InputParameters & parameters);
  virtual ~VarDepIC();

  virtual Real value(const Point & /*p*/);

protected:
  unsigned int _num_eta;
  std::vector<const VariableValue *> _etas;
  std::vector<const VariableValue *> _cis;
};

#endif
