#!/bin/bash
PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
# Update the package lists for upgrades and new package installations
sudo apt-get update
sudo apt-get install -y wget tar python3 python3-pip openjdk-17-jdk

mkdir /cli_trino
cd /cli_trino
wget 'https://repo1.maven.org/maven2/io/trino/trino-cli/425/trino-cli-425-executable.jar'

# Create directory for Trino
cd --
mkdir /trino

# Navigate to the trino directory
cd --
cd /trino

# Download and extract Trino
wget 'https://repo1.maven.org/maven2/io/trino/trino-server/425/trino-server-425.tar.gz'
tar xzvf trino-server-425.tar.gz

# Rename the extracted directory and create necessary directories
mv trino-server-425 trino-server
cd --
cd /trino
mkdir trino-data
cd --
cd /trino
mkdir trino-server/etc

# Create and configure node.properties file
cat > trino-server/etc/node.properties << EOL
node.environment = production
node.id = trino-master
node.data-dir = /trino/trino-data
EOL

# Create and configure jvm.config file
cat > trino-server/etc/jvm.config << EOL
-server
-Xmx3G
-XX:InitialRAMPercentage=80
-XX:MaxRAMPercentage=80
-XX:G1HeapRegionSize=32M
-XX:+ExplicitGCInvokesConcurrent
-XX:+ExitOnOutOfMemoryError
-XX:+HeapDumpOnOutOfMemoryError
-XX:-OmitStackTraceInFastThrow
-XX:ReservedCodeCacheSize=512M
-XX:PerMethodRecompilationCutoff=10000
-XX:PerBytecodeRecompilationCutoff=10000
-Djdk.attach.allowAttachSelf=true
-Djdk.nio.maxCachedBufferSize=2000000
-XX:+UnlockDiagnosticVMOptions
-XX:+UseAESCTRIntrinsics
-Dfile.encoding=UTF-8
-XX:-G1UsePreventiveGC
-XX:GCLockerRetryAllocationCount=32
EOL

# Create and configure config.properties file
cat > trino-server/etc/config.properties << EOL
coordinator=true
node-scheduler.include-coordinator=false
http-server.http.port=8080
discovery.uri=http://$PRIVATE_IP:8080
EOL

# Create and configure log.properties file
cat > trino-server/etc/log.properties << EOL
io.trino=INFO
EOL

# Create catalog directory and configure connector properties
cd --
cd /trino
mkdir trino-server/etc/catalog

# Databricks connector
cat > trino-server/etc/catalog/databricks.properties << EOL
connector.name=delta_lake
hive.metastore=glue
hive.metastore.glue.region=ap-southeast-1
hive.metastore.glue.iam-role= ${role_arn}
hive.metastore.glue.aws-credentials-provider=com.amazonaws.auth.InstanceProfileCredentialsProvider
hive.metastore.glue.pin-client-to-current-region=false
hive.metastore.glue.max-connections=30
hive.metastore.glue.max-error-retries=11
EOL

# Redshift connector
cat > trino-server/etc/catalog/redshift.properties << EOL
connector.name=redshift
connection-url=jdbc:redshift://redshift-cluster-1.caysi7ehlfkv.ap-southeast-1.redshift.amazonaws.com:5439/dev
connection-user=awsuser
connection-password=Ducph4010
EOL

# S3 connector
cat > trino-server/etc/catalog/s3.properties << EOL
connector.name=hive
hive.metastore=glue
hive.s3.path-style-access=true
hive.metastore.glue.region= ap-southeast-1
hive.metastore.glue.iam-role= ${role_arn_glue}
hive.metastore.glue.aws-credentials-provider=com.amazonaws.auth.InstanceProfileCredentialsProvider
hive.metastore.glue.pin-client-to-current-region=false
hive.s3.ssl.enabled=false
hive.non-managed-table-writes-enabled=true
hive.parquet.use-column-names=true
EOL

# Set permissions for the Trino launcher
cd --
chmod +x /trino/trino-server/bin/launcher.py

# Start Trino
cd --
cd /trino/trino-server/bin
sudo python3 launcher.py run
sudo python3 launcher.py start


