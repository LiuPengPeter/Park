# include "ACMultiR5.h"

registerMooseObject("parkApp", ACMultiR5);

template<>
InputParameters validParams<ACMultiR5>()
{
  InputParameters params=validParams<Kernel>();
  params.addRequiredCoupledVar("etas", "Vector of etas");
  params.addRequiredCoupledVar("cs", "Vector of cs");
  params.addRequiredParam<std::vector<MaterialPropertyName>>("fs", "Vector of fs");
  params.addRequiredParam<MaterialPropertyName>("dfdc", "a condition of local thermodynamic equilibrium");
  return params;
}

ACMultiR5::ACMultiR5(const InputParameters & parameters)
  : JvarMapKernelInterface<Kernel>(parameters),
    _etas_num(coupledComponents("etas")),
    _etas(coupledValues("etas")),
    _etas_map(getParameterJvarMap("etas")),
    _x(_etas_num,0),
    _Np(0),
    _M(_etas_num*_etas_num, 0.0),
    _W(_etas_num*_etas_num,0.0),
    _index_var(0),
    _cs(coupledValues("cs")),
    _cs_map(getParameterJvarMap("cs")),
    _fs_names(getParam<std::vector<MaterialPropertyName>>("fs")),
    _fs(_etas_num),
    _dfdc(getMaterialProperty<Real>("dfdc"))
{
  //

  // fs with _etas_num components,
  for (unsigned int i = 0; i < _etas_num; ++i)
  {
    if (i==0)
    _fs[i] = &getMaterialPropertyByName<Real>(_fs_names[0]);
    if (i < _etas_num-1)
    _fs[i] = &getMaterialPropertyByName<Real>(_fs_names[1]);
    else
    _fs[i] = &getMaterialPropertyByName<Real>(_fs_names[2]);
  }

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
ACMultiR5::computeQpResidual()
{
  Real sum = 0.0;
  for (unsigned int j = 0; j < _etas_num; ++j)
  {
    if (j==_index_var)
    continue;
    sum += 2/_Np*_x[_index_var]*_x[j]*_M[_index_var*_etas_num+j]*((*_fs[_index_var])[_qp]-(*_fs[j])[_qp]-(*_cs[_index_var])[_qp]*_dfdc[_qp]+(*_cs[j])[_qp]*_dfdc[_qp]);
  }
  return sum;
}

Real
ACMultiR5::computeQpJacobian()
{
return 0.0;
}

Real
ACMultiR5::computeQpOffDiagJacobian(unsigned int jvar)
{
  Real sum = 0.0;

  auto etavar = mapJvarToCvar(jvar, _etas_map);
  if (etavar >= 0)
    return 0.0;

  auto cvar = mapJvarToCvar(jvar, _cs_map);
  if (cvar >= 0)
  for (unsigned int j = 0; j < _etas_num; ++j)
  {
    if (j==_index_var)
    continue;
    if (cvar==_index_var)
      sum += 2/_Np*_x[_index_var]*_x[j]*_M[_index_var*_etas_num+j]*(_phi[_j][_qp]*_dfdc[_qp]);
    if (cvar==j)
      sum += 2/_Np*_x[_index_var]*_x[j]*_M[_index_var*_etas_num+j]*(_phi[_j][_qp]*_dfdc[_qp]);  //有问题f是不是要二次？？？
  }
  return sum;
}
