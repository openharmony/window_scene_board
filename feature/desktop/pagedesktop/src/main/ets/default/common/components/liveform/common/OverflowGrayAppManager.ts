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

import { HashSet } from '@kit.ArkTS';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { localEventManager } from '@ohos/frameworkwrapper';
import { BaseBundleInfo } from '@ohos/launchercommon/src/main/ets/bean/BaseBundleInfo';
import { GrayAppListManager, ReceiveEventInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';

const TAG = 'FormProviderStage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class OverflowGrayAppManager {
  private static instance: OverflowGrayAppManager;
  private eventListenerSet: HashSet<string> = new HashSet();

  // 用来记录当前被禁用的所有应用包名信息
  private disabledLiveFormSet: HashSet<string> = new HashSet();
  private readonly listener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: boolean) => {
      log.showInfo(`onReceiveEvent: event is ${event}, params is: ${params}`);
      if (params) {
        this.disabledLiveFormSet.add(event);
      } else {
        this.disabledLiveFormSet.remove(event);
      }
      AppStorage.setOrCreate('disabledLiveFormCount', this.disabledLiveFormSet.length);
    }
  };

  private constructor() {
    this.initBundleInfo();
  }

  /**
   * 小游戏引擎没有图标，需要额外进行注册禁用/解禁状态监听
   */
  private initBundleInfo(): void {
    this.registerEventListener({ bundleName: HiSysEventUtil.GAME_ENGINE_BUNDLE_NAME, appIndex: 0 });
  }

  /**
   * 卡片提供方禁用状态单例
   *
   * @return 返回单例
   */
  public static getInstance(): OverflowGrayAppManager {
    if (!OverflowGrayAppManager.instance) {
      OverflowGrayAppManager.instance = new OverflowGrayAppManager();
    }
    return OverflowGrayAppManager.instance;
  }

  /**
   * 对卡片禁用/解禁状态监听进行注册
   *
   * @param BaseBundleInfo 禁用的卡片信息bundleName和appIndex
   */
  public registerEventListener(bundleInfo: BaseBundleInfo): void {
    if (CheckEmptyUtils.isEmpty(bundleInfo) ||
      CheckEmptyUtils.checkStrIsEmpty(bundleInfo.bundleName)) {
      log.error('registerEventListener: Invalid bundleInfo provided');
      return;
    }
    if (this.eventListenerSet.has(bundleInfo.bundleName)) {
      log.showInfo(`registerEventListener: ${bundleInfo.bundleName} has been registered`);
      return;
    }
    this.eventListenerSet.add(bundleInfo.bundleName);
    let grayEvent: string = GrayAppListManager.getInstance().getGrayAppIconEventKey(bundleInfo);
    localEventManager.registerEventListener(this.listener, [grayEvent]);
  }

  /**
   * 对卡片禁用/解禁状态监听进行解注册
   */
  public unregisterEventListener(): void {
    localEventManager.unregisterEventListener(this.listener);
    this.eventListenerSet.clear();
    this.disabledLiveFormSet.clear();
  }

  /**
   * 查询卡片包名信息是否在 disabledLiveFormSet 中, 存在的话返回 true, 否则返回 false
   *
   * @param bundleName 卡片的包名信息
   */
  public isBundleNameInDisabledLiveFormSet(bundleName: string): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.error('isBundleNameInDisabledLiveFormSet: bundleName is empty');
      return false;
    }
    let bundleInfo: BaseBundleInfo = { bundleName: bundleName, appIndex: 0 };
    let grayEvent: string = GrayAppListManager.getInstance().getGrayAppIconEventKey(bundleInfo);
    return this.disabledLiveFormSet.has(grayEvent);
  }
}