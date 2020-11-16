#pragma once

#include "Kernel.h"
#include "JvarMapInterface.h"

class ACMultiR3;

template <>
InputParameters validParams<ACMultiR3>();

class ACMultiR3 : public JvarMapKernelInterface<Kernel>
{
public:
  ACMultiR3(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

private:
  const int _etas_num;
  const std::vector<const VariableValue *> _etas;
  const std::vector<const VariableGradient *> _grad_etas;
  std::vector<int> _x;
  int _Np;
  std::vector<Real> _M;
  std::vector<Real> _E;
  std::vector<Real> _W;
  int _index_var;
};
