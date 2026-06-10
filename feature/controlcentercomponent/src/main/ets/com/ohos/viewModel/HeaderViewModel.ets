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

import { LogDomain, LogHelper, SingletonHelper, StartType } from '@ohos/basicutils';
import { ExtAppConstants } from '@ohos/commonconstants';
import {
  HiSysEventUtil,
  obtainStartAbility,
  sEventManager,
  GlobalContext,
} from '@ohos/frameworkwrapper';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { StartAbilityOverlayAnimate } from './StartAbilityOverlayAnimate';
import sControlCenterBaseController from '../controller/ControlCenterBaseController';
import { HeaderViewData } from '../model/HeaderViewData';
import lazy { MultiWindowToggleController } from '../controller/MultiWindowToggleController';
import { EventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/EventManagerAdapter';
import { CloseAppManagerAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/CloseAppManagerAdapter';
import { SceneSessionAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/SceneSessionAdapter';

const TAG = 'Ctrl.HeaderViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export class HeaderViewModel {

  private viewData?: HeaderViewData;

  public static getInstance(): HeaderViewModel {
    let headerViewModel: HeaderViewModel = SingletonHelper.getInstance(HeaderViewModel, TAG);
    return headerViewModel;
  }

  initData(viewData: HeaderViewData) {
    this.viewData = viewData;
  }

  /**
   * 跳转设置主界面
   */
  public onSettingClick = () => {
    log.showInfo('settingClick');
    HiSysEventUtil.reportCCSettingIconClick({
      LOCK_STATUS: AppStorage.get('lockStatus'),
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`
    });
    if (this.needStartOverlayAnimate()) {
      CloseAppManagerAdapter.setStartAppType(StartType.APP);
      StartAbilityOverlayAnimate.getInstance().prepareForOverlayAnimate();
    }
    sControlCenterBaseController.handleOnControlCenterWithScreenLockForUIE(this.handleSettingClick, false, false);
  }

  private handleSettingClick = () => {
    log.showInfo('handleSettingClick');
    EventManagerAdapter.startAbility(obtainStartAbility(ExtAppConstants.PKG_SETTINGS,
      ExtAppConstants.ABILITY_SETTINGS_MAIN, ExtAppConstants.MODULE_PHONE_SETTINGS_SOUND));
  }

  public setVisibleOfSettingIcon(visible: boolean) {
    if (this.viewData) {
      this.viewData.isSettingIconVisible = visible;
    }
  }

  public getIconName(symbolName: string, appIconName: string): string {
    try {
      GlobalContext.getContext().resourceManager.getSymbolByName(symbolName);
      return `sys.symbol.${symbolName}`;
    } catch (e) {
      log.showWarn(`getIconName error = ${e}`);
      return `app.media.${appIconName}`;
    }
  }

  /**
   * 判断是否需要执行Overlay动画
   * 分屏,宇宙立方中景,PAD多窗场景不需要走StartAbilityOverlay动效
   */
  private needStartOverlayAnimate(): boolean {
    if (MultiWindowToggleController.getInstance().getViewData().isOn) {
      log.showWarn(`MultiWindow state is opening, no need to start OverlayAnimate`);
      return false;
    }
    return SceneSessionAdapter.isSplitScreenMode();
  }
}