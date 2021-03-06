#-------------------------------------------------------------------------------
# Copyright (C) 2017 Create-Net / FBK.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
#     Create-Net / FBK - initial API and implementation
#-------------------------------------------------------------------------------
# If a docker tag and image is present let's push it to dockerhub
function docker_push_if_needed {
  if [[ -n ${DOCKER_TAG} && ${DOCKER_IMAGE} ]]; then
    docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD";
    docker push $DOCKER_IMAGE:$DOCKER_TAG;
  else
    echo "DOCKER_TAG & DOCKER_IMAGE is not set, aborting push to dockerhub"
    return 0
  fi
}

# If is on master and doesn't have tag and it's instructed by the versionist envar then run versionist
function versionist_if_needed {
  if [[ ${TRAVIS_PULL_REQUEST} == "false" && ${TRAVIS_BRANCH} == "master" && -z ${TRAVIS_TAG} && VERSIONIST ]]; then
    git checkout master;
    git remote set-url origin https://$GH_TOKEN@github.com/agile-iot/$COMPONENT.git;
    versionist;
  fi

}

docker_push_if_needed
versionist_if_needed
