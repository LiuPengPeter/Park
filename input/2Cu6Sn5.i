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
  [../]
  # phase concentration  Sn in Cu
  [./c_Cu]
      order = FIRST
      family = LAGRANGE
      initial_condition = 0.02    ##尺寸效应和初始的条件相关？（钎料中的cu浓度改变了自由能？？？）
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
      [./InitialCondition]
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

  #
  #CH equation
  #
  [./dcdt]
  type = TimeDerivative
  variable = c
  [../]

  [./Diffusion_Park]
  type = Diffusion_Park
  variable = c
  Diffusion = Diffusion
  etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  cs = 'c_Cu c_Eta1 c_Eta2 c_Sn'
  [../]

  #
  #AC equation for Cu
  #
  [./deta_Cudt]
  type = TimeDerivative
  variable = eta_Cu
  [../]

  [./ACMultiR1_eta_Cu]
    type = ACMultiR1
    variable = eta_Cu
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  [../]

  [./ACMultiR2_eta_Cu]
    type = ACMultiR2
    variable = eta_Cu
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  [../]

  [./ACMultiR3_eta_Cu]
    type = ACMultiR3
    variable = eta_Cu
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  [../]

  [./ACMultiR4_eta_Cu]
    type = ACMultiR4
    variable = eta_Cu
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  [../]

  [./ACMultiR5_eta_Cu]
    type = ACMultiR5
    variable = eta_Cu
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
    cs = 'c_Cu c_Eta1 c_Eta2 c_Sn'
    fs = 'f_Cu f_IMC f_Sn'
    dfdc = f_partial
    #化学势相等条件，用 f_Sn ?????
  [../]
  #
  #AC equation for Eta1
  #
  [./deta_Eta1dt]
  type = TimeDerivative
  variable = eta_Eta1
  [../]

  [./ACMultiR1_eta_Eta1]
    type = ACMultiR1
    variable = eta_Eta1
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  [../]

  [./ACMultiR2_eta_Eta1]
    type = ACMultiR2
    variable = eta_Eta1
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  [../]

  [./ACMultiR3_eta_Eta1]
    type = ACMultiR3
    variable = eta_Eta1
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  [../]

  [./ACMultiR4_eta_Eta1]
    type = ACMultiR4
    variable = eta_Eta1
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  [../]

  [./ACMultiR5_eta_Eta1]
    type = ACMultiR5
    variable = eta_Eta1
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
    cs = 'c_Cu c_Eta1 c_Eta2 c_Sn'
    fs = 'f_Cu f_IMC f_Sn'
    dfdc = f_partial
  [../]
  #
  #AC equation for eta_Eta2
  #
  [./deta_Eta2dt]
  type = TimeDerivative
  variable = eta_Eta2
  [../]

  [./ACMultiR1_eta_Eta2]
    type = ACMultiR1
    variable = eta_Eta2
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  [../]

  [./ACMultiR2_eta_Eta2]
    type = ACMultiR2
    variable = eta_Eta2
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  [../]

  [./ACMultiR3_eta_Eta2]
    type = ACMultiR3
    variable = eta_Eta2
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  [../]

  [./ACMultiR4_eta_Eta2]
    type = ACMultiR4
    variable = eta_Eta2
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  [../]

  [./ACMultiR5_eta_Eta2]
    type = ACMultiR5
    variable = eta_Eta2
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
    cs = 'c_Cu c_Eta1 c_Eta2 c_Sn'
    fs = 'f_Cu f_IMC f_Sn'
    dfdc = f_partial
  [../]
  #
  #AC equation for eta_Sn
  #
  [./deta_Sndt]
  type = TimeDerivative
  variable = eta_Sn
  [../]

  [./ACMultiR1_eta_Sn]
    type = ACMultiR1
    variable = eta_Sn
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  [../]

  [./ACMultiR2_eta_Sn]
    type = ACMultiR2
    variable = eta_Sn
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  [../]

  [./ACMultiR3_eta_Sn]
    type = ACMultiR3
    variable = eta_Sn
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  [../]

  [./ACMultiR4_eta_Sn]
    type = ACMultiR4
    variable = eta_Sn
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
  [../]

  [./ACMultiR5_eta_Sn]
    type = ACMultiR5
    variable = eta_Sn
    etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
    cs = 'c_Cu c_Eta1 c_Eta2 c_Sn'
    fs = 'f_Cu f_IMC f_Sn'
    dfdc = f_partial
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
    type = ParsedMaterial
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
    material_property_names = 'g_Alpha_Cu g_Ser_Sn'
    function = '1/Vm * (2e5*(c_Eta1-0.435)^2 + 0.545*g_Alpha_Cu + 0.455*g_Ser_Sn - 6869.5 - 0.1589*T)'
  [../]
  [./f_Sn]
    type = DerivativeParsedMaterial
    f_name = f_Sn
    args = 'c_Sn'
    material_property_names = 'g_L_Cu g_L_Sn R T l_L_0 l_L_1'
    function = '1/Vm * ((1-c_Sn)*g_L_Cu + c*g_L_Sn + R*T*((1-c_Sn)*log(1-c_Sn)+c_Sn*log(c_Sn)) + c_Sn*(1-c_Sn)*(l_L_0+l_L_1*(1-2*c_Sn)+l_L_2(1-4*c_Sn-4*c_Sn^2)))'
  [../]
  [./f_partial]
    type = DerivativeParsedMaterial
    f_name = f_partial
    function = 'dfdc_Sn'
    args = 'c_Sn'
    material_property_names = 'dfdc_Sn:=D[f_Sn,c_Sn]'
    derivative_order = 1
    outputs = exodus
  [../]
  [./h_eta_Cu]
      type = SwitchingFunctionMultiPhaseMaterial
      h_name = h_eta_Cu
      all_etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
      phase_etas = eta_Cu
  [../]
  [./h_eta_Eta1]
      type = SwitchingFunctionMultiPhaseMaterial
      h_name = h_eta_Eta1
      all_etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
      phase_etas = eta_Eta1
  [../]
  [./h_eta_Eta2]
      type = SwitchingFunctionMultiPhaseMaterial
      h_name = h_eta_Eta2
      all_etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
      phase_etas = eta_Eta2
  [../]
  [./h_eta_Sn]
      type = SwitchingFunctionMultiPhaseMaterial
      h_name = h_eta_Sn
      all_etas = 'eta_Cu eta_Eta1 eta_Eta2 eta_Sn'
      phase_etas = eta_Sn
  [../]
  [./Diffusion]
    type = ParsedMaterial
    material_property_names = 'h_eta_Cu h_eta_Eta1 h_eta_Eta2 h_eta_Sn'
    f_name = Diffusion
    constant_names = 'D_Cu D_IMC D_Sn'
    constant_expressions = '2e-18 4e-17 2e-12'
    function = 'D_Cu*h_eta_Cu+D_IMC*h_eta_Eta1+D_IMC*h_eta_Eta2+D_Sn*h_eta_Sn'
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
