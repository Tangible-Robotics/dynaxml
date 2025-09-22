#!/usr/bin/env python3
import sys
import copy
import os
import xml.etree.ElementTree as ET
from mjcf_urdf_simple_converter import convert


def process_urdf(urdf_file, package_name):
    tree = ET.parse(urdf_file)
    root = tree.getroot()

    robot_name = os.path.splitext(os.path.basename(urdf_file))[0]
    if root.tag == "robot":
        root.set("name", robot_name)
        print(f"Robot name in urdf set to '{robot_name}'")

    print("Ensuring every link has both visual and collision geometry")
    for link in root.findall("link"):
        visuals = link.findall("visual")
        collisions = link.findall("collision")

        # Case 1: Link has <visual> but no <collision>
        if visuals and not collisions:
            for vis in visuals:
                new_collision = copy.deepcopy(vis)
                new_collision.tag = "collision"
                link.append(new_collision)

        # Case 2: Link has neither
        if not visuals and not collisions:
            sphere_xml = ET.Element("geometry")
            sphere = ET.SubElement(sphere_xml, "sphere")
            sphere.set("radius", "0.002")

            vis = ET.Element("visual")
            vis.append(copy.deepcopy(sphere_xml))
            link.append(vis)

            col = ET.Element("collision")
            col.append(copy.deepcopy(sphere_xml))
            link.append(col)

    print("Ensuring all joint velocity limits are written as floats")
    for joint in root.findall("joint"):
        limit = joint.find("limit")
        if limit is not None and "velocity" in limit.attrib:
            v = limit.attrib["velocity"]
            try:
                # Convert to float and back, forcing ".0" if integer
                v_float = float(v)
                if v_float.is_integer():
                    v_float = v_float + 0.1
                limit.attrib["velocity"] = str(v_float)
            except ValueError:
                print(f"[WARN] Joint '{joint.attrib['name']}': velocity '{v}' is not a number, skipping")
    

    indent(root)
    tree.write(urdf_file, encoding="utf-8", xml_declaration=True)
    print(f"URDF post-processed and saved: {urdf_file}")
    print(f"'{urdf_file}' should now go in '{package_name}/urdf', and the generated mesh files found in './meshes' should go in '{package_name}/urdf/meshes'")


def indent(elem, level=0):
    """Pretty-print XML (recursive)."""
    i = "\n" + level * "  "
    if len(elem):
        if not elem.text or not elem.text.strip():
            elem.text = i + "  "
        for e in elem:
            indent(e, level + 1)
        if not e.tail or not e.tail.strip():
            e.tail = i
    if level and (not elem.tail or not elem.tail.strip()):
        elem.tail = i


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python3 xml2urdf.py input.xml output.urdf package_name")
        sys.exit(1)

    xml_file = sys.argv[1]
    urdf_file = sys.argv[2]
    package_name = sys.argv[3]

    # Step 1: Convert MJCF XML → URDF
    print(f"Converting {xml_file} → {urdf_file}")
    prefix = f"package://{package_name}/urdf/"
    convert(xml_file, urdf_file, asset_file_prefix = prefix)

    # Step 2: Add collisions + fix mesh paths
    process_urdf(urdf_file, package_name)
