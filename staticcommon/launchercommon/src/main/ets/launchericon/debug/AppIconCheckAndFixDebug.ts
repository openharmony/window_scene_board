/*
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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { AppIconCheckAndFixManager, LostBundleInfo, INVALID_REASON } from '../viewmodel/AppIconCheckAndFixManager';
import { AppModel } from '../../TsIndex';

/**
 * 图标检测与修复维测类
 */
const TAG = 'AppIconCheckAndFixDebug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class AppIconCheckAndFixDebug {
  private static instance: AppIconCheckAndFixDebug;
  private static isRegistered = false;

  public static getInstance(): AppIconCheckAndFixDebug {
    if (!AppIconCheckAndFixDebug.instance) {
      AppIconCheckAndFixDebug.instance = new AppIconCheckAndFixDebug();
    }
    return AppIconCheckAndFixDebug.instance;
  }

  /**
   * 注册Debug命令
   */
  public register(): void {
    if (!AppIconCheckAndFixDebug.isRegistered) {
      DebugCommandManager.getInstance().register(TAG, this.getCommands());
      AppIconCheckAndFixDebug.isRegistered = true;
    }
  }

  private getCommands(): DebugCommand[] {
    let cmds: DebugCommand[] = [];
    cmds.push({
      cmdName: 'checkAppIconImage',
      callback: (args: Array<string>) => this.checkAppIconImage(args)
    });
    cmds.push({
      cmdName: 'checkAppIconOpacity',
      callback: (args: Array<string>) => this.checkAppIconOpacity(args)
    });
    cmds.push({
      cmdName: 'checkAppIconCache',
      callback: (args: Array<string>) => this.checkAppIconCache(args)
    });
    cmds.push({
      cmdName: 'fixAppIconImage',
      callback: (args: Array<string>) => this.fixAppIconImage(args)
    });
    cmds.push({
      cmdName: 'fixAppIconOpacity',
      callback: (args: Array<string>) => this.fixAppIconOpacity(args)
    });
    cmds.push({
      cmdName: 'fixAppIconCache',
      callback: (args: Array<string>) => this.fixAppIconCache(args)
    });
    cmds.push({
      cmdName: 'debugDeleteAppIconCache',
      callback: (args: Array<string>) => this.debugDeleteAppIconCache(args)
    });
    return cmds;
  }

  private debugDeleteAppIconCache(args: string[]): string {
    if (args.length === 0) {
      return 'Please input one bundleName';
    }
    args.forEach((item) => {
      AppModel.getInstance().appItemRemove(item, 0);
    });
    return 'debugDeleteAppIconCache end';
  }

  private checkAppIconImage(args: string[]): string {
    if (args.length > 1) {
      return 'Please input one bundleName';
    }
    let bundleName: string = args.length === 0 ? '' : args[0];
    log.showWarn(`checkAppIconImage bundleName ${bundleName}`);
    let checkResult: LostBundleInfo[] =
      AppIconCheckAndFixManager.getInstance().checkIconForDebug(INVALID_REASON.INVALID_ICON_IMAGE, bundleName);
    return JSON.stringify(checkResult);
  }

  private checkAppIconOpacity(args: string[]): string {
    if (args.length > 1) {
      return 'Please input one bundleName';
    }
    let bundleName: string = args.length === 0 ? '' : args[0];
    log.showWarn(`checkAppIconOpacity bundleName ${bundleName}`);
    let checkResult: LostBundleInfo[] =
      AppIconCheckAndFixManager.getInstance().checkIconForDebug(INVALID_REASON.INVALID_ICON_OPACITY, bundleName);
    return JSON.stringify(checkResult);
  }

  private checkAppIconCache(args: string[]): string {
    if (args.length > 1) {
      return 'Please input one bundleName';
    }
    let bundleName: string = args.length === 0 ? '' : args[0];
    log.showWarn(`checkAppIconCache bundleName ${bundleName}`);
    AppIconCheckAndFixManager.getInstance().checkIconForDebug(INVALID_REASON.INVALID_ICON_LAYOUT_CACHE, bundleName);
    return 'checkAppIconCache success, result print into hilog';
  }

  private fixAppIconImage(args: string[]): string {
    if (args.length > 1) {
      return 'Please input one bundleName';
    }
    let bundleName: string = args.length === 0 ? '' : args[0];
    AppIconCheckAndFixManager.getInstance().fixIcon(INVALID_REASON.INVALID_ICON_IMAGE, bundleName);
    return 'send fixAppIconImage debug cmd success';
  }

  private fixAppIconOpacity(args: string[]): string {
    if (args.length > 1) {
      return 'Please input one bundleName';
    }
    let bundleName: string = args.length === 0 ? '' : args[0];
    AppIconCheckAndFixManager.getInstance().fixIcon(INVALID_REASON.INVALID_ICON_OPACITY, bundleName);
    return 'send fixAppIconOpacity debug cmd success';
  }

  private fixAppIconCache(args: string[]): string {
    if (args.length > 1) {
      return 'Please input one bundleName';
    }
    let bundleName: string = args.length === 0 ? '' : args[0];
    AppIconCheckAndFixManager.getInstance().fixIcon(INVALID_REASON.INVALID_ICON_LAYOUT_CACHE, bundleName);
    return 'send fixAppIconCache debug cmd success';
  }
}