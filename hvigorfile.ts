// module.exports = require('@ohos/hvigor-ohos-plugin').appTasks

/**
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

// Script for compiling build behavior. It is built in the build plug-in and cannot be modified currently.
import type { Project } from '@ohos/hvigor';
import { hvigor, getHvigorNode } from '@ohos/hvigor';
import { appTasks } from '@ohos/hvigor-ohos-plugin';
import fs from 'fs';
import path from 'path';
import crypto from 'crypto';
import { execSync } from 'child_process';
// import { uploadTestCases } from '@ohos/hypium-plugin';

const hvigorNode = getHvigorNode(__filename) as Project;
const appTask = appTasks(hvigorNode);

function getFileHash(filePath: string): string {
  const hash = crypto.createHash('md5');
  const buffer = fs.readFileSync(filePath);
  hash.update(buffer);
  return hash.digest('hex');
}

function copySignatureFile(sdkInfo): void {
  if (process.platform !== 'win32') {
    return;
  }

  console.log('Copy signature file begin');
  const hapSignTool = path.resolve(sdkInfo.getSdkToolchainsDir(), 'lib/hap-sign-tool.jar');
  fs.copyFileSync(hapSignTool, path.resolve(__dirname, 'signature/hap-sign-tool.jar'));
  const onlineSignTool = path.resolve(__dirname, 'signature/hapsign-online-plugin.jar');

  if (!fs.existsSync(onlineSignTool)) {
    console.log('Download hapsign-online-plugin.jar begin');
    console.log('Download hapsign-online-plugin.jar end');
  }

  console.log('Copy signature file end');
}

// 主要用于模块检查规则的定义，尤其是在应用配置合规性校验中起到关键作用。以下是核心要点解析：
function modifyArkDataSchemaConfig(sdkInfo): void {
  const file = path.resolve(sdkInfo.getSdkToolchainsDir(), '../../hms/toolchains/modulecheck/arkDataSchema.json');
  let content = fs.readFileSync(file, 'utf8');
  if (content.length === 0) {
    console.warn('arkdata schema file content is null', content.length);
    return;
  }
  let schema = JSON.parse(content);
  if (!schema.propertyNames || !schema.propertyNames.enum || !Array.isArray(schema.propertyNames.enum)) {
    console.warn('arkdata schema has incorrect propertyNames.enum parameter');
    return;
  }
  for (let i = 0; i < schema.propertyNames.enum.length; i++) {
    if (schema.propertyNames.enum[i] === 'searchConfig') {
      console.log('arkdata schema already has searchConfig');
      return;
    }
  }
  schema.propertyNames.enum.push('searchConfig');
  fs.writeFileSync(file, JSON.stringify(schema, null, 4));
  console.log('modify arkdata schema file success');
}

function updateSdkInterface(sdkInfo): void {
  if (process.platform !== 'win32') {
    return;
  }

  const sdkBasePath = path.resolve(sdkInfo.getSdkToolchainsDir(), '../');
  console.log('Update SDK interface begin');
  const result = execSync(`node ./hvigor/update-sdk-interface.js "${sdkBasePath}"`);
  console.log(result.toString());
}
//初始化后配置完就执行
hvigor.nodesEvaluated(() => {
  console.log('Current sdk test:');

  try {
    const taskService = appTask.getTaskService()!;
    const sdkInfo = taskService.getSdkInfo();
    const etsSdkVersion = require(path.resolve(sdkInfo.getSdkToolchainsDir(), '../ets/oh-uni-package.json')).version;
// sdk 版本
    console.log('Current sdk version:', etsSdkVersion);

    // copySignatureFile(sdkInfo);
    updateSdkInterface(sdkInfo);
    // modifyArkDataSchemaConfig(sdkInfo);
  } catch (e) {
    console.log('Prepare for build failed:', e);
  }
});

export default appTask;
