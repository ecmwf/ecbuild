#include "pythonlib.hpp"

BOOST_PYTHON_MODULE(libmypython)
{
  boost::python::scope().attr("__doc__") = "Python API for my python project";
}
