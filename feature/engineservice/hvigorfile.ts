import { hapTasks } from '@ohos/hvigor-ohos-plugin';

export default {
  system: hapTasks, /* Built-in plugin of Hvigor. It cannot be modified. */
  plugins: []       /* Custom plugin to extend the functionality of Hvigor. */
}
// /*
//  * Copyright (c) Huawei Device Co., Ltd. 2023-2023. All rights reserved.
//  */
//
// // Script for compiling build behavior. It is built in the build plug-in and cannot be modified currently.
// import { hvigor, getHvigorNode, HvigorPlugin, HvigorNode, HvigorTaskContext, FileUtil } from '@ohos/hvigor';
// import { hapTasks, OhosAppContext, OhosHapContext, OhosPluginId, Target } from '@ohos/hvigor-ohos-plugin';
// import * as path from 'path';
// import { executeOnlineSign, onlineSignHap } from '../../signature/sign.js';
//
// const TAG = 'engineservice-hvigor';
// const path = require('path');
// const fs = require('fs');
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
// onlineSignHap(mModule, ohosPlugin, (targetService) => {
//   const curProductName = targetService.getTargetData().getProduct().name;
//   const curTargetName = targetService.getTargetData().getTargetName();
//   // 构建的未签名的hap的输出根目录
//   const moduleBuildOutputDir =
//     path.resolve(projectRootPath, `feature/engineservice/build/${curProductName}/outputs/${curTargetName}/`);
//   // 未签名的hap包路径
//   const inputFile = path.resolve(moduleBuildOutputDir,
//     `${mModuleName}${entryName ? '-' + entryName : ''}-default-unsigned.hap`);
//   // 签名后的hap包路径
//   const outputFile =
//     path.resolve(moduleBuildOutputDir, `${mModuleName}${entryName ? '-' + entryName : ''}-default-signed.hap`);
//   executeOnlineSign(inputFile, outputFile);
// });
//
// module.exports = {
//   ohos: ohosPlugin,
// };
//
