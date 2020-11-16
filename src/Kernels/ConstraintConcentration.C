#include "ConstraintConcentration.h"

registerMooseObject("parkApp", ConstraintConcentration);

InputParameters
ConstraintConcentration::validParams()
{
  InputParameters params = Kernel::validParams();
  params.addRequiredCoupledVar("c", "due to the formula, c is treated specially");
  params.addRequiredCoupledVar("cs", "Vector of phase concentrations");
  params.addRequiredCoupledVar("etas", "Vector of etas");
  return params;
}

ConstraintConcentration::ConstraintConcentration(const InputParameters & parameters)
  : JvarMapKernelInterface<Kernel>(parameters),
    _c_var(coupled("c")),
    _c(coupledValue("c")),
    _cs_num(coupledComponents("cs")),
    _cs(coupledValues("cs")),
    _cs_var(_cs_num),
    _cs_map(getParameterJvarMap("cs")),
    _k(-1),
    _etas_num(coupledComponents("etas")),
    _etas(coupledValues("etas")),
    _eta_var(_etas_num),
    _etas_map(getParameterJvarMap("etas"))
{
  for (unsigned int i = 0; i < _cs_num; ++i)
  {
    _cs_var[i] = getVar("cs", i)->name();
    if (coupled("cs", i) == _var.number())
      _k = i;
  }

  for (unsigned int j = 0; j < _etas_num; ++j)
    _eta_var[j] = getVar("etas", j)->name();
}

Real
ConstraintConcentration::computeQpResidual()
{
  Real sum = 0.0;
  for (unsigned int i = 0; i < _cs_num; ++i)
    sum += (*_cs[i])[_qp] * (*_etas[i])[_qp];
  return _test[_i][_qp] * (sum - _c[_qp]);
}

Real
ConstraintConcentration::computeQpJacobian()
{
  return _test[_i][_qp] * (*_etas[_k])[_qp] * _phi[_j][_qp];
}

Real
ConstraintConcentration::computeQpOffDiagJacobian(unsigned int jvar)
{
  if(jvar = _c_var)
    return -_test[_i][_qp] * _phi[_j][_qp];

  auto cvar = mapJvarToCvar(jvar, _cs_map);
  if (cvar >= 0)
    return _test[_i][_qp] * (*_etas[cvar])[_qp] * _phi[_j][_qp];

  auto etavar = mapJvarToCvar(jvar, _etas_map);
  if (etavar >= 0)
  {
    return _test[_i][_qp] * (*_cs[etavar])[_qp] * _phi[_j][_qp];
  }

  return 0.0;
}
