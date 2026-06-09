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

import { GlobalContext } from '@ohos/frameworkwrapper';
import type ServiceExtensionContext from 'application/ServiceExtensionContext';
import { AppIconCommonEvent, AppIconConfig, AppNameVm } from '@ohos/launchercommon/Index';
import { DockAllAppsItemParam } from './GestureDockAllAppsItemParam';
import { GestureDockViewModel } from '../../../dock/viewmodel/GestureDockViewModel';
import { GestureDockItemInfo } from '../../../dockbar/model/GestureDockItemInfo';
import { GestureDockAllAppsIcon } from '../../../dockallapps/GestureDockAllAppsView';
import { AllAppsStyleConfig } from '../../../dockallapps/model/AllAppsStyleConfig';
import { AllAppsParam } from '../../../dockallapps/viewmodel/viewdata/GestureDockAllAppsParam';
import { CommonConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { GestureDockConstants, GestureDockMode } from '../../../common/GestureDockConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'GestureDockAllAppsItemViewDataMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * GestureDockAllAppsViewDataMgr
 */
export default class GestureDockAllAppsItemViewDataMgr {
  public appItemParam: DockAllAppsItemParam = new DockAllAppsItemParam();
  public item: GestureDockItemInfo = new GestureDockItemInfo();
  public dockViewModel: GestureDockViewModel = GestureDockViewModel.getInstance();
  public desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  public gestureDockAllAppsIcon: number = GestureDockAllAppsIcon.FLOAT_APPS;
  public gestureDockDirection: number = 0;
  public dockAddAppSource: number = 0;
  public allAppsStyleConfig?: AllAppsStyleConfig;
  public allAppsParam?: AllAppsParam;
  public itemOnClick?: Function;
  public appIconConfig: AppIconConfig = new AppIconConfig();
  public appNameVm: AppNameVm = new AppNameVm();
  public iconEvent: AppIconCommonEvent = new AppIconCommonEvent();

  /**
   * 图标ID
   * @returns 图标ID
   */
  public getItemId(): string {
    return CommonConstants.RESIDENT_LAYOUT_APP_TAG + this.item?.bundleName + this.item?.abilityName +
      this.item?.appIndex + this.gestureDockDirection + this.gestureDockAllAppsIcon;
  }

  /**
   * 图标是否可用
   * @returns 可用
   */
  public getHitTestBehavior(): number {
    if (this.allAppsParam?.gestureDockShowMode === GestureDockMode.EDIT) {
      // 编辑模式,根据角标判断
      return this.appItemParam.isShowBadge ? HitTestMode.Transparent : HitTestMode.Block
    } else {
      // 非编辑模式,根据透明度判断
      return this.appItemParam.iconOpacity === GestureDockConstants.APP_ICON_OPACITY_100 ? HitTestMode.Transparent :
      HitTestMode.Block
    }
  }

  /**
   * 透明度
   * @returns 透明度
   */
  public getOpacity(): number {
    // 编辑模式只判断角标,非编辑模式判应用是否启动
    let opacity = GestureDockConstants.APP_ICON_OPACITY_100;
    log.showInfo(`getOpacity ${this.item?.bundleName} ${this.allAppsParam?.gestureDockShowMode} ${this.appItemParam.isShowBadge}`);
    if (this.allAppsParam?.gestureDockShowMode === GestureDockMode.EDIT) {
      opacity = this.appItemParam.isShowBadge ? GestureDockConstants.APP_ICON_OPACITY_100 :
      GestureDockConstants.APP_ICON_OPACITY_60;
    }
    return opacity;
  }
}