#!/usr/bin/env bash
function get_docker_tag {
  # if is PR set DOCKER_TAG to PR BRANCH NAME
  if [[ ${TRAVIS_PULL_REQUEST} != "false" ]]; then
    echo "$TRAVIS_PULL_REQUEST_BRANCH-$TRAVIS_PULL_REQUEST_SHA";
    # return 0;
  fi
  # if is not PR but has a git tag
  if [[ ${TRAVIS_PULL_REQUEST} == "false" && -n ${TRAVIS_TAG} ]]; then
    echo "$TRAVIS_TAG";
    # return 0;
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

bootstrap
