#pragma once

#include "Kernel.h"
#include "JvarMapInterface.h"

class ACMultiR2;

template <>
InputParameters validParams<ACMultiR2>();

class ACMultiR2 : public JvarMapKernelInterface<Kernel>
{
public:
  ACMultiR2(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

private:
  const int _etas_num;
  const std::vector<const VariableValue *> _etas;
  std::vector<int> _x;
  int _Np;
  std::vector<Real> _M;
  std::vector<Real> _W;
  int _index_var;
};
