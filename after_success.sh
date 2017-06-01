# If a docker tag and image is present let's push it to dockerhub
if [[ -n ${DOCKER_TAG} && ${DOCKER_IMAGE} ]]; then
  docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD";
  docker push $DOCKER_IMAGE:$DOCKER_TAG;
else
  echo "DOCKER_TAG & DOCKER_IMAGE is not set, aborting push to dockerhub"
fi

# If is on master and doesn't have tag and it's instructed by the versionist envar then run versionist
if [[ ${TRAVIS_PULL_REQUEST} == "false" && ${TRAVIS_BRANCH} == "master" && -z ${TRAVIS_TAG} && VERSIONIST ]]; then
  git checkout master;
  git remote set-url origin https://$GH_TOKEN@github.com/agile-iot/$COMPONENT.git;
  versionist;
fi
