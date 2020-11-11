#pragma once

#include "Kernel.h"
#include "JvarMapInterface.h"

class ConstraintConcentration
  : public JvarMapKernelInterface<Kernel>
{
public:
  static InputParameters validParams();

  ConstraintConcentration(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

private:
  unsigned int _c_var;
  const VariableValue & _c;

  const unsigned int _cs_num;
  const std::vector<const VariableValue *> _cs;   //是指针！！！为什么
  const JvarMap & _cs_map;
  std::vector<VariableName> _cs_var;

  int _k;

  const unsigned int _etas_num;
  const std::vector<const VariableValue *> _etas;   //是指针！！！为什么
  const JvarMap & _etas_map;
  std::vector<VariableName> _eta_var;
};
