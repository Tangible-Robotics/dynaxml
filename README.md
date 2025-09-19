# dynaxml
Mako-based tool for easy generation of MuJoCo XML kinematic chains with Dynamixel servos

## Installation

Clone the repository. Install Mako via pip.

Optional: run `source env.sh` to make dynaxml available globally, so you can call it from any directory in your system.

## Getting started

Run the provided example file:

```python dynaxml.py example.xml.mako```

...and open the generated ```example.xml``` in MuJoCo.

Coming soon: documentation of the coordinate frame conventions used by dynaxml.

## URDF conversion

dynaxml output can be converted to urdf using the [https://github.com/Yasu31/mjcf_urdf_simple_converter](mjcf_urdf_simple_converter) tool.

Since this tool only recognizes mesh geometry (as opposed to primitives), dynaxml has an option (now enabled by default) to use simple meshes for all the geometry it creates for the servos. You can change that setting in the header of ```dynamixel.xml.mako```. Make sure to also use only meshes in any geometry you create yourself.

Also, mjcf_urdf_simple_converter only creates \<visual\> geometry tags, and many "intermediate" links with no geometry. This casuses the MoveIt! Setup Assistant to crash. To simplify the process, a simple script is provided here to do the conversion from xml to urdf, duplicate all \<visual\> geometry as \<collision\> geometry in the resulting .urdf, and create some bogus geometry (a small sphere) in any link that has none. This can be used as follows:

```python3 xml2urdf.py input.xml output.urdf package_name```

This will output a .urdf ready to go in the urdf folder of a ROS2 package called ```package_name```. Make sure to also copy over the generated meshes, and place them in urdf/meshes. At this pint, the resulting .urdf should be usable with the MoveIt! Setup Assistant.