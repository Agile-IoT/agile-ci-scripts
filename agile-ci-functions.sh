#!/usr/bin/env bash
function get_docker_tag {
  # if is PR set DOCKER_TAG to PR BRANCH NAME
  if [[ ${TRAVIS_PULL_REQUEST} != "false" ]]; then
    echo "$TRAVIS_PULL_REQUEST_BRANCH-$TRAVIS_PULL_REQUEST_SHA";
    return 0;
  fi
  # if is not PR but has a git tag
  if [[ ${TRAVIS_PULL_REQUEST} == "false" && -n ${TRAVIS_TAG} ]]; then
    echo "$TRAVIS_TAG";
    return 0;
  fi
  if [[ ${TRAVIS_PULL_REQUEST} == "false" && -z ${TRAVIS_TAG} ]]; then
    echo "$TRAVIS_BRANCH";
    return 0;
  fi

}

function bootstrap {
  export DOCKER_TAG
  DOCKER_TAG=$(get_docker_tag)
  echo "DOCKER_TAG set as $DOCKER_TAG"
  git fetch --tags
  git config --global user.name "Agile CI Bot" && git config --global user.email "bot@http://agile-iot.eu/"
  docker run --rm --privileged multiarch/qemu-user-static:register
  if [ "$BASEIMAGE" ] ; then sed -i "s/^FROM .*/FROM $BASEIMAGE/" Dockerfile ; fi
  if [ -f "package.json" ]; then
  	echo "contains package.json - expect dependencies to be installed"
  else
    npm i git://github.com/resin-io/versionist.git#agile versionist-plugins;
  fi
}

# If a docker tag and image is present let's push it to dockerhub
function docker_push_if_needed {
  if [[ -n ${DOCKER_TAG} && ${DOCKER_IMAGE} ]]; then
    docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD";
    docker push $DOCKER_IMAGE:$DOCKER_TAG;
  else
    echo "DOCKER_TAG & DOCKER_IMAGE is not set, aborting push to dockerhub"
  fi
}

# If is on master and doesn't have tag and it's instructed by the versionist envar then run versionist
function versionist_if_needed {
  if [[ ${TRAVIS_PULL_REQUEST} == "false" && ${TRAVIS_BRANCH} == "master" && -z ${TRAVIS_TAG} && "$VERSIONIST" == "true" ]]; then
    git checkout master;
    git remote set-url origin https://$GH_TOKEN@github.com/agile-iot/$COMPONENT.git;
    versionist;
  fi
}

# Load Travis cache file into docker images, if available
function cache_load {
  if [ -f $DOCKER_CACHE_FILE ]; then
    gunzip -c $DOCKER_CACHE_FILE | docker load || true;
  fi
}

# Save docker images to Travis cache.
# Note: This has to be called in "script", otherwise the cache is not saved by Travis
function cache_save {
  if [[ ${TRAVIS_PULL_REQUEST} == "false" ]]; then
    mkdir -p $(dirname ${DOCKER_CACHE_FILE});
    docker save $(docker history -q $IMAGE:$DOCKER_TAG | grep -v '<missing>') | gzip > ${DOCKER_CACHE_FILE};
  fi
}
