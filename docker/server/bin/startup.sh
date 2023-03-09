#!/bin/sh

# Setting up configuration
echo "Setting up configuration file..."
cd /app/libs
echo "Property file: $CONFIG_PROP"
echo "Remote property file: $REMOTE_CONFIG_PROP"
export config_file=

if [ -n "${REMOTE_CONFIG_PROP}" ]; then
  echo "Downloading remote config file..."
  gcloud storage cp $REMOTE_CONFIG_PROP /app/config/config-remote.properties
  export config_file=/app/config/config-remote.properties
elif [ -n "${CONFIG_PROP}" ]; then
  echo "Using config file..."
  export config_file=/app/config/$CONFIG_PROP
else
  echo "Using an in-memory instance of conductor";
  export config_file=/app/config/config-local.properties
fi

# Run Conductor
echo "Using java options config: $JAVA_OPTS"
java ${JAVA_OPTS} -jar -DCONDUCTOR_CONFIG_FILE=$config_file conductor-server-*-boot.jar 2>&1 | tee -a /app/logs/server.log
