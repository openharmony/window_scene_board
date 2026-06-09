import { hapTasks } from '@ohos/hvigor-ohos-plugin';

export default {
  system: hapTasks, /* Built-in plugin of Hvigor. It cannot be modified. */
  plugins: []       /* Custom plugin to extend the functionality of Hvigor. */
}
// /**
//  * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
//  * Licensed under the Apache License, Version 2.0 (the "License");
//  * you may not use this file except in compliance with the License.
//  * You may obtain a copy of the License at
//  *
//  *     http://www.apache.org/licenses/LICENSE-2.0
//  *
//  * Unless required by applicable law or agreed to in writing, software
//  * distributed under the License is distributed on an "AS IS" BASIS,
//  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  * See the License for the specific language governing permissions and
//  * limitations under the License.
//  */
//
// // Script for compiling build behavior. It is built in the build plug-in and cannot be modified currently.
// import { hvigor, getHvigorNode } from '@ohos/hvigor';
// import { hapTasks } from '@ohos/hvigor-ohos-plugin';
// import * as path from 'path';
// import { executeOnlineSign, onlineSignHap } from '../../signature/sign.js';
// import { initTesting } from '@ohos/hypium-plugin';
//
// const mModule = getHvigorNode(__filename);
// const ohosPlugin = hapTasks(mModule);
//
// const mModuleName = mModule.getName();
// const projectRootPath = process.cwd();
//
// // 若是feature模块签名，此处填写依赖的entry模块名称
// const entryName = '';
//
// // 配置需要进行签名 + 测试的模块
// const config = {
//   hvigor: hvigor,
//   packageConfig : {
//     // 自定义测试包的名称，当前与模块名一致
//     appName: 'PCDockAndAppCenter',
//     // hvigor 命令行参数
//     commandParams: hvigor.getExtraConfig(),
//     // 当前模块对象
//     module: mModule
//   },
//   signConfig: {
//     p7bFilePath: 'signature/sceneboard.p7b', // p7b签名文件路径,支持全路径或基于新项目文件夹的相对路径
//     keyAlias: 'SceneBoard' // 可以不填，默认是"HOS Application Provision Debug"
//   }
// };
//
// function isDtInLinux():boolean {
//   const temp = process.env.IS_DT_IN_LINUX;
//   console.log(`isDtInLinux:${temp}`);
//   if (temp === true || temp === 'true') {
//     return true;
//   }
//   return false;
// }
//
// if (isDtInLinux()) {
//   initTesting(config);
// }
//
// onlineSignHap(mModule, ohosPlugin, (targetService) => {
//   const curProductName = targetService.getTargetData().getProduct().name;
//   const curTargetName = targetService.getTargetData().getTargetName();
//   // 构建的未签名的hap的输出根目录
//   const moduleBuildOutputDir = path.resolve(projectRootPath,
//     `product/pc/build/${curProductName}/outputs/${curTargetName}/`);
//   // 未签名的hap包路径
//   const inputFile = path.resolve(moduleBuildOutputDir,
//     `${mModuleName}${entryName ? '-' + entryName : ''}-${curTargetName}-unsigned.hap`);
//   // 签名后的hap包路径
//   const outputFile = path.resolve(moduleBuildOutputDir,
//     `${mModuleName}${entryName ? '-' + entryName : ''}-${curTargetName}-signed.hap`);
//   executeOnlineSign(inputFile, outputFile);
// });
//
// module.exports = {
//   ohos: ohosPlugin
// };