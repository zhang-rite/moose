# Considers the mechanics solution for a thick spherical shell that is uniformly
# pressurized on the inner and outer surfaces, using 2D axisymmetric geometry.
# This test uses the strain calculators ComputeAxisymmetricRZSmallStrain
# and ComputeAxisymmetricRZIncrementalStrain which are generated by the
# TensorMechanics MasterAction depending on the cli_args given in the tests file.
#
# From Roark (Formulas for Stress and Strain, McGraw-Hill, 1975), the radially-dependent
# circumferential stress in a uniformly pressurized thick spherical shell is given by:
#
# S(r) = [ Pi[ri^3(2r^3+ro^3)] - Po[ro^3(2r^3+ri^3)] ] / [2r^3(ro^3-ri^3)]
#
#   where:
#          Pi = inner pressure
#          Po = outer pressure
#          ri = inner radius
#          ro = outer radius
#
# The tests assume an inner and outer radii of 5 and 10, with internal and external
# pressures of 100000 and 200000, respectively. The resulting compressive tangential
# stress is largest at the inner wall and, from the above equation, has a value
# of -271429.

[Mesh]
  file = 2D-RZ_mesh.e
[]

[GlobalParams]
  displacements = 'disp_r disp_z'
[]

[Problem]
  coord_type = RZ
[]

[Modules/TensorMechanics/Master]
  [./all]
    strain = SMALL
    add_variables = true
    generate_output = 'stress_zz'
    use_automatic_differentiation = true
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ADComputeIsotropicElasticityTensor
    youngs_modulus = 1e10
    poissons_ratio = 0.345
  [../]
  [./stress]
  [../]
[]

[BCs]
# pin particle along symmetry planes
  [./no_disp_r]
    type = DirichletBC
    variable = disp_r
    boundary = xzero
    value = 0.0
  [../]

  [./no_disp_z]
    type = DirichletBC
    variable = disp_z
    boundary = yzero
    value = 0.0
  [../]

# exterior and internal pressures
  [./exterior_pressure_r]
    type = ADPressure
    variable = disp_r
    boundary = outer
    component = 0
    constant = 200000
  [../]

 [./exterior_pressure_z]
    type = ADPressure
    variable = disp_z
    boundary = outer
    component = 1
    constant = 200000
  [../]

  [./interior_pressure_r]
    type = ADPressure
    variable = disp_r
    boundary = inner
    component = 0
    constant = 100000
  [../]

  [./interior_pressure_z]
    type = ADPressure
    variable = disp_z
    boundary = inner
    component = 1
    constant = 100000
  [../]
[]

[Debug]
  show_var_residual_norms = true
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient

  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter'
  petsc_options_value = '  201               hypre    boomeramg      10'

  line_search = 'none'

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'

  nl_rel_tol = 5e-9
  nl_abs_tol = 1e-10
  nl_max_its = 15

  l_tol = 1e-3
  l_max_its = 50

  start_time = 0.0
  end_time = 1
#  num_steps = 1000

  dtmax = 5e6
  dtmin = 1

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
    optimal_iterations = 6
    iteration_window = 0
    linear_iteration_ratio = 100
  [../]

  [./Predictor]
    type = SimplePredictor
    scale = 1.0
  [../]

[]

[Postprocessors]
  [./dt]
    type = TimestepSize
  [../]
[]

[Outputs]
  exodus = true
[]
