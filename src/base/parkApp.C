#include "parkApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
parkApp::validParams()
{
  InputParameters params = MooseApp::validParams();

  // Do not use legacy DirichletBC, that is, set DirichletBC default for preset = true
  params.set<bool>("use_legacy_dirichlet_bc") = false;

  return params;
}

parkApp::parkApp(InputParameters parameters) : MooseApp(parameters)
{
  parkApp::registerAll(_factory, _action_factory, _syntax);
}

parkApp::~parkApp() {}

void
parkApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAll(f, af, s);
  Registry::registerObjectsTo(f, {"parkApp"});
  Registry::registerActionsTo(af, {"parkApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
parkApp::registerApps()
{
  registerApp(parkApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
parkApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  parkApp::registerAll(f, af, s);
}
extern "C" void
parkApp__registerApps()
{
  parkApp::registerApps();
}
