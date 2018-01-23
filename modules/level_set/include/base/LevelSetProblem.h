/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#ifndef LEVELSETPROBLEM_H
#define LEVELSETPROBLEM_H

#include "FEProblem.h"

class LevelSetProblem;

template <>
InputParameters validParams<LevelSetProblem>();

/**
 * Problem that defines a custom call to MultiAppTransfers to allow for
 * adaptivity to be transferred from master to sub-application.
 */
class LevelSetProblem : public FEProblem
{
public:
  LevelSetProblem(const InputParameters & parameters);

  virtual bool adaptMesh() override;
};

#endif
