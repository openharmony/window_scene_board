import { hapTasks } from '@ohos/hvigor-ohos-plugin';

export default {
  system: hapTasks, /* Built-in plugin of Hvigor. It cannot be modified. */
  plugins: []       /* Custom plugin to extend the functionality of Hvigor. */
}
// /*
//  * Copyright (c) Huawei Technologies Co., Ltd. 2022-2022. All rights reserved.
//  */
//
// // Script for compiling build behavior. It is built in the build plug-in and cannot be modified currently.
// import { hvigor, getHvigorNode } from '@ohos/hvigor';
// import { hapTasks } from '@ohos/hvigor-ohos-plugin';
// import * as path from 'path';
// import fs from 'fs';
// import { onlineSignHap, executeOnlineSign } from '../../../signature/sign.js';
//
// const mModule = getHvigorNode(__filename)
// const ohosPlugin = hapTasks(mModule)
//
// const mModuleName = mModule.getName()
// const projectRootPath = process.cwd()
//
// // 若是feature模块签名，此处填写依赖的entry模块名称
// const entryName = '';
// const includeResources = ['managementcomponent', 'notificationmanagement'];
//
// onlineSignHap(mModule, ohosPlugin, (targetService) => {
//   const curProductName = targetService.getTargetData().getProduct().name;
//   const curTargetName = targetService.getTargetData().getTargetName();
//   // 构建的未签名的hap的输出根目录
//   const moduleBuildOutputDir = path.resolve(projectRootPath,
//     `feature/notification/notificationmanagement/build/${curProductName}/outputs/${curTargetName}/`);
//   // 未签名的hap包路径
//   const inputFile = path.resolve(moduleBuildOutputDir,
//     `${mModuleName}${entryName ? '-' + entryName : ''}-${curTargetName}-unsigned.hap`);
//   // 签名后的hap包路径
//   const outputFile = path.resolve(moduleBuildOutputDir,
//     `${mModuleName}${entryName ? '-' + entryName : ''}-${curTargetName}-signed.hap`);
//   executeOnlineSign(inputFile, outputFile);
// });
//
// hvigor.nodesEvaluated(() => {
//   ohosPlugin.getNeedExecTargetServiceList().forEach(targetService => {
//     handleResource(targetService);
//   });
// });
//
// function handleResource(targetService): void {
//   const productName = targetService.getTargetData().getProduct().name;
//   const targetName = targetService.getTargetData().getTargetName();
//   const task = mModule.getTaskByName(`${targetName}@ProcessResource`);
//   if (!task) {
//     return;
//   }
//   task.afterRun(() => {
//     const targetData = targetService.getTargetData();
//     const buildDir = targetData.getPathInfo().getModuleBuildPath();
//     console.log(`Handle resource for ${mModuleName}, productName:${productName}, curTargetName: ${targetName}`);
//     console.log(`BuildDir: ${buildDir}`);
//     const resConfigPath = path.resolve(buildDir, `${productName}/intermediates/res/${targetName}/resConfig.json`);
//     const resConfig = JSON.parse(fs.readFileSync(resConfigPath).toString());
//     const resDependencies = resConfig.dependencies;
//     if (!Array.isArray(resDependencies)) {
//       return
//     }
//     resConfig.dependencies = resDependencies.filter(item => includeResources.some((ir) => item.includes(ir)));
//     console.log(`resConfig.dependencies: ${resConfig.dependencies}`);
//     fs.writeFileSync(resConfigPath, JSON.stringify(resConfig));
//   });
// }
//
// module.exports = {
//   ohos: ohosPlugin
// };