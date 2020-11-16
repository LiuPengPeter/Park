#include "Diffusion_Park.h"

registerMooseObject("parkApp", Diffusion_Park);

template<>
InputParameters validParams<Diffusion_Park>()
{
  InputParameters params = validParams<Kernel>();
  params.addRequiredCoupledVar("etas", "Vector of etas");
  params.addRequiredCoupledVar("cs", "Vector of cs");
  params.addRequiredParam<MaterialPropertyName>("Diffusion", "which is constructed by h");
  return params;
}

Diffusion_Park::Diffusion_Park(const InputParameters & parameters)
  : JvarMapKernelInterface<Kernel>(parameters),
    _etas_num(coupledComponents("etas")),
    _etas(coupledValues("etas")),
    _grad_etas(coupledGradients("etas")),
    _etas_map(getParameterJvarMap("etas")),
    _cs(coupledValues("cs")),
    _grad_cs(coupledGradients("cs")),
    _cs_map(getParameterJvarMap("cs")),
    _D(getMaterialProperty<Real>("Diffusion"))
{
}

Real
Diffusion_Park::computeQpResidual()
{
  RealGradient sum = 0.0;
  for (unsigned int i = 0; i < _etas_num; ++i)
  {
    sum = (*_etas[i])[_qp]*(*_grad_cs[i])[_qp];
  }
  return _D[_qp]*sum*_grad_test[_i][_qp];
}

Real
Diffusion_Park::computeQpJacobian()
{
  return 0.0;
}

Real
Diffusion_Park::computeQpOffDiagJacobian(unsigned int jvar)
{
  auto cvar = mapJvarToCvar(jvar, _cs_map);
  if (cvar >= 0)
  return _D[_qp]*(*_etas[cvar])[_qp]*_grad_phi[_j][_qp]*_grad_test[_i][_qp];

  auto etavar = mapJvarToCvar(jvar, _etas_map);
  if (etavar >= 0)
  return _D[_qp]*_phi[_j][_qp]*(*_grad_cs[etavar])[_qp]*_grad_test[_i][_qp];
}
