import { hapTasks } from '@ohos/hvigor-ohos-plugin';

export default {
  system: hapTasks, /* Built-in plugin of Hvigor. It cannot be modified. */
  plugins: []       /* Custom plugin to extend the functionality of Hvigor. */
}
// /*
//  * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
//  */
//
// // Script for compiling build behavior. It is built in the build plug-in and cannot be modified currently.
// import { getHvigorNode } from '@ohos/hvigor';
// import { hapTasks } from '@ohos/hvigor-ohos-plugin';
// import * as path from 'path';
// import { executeOnlineSign, onlineSignHap } from '../../signature/sign.js';
//
// const mModule = getHvigorNode(__filename);
// const ohosPlugin = hapTasks(mModule);
//
// const mModuleName = mModule.getName();
// const projectRootPath = process.cwd();
//
// // 若是 feature 模块签名，此处填写依赖的entry模块名称
// const entryName = '';
//
// onlineSignHap(mModule, ohosPlugin, (targetService) => {
//   let curProductName = targetService.getTargetData().getProduct().name;
//   let curTargetName = targetService.getTargetData().getTargetName();
//   // 构建的未签名的hap的输出根目录
//   const moduleBuildOutputDir =
//     path.resolve(projectRootPath, `feature/${mModuleName}/build/${curProductName}/outputs/${curTargetName}/`);
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
//
