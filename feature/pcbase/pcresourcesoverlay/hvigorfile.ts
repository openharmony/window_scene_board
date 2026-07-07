module.exports = require('@ohos/hvigor-ohos-plugin').hspTasks

// /*
//  * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
//  */
// import { getHvigorNode, hvigor } from '@ohos/hvigor';
// import { hspTasks } from '@ohos/hvigor-ohos-plugin';
// import * as path from 'path'
// import { executeOnlineSign, onlineSignHsp } from '../../../signature/sign';
//
// const mModule = getHvigorNode(__filename);
// const ohosPlugin = hspTasks(mModule);
//
// const mModuleName = mModule.getName();
// const projectRootPath = process.cwd();
//
// onlineSignHsp(mModule, ohosPlugin, (targetService) => {
//   const curProductName = targetService.getTargetData().getProduct().name;
//   const curTargetName = targetService.getTargetData().getTargetName();
//
//   // 构建的未签名的hsp的输出根目录
//   const moduleBuildOutputDir = path.resolve(projectRootPath + `/feature/pcbase`, mModuleName,
//     `build/${curProductName}/outputs/${curTargetName}/`);
//
//   // 未签名的hsp包路径
//   const inputFile = path.resolve(moduleBuildOutputDir, `${mModuleName}-${curTargetName}-unsigned.hsp`);
//   // 签名后的hsp包路径
//   const outputFile = path.resolve(moduleBuildOutputDir, `${mModuleName}-${curTargetName}-signed.hsp`);
//   executeOnlineSign(inputFile, outputFile)
// });
//
// module.exports = {
//   ohos: ohosPlugin
// }