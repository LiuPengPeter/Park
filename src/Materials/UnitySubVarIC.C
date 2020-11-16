#include "UnitySubVarIC.h"
registerMooseObject("parkApp", UnitySubVarIC);

template <>
InputParameters
validParams<UnitySubVarIC>()
{
  InputParameters params = validParams<InitialCondition>();
  params.addRequiredCoupledVar("etas", "Vector of order parameters");
  return params;
}

UnitySubVarIC::UnitySubVarIC(const InputParameters & parameters)
  : InitialCondition(parameters),
    _num_eta(coupledComponents("etas")),
    _etas(_num_eta)
{
  for (unsigned int i = 0; i < _num_eta; ++i)
    _etas[i] = &coupledValue("etas", i);
}

UnitySubVarIC::~UnitySubVarIC() {}

Real
UnitySubVarIC::value(const Point & p)
{
  Real sum_ec = 0.0;
  for (unsigned int i = 0; i < _num_eta; ++i)
    sum_ec += (*_etas[i])[_qp];
  return 1.0-sum_ec;
}
