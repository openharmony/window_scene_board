/**
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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { StartAbilityUtil } from '@ohos/windowscene';
import { AppIconCommonView, AppIconConfig } from '@ohos/launchercommon/Index';
import { AppIconBadgeVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconBadgeVm';
import { AppItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
// import { EmergencyViewModel } from '../../emergency/viewmodel/EmergencyViewModel';
import { CommonConstants } from '../CommonConstants';
import { HiSysEventUtils } from '../../common/hisysevent/HiSysEventUtils';

const TAG = 'EmergencyAppItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct EmergencyAppItem {
  @Prop appItemInfo: AppItemInfo;
  @Prop iconSize: number;
  @Prop isInEditMode: boolean;
  @Prop isInSearchMode: boolean;
  // model type 1: emergency model;  2: Thermal safe model
  @Prop modelType: number;
  private onSearchItemClick?: Function;
  private nameFontColor: string = '#FFFFFF';
  // private emergencyViewModel: EmergencyViewModel = EmergencyViewModel.getInstance();
  private appIconConfig: AppIconConfig = new AppIconConfig();

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    this.appIconConfig.setEnableName(true)
      .setEnableBadge(false)
      .setEnableMenu(false)
      .setEnableDrag(false)
      .setEnableBackplane(false)
      .setEnableInstallAnimate(false)
      .setEnableTouchMask(false)
      .setEnableEffectFlag(0)
      .setExternCb({
        onIconClick: (event?: ClickEvent, fingers?: number): void => {
          this.clickEvent(event);
        }
      });
  }

  private clickEvent(event?: ClickEvent ): void {
    if (this.isInEditMode) {
      return;
    }
    if (this.isInSearchMode) {
      // this.emergencyViewModel.addTempEmergencyInfo(this.appItemInfo);
      if (this.onSearchItemClick) {
        this.onSearchItemClick();
      }
      return;
    }
    log.showInfo('Click, bundleName:%{public}s, abilityName:%{public}s', this.appItemInfo.bundleName, this.appItemInfo.abilityName);
    StartAbilityUtil.startAbilityFromOther({
      bundleName: this.appItemInfo.bundleName,
      abilityName: this.appItemInfo.abilityName,
      moduleName: this.appItemInfo.moduleName
    });
    if (this.modelType == CommonConstants.EMERGENCY_MODEL_TYPE) {
      HiSysEventUtils.reportEmergencyClickAppEvent(TAG, 'clickEvent', this.appItemInfo.bundleName);
    } else if (this.modelType == CommonConstants.THERMAL_MODEL_TYPE) {
      HiSysEventUtils.reportThermalClickAppEvent(TAG, 'clickEvent', this.appItemInfo.bundleName);
    }
  }

  @State iconBadgeVm: AppIconBadgeVm = new AppIconBadgeVm();

  private getAccessibilityClickEventId(): string {
    return `emergencyAppItemClick${this.appItemInfo.keyName}`;
  }


  build() {
    AppIconCommonView({
      appIconConfig: this.appIconConfig,
      item: this.appItemInfo,
      iconSize: this.iconSize,
      nameHeight: CommonConstants.APP_NAME_HEIGHT,
      nameSize: CommonConstants.APP_NAME_SIZE,
      nameMarginTop: CommonConstants.APP_NAME_MARGIN_TOP,
      nameFontColor: this.nameFontColor
    })
  }
}