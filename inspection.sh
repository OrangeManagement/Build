#!/bin/bash

# Include
. config.sh

# Executing unit tests
. Inspection/Php/tests.sh

# Stats & metrics
. Inspection/Php/stats.sh

# Local inspection
. Inspection/Php/tools.sh

# Linting
. Inspection/Php/linting.sh
. Inspection/Json/linting.sh

# Custom html inspections
. Inspection/Html/tags.sh
. Inspection/Html/attributes.sh

# Custom php inspections
. Inspection/Php/security.sh
