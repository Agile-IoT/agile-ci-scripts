# Agile-ci-scripts

> a couple scripts to help with travis builds

Requirements:

* `versionist.conf.js` - must be in root directory.
* if you have a package.json in your root you must install `versionist` + `versionist-plugins`.

Required environment variables:

| Environment variable | example                    |
|-----------------------|----------------------------|
| COMPONENT             | agile-example              |
| DOCKER_IMAGE          | agileiot/$COMPONENT-armv7l |
| GH_TOKEN              | asdfadsfadsfasfadsfa       |
| DOCKER_USERNAME       | craycraig                  |
| DOCKER_PASSWORD       | xxxx                       |

For a working example check out [agile-example](https://github.com/Agile-IoT/agile-example).
