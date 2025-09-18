<%namespace name="dynamixel" file="dynamixel.xml.mako"/>

<mujoco>
 
  <worldbody>
    <light diffuse=".5 .5 .5" pos="0 0 10" dir="0 0 -1"/>

    <body name="palm" pos="0 0 0">
      <geom name="palm" pos="0.0 0 0.0" type="box" size="0.044 .016 .0150" rgba=".25 .25 1 1"/>

      <body name="finger" pos="-.056 0 0" euler="0 90 90">
    
      <!-- a regular servo in standard orientation-->
      ${dynamixel.xm540_start(name="servo1",next_body_name="link1",joint_name="joint1")}

        <!-- a "flipped" servo, also turned 90 degrees-->
        <frame pos="0 0 0" euler="0 90 0">
        ${dynamixel.xm540_start(name="servo2",next_body_name="link2",joint_name="joint2", orientation="flipped")}

          <!-- a regular servo, but mounted sideways, and with custom joint limits-->
          <frame pos="0 ${dynamixel.get_size("xm430_z_dim")/2.0} -0.02" euler="90 0 0">
          ${dynamixel.xm430_start("servo3","link3","joint3", lower_joint_limit="-90", upper_joint_limit="0")}

            <!-- a dual servo -->
            ${dynamixel.dualxc430_start("servo4","joint4", "joint5","link5")}

              <!-- another "flipped" servo-->
              ${dynamixel.xc330_start("servo6","link6", "joint6",orientation = "flipped")}

              ${dynamixel.xc330_end()}

            ${dynamixel.dualxc430_end()}

          <!--remember to close the frame tag-->
          ${dynamixel.xm430_end()}
          </frame>

        <!--remember to close the frame tag-->
        ${dynamixel.xm540_end()}
        </frame>

      ${dynamixel.xm540_end()}

      </body>
    </body>

  </worldbody>
</mujoco>