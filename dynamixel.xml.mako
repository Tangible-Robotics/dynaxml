
<%!
    use_primitives = False

    xc330_x_dim = 0.023
    xc330_y_dim = 0.034
    xc330_z_dim = 0.020
    xc330_face_to_axis = 0.0095
    xc330_bracket_clearance = 0.014

    xm430_x_dim = 0.0340
    xm430_y_dim = 0.0465
    xm430_z_dim = 0.0285
    xm430_face_to_axis = 0.01125
    xm430_bracket_clearance = 0.020

    xm540_x_dim = 0.0440
    xm540_y_dim = 0.0585
    xm540_z_dim = 0.0335
    xm540_face_to_axis = 0.01375
    xm540_bracket_clearance = 0.022

    dualxc430_x_dim = 0.0360
    dualxc430_y_dim = 0.0465
    dualxc430_z_dim = 0.0360
    dualxc430_face_to_axis = 0.01125
    dualxc430_bracket_clearance = 0.022

sizes = {
    "xc330_x_dim": xc330_x_dim,
    "xc330_y_dim": xc330_y_dim,
    "xc330_z_dim": xc330_z_dim,
    "xc330_face_to_axis": xc330_face_to_axis,
    "xc330_bracket_clearance": xc330_bracket_clearance,

    "xm430_x_dim": xm430_x_dim,
    "xm430_y_dim": xm430_y_dim,
    "xm430_z_dim": xm430_z_dim,
    "xm430_face_to_axis": xm430_face_to_axis,
    "xm430_bracket_clearance": xm430_bracket_clearance,

    "xm540_x_dim": xm540_x_dim,
    "xm540_y_dim": xm540_y_dim,
    "xm540_z_dim": xm540_z_dim,
    "xm540_face_to_axis": xm540_face_to_axis,
    "xm540_bracket_clearance": xm540_bracket_clearance,

    "dualxc430_x_dim": dualxc430_x_dim,
    "dualxc430_y_dim": dualxc430_y_dim,
    "dualxc430_z_dim": dualxc430_z_dim,
    "dualxc430_face_to_axis": dualxc430_face_to_axis,
    "dualxc430_bracket_clearance": dualxc430_bracket_clearance,
}%>

<%def name="box_mesh(name, x, y, z)">
<%
    xh = x/2.0
    yh = y/2.0
    zh = z/2.0
%>
<asset>
  <mesh name="${name}" vertex=" ${xh}  ${yh}  ${zh}
                               -${xh}  ${yh}  ${zh}
                                ${xh} -${yh}  ${zh}
                                ${xh}  ${yh} -${zh}
                                ${xh} -${yh} -${zh}
                               -${xh}  ${yh} -${zh}
                               -${xh} -${yh}  ${zh}
                               -${xh} -${yh} -${zh}
                                "/>
</asset>
</%def>

<%def name="get_meshes()">
${box_mesh("xc330", xc330_x_dim, xc330_y_dim,xc330_z_dim)}
${box_mesh("xm430", xm430_x_dim, xm430_y_dim,xm430_z_dim)}
${box_mesh("xm540", xm540_x_dim, xm540_y_dim,xm540_z_dim)}
${box_mesh("dualxc430_half", dualxc430_x_dim, dualxc430_y_dim /2.0, dualxc430_z_dim)}
${box_mesh("xc330_bracket", xc330_x_dim+0.01, 0.002, xc330_z_dim)}
${box_mesh("xm430_bracket", xm430_x_dim+0.01, 0.002, xm430_z_dim)}
${box_mesh("xm540_bracket", xm540_x_dim+0.01, 0.002, xm540_z_dim)}
${box_mesh("dualxc430_half_bracket", dualxc430_x_dim+0.01, 0.002, dualxc430_z_dim)}
</%def>

<%def name="get_size(name)">
<% return sizes[name]%>
</%def>

<%def name="generic_servo_start(name, pos, euler,
                                next_body_name,joint_name,
                                x_dim,y_dim,z_dim,face_to_axis,bracket_clearance,
                                lower_joint_limit, upper_joint_limit,
                                mount, mesh = '')">
<%
    axis_size = x_dim + 0.006
    bracket_width = 0.002
    axis_to_next_body = bracket_clearance + bracket_width
%>
% if mount == "standard":
<body name="${name}_body" pos="${pos}" euler="${euler}">
% if use_primitives:
<geom name="${name}_body" type="box" size="${x_dim/2.0} ${y_dim/2.0} ${z_dim/2.0}" pos="0 ${y_dim/2.0} 0" rgba="0.5 0.5 0.75 1"/>
<geom name="${name}_axis" type="cylinder" size=".005 ${axis_size/2.0}" pos="0 ${y_dim-face_to_axis} 0" euler="0 90 0" contype="0" conaffinity="0"/>
% else:
<geom name="${name}_body" type="mesh" mesh="${mesh}" pos="0 ${y_dim/2.0} 0" rgba="0.5 0.5 0.75 1"/>
% endif
<body name="${name}_bracket" pos="0 ${y_dim-face_to_axis} 0" euler="0 0 0" >
  <inertial pos="0 0 0" mass="0.05" diaginertia="1e-5 1e-5 1e-5"/>
  <joint type="hinge" name="${joint_name}" axis="1 0 0" limited="true" range="${lower_joint_limit} ${upper_joint_limit}"/>  
% if use_primitives:
  <geom name="${name}_bracket_1" type="box" size="${axis_size/2.0} ${bracket_width/2.0} ${z_dim/2.0}" pos="0 ${axis_to_next_body-.001} 0" rgba=".25 .25 .25 1"/>
  <geom name="${name}_bracket_2" type="box" size="${bracket_width/2.0} ${(bracket_clearance+bracket_width)/2.0} ${z_dim/2.0}" pos="${axis_size/2.0-bracket_width/2.0} ${axis_to_next_body-(bracket_clearance+bracket_width)/2.0} 0" rgba=".25 .25 .25 1"/>
  <geom name="${name}_bracket_3" type="box" size="${bracket_width/2.0} ${(bracket_clearance+bracket_width)/2.0} ${z_dim/2.0}" pos="${-(axis_size/2.0-bracket_width/2.0)} ${axis_to_next_body-(bracket_clearance+bracket_width)/2.0} 0" rgba=".25 .25 .25 1"/>
% else:
  <geom name="${name}_bracket" type="mesh" mesh="${mesh}_bracket" pos="0 ${axis_to_next_body-.001} 0"/>
%endif
  <body name="${next_body_name}" pos="0 ${axis_to_next_body} 0">
% elif mount == "flipped":
<body name="${name}_bracket" pos="${pos}" euler="${euler}">
% if use_primitives:
  <geom name="${name}_prev_bracket_1" type="box" size="${axis_size/2.0} ${bracket_width/2.0} ${z_dim/2.0}" pos="0 .001 0" rgba=".25 .25 .25 1"/>
  <geom name="${name}_prev_bracket_2" type="box" size="${bracket_width/2.0} ${(bracket_clearance+bracket_width)/2.0} ${z_dim/2.0}" pos="${axis_size/2.0-bracket_width/2.0} ${(bracket_clearance+bracket_width)/2.0} 0" rgba=".25 .25 .25 1"/>
  <geom name="${name}_prev_bracket_3" type="box" size="${bracket_width/2.0} ${(bracket_clearance+bracket_width)/2.0} ${z_dim/2.0}" pos="${-(axis_size/2.0-bracket_width/2.0)} ${(bracket_clearance+bracket_width)/2.0} 0" rgba=".25 .25 .25 1"/>
% else:
  <geom name="${name}_bracket" type="mesh" mesh="${mesh}_bracket" pos="0 .001 0"/>
% endif
<body name="${name}_body" pos="0 ${axis_to_next_body} 0" euler="0 0 0" >
  <joint type="hinge" name="${joint_name}" axis="1 0 0" limited="true" range="-90 90"/>  
% if use_primitives:
  <geom name="${name}_axis1" type="cylinder" size=".005 ${axis_size/2.0}" pos="0 0 0" euler="0 90 0" contype="0" conaffinity="0"/>
  <geom name="${name}" type="box" size="${x_dim/2.0} ${y_dim/2.0} ${z_dim/2.0}" pos="0 ${y_dim/2.0-face_to_axis} 0" rgba="0.5 0.5 0.75 1"/>
%else:
  <geom name="${name}_body" type="mesh" mesh="${mesh}" pos="0 ${y_dim/2.0-face_to_axis} 0" rgba="0.5 0.5 0.75 1"/>
%endif
  <body name="${next_body_name}" pos="0 ${y_dim-face_to_axis} 0">
% else:
<!-- Unsupported mount ${mount} requested-->  
% endif
</%def>

<%def name="generic_servo_end()">
</body>
</body>
</body>
</%def>

<%def name="xc330_start(name,next_body_name,joint_name,
                        lower_joint_limit='-90', upper_joint_limit='90',
                        mount='standard', pos='0 0 0', euler='0 0 0'
                        )">
${generic_servo_start(name, pos, euler, next_body_name, joint_name, 
                      xc330_x_dim, xc330_y_dim, xc330_z_dim, xc330_face_to_axis, xc330_bracket_clearance,
                      lower_joint_limit, upper_joint_limit,
                      mount,'xc330')}
</%def>

<%def name="xc330_end()">
${generic_servo_end()}
</%def>


<%def name="xm430_start(name,next_body_name,joint_name,
                        lower_joint_limit='-90', upper_joint_limit='90',
                        mount='standard', pos='0 0 0', euler='0 0 0')">
${generic_servo_start(name, pos, euler, next_body_name, joint_name, 
                      xm430_x_dim, xm430_y_dim, xm430_z_dim, xm430_face_to_axis, xm430_bracket_clearance,
                      lower_joint_limit, upper_joint_limit,
                      mount,'xm430')}
</%def>

<%def name="xm430_end()">
${generic_servo_end()}
</%def>

<%def name="xm540_start(name,next_body_name,joint_name,
                        lower_joint_limit='-90', upper_joint_limit='90',
                        mount='standard', pos='0 0 0', euler='0 0 0')">
${generic_servo_start(name, pos, euler, next_body_name, joint_name, 
                      xm540_x_dim, xm540_y_dim, xm540_z_dim, xm540_face_to_axis, xm540_bracket_clearance,
                      lower_joint_limit, upper_joint_limit,
                      mount,'xm540')}
</%def>

<%def name="xm540_end()">
${generic_servo_end()}
</%def>

<%def name="dualxc430_start(name,joint1_name,joint2_name,next_body_name,
                            lower_joint1_limit='-90', upper_joint1_limit='90',
                            lower_joint2_limit='-90', upper_joint2_limit='90',
                            pos='0 0 0', euler='0 0 0')">
<%
    axis_size = dualxc430_x_dim + 0.006
    bracket_width = 0.002
    axis_to_next_body = dualxc430_bracket_clearance + bracket_width
    first_name = name + "first"
    bridge_name = name + "bridge"
    second_name = name + "second"
%>
${generic_servo_start(first_name, pos, euler, bridge_name, joint1_name, 
                      dualxc430_x_dim, dualxc430_y_dim/2.0, dualxc430_z_dim, dualxc430_face_to_axis, dualxc430_bracket_clearance,
                      lower_joint1_limit, upper_joint1_limit,
                      "flipped",'dualxc430_half')}
${generic_servo_start(second_name, "0 0 0", "0 90 0",
                      next_body_name, joint2_name, 
                      dualxc430_x_dim, dualxc430_y_dim/2.0, dualxc430_z_dim, dualxc430_face_to_axis, dualxc430_bracket_clearance,
                      lower_joint2_limit, upper_joint2_limit,
                      "standard",'dualxc430_half')}
</%def>

<%def name="dualxc430_end()">

</body>
</body>
</body>
</body>
</body>
</body>

</%def>
