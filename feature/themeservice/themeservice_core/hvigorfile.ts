import { hapTasks } from '@ohos/hvigor-ohos-plugin';

export default {
  system: hapTasks, /* Built-in plugin of Hvigor. It cannot be modified. */
  plugins: []       /* Custom plugin to extend the functionality of Hvigor. */
}
// /*
//  * Copyright (c) Huawei Device Co., Ltd. 2024-2024. All rights reserved.
//  */
//
// // Script for compiling build behavior. It is built in the build plug-in and cannot be modified currently.
// import { hvigor, getHvigorNode } from '@ohos/hvigor';
// import { hapTasks } from '@ohos/hvigor-ohos-plugin';
// import * as path from 'path';
// import { executeOnlineSign, onlineSignHap } from '../../../signature/sign.js';
// import { initTesting } from '@ohos/hypium-plugin';
// import fs from 'fs';
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
//   packageConfig: {
//     // 自定义测试包的名称，当前与模块名一致
//     appName: 'ThemeService',
//     // hvigor 命令行参数
//     commandParams: hvigor.getExtraConfig(),
//     // 当前模块对象
//     module: mModule,
//     // dt测试匹配的模块名（一般为空）
//     entryName: 'phone_sceneboard',
//   },
//   signConfig: {
//     p7bFilePath: 'signature/sceneboard.p7b', // p7b签名文件路径,支持全路径或基于新项目文件夹的相对路径
//     keyAlias: 'SceneBoard' // 可以不填，默认是"HOS Application Provision Debug"
//   }
// };
//
// function isDtInLinux(): boolean {
//   const temp = process.env.IS_DT_IN_LINUX;
//   console.log(`isDtInLinux:${temp}`);
//   if (temp === true || temp === 'true') {
//     return true;
//   }
//   return false;
// }
//
// if (isDtInLinux()) {
//   fs.copyFileSync(path.resolve(__dirname, 'src/ohosTest/ets/TServiceRegister.ets'),
//     path.resolve(__dirname, 'src/main/ets/service/TServiceRegister.ets'));
//   initTesting(config);
// }
//
// onlineSignHap(mModule, ohosPlugin, (targetService) => {
//   const curProductName = targetService.getTargetData().getProduct().name;
//   const curTargetName = targetService.getTargetData().getTargetName();
//   // 构建的未签名的hap的输出根目录
//   const moduleBuildOutputDir = path.resolve(projectRootPath,
//     `feature/themeservice/themeservice_core/build/${curProductName}/outputs/${curTargetName}/`);
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