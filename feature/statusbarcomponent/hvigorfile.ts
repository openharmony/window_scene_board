module.exports = require('@ohos/hvigor-ohos-plugin').harTasks

// import { harTasks } from '@ohos/hvigor-ohos-plugin';
// import { hvigor, getHvigorNode } from '@ohos/hvigor';
// import * as path from 'path';
// import { executeOnlineSign } from '../../signature/sign.js';
// import { initTesting } from '@ohos/hypium-plugin';
//
// const mModule = getHvigorNode(__filename);
// const tasks = harTasks(mModule);
// const ohosTestOutputDir = path.join(path.dirname(__filename), 'build/default/outputs/ohosTest');
// const mModuleName = 'statusbarcomponent';
//
// const assembleHapTask = mModule.task(() => {
//   console.log(mModuleName + ' AssembleHap succeed');
// }, 'assembleHap');
//
// const config = {
//   hvigor: hvigor,
//   packageConfig: {
//     appName: 'statusbarcomponent',
//     commandParams: hvigor.getExtraConfig(),
//     module: mModule,
//     entryName: '',
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
//   initTesting(config);
// }
//
// /** 本地IDE执行时会执行 genOnDeviceTestHap **/
// const genOnDeviceTestHapTask = mModule.getTaskByName('genOnDeviceTestHap');
// /** 流水线编译时会执行 packageTestingTask **/
// const packageTestingTask = mModule.getTaskByName('packageTesting');
// /** 本地或流水线编译DT包时都会执行 genOnDeviceTestHap **/
// const ohosTestPackageHapTask = mModule.getTaskByName('ohosTest@PackageHap');
//
// if ((packageTestingTask || genOnDeviceTestHapTask) && ohosTestPackageHapTask) {
//   const onlineSignTask = mModule.task(() => {
//     const inputFile = path.resolve(ohosTestOutputDir, `${mModuleName}-ohosTest-unsigned.hap`);
//     const outputFile = path.resolve(ohosTestOutputDir, `${mModuleName}-ohosTest-signed.hap`);
//
//     console.log(`sign: ${inputFile}`);
//     executeOnlineSign(inputFile, outputFile);
//   }, 'onlineSignTestHap').dependsOn('ohosTest@PackageHap');
//
//   if (onlineSignTask.getEnabled()) {
//     mModule.getTaskByName('ohosTest@SignHap')?.setEnabled(false);
//     mModule.getTaskByName('testingOnlineSignTask')?.setEnabled(false);
//   }
//
//   if (packageTestingTask) {
//     console.info('packageTestingTask dependsOn onlineSignTestHap');
//     packageTestingTask.dependsOn('onlineSignTestHap')
//   } else {
//     console.info(' dependsOn onlineSignTestHap');
//     genOnDeviceTestHapTask.dependsOn('onlineSignTestHap')
//   }
// }
//
// module.exports = {
//   ohos: tasks
// };