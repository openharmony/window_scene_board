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
  LogHelper
} from '@ohos/basicutils';
import {
  sSettingsUtil,
  PluginClickInfo,
  DeviceHelper,
  GlobalContext
} from '@ohos/frameworkwrapper';
import { StartAbilityUtilAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/StartAbilityUtilAdapter';
import { FASlotName } from '@ohos/commonconstants';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
// import minorsProtection from '@hms.core.account.minorsProtection';
import { settings } from '@kit.BasicServicesKit';
import Constants from '../common/Constants'
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import lazy { windowMgr } from '@ohos/windowscene/src/main/ets/windowmanager/WindowManagerProxy';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';
import { ToggleScene, ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';

const TAG = 'Model.JuvenileModeToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export enum JuvenileModeState {
  /**
   *  设置项未成年人模式关闭状态
   */
  CLOSE = -1,

  /**
   *  设置项未成年人模式开启状态
   */
  OPEN = 1,
}
const ERROR_CODE_NEED_OPEN_SUBPAGE: number = 1009900010;

export class JuvenileModeToggleController extends ToggleBaseViewModel {
  public dialogController?: CustomDialogController;
  public privacyController?: CustomDialogController;
  private context: common.ExtensionContext = GlobalContext.getContext();

  public openDetailPageFunc: (() => void) | undefined = () => {
    this.openJuvenileMode();
  }

  constructor() {
    super();
    this.getViewData().label = $r('app.string.juvenile_mode_toggle');
    this.getViewData().icon = $r('app.media.ic_juvenile_mode');
  }

  decorateStyle(style: ToggleStyle, scene?: ToggleScene | undefined): ToggleStyle | undefined {
    if (scene === ToggleScene.PC) {
      style.toggleParam?.labelArrow(true);
    }
    return style;
  }

  isLoadLottie(): boolean {
    return true;
  }

  getLottieOpenDarkName(): string {
    return Constants.LOTTIE_DATA_OPEN_DARK;
  }

  getLottieCloseDarkName(): string {
    return Constants.LOTTIE_DATA_CLOSE_DARK;
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    try {
      settings.registerKeyObserver(this.context, 'parentcontrol_minor_state', settings.domainName.DEVICE_SHARED, () => {
        this.onModeChanged(sSettingsUtil.getValue('parentcontrol_minor_state', '-1', this.context));
      });
    } catch (err) {
      log.showWarn(`registerKeyObserver error: ${err?.code}, ${err?.message}`);
    }
    this.onModeChanged(sSettingsUtil.getValue('parentcontrol_minor_state', '-1', this.context));
  }

  onModeChanged(modeVal: string) {
    log.showInfo('youth mode changed to %{public}s', modeVal);
    let mode = parseInt(modeVal);
    switch (mode) {
      case JuvenileModeState.CLOSE:
        log.showInfo('youth mode closed');
        this.getViewData().isOn = false;
        break;
      case JuvenileModeState.OPEN:
        log.showInfo('youth mode opened');
        this.getViewData().isOn = true;
        break;
      default:
        log.showInfo('youth mode unkown');
        break;
    }
  }

  onStop(): void {
    super.onStop();
    settings.unregisterKeyObserver(this.context, 'parentcontrol_minor_state', settings.domainName.DEVICE_SHARED);
    log.showInfo('onStop');
  }

  isAvailable(): boolean {
    return !DeviceHelper.isEmulator();
  }

  handleOneClick(): boolean {
    log.info('controlCenter JuvenileMode click');
    if (DeviceHelper.isPC()) {
      if (ControlCenterPluginMgr.isPcMode) {
        if (!this.getViewData().isOn) {
          // minorsProtection.turnOnMinorsMode().catch((err: BusinessError) => {
          //   log.showInfo('turnOnMinorsMode catch error code %{public}d', err?.code);
          //   if (err?.code === ERROR_CODE_NEED_OPEN_SUBPAGE) {
          //     windowMgr.showWindowWithAnim(FASlotName.YOUTH_MODE);
          //   }
          // })
          return true;
        } else {
          this.startJuvenileModeService();
        }
      }
      log.info('handleLongClick: long-click event not supported.');
    } else {
      this.openJuvenileMode();
    }
    return true;
  }

  private openJuvenileMode(): void {
    log.showInfo(`openJuvenileMode, now status: ${this.getViewData().isOn}`);
    if (!this.getViewData().isOn) {
      if (ControlCenterPluginMgr.isPcMode) {
        // minorsProtection.turnOnMinorsMode().catch((err: BusinessError) => {
        //   log.showInfo('turnOnMinorsMode catch error code %{public}d', err?.code);
        //   if (err?.code === ERROR_CODE_NEED_OPEN_SUBPAGE) {
        //     windowMgr.showWindowWithAnim(FASlotName.YOUTH_MODE);
        //   }
        // })
      }
      this.handleOnControlCenterWithScreenLockForUIE((): void => this.openJuvenileModeSubWindow(), false);
    } else {
      this.handleOnControlCenterWithScreenLockForUIE((): void => this.startJuvenileModeService(), false);
    }
  }

  private openJuvenileModeSubWindow(): void {
    log.showInfo(`openJuvenileModeSubWindow, now status: ${this.getViewData().isOn}`);
    // minorsProtection.turnOnMinorsMode().catch((err: BusinessError) => {
    //   log.showInfo('turnOnMinorsMode catch error code %{public}d', err?.code);
    //   if (err?.code === ERROR_CODE_NEED_OPEN_SUBPAGE) {
    //     log.showInfo('Need to start the control center sub-page.')
    //     sToggleSubWindowController.showSubWindowByClickInfo(FASlotName.YOUTH_MODE, {
    //       clickType: 'window',
    //       bundleName: 'com.ohos.huaweiid',
    //       abilityName: 'AccountUIExtensionAbility',
    //       uiExtensionType: 'hms/account',
    //       requestType: 25
    //     } as PluginClickInfo);
    //   }
    //   return;
    // })
  }

  private startJuvenileModeService(): void {
    log.showInfo(`startJuvenileModeService, now status: ${this.getViewData().isOn}`);
    DropDownPanelManager.animDelayToDismiss(0);
    try {
      StartAbilityUtilAdapter.startServiceExtensionAbility({
        bundleName: 'com.ohos.parentcontrol',
        abilityName: 'ServiceExtAbility',
        action:'closeMinorsModeByControlCenter',
      });
    } catch (error) {
      log.error(`start JuvenileMode service failed with ${error}`)
    }
  }
}
