/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { LogDomain, LogHelper, singleManager, SingletonHelper } from '@ohos/basicutils';
import { util } from '@kit.ArkTS';
import fs from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';
import CommonEventManager from '@ohos.commonEventManager';
import type { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';
import systemparameter from '@ohos.systemParameterEnhance';

const TAG = 'DebugCommand';
// 防止自己监听，自己发布
const DEBUG_EVENT_LISTENER_NAME = 'com.ohos.sceneboard.debug.event.listener';
const DEBUG_EVENT_RESPONSE_NAME = 'com.ohos.sceneboard.debug.event.response';
const DEBUG_ON_DEFAULT = '0';
const ENG_PARAMETER = 'const.debuggable';
const VERSION_NAME = 'const.logsystem.versiontype';
const ENG_MODE: boolean = !!(systemparameter.getSync(ENG_PARAMETER, DEBUG_ON_DEFAULT));
const BETA_MODE: boolean = (systemparameter.getSync(VERSION_NAME, 'default') === 'beta');
const MID_SCENE = 'midSceneFSM';

const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

type DebugCommandCallback = (args: string[]) => string;

export interface DebugCommand {
  cmdName: string;
  callback: DebugCommandCallback;
}

class PublishOptions {
  code?: number;
  data?: string;
  isOrdered?: boolean;
  subscriberPermissions?: string[];
}

class CmdOptions {
  name: string = '';
  cmds: DebugCommand[] = [];
}

export class DebugCommandManager {
  private readonly MAX_MODULE_SIZE = 256;
  private moduleCommandList = new Map<string, DebugCommand[]>();
  private subscriber: CommonEventSubscriber | undefined = undefined;

  constructor() {
    this.initialDependentModules();
  }

  public register(module: string, debugCommandList: DebugCommand[]): void {
    if (this.moduleCommandList.size > this.MAX_MODULE_SIZE) {
      log.showError(`too many debug command moudles, ${module} can not register now`);
      return;
    }
    this.moduleCommandList.set(module, debugCommandList);
  }

  public unregister(module: string): void {
    if (this.moduleCommandList.has(module)) {
      this.moduleCommandList.delete(module);
    }
  }

  public getAllModules(): string {
    return Array.from(this.moduleCommandList.keys()).join(' | ');
  }

  private getAllCommandNames(debugCommandList: DebugCommand[] | undefined): string {
    let cmdNames: string = '';
    const separator = ' | ';
    debugCommandList?.forEach((item: DebugCommand) => {
      cmdNames += item.cmdName;
      cmdNames += separator;
    });
    // trim separator at the end of cmdNames
    if (cmdNames.length > separator.length) {
      return cmdNames.slice(0, cmdNames.length - separator.length);
    }
    return cmdNames;
  }

  private doCommandInner(module: string, cmdName: string, args: string[]): string {
    let responseText: string = '';
    if (!this.moduleCommandList.has(module)) {
      responseText = 'Available modules: ';
      responseText += this.getAllModules();
      return responseText;
    }
    let moduleCommand = this.moduleCommandList.get(module);
    let debugCommand = moduleCommand?.find((item: DebugCommand) => {
      return item.cmdName === cmdName;
    });
    if (debugCommand) {
      responseText = debugCommand.callback(args);
      return responseText;
    }

    responseText = 'Available commands: ';
    responseText += this.getAllCommandNames(moduleCommand);
    return responseText;
  }

  private doStringCommand(args: string): string {
    let responseText: string = '';

    let argList = args.trim().split(' ');
    if (argList.length === 0) {
      responseText = 'Available modules: ';
      responseText += this.getAllModules();
      return responseText;
    }
    // scb_debug module cmdName arg1(option) arg2(option)...
    let module = argList[0];
    let cmdName = (argList[1] !== undefined) ? argList[1] : 'invalid_cmd';
    let cmdArgList = (argList[2] !== undefined) ? argList.slice(2) : new Array<string>();
    return this.doCommandInner(module, cmdName, cmdArgList);
  }

  /**
   * Write Dump Info To File
   *
   * @param { string } filePath
   * @param { string } responseText
   * @returns { void }
   */
   public writeToDumpFile(filePath: string, responseText: string): void {
    let file: fs.File | undefined;
    try {
      file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    } catch (err) {
      log.showError(`[WMS_DUMP] open failed with error code ${err.code}, error message ${err.message}`);
    }
    
    if (file) {
      fs.write(file.fd, responseText).then((writeLen: number) => {
        log.showInfo(`[WMS_DUMP] write succeed and size is ${writeLen}`);
      }).catch((err: BusinessError) => {
        log.showError(`[WMS_DUMP] write failed with error code ${err.code}, error message ${err.message}`);
      }).finally(() => {
        fs.closeSync(file);
      });
    }
  }

  private doCommand(args: string | undefined, filePath: string): void {
    if (args === undefined) {
      return;
    }
    let responseText = this.doStringCommand(args);
    // scb_debug write to file if lenth is greater than DUMP_BYTE_MAX
    const textEncoder: util.TextEncoder = new util.TextEncoder();
    const encodedLength = textEncoder.encodeInto(responseText).length;
    log.showDebug(`[WMS_DUMP] Dump size ${encodedLength}`);
    const DUMP_BYTE_MAX = 100000;
    if (filePath !== undefined && filePath !== '' && encodedLength > DUMP_BYTE_MAX) {
      this.writeToDumpFile(filePath, responseText);
    }
    this.publish(responseText);
  }

  private publish(data: string): void {
    let options: PublishOptions = {
      code: 0,
      data: data,
      isOrdered: false,
      subscriberPermissions: ['ohos.permission.DUMP']
    };

    try {
      CommonEventManager.publish(DEBUG_EVENT_RESPONSE_NAME, options, (err) => {
        if (err && err.code !== 0) {
          log.showError('publish error: ' + JSON.stringify(err));
        }
      });
    } catch (err) {
      log.showError('publish failed, catch error' + JSON.stringify(err));
    }
  }

  /* 这里放debug模块依赖的模块debug命令，解决循环依赖问题。 */
  private initialDependentModules(): void {
    let cmd: CmdOptions = initialSingleManagerDebug();
    this.register(cmd.name, cmd.cmds);
  }

  public subscribe(): void {
    if (this.subscriber !== undefined || (!ENG_MODE && !BETA_MODE)) {
      log.showWarn('debug command has already subscribed, no need subscribe again. ' +
        'Or ENG MODE/BETA MODE, not subscribe.');
      return;
    }
    log.showInfo('start subscribe ' + DEBUG_EVENT_LISTENER_NAME);
    let subscribeInfo: CommonEventManager.CommonEventSubscribeInfo = {
      events: [DEBUG_EVENT_LISTENER_NAME],
      publisherPermission: 'ohos.permission.ACCESS_SYSTEM_SETTINGS'
    };
    CommonEventManager.createSubscriber(subscribeInfo, (err, subscriber) => {
      if (err && err.code !== 0) {
        log.showError('create subscriber error: ' + JSON.stringify(err));
        return;
      }
      this.subscriber = subscriber;
      try {
        CommonEventManager.subscribe(subscriber, (err, commonEventData) => {
          if (err && err.code !== 0) {
            log.showError('subscribe error: ' + JSON.stringify(err));
            return;
          }
          let dumpFilePath: string = '';
          if (commonEventData?.parameters?.dumpFilePath !== undefined) {
            dumpFilePath = commonEventData.parameters.dumpFilePath;
          }
          this.doCommand(commonEventData.data, dumpFilePath);
        });
      } catch (err) {
        log.showError('subscribe failed, catch error' + JSON.stringify(err));
      }
    });
  }

  public filterMidSceneFSM(key: string): boolean {
    return key !== MID_SCENE;
  }

  public static getInstance(): DebugCommandManager {
    return SingletonHelper.getInstance(DebugCommandManager, TAG);
  }
}

function initialSingleManagerDebug(): CmdOptions {
  let cmds: DebugCommand[] = [];

  cmds.push({ cmdName: 'Show', callback: (args: Array<string>) => { return singleManager.toString(); } });
  cmds.push({ cmdName: 'SetDFT', callback: (args: Array<string>) => {
    let size = args.length >= 1 ? Number(args[0]) : 10;
    size = isNaN(size) ? 10 : size;
    singleManager.enableDft(size);
    return 'Set DFX size as ' + size;
  } });
  cmds.push({ cmdName: 'SetDFR', callback: (args: Array<string>) => {
    let input = args.length >= 1 ? Number(args[0]) : 10;
    input = isNaN(input) ? 0 : input;
    let enable = input > 0 ? true : false;
    singleManager.enableDfr(enable);
    return 'Set DFR as ' + enable;
  } });
  return { name: 'SingleManager', cmds: cmds };
}
