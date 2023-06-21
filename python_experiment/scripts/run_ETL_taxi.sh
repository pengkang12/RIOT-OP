home_path="/home/cc/"
home_source=${home_path}"storm/riot-bench/modules/tasks/src/main/resources/"


${home_path}storm/bin/storm kill ETLTopologyTAXI

# set the input rate
IMG_WIDTH=$1
IMG2_WIDTH=100
inputRate=$(echo "$IMG_WIDTH $IMG2_WIDTH" | awk '{printf "%.4f \n", $1/$2}')
echo $inputRate
# choose the scheduler methods
cd ~/storm/riot-bench/

#~/maven/bin/mvn clean compile package -DskipTests

cd -

sleep 60


${home_path}storm/bin/storm jar ${home_path}storm/riot-bench/modules/storm/target/iot-bm-storm-0.1-jar-with-dependencies.jar in.dream_lab.bm.stream_iot.storm.topo.apps.ETLTopology C ETLTopologyTAXI ${home_source}TAXI_sample_data_senml.csv SENML $inputRate   ${home_path}storm/riot-bench/output/    ${home_source}tasks_TAXI.properties  test $topologyMap

# storm jar <stormJarPath>   in.dream_lab.bm.stream_iot.storm.topo.micro.MicroTopologyDriver  C  <TopoName>  <inputDataFilePath used by CustomEventGen and spout>   PLUG-<expNum>  <rate as 1x,2x>  <outputLogPath>   <tasks.properties File Path>   <microTaskName>
 
