## Overview

This is the process used to get the Observability Pipeline example running.  Steps are as follows:


* Run the following command to start the container.
```
docker run -i -e DD_API_KEY=<DD_API_KEY>\
-e DD_OP_PIPELINE_ID=2f111af0-93b3-11ee-84a8-da7ad0900002 \
-e DD_SITE=datadoghq.com \
-p 8282:8282 --cd name observability-pipeline \
-v ./pipeline.yaml:/etc/observability-pipelines-worker/pipeline.yaml:ro \
datadog/observability-pipelines-worker run
```