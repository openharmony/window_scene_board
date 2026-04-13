module.exports = require('@ohos/hvigor-ohos-plugin').harTasks

// import { harTasks } from '@ohos/hvigor-ohos-plugin';
// import { getHvigorNode } from '@ohos/hvigor';
// import * as path from 'path';
// import { executeOnlineSign } from '../../../signature/sign.js';
//
// const node = getHvigorNode(__filename);
// const tasks = harTasks(node);
// const ohosTestOutputDir = path.join(path.dirname(__filename), 'build/default/outputs/ohosTest');
// const mModuleName = 'notificationcomponent';
//
// const genOnDeviceTestHapTask = node.getTaskByName('genOnDeviceTestHap');
// const ohosTestPackageHapTask = node.getTaskByName('ohosTest@PackageHap');
// if (genOnDeviceTestHapTask && ohosTestPackageHapTask) {
//   const onlineSignTask = node.task(() => {
//     const inputFile = path.resolve(ohosTestOutputDir, `${mModuleName}-ohosTest-unsigned.hap`);
//     const outputFile = path.resolve(ohosTestOutputDir, `${mModuleName}-ohosTest-signed.hap`);
//
//     console.log(`sign: ${inputFile}`);
//     executeOnlineSign(inputFile, outputFile);
//   }, 'onlineSignTestHap').dependsOn('ohosTest@PackageHap');
//
//   if (onlineSignTask.getEnabled()) {
//     node.getTaskByName('ohosTest@SignHap')?.setEnabled(false);
//   }
//
//   genOnDeviceTestHapTask.dependsOn('onlineSignTestHap')
// }
//
// module.exports = {
//   ohos: tasks
// };
