#!/bin/bash
PROJ_NAME="rest-test"
echo "Start installation '$PROJ_NAME'..."

eval $(crc oc-env)

CRC_REGISTRY=default-route-openshift-image-registry.apps-crc.testing
export CRC_REGISTRY

docker login -u kubeadmin -p $(oc whoami -t) $CRC_REGISTRY

DEL_RES="$(oc get project.project.openshift.io/$PROJ_NAME --show-kind --ignore-not-found)"
if [ ${#DEL_RES} != 0 ]; 
then 
   oc delete project $PROJ_NAME

   DEL_RES="$(oc get project.project.openshift.io/$PROJ_NAME --show-kind --ignore-not-found)"
   echo "Waiting for delete project '$PROJ_NAME'..."
   while [ ${#DEL_RES} != 0 ]
   do
       echo "Waiting...";
       sleep 3;
       DEL_RES="$(oc get project.project.openshift.io/$PROJ_NAME --show-kind --ignore-not-found)";
   done && echo "Finish waiting for project deletion.\n";
fi

oc new-project $PROJ_NAME

cd ./springdemo
mvn clean install

docker build -t $PROJ_NAME/springdemo:latest ./
docker tag $PROJ_NAME/springdemo $CRC_REGISTRY/$PROJ_NAME/springdemo
docker push $CRC_REGISTRY/$PROJ_NAME/springdemo

cd ..

oc apply -f ./springdemo/yaml/deployment.yml -n $PROJ_NAME
oc apply -f ./springdemo/yaml/service.yml -n $PROJ_NAME
oc expose svc/springdemo -n $PROJ_NAME

echo "finish"
