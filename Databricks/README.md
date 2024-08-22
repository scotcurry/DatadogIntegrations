# Overview

It is possible to get a free trial.  This document will be based on GCP and [this](https://docs.gcp.databricks.com/en/getting-started/index.html) documentation.  The GCP Project ID is databricks-419918.

## GCP Setup

* Enable the Compute Engine API
* Updated the N2 CPU Quota to 100
* Go back to the Databricks in the Marketplace and start the trial
* **It takes a while for the trail to get enabled.** Email will be sent when it is up.

## Databricks Setup

Once you have a Databricks environment, you could will be able to log into it from the GCP console.

* Create compute - **I ended up using e2-highmem-2 16GB, 2 Core compute**
* Before you create the compute, there is a place to add an **init-script**.  This is what is shown in the Integration tile in the Datadog UI.
* On the Spark tab in the Advanced Settings when building compute is where you set environment variables.
* The init-script echos lots of values to to the file system.  You will need to look at this.  **Use brew to install the databricks [CLI](https://docs.databricks.com/en/dev-tools/cli/tutorial.html)**.
* Authenticate with the following command:
```databricks auth login --host https://527621034240877.7.gcp.databricks.com```.  It will do an OAuth redirect and you are in.