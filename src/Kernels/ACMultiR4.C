# include "ACMultiR4.h"

registerMooseObject("parkApp", ACMultiR4);

template<>
InputParameters validParams<ACMultiR4>()
{
  InputParameters params=validParams<Kernel>();
  params.addRequiredCoupledVar("etas", "Vector of etas");
  return params;
}

ACMultiR4::ACMultiR4(const InputParameters & parameters)
  : JvarMapKernelInterface<Kernel>(parameters),
    _etas_num(coupledComponents("etas")),
    _etas(coupledValues("etas")),
    _grad_etas(coupledGradients("etas")),
    _x(_etas_num,0),
    _Np(0),
    _M(_etas_num*_etas_num, 0.0),
    _W(_etas_num*_etas_num,0.0),
    _index_var(0)
{

  //_x and _Np
  for (unsigned int i = 0; i < _etas_num; ++i)
  {
    if (_etas[i]>0)
    _x[i]=1;
    _Np += _x[i];
  }

  //_M
  for (unsigned int i = 0; i < _etas_num; ++i)
  {
    for (unsigned int j = 0; j < _etas_num; ++j)
    {
      if (0<i && i<_etas_num && j==_etas_num)
        _M[i*_etas_num+j]=1e-6;
      else if (0<j && j<_etas_num && i==_etas_num)
        _M[i*_etas_num+j]=1e-6;
      else
        _M[i*_etas_num+j]=7e-8;
    }
  }

  //_E
  for (unsigned int i = 0; i < _etas_num; ++i)
  {
    for (unsigned int j = 0; j < _etas_num; ++j)
    {
      if (0<i && i<_etas_num && j==_etas_num)
        _E[i*_etas_num+j]=0.0000255;
      else if (0<j && j<_etas_num && i==_etas_num)
        _E[i*_etas_num+j]=0.0000255;
      else
        _E[i*_etas_num+j]=0.0000765;
    }
  }

  //_W
  for (unsigned int i = 0; i < _etas_num; ++i)
  {
    for (unsigned int j = 0; j < _etas_num; ++j)
    {
      if (0<i && i<_etas_num && j==_etas_num)
        _W[i*_etas_num+j]=5e6;
      else if (0<j && j<_etas_num && i==_etas_num)
        _W[i*_etas_num+j]=5e6;
      else
        _W[i*_etas_num+j]=15e6;
    }
  }

  // the index of variable etas _index_var
  for (unsigned int i = 0; i < _etas_num; ++i)
  {
    if (coupled("etas", i) == _var.number())
      _index_var = i;
  }
}

Real
ACMultiR4::computeQpResidual()
{
  Real sum = 0.0;
  for (unsigned int j = 0; j < _etas_num; ++j)
  {
    if (_index_var==j)
    continue;
    for (unsigned int k = 0; k < _etas_num; ++k)
    {
      if (k==j)
      continue;
      if (k==_index_var)
      continue;
      sum += 2/_Np*_x[_index_var]*_x[j]*_M[_index_var*_etas_num+j]*(0.5*_W[_index_var*_etas_num+k]*_W[_index_var*_etas_num+k]-0.5*_W[j*_etas_num+k]*_W[j*_etas_num+k])*(*_etas[k])[_qp]*_test[_i][_qp];
    }
  }
  return sum;
}

Real
ACMultiR4::computeQpJacobian()
{
return 0.0;
}

Real
ACMultiR4::computeQpOffDiagJacobian(unsigned int jvar)
{
  Real sum = 0.0;
  auto cvar = mapJvarToCvar(jvar);
  if (cvar >= 0)
  for (unsigned int j = 0; j < _etas_num; ++j)
  {
    if (_index_var==j)
    continue;
      sum += 2/_Np*_x[_index_var]*_x[j]*_M[_index_var*_etas_num+j]*(0.5*_W[_index_var*_etas_num+cvar]*_W[_index_var*_etas_num+cvar]-0.5*_W[j*_etas_num+cvar]*_W[j*_etas_num+cvar])*(_phi[_j][_qp])*_test[_i][_qp];
  }
  return sum;
}
