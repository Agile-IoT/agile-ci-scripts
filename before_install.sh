#!/usr/bin/env bash
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
