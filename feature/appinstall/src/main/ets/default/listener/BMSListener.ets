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

import { CacheManager } from '../manager/CacheManager';
import {
  CheckEmptyUtils,
  CommonUtils,
  OutdoorConfig,
  LogDomain,
  LogHelper
} from '@ohos/basicutils/src/main/ets/TsIndex';
import { EvtBus, PackageCommonEvent } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { AccountChangeListener } from './AccountChangeListener';
import {
  GetHideAppsFromConfig,
  GetLayoutInfoFromConfig,
  launcherAbilityManager,
  GridLayoutItemInfo
} from '@ohos/launchercommon';
import { LightOutdoorConfig } from '@ohos/frameworkwrapper';

const TAG = 'appInstall_BMSListener';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DELIVER_BUNDLE_STATUS_DEFAULT: number = 1;
const BMS_BROKER_UID: number = 5557;

/**
 * BMS监听
 */
export class BMSListener {
  private static mInstance: BMSListener;
  private packageCommonEvent = (event: PackageCommonEvent) => {
    this.handlePackageEvent(event);
  }

  private constructor() {
  }

  static getInstance(): BMSListener {
    if (!BMSListener.mInstance) {
      BMSListener.mInstance = new BMSListener();
    }
    return BMSListener.mInstance;
  }

  /**
   * 初始化该类
   */
  public init(): void {
    EvtBus.on(PackageCommonEvent, this.packageCommonEvent);
  }

  /**
   * 销毁该类
   */
  public destroy(): void {
    EvtBus.off(PackageCommonEvent, this.packageCommonEvent);
  }

  /**
   * 处理包管理事件回调
   * 元服务也会监听
   *
   * @param event 包管理事件
   */
  private handlePackageEvent(event: PackageCommonEvent): void {
    if (!event || CommonUtils.isInvalid(event.event)) {
      log.showWarn('handlePackageEvent package event unknown');
      return;
    }
    if (!event.bundleName) {
      log.showWarn('packageAddCallback bundleName is invalid');
      return;
    }
    let bundleName: string = event.bundleName;
    log.showInfo('handlePackageEvent event: %{public}s, bundleName: %{public}s', event.event, bundleName);
    if (GetHideAppsFromConfig.getInstance().isHideApp(bundleName)) {
      log.showWarn('handlePackageEvent bundleName:%{public}s is hide app, return', bundleName);
      return;
    }
    switch (event.event) {
      case PackageCommonEvent.EVENT_PACKAGE_REMOVED:
        // 包卸载事件
        CacheManager.getInstance().packageRemoved(event, bundleName);
        break;
      case PackageCommonEvent.EVENT_PACKAGE_ADD:
      case PackageCommonEvent.EVENT_PACKAGE_CHANGED:
        this.handlePackageAddOrChangeEvent(event);
        break;
      case PackageCommonEvent.EVENT_UPDATING_DELIVER_BUNDLE_STATUS:
        if (event.userId !== launcherAbilityManager.getUserId() || event.uid !== BMS_BROKER_UID) {
          log.showWarn('user or uid is not current');
          return;
        }
        CacheManager.getInstance().updateInstallingData(event.parameters?.bundleName ?? '',
          event.parameters?.status ?? DELIVER_BUNDLE_STATUS_DEFAULT);
        break;
      default:
        log.showInfo('handlePackageEvent package event invalid');
        break;
    }
  }

  /**
   * 处理安装，更新的逻辑
   * @param event
   * @returns
   */
  private async handlePackageAddOrChangeEvent(event: PackageCommonEvent): Promise<void> {
    if (OutdoorConfig.getInstance().isInOutdoorMode()) {
      this.handlePackageAddOrChangeEventForOutdoorMode(event);
    } else if (LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
      this.handlePackageAddOrChangeEventForLightOutdoorMode(event);
    } else {
      // 包更新或者安装事件
      CacheManager.getInstance().appAddedOrUpdated(event, event.bundleName!);
    }
  }

  /**
   * 处理户外模式模式下的包添加或更新逻辑
   * 当bundleName 对应的应用在预制布局中才会走添加/更新逻辑
   * @param event
   * @returns
   */
  private async handlePackageAddOrChangeEventForOutdoorMode(event: PackageCommonEvent): Promise<void> {
    let bundleName: string = event.bundleName!;
    let finalLayout = await GetLayoutInfoFromConfig.getInstance().getOutdoorLayoutConfigFile();
    let listInConfigFiles: GridLayoutItemInfo[] = finalLayout.layoutInfo.filter((item) => {
      return item.bundleName === event.bundleName;
    });
    // 如果通知中的应用不在预置布局中，则不处理。
    if (CheckEmptyUtils.isEmptyArr(listInConfigFiles)) {
      log.showWarn(`OutdoorMode not support ${bundleName}`);
      return;
    } else {
      log.showWarn(`OutdoorMode support ${bundleName}`)
    }
    // 包更新或者安装事件
    CacheManager.getInstance().appAddedOrUpdated(event, event.bundleName!);
  }

  private async handlePackageAddOrChangeEventForLightOutdoorMode(event: PackageCommonEvent): Promise<void> {
    let bundleName: string = event.bundleName!;
    let layoutInfoList: GridLayoutItemInfo[] = CacheManager.getInstance().getAllGridLayoutItemList();
    let listInConfigFiles = layoutInfoList.filter((item) => {
      return item.bundleName === event.bundleName;
    });
    if (CheckEmptyUtils.isEmptyArr(listInConfigFiles)) {
      log.showWarn(`LightOutdoorMode not support ${bundleName}`);
      return;
    } else {
      log.showWarn(`LightOutdoorMode support ${bundleName}`)
    }
    // 包更新或者安装事件
    CacheManager.getInstance().appAddedOrUpdated(event, event.bundleName!);
  }
}