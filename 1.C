# include "StudyConvection.h"
registerMooseObject("", StudyConvection);

template<>
InputParameters validParams<StudyConvection>()
{
  InputParameters params=validParams<Kernel>();
  params.addRequiredParam<;
  return params;
}

StudyConvection::StudyConvection(const InputParameters & parameters)
  :Kernel(parameters),

{
}

Real
StudyConvection::computeQpResidual()
{
return _test[_i][_qp] * (_velocity * _grad_u[_qp]);
}

Real
StudyConvection::computeQpJacobian()
{
return _test[_i][_qp] * (_velocity * _grad_phi[_j][_qp]);
}
