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
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {
  EventConstants,
  localEventManager,
  ResourceManager,
  HiSysEventUtil,
  LightOutdoorConfig
} from '@ohos/frameworkwrapper';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import {
  AppItemInfo,
  CommonConstants,
  GridLayoutItemInfo,
  RdbStoreManager,
  ShortcutInfo
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  CheckResult,
  ResultCode,
  ShortcutSourceType,
  ShortcutViewModel
} from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/ShortcutViewModel';
import { PageDesktopViewModel } from './PageDesktopViewModel';

const TAG = 'DesktopShortcutViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class DesktopShortcutViewModel {
  private static mInstance: DesktopShortcutViewModel;
  private mShortcutViewModel: ShortcutViewModel;

  private constructor() {
    this.mShortcutViewModel = ShortcutViewModel.getInstance();
  }

  public static getInstance(): DesktopShortcutViewModel {
    if (!DesktopShortcutViewModel.mInstance) {
      DesktopShortcutViewModel.mInstance = new DesktopShortcutViewModel();
    }
    return DesktopShortcutViewModel.mInstance;
  }

   /**
   * 自定义快捷方式需要校验更多参数
   */
  private checkShortcutMore(shortcutInfo: ShortcutInfo): ResultCode {
    if (shortcutInfo.sourceType !== ShortcutSourceType.CUSTOM_TYPE &&
      shortcutInfo.sourceType !== ShortcutSourceType.STATIC_TYPE) {
      log.showWarn(`check shortcutInfo more fail, sourceType is ${shortcutInfo.sourceType}`);
      return ResultCode.FAILED_INVALID_PARAMETERS;
    }

    let isInvalid: boolean = shortcutInfo.sourceType === ShortcutSourceType.CUSTOM_TYPE && (!shortcutInfo.moduleName ||
      !shortcutInfo.icon || !shortcutInfo.label || !shortcutInfo.hostAbility || !shortcutInfo.wants);
    if (isInvalid) {
      log.showWarn('check shortcutInfo more fail, custom shortcut invalid parameters');
      return ResultCode.FAILED_INVALID_PARAMETERS;
    }

    return ResultCode.SUCCESS;
  }

  /**
   * 应用内快捷方式加桌
   */
  public async addShortcutToDesktop(shortcutInfo: ShortcutInfo): Promise<ResultCode> {
    if (LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
      log.showWarn('not support adding shortcut to desktop due to LightOutdoorMode');
      return ResultCode.FAILED_ON_LIGHT_OUTDOOR_MODE;
    }
    // 桌面参数校验
    let checkResult: CheckResult = this.mShortcutViewModel.checkShortcut(shortcutInfo);
    if (checkResult.code !== ResultCode.SUCCESS) {
      log.showWarn(`check shortcutInfo fail, resultCode:${checkResult.code}`);
      return checkResult.code;
    }

    // 自定义快捷方式需要校验更多参数
    let resultCode: ResultCode = this.checkShortcutMore(shortcutInfo);
    if (resultCode !== ResultCode.SUCCESS) {
      log.showWarn(`check shortcutInfo more fail, resultCode:${resultCode}`);
      return resultCode;
    }

    // 静态快捷方式从包管理获取ShortcutInfo
    if (shortcutInfo.sourceType === ShortcutSourceType.STATIC_TYPE) {
      let shortcutInfoList: ShortcutInfo[] = this.mShortcutViewModel.getShortcutByBundleName(shortcutInfo.bundleName);
      if (CheckEmptyUtils.isEmptyArr(shortcutInfoList)) {
        log.showError(`${shortcutInfo.bundleName} shortcutInfo from Bundle Manager is empty`);
        return ResultCode.FAILED_OTHER;
      }
      let shortcut = shortcutInfoList.find(item => item.id === shortcutInfo.id);
      if (!shortcut) {
        log.showError(`${shortcutInfo.id} is not found in shortcutInfoList`);
        return ResultCode.FAILED_INVALID_PARAMETERS;
      }
      let tempAppIndex = shortcutInfo.appIndex;
      shortcutInfo = shortcut;
      shortcutInfo.appIndex = tempAppIndex;
      // BMS问题导致sourceType都是0，先主动设置
      shortcutInfo.sourceType = 1;
    }

    // BMS没有此快捷方式，则同步到BMS
    let shortcutList: ShortcutInfo[] = await this.mShortcutViewModel.getAllDesktopShortcutFromBMS();
    let isExist: boolean = shortcutList.some(item => item.bundleName === shortcutInfo.bundleName &&
      item.id === shortcutInfo.id && item.appIndex === shortcutInfo.appIndex);
    if (!isExist) {
      resultCode = await this.mShortcutViewModel.addShortcutToBMS(shortcutInfo);
      if (resultCode !== ResultCode.SUCCESS) {
        return resultCode;
      }
    }

    // 加桌
    this.addItemToDesktop(shortcutInfo);
    HiSysEventUtil.reportInAppAddShortcutToDesktop(shortcutInfo.bundleName, shortcutInfo.id);
    return ResultCode.SUCCESS;
  }

  /**
   * 加桌
   */
  private async addItemToDesktop(shortcutInfo: ShortcutInfo): Promise<void> {
    log.showWarn('start to add shortcut to desktop');
    let sameAppItemInfoList = this.mShortcutViewModel.selectAllSameApp(shortcutInfo.bundleName, shortcutInfo.appIndex);

    // 创建布局信息
    let itemInfo = new GridLayoutItemInfo();
    if (sameAppItemInfoList.length > 0) {
      ObjectCopyUtil.deepClone(sameAppItemInfoList[0], itemInfo);
    } else {
      // 无图标应用
      itemInfo.bundleName = shortcutInfo.bundleName;
      itemInfo.abilityName = shortcutInfo.hostAbility ?? '';
      itemInfo.appIndex = shortcutInfo.appIndex;
      itemInfo.container = -100;
      itemInfo.moduleName = shortcutInfo.moduleName;
      itemInfo.isUninstallAble = true;
    }
    //选中态,pc专用属性
    itemInfo.isSelect = false;
    itemInfo.container = CommonConstants.CONTAINER_DESKTOP;
    itemInfo.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
    itemInfo.appIconId = shortcutInfo.iconId ?? 0;
    itemInfo.appLabelId = shortcutInfo.labelId;
    itemInfo.shortcutId = shortcutInfo.id;
    let appLabel = await ResourceManager.getInstance().getAppNameSync(shortcutInfo.labelId, shortcutInfo.bundleName,
      shortcutInfo.moduleName, itemInfo.appName, shortcutInfo.appIndex);
    itemInfo.appName = shortcutInfo.sourceType === 0 ? shortcutInfo.label : appLabel;
    itemInfo.iconResource = shortcutInfo.sourceType === 0 ? shortcutInfo.icon : undefined;
    itemInfo.area = [1, 1];
    itemInfo.intent = `{"sourceType": "${shortcutInfo.sourceType}"}`;
    itemInfo.keyName = AppItemInfo.getKeyName(itemInfo);
    itemInfo.infoId = RdbStoreManager.getInstance().generateRandomUUID();
    (itemInfo as Object as AppItemInfo).appId = itemInfo.infoId;

    // 找位加桌，刷新界面
    PageDesktopViewModel.getInstance().updateAppItemLayoutInfo(itemInfo);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
    log.showInfo('finish to add shortcut to desktop');
  }
}