#pragma once

#include "Kernel.h"
#include "JvarMapInterface.h"

class ACMultiR5;

template <>
InputParameters validParams<ACMultiR5>();

class ACMultiR5 : public JvarMapKernelInterface<Kernel>
{
public:
  ACMultiR5(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

private:
  const int _etas_num;
  const std::vector<const VariableValue *> _etas;
  const JvarMap & _etas_map;

  std::vector<int> _x;
  int _Np;
  std::vector<Real> _M;
  std::vector<Real> _E;
  std::vector<Real> _W;

  int _index_var;

  const std::vector<const VariableValue *> _cs;
  const JvarMap & _cs_map;

  std::vector<MaterialPropertyName> _fs_names;
  std::vector<const MaterialProperty<Real> *> _fs;

  const MaterialProperty<Real> & _dfdc;

};
