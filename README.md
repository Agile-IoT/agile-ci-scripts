<!--
# Copyright (C) 2017 Create-Net / FBK.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
# 
# Contributors:
#     Create-Net / FBK - initial API and implementation
-->

# Agile-ci-scripts

> a couple of shell functions to help with travis builds

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
