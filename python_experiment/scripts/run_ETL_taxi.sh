home_path="/home/cc/"
home_source=${home_path}"storm/riot-bench/modules/tasks/src/main/resources/"


${home_path}storm/bin/storm kill ETLTopologyTAXI

# set the input rate
IMG_WIDTH=$1
IMG2_WIDTH=100
inputRate=$(echo "$IMG_WIDTH $IMG2_WIDTH" | awk '{printf "%.4f \n", $1/$2}')
echo $inputRate
# choose the scheduler methods
option=$2
case "$option" in
   "test") echo "using test scheduler"
	topologyMap="spout1:core1,SenMlParseBolt:worker1,RangeFilterBolt:worker1,BloomFilterBolt:worker1,InterpolationBolt:worker1,JoinBolt:worker1,AnnotationBolt:worker1,CsvToSenMLBolt:worker1,PublishBolt:edge4,sink:worker1"
   ;;
   "default") echo "using default scheduler"
	topologyMap="spout1:core1,SenMlParseBolt:edge4,RangeFilterBolt:core1,BloomFilterBolt:core1,InterpolationBolt:edge4,JoinBolt:core1,AnnotationBolt:edge4,CsvToSenMLBolt:edge4,PublishBolt:edge4,sink:core1"
   ;;
   "resource") echo "using resource aware scheduler"
	# Resource aware 
      	topologyMap="spout1:core1,SenMlParseBolt:edge4,RangeFilterBolt:edge4,BloomFilterBolt:edge4,InterpolationBolt:edge4,JoinBolt:edge4,AnnotationBolt:edge4,CsvToSenMLBolt:edge4,PublishBolt:edge4,sink:core1"
   ;; 
   "amnis") echo "using amnis scheduler"
 	# Amnis methods
   	topologyMap="spout1:edge4,SenMlParseBolt:edge4,RangeFilterBolt:edge4,BloomFilterBolt:edge4,InterpolationBolt:edge4,JoinBolt:edge4,AnnotationBolt:edge4,CsvToSenMLBolt:core1,PublishBolt:core1,sink:core1"
   ;; 
   "coda") echo "using coda scheduler"
 	# coda methods
	topologyMap="spout1:core1,SenMlParseBolt:edge4,RangeFilterBolt:core,BloomFilterBolt:core,InterpolationBolt:core,JoinBolt:core,AnnotationBolt:core,CsvToSenMLBolt:core,PublishBolt:core,sink:core"
   ;;
   "beaver") echo "using beaver scheduler"
 	# beaver 
   	topologyMap="spout1:core1,SenMlParseBolt:edge4,RangeFilterBolt:edge4,BloomFilterBolt:edge4,InterpolationBolt:edge4,JoinBolt:edge4,AnnotationBolt:edge4,CsvToSenMLBolt:core,PublishBolt:core,sink:core"
   ;; 
esac
 
cd ~/storm/riot-bench/

#~/maven/bin/mvn clean compile package -DskipTests

cd -

sleep 60


${home_path}storm/bin/storm jar ${home_path}storm/riot-bench/modules/storm/target/iot-bm-storm-0.1-jar-with-dependencies.jar in.dream_lab.bm.stream_iot.storm.topo.apps.ETLTopology C ETLTopologyTAXI ${home_source}TAXI_sample_data_senml.csv SENML $inputRate   ${home_path}storm/riot-bench/output/    ${home_source}tasks_TAXI.properties  test $topologyMap

# storm jar <stormJarPath>   in.dream_lab.bm.stream_iot.storm.topo.micro.MicroTopologyDriver  C  <TopoName>  <inputDataFilePath used by CustomEventGen and spout>   PLUG-<expNum>  <rate as 1x,2x>  <outputLogPath>   <tasks.properties File Path>   <microTaskName>
 
