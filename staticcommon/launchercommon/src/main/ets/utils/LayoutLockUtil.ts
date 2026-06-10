/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import {
  LogDomain,
  LogHelper,
  SingletonHelper,
} from '@ohos/basicutils';
import {
  DebugCommand,
  DebugCommandManager,
  DeviceHelper,
  GlobalContext,
  sSettingsUtil
} from '@ohos/frameworkwrapper';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import dataPreferences from '@ohos.data.preferences';
import { GetLayoutInfoFromConfig } from '../layoutconfig/GetLayoutInfoFromConfig';
import { CommonConstants, DesktopLayoutState } from '../constants/CommonConstants';
import { launcherStatusUtil } from '@ohos/windowscene';

const TAG = 'LayoutLockUtil';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 演示样机布局锁定工具类
 */
export class LayoutLockUtil {
  private isRetailEnable: boolean = false;
  private locked: boolean = false;
  private lockedPageNum: number = 0;
  private lockedOuterPage: number = 0;

  constructor() {
    try {
      this.isRetailEnable = systemParameterEnhance.getSync('const.dfx.enable_retail', 'false') === 'true';
    } catch (err) {
      log.showError('systemParameterEnhance error %{public}d: %{public}s', err.code, err.message);
    }
    this.registerDebug();
  }

  /**
   * 初始化预置布局信息
   *
   * @param fromConfig 是否从配置文件初始化
   * @param pageCount 预置布局页数
   */
  public async init(): Promise<void> {
    if (DeviceHelper.isPC()) {
      // pc无需锁定样机
      return;
    }
    try {
      // 读取备份是否完成，完成后演示样机无需锁定布局
      let preferences = dataPreferences.getPreferencesSync(GlobalContext.getContext(),
        { name: CommonConstants.BACK_UP_STATUS });
      let backupFinish: boolean = preferences.getSync(CommonConstants.BACK_UP_FINISH, 'false') === 'true';
      let pageCount: number = 0;
      let outerPageCount: number = 0;
      // 锁定布局时，需要额外读取配置文件，获取预置布局页数
      if (this.isRetailEnable && !backupFinish) {
        let desktopLayout: number = Number(sSettingsUtil.getValue(CommonConstants.SIMPLE_MODE_KEY, '0'));
        let layout = desktopLayout === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL ?
          await GetLayoutInfoFromConfig.getInstance().getSimpleLayoutConfigFile() :
          await GetLayoutInfoFromConfig.getInstance().getAllLayoutConfigFile();
        layout.layoutInfo.forEach(item => pageCount = Math.max(pageCount, (item.page ?? 0) + 1));
      }
      this.initParams(this.isRetailEnable && !backupFinish, pageCount, outerPageCount);
      log.showInfo('init finish, isRetailEnable: %{public}s backupFinish: %{public}s lockedPageNum: %{public}d',
        this.isRetailEnable, backupFinish, this.lockedPageNum);
    } catch (err) {
      log.showError('init error %{public}d: %{public}s', err.code, err.message);
    }
  }

  /**
   * 获取当前是否为演示样机
   */
  public isLocked(msg?: string): boolean {
    if (this.locked && msg) {
      log.showInfo('locked layout, when (%{public}s)', msg);
    }
    return this.locked;
  }

  /**
   * 获取当前是否为演示样机预置页
   * @param index 当前页面数
   */
  public isLockedPage(index: number, msg?: string, checkOuter?: boolean): boolean {
    let lockedPageNum: number = this.lockedPageNum;
    if (checkOuter && launcherStatusUtil.getShowOutLauncherStatus()) {
      lockedPageNum = this.lockedOuterPage;
    }
    let res: boolean = this.locked && index >= 0 && index < lockedPageNum;
    if (res && msg) {
      log.showInfo('locked page: %{public}d, when (%{public}s)', index, msg);
    }
    return res;
  }

  /**
   * 获取演示样机预置布局页数
   */
  public getLockedPageNum(isOuter: boolean): number {
    if (isOuter) {
      return this.lockedOuterPage;
    }
    if (isOuter === undefined) {
      return launcherStatusUtil.getShowOutLauncherStatus() ? this.lockedOuterPage : this.lockedPageNum;
    }
    return this.lockedPageNum;
  }

  private initParams(locked: boolean, lockedPageNum: number, lockedOuterPageNum: number): void {
    this.locked = locked;
    this.lockedPageNum = lockedPageNum;
    this.lockedOuterPage = lockedOuterPageNum;
  }

  private registerDebug(): void {
    let cmds: DebugCommand[] = [];
    cmds.push({
      cmdName: 'setLayoutLockInfo',
      callback: (args: string[]) => {
        if (args.length !== 2) {
          return 'please confirm your input';
        }
        let locked: boolean = args[0] === 'true';
        let length: number = Number(args[1]);
        this.initParams(locked, isNaN(length) ? 0 : length, isNaN(length) ? 0 : length);
        return `set layoutLockInfo success`;
      }
    });
    DebugCommandManager.getInstance().register(TAG, cmds);
  }
}

export const layoutLockUtil: LayoutLockUtil = SingletonHelper.getInstance(LayoutLockUtil, TAG);