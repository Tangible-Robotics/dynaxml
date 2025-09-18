#!/bin/bash

# Export the current directory as DYNAXML_PATH
export DYNAXML_PATH="$(pwd)"

# Add the current directory to PATH (if not already there)
case ":$PATH:" in
    *":$DYNAXML_PATH:"*) ;;
    *) export PATH="$DYNAXML_PATH:$PATH" ;;
esac

# Make dynaxml.py executable
chmod +x "$DYNAXML_PATH/dynaxml.py"
