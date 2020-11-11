[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 184
  ny = 290
  xmin = 0
  xmax = 1840 #[nm]
  ymin = 0
  ymax = 2900
  elem_type = QUAD4
[]

[Variables]
  # concentration Sn
  # it could be calculated through the ConstraintConcentration kernel.
  [./c]
      order = FIRST
      family = LAGRANGE
      [./InitialCondition]
        etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
        cis = 'c_Cu c_Eta1 c_Eta2 c_Sn'
      [../]
  [../]
  # phase concentration  Sn in Cu
  [./c_Cu]
      order = FIRST
      family = LAGRANGE
      initial_condition = 0.02
  [../]
  # phase concentration  Sn in Cu6Sn5
  [./c_Eta1]
      order = FIRST
      family = LAGRANGE
      initial_condition = 0.4105
  [../]
  [./c_Eta2]
      order = FIRST
      family = LAGRANGE
      initial_condition = 0.4105
  [../]
  # phase concentration  Sn in Sn
  [./c_Sn]
      order = FIRST
      family = LAGRANGE
      initial_condition = 0.9767
  [../]
  # order parameter Cu
  [./eta_Cu]
      order = FIRST
      family = LAGRANGE
      [./InitialCondition]
        type = BoundingBoxIC
        x1 = 0
        y1 = 0
        x2 = 184
        y2 = 250
        inside = 1
        outside = 0
        int_width = 0
      [../]
  [../]
  # order parameter Cu6Sn5 1
  [./eta_Eta1]
      order = FIRST
      family = LAGRANGE
      [./InitialCondition]
        type = BoundingBoxIC
        x1 = 90
        y1 = 20
        x2 = 100
        y2 = 25
        inside = 1
        outside = 0
        int_width = 2
      [../]
  [../]
  # order parameter Cu6Sn5 1
  [./eta_Eta2]
      order = FIRST
      family = LAGRANGE
      [./InitialCondition]
        type = BoundingBoxIC
        x1 = 120
        y1 = 20
        x2 = 125
        y2 = 25
        inside = 1
        outside = 0
        int_width = 2
      [../]
  [../]
  # order parameter Sn
  [./eta_Sn]
      order = FIRST
      family = LAGRANGE
      [./eta_Sn] #Sn 修改，在全范围etas和1。另一个问题：在ICs中添加约束了，之后就不用了吗？
        type = UnitySubVarIC
        variable = eta_Sn
        etas = 'eta_Cu eta_Eta1 eta_Eta2'
      [../]
  [../]
[]

[Kernels]
  # there are two constraints. The other is to enforce sum etas = 1 and it is included in AC equation.
  # enforce c = sum eta_i * c_i
  [./constraint_concentration]
    type = ConstraintConcentration
    #The constraint formula needs to be alone. So the variable needs to be different to variables of other kernels.
    variable = c_Sn
    c = c
    cs = 'c_Cu c_Eta1 c_Eta2 c_Sn'
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  [../]

  #AC equation for Cu
  [./deta_Cudt]
  type = TimeDerivative
  variable = eta_Cu
  [../]
  [./ACMultiR1_eta_Cu]
    type =  ACMultiR1
  #  M_ij = '7e-8 7e-8 7e-8 7e-8
  #          7e-8 7e-8 7e-8 e-6
  #          7e-8 7e-8 7e-8 e-6
  #          7e-8 e-6 e-6 7e-8'
  [../]
[]

[BCs]
    #eta
    [./neumann_bottom_etaCu]
        type = NeumannBC
        boundary = 'bottom'
        variable = 'eta_Cu'
        value = 1
    [../]
    [./neumann_bottom_eta]
        type = NeumannBC
        boundary = 'bottom'
        variable = 'eta_Eta1 eta_Eta2 eta_Sn'
        value = 0
    [../]
    [./neumann_top_etaSn]
        type = NeumannBC
        boundary = 'top'
        variable = 'eta_Sn'
        value = 1
    [../]
    [./neumann_top_eta]
        type = NeumannBC
        boundary = 'top'
        variable = 'eta_Cu eta_Eta1 eta_Eta2'
        value = 0
    [../]

    #c (of Sn)
    [./neumann_bottom_c]
        type = NeumannBC
        boundary = 'bottom'
        variable = 'c_Cu'
        value = 0.02
    [../]
    [./neumann_bottom_c_]
        type = NeumannBC
        boundary = 'bottom'
        variable = 'c_Eta1 c_Eta2'
        value = 0.02
    [../]
    [./neumann_top_c]
        type = NeumannBC
        boundary = 'top'
        variable = 'c_Sn'
        value = 0.9767
    [../]
    [./neumann_top_c_Cu]
        type = NeumannBC
        boundary = 'top'
        variable = 'c_Cu c_Eta1 c_Eta2'
        value = 0.02
    [../]

    [./Periodic]
      [./x]
        auto_direction = 'x'
        variable = 'c_Cu c_Eta1 c_Eta2 c_Sn eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
      [../]
    [../]
[]

[Materials]
  [./model_constants]
    type = GenericConstantMaterial
    prop_names = 'Vm R T'
    prop_values = '16.29e-6 8.314 523'    #Vm:m^3/mol T:K
  [../]
  [./energy_constant]
    type = GenericConstantMaterial
    prop_names = 'g_Alpha_Cu g_Alpha_Sn g_Ser_Sn g_L_Cu g_L_Sn l_Alpha_0 l_Alpha_1 l_L_0 l_L_1 l_L_2'
    prop_values = '-19073 -27280 346160 -11083 -28963 -11448 -11694 -10487 -18198 10528.4'    # J/mol
  [../]
  [./f_Cu]
    type = DerivativeParsedMaterial
    f_name = f_Cu
    args = 'c_Cu'
    material_property_names = 'Vm g_Alpha_Cu g_Alpha_Sn l_Alpha_0 l_Alpha_1'
    # About unit of f: the unit of Vm is m^3/mol. c is the molar percenage of Sn. f is the free energy density.
    function = '1/Vm * ((1-c_Cu)*g_Alpha_Cu + c_Cu*g_Alpha_Sn + R*T*((1-c_Cu)*log(1-c_Cu) + c_Cu*log(c_Cu)) + c_Cu*(1-c_Cu) * (l_Alpha_0 + l_Alpha_1*(1-2*c_Cu)))'
    [../]
  [./f_IMC]
    type = DerivativeParsedMaterial
    f_name = f_IMC
    args = 'c_Eta1'
    material_property_names = 'g_Alpha_Cu g_Ser_Sn T'
    function = '1/Vm * (2e5*(c_Eta1-0.435)^2 + 0.545*g_Alpha_Cu + 0.455*g_Ser_Sn - 6869.5 - 0.1589*T)'
  [../]
  [./f_Sn]
    type = DerivativeParsedMaterial
    f_name = f_Sn
    args = 'c_Sn'
    material_property_names = 'g_L_Cu g_L_Sn R T l_L_0 l_L_1'
    function = '1/Vm * ((1-c_Sn)*g_L_Cu + c*g_L_Sn + R*T*((1-c_Sn)*log(1-c_Sn)+c_Sn*log(c_Sn)) + c_Sn*(1-c_Sn)*(l_L_0+l_L_1*(1-2*c_Sn)+l_L_2(1-4*c_Sn-4*c_Sn^2)))'
  [../]
[]

[Executioner]
  type =  Transient
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
  file_base = 2cu6sn5
[]
