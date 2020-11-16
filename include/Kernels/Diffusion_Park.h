#pragma once

#include "Kernel.h"
#include "JvarMapInterface.h"

class Diffusion_Park;

template <>
InputParameters validParams<Diffusion_Park>();

class Diffusion_Park : public JvarMapKernelInterface<Kernel>
{
public:
  Diffusion_Park(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned int) override;

private:
  const int _etas_num;
  const std::vector<const VariableValue *> _etas;
  const std::vector<const VariableGradient *> _grad_etas;
  const JvarMap & _etas_map;

  const std::vector<const VariableValue *> _cs;
  const std::vector<const VariableGradient *> _grad_cs;
  const JvarMap & _cs_map;

  const MaterialProperty<Real> & _D;
};
