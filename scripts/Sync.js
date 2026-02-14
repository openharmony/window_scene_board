/**
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
const path = require('path');
const CommandUtil = require('./CommandUtil');

const idePath = path.resolve(process.env.DEVECO_SDK_HOME, '..');
const nodePath = path.resolve(idePath, 'tools/node');
const hvigorPath = path.resolve(idePath, 'tools/hvigor/bin/hvigorw.js');
process.env.JAVA_HOME = path.resolve(idePath, 'jbr');
process.env.PATH = `${process.env.PATH};${nodePath};${process.env.JAVA_HOME}\\bin`;

(async () => {
  const begin = Date.now();
  await CommandUtil.run([process.execPath, hvigorPath, ...(`clean -p product=default --stacktrace --parallel --incremental --no-daemon`).split(' ')]);
  await CommandUtil.run([process.execPath, hvigorPath, ...(`--sync -p product=default --stacktrace --parallel --incremental --no-daemon`).split(' ')]);
  await CommandUtil.run([process.execPath, path.resolve(idePath, 'tools/ohpm/bin/pm-cli.js'), ...(`install --all --strict_ssl false`.split(' '))]);
  console.info(`Sync complete in ${Date.now() - begin} ms`);
})();