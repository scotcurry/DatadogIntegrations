## Overview ##

The agent and the collector can be deployed in separate locations.  Both have config maps for configuration.  You specifically need to update the collector config-map to deal with the appropriate oltp exporter.  Called out in the collector-config-map.yaml file.