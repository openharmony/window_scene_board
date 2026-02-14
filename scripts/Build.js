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
const fs = require('fs');
const path = require('path');
const CommandUtil = require('./CommandUtil');
const json5 = require('json5');

const idePath = path.resolve(process.env.DEVECO_SDK_HOME, '..');
const rootPath = path.resolve(__dirname, '..');
const hdcPath = path.resolve(idePath, 'sdk/default/openharmony/toolchains/hdc.exe');
const nodePath = path.resolve(idePath, 'tools/node');
const hvigorPath = path.resolve(idePath, 'tools/hvigor/bin/hvigorw.js');
process.env.JAVA_HOME = path.resolve(idePath, 'jbr');
process.env.PATH = `${process.env.PATH};${nodePath};${process.env.JAVA_HOME}\\bin`;

const isNeedDeploy = process.argv.find((arg) => arg === '--deploy');
const isNeedClean = process.argv.find((arg) => arg === '--clean');
const isRelease = process.argv.find((arg) => arg === '--release');
const isDaemon = process.argv.find((arg) => arg === '--daemon');
const product = process.argv.find((arg) => arg.startsWith('--product'))?.split('=')?.[1] ?? 'phone';
const productParam = 'default';
const moduleArg = process.argv.find((arg) => arg.startsWith('--module'))?.split('=')?.[1];
const buildProfile = json5.parse(fs.readFileSync(path.resolve(rootPath, 'build-profile.json5'), 'utf-8'));
const PHONE_MODULE_CONFIG = {
  basecommon: '/system/app/SceneBoard/basecommon.hsp',
  'phone_sceneboard': '/system/app/SceneBoard/SceneBoard.hap',
};
const PAD_MODULE_CONFIG = {
  basecommon: '/system/app/SceneBoard/basecommon.hsp',
  'pad_sceneboard': '/system/app/SceneBoard/SceneBoard.hap',
};
const PC_MODULE_CONFIG = {
  'pc_sceneboard': '/system/app/SceneBoard/SceneBoard.hap',
};

async function deployModules(mods, moduleConfig) {
  await buildModules(mods, moduleConfig);
  if (!isNeedDeploy) {
    return;
  }
  await CommandUtil.run([hdcPath, 'target', 'mount'], {
    stderr: process.stderr,
    stdout: process.stdout,
  });
  ignoreAutoReboot();
  for (const mod of mods) {
    const modOutputPath = getModOutputPath(mod, moduleConfig[mod]);
    await sendFile(modOutputPath, moduleConfig[mod]);
  }
}

async function sendFile(srcPath, targetPath) {
  if (!fs.existsSync(srcPath)) {
    console.error(`File ${srcPath} is not exists`);
    process.exit(-1);
  }
  const srcFileSize = fs.statSync(srcPath).size;
  let count = 0;
  const tempPath = '/data/local/tmp/' + path.basename(targetPath);
  CommandUtil.runSync([hdcPath, 'shell', 'rm', tempPath, '-rf']);
  console.log(CommandUtil.runSync([hdcPath, 'file', 'send', srcPath, tempPath]));
  while (true) {
    CommandUtil.runSync([hdcPath, 'shell', 'rm', '-rf', targetPath]);
    CommandUtil.runSync([hdcPath, 'shell', 'cp', tempPath, targetPath]);
    const targetFileSize = getFileSize(targetPath);
    if (targetFileSize === srcFileSize) {
      break;
    }
    if (++count >= 3) {
      console.error(`Send file to ${targetPath} failed, srcFileSize: ${srcFileSize}, targetFizeSize: ${targetFileSize}`);
      process.exit(1);
    }
  }
}

function getFileSize(targetPath) {
  const output = CommandUtil.runSync([hdcPath, 'shell', 'wc', '-c', targetPath]);
  return Number(output.split(' ')[0]);
}

function getBuildArgs(task, mods) {
  let args = `${isNeedClean ? 'clean ' : ''}${task} --mode module`;
  args += ` -p module=${mods.map((mod) => `${mod}@${getModTarget(mod)}`)} --stacktrace --parallel --incremental`;
  args += ` -p product=${productParam}`;
  args += isDaemon ? '--daemon' : ' --no-daemon';
  if (isRelease) {
    args += ` -p buildMode=release`;
  }
  return args;
}

async function ignoreAutoReboot() {
  const amsServiceConfig = await CommandUtil.run([
    hdcPath,
    'shell',
    'cat /system/etc/ams_service_config.json',
  ], {
    stderr: undefined,
    stdout: undefined,
  });
  if (amsServiceConfig.includes('"supportSCBCrashReboot": true,')) {
    console.log('amsServiceConfig:', amsServiceConfig);
    await CommandUtil.run([
      hdcPath,
      'shell',
      `sed -i 's/\\"supportSCBCrashReboot\\": true,/\\"supportSCBCrashReboot\\": false,/g' /system/etc/ams_service_config.json`
    ]);
  }
}

async function buildModules(mods, moduleConfig) {
  const hspMods = mods.filter((mod) => moduleConfig[mod].endsWith('.hsp'));
  const hapMods = mods.filter((mod) => moduleConfig[mod].endsWith('.hap'));

  if (hspMods.length) {
    await CommandUtil.run([process.execPath, hvigorPath, ...getBuildArgs('assembleHsp', hspMods).split(' ')], {
      cwd: rootPath,
      stderr: process.stderr,
      stdout: process.stdout,
    });
  }
  if (hapMods.length) {
    await CommandUtil.run([process.execPath, hvigorPath, ...getBuildArgs('assembleHap', hapMods).split(' ')], {
      cwd: rootPath,
      stderr: process.stderr,
      stdout: process.stdout,
    });
  }
}

function getModTarget(mod) {
  return 'default';
}

function getModOutputPath(mod, targetPath) {
  const srcPath = buildProfile.modules.find((m) => m.name === mod).srcPath;
  const target = getModTarget(mod);
  const extname = path.extname(targetPath);
  return path.resolve(rootPath, srcPath, `build/${productParam}/outputs/${target}/${mod}-${target}-signed${extname}`);
}

async function restartSceneBoard() {
  if (!isNeedDeploy) {
    return;
  }
  await CommandUtil.run([hdcPath, 'shell', `echo ENABLED > /etc/windowscene.config`]);
  await CommandUtil.run([hdcPath, 'shell', `kill -9 $(pidof com.ohos.sceneboard)`]);
}

async function rebootDevice() {
  if (!isNeedDeploy) {
    return;
  }
  await CommandUtil.run([hdcPath, 'shell', `param set persist.bms.test-upgrade true`]);
  await CommandUtil.run([hdcPath, 'shell', `sync /system/bin/udevadm trigger`]);
  await CommandUtil.run([hdcPath, 'shell', `reboot`]);
}

async function backup() {
  const output = CommandUtil.runSync([hdcPath, 'shell', `ls /data/local/tmp/SceneBoardBak`]);
  if (output.includes('No such file or directory')) {
    await CommandUtil.run([hdcPath, 'shell', `cp -r /system/app/SceneBoard /data/local/tmp/SceneBoardBak`]);
  }
}

(async () => {
  const begin = Date.now();
  const moduleConfig = product === 'pc' ? PC_MODULE_CONFIG :
    product === 'pad' ? PAD_MODULE_CONFIG : PHONE_MODULE_CONFIG;

  await backup();
  if (moduleArg) {
    await deployModules(moduleArg.split(','), moduleConfig);
    await restartSceneBoard();
  } else {
    await deployModules(Object.keys(moduleConfig), moduleConfig);
    await rebootDevice();
  }

  console.log(`${new Date().toLocaleString()}: ${isNeedDeploy ? 'Deploy' : 'Build'} complete in ${Date.now() - begin} ms`);
})();
