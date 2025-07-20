#!/bin/bash

echo "REMOTE_USER=$REMOTE_USER"
echo "HOST=$HOST"

REMOTE_USER="${REMOTE_USER}"
HOST="${STAGING_HOST}"
REGION="${AWS_REGION}"
APP_NAME="${APP_NAME}"
ACCOUNT_ID="${AWS_ACCOUNT_ID}"
TAG="${BUILD_NUMBER}"

IMAGE="$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$APP_NAME:$TAG"

echo "Deploying $IMAGE to $HOST"
sshpass -p $sshUserPass ssh -v -t -o StrictHostKeyChecking=no "$REMOTE_USER@$HOST" << EOF
  aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com
  docker pull $IMAGE
  docker stop $APP_NAME
  docker rm $APP_NAME
  docker run -d --name $APP_NAME -p 80:80 -v /var/log/nginx:/var/log/nginx $IMAGE 
EOF
curl http://$HOST
echo "Deployed $APP_NAME to $HOST"
