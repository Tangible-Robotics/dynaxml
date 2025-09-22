#!/usr/bin/env python3
from mako.lookup import TemplateLookup
from mako.template import Template
from mako import exceptions

import argparse
import os
import sys

def main():

  parser = argparse.ArgumentParser()
  parser.add_argument("input", type=str)
  parser.add_argument("--output", type=str)
  args=parser.parse_args()

  if "DYNAXML_PATH" in os.environ:
    lookup = TemplateLookup(directories=[os.environ.get("DYNAXML_PATH")]) 
  else:
    lookup = TemplateLookup(directories=["."]) 
    print("DYNAXML_PATH environment variable not set, looking for templates in current directory")

  # Load the top-level robot template
  template = Template(filename=args.input, lookup = lookup)

  if args.output is None:
    if args.input.endswith('.xml.mako'):
        outfile = args.input.removesuffix('.mako')
    else:
       raise ValueError("Specify output file via --output, or use an input file that ends with .xml.mako")
  else:
     outfile = args.output
  print("Saving to ", outfile)

  # Render the template with global parameters (if any)
  try:
    xml_output = template.render()
  except:
    print(exceptions.text_error_template().render())
    print("mako parsing failed")
    sys.exit(1)

  # Save result to a MuJoCo XML file
  with open(outfile, "w") as f:
    f.write(xml_output)

  print("xml generated")

if __name__ == "__main__":
    main()
