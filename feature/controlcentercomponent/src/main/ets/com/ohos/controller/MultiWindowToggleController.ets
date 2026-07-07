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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import {
  HiDfxEventUtil,
  obtainLocalEvent,
  PluginSlot,
  HiSysEventUtil,
  SwitchFreeMultiWindowModeReason,
  DeviceHelper,
} from '@ohos/frameworkwrapper';
import {
  SCBScreenProperty,
  SCBRotateChangeReason,
  ResUtils,
} from '@ohos/windowscene';
import { SceneSessionAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/SceneSessionAdapter';
import { ScreenSessionAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ScreenSessionAdapter';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { RotationConstants } from '@ohos/commonconstants';
import { PromptAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/PromptAdapter';
import { EventManagerAdapter } from '@ohos/systemuicommon';
import { DeviceInfoVm } from '@ohos/systemuicommon/src/main/ets/vm/DeviceInfoVm';

const TAG: string = 'MultiWindowToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const mainScreenId: number = 0;

export class MultiWindowToggleController extends ToggleBaseViewModel {
  // 控制中心多窗按钮开关状态, 默认为false
  private isThreeFoldProduct: boolean = DeviceHelper.isThreeFoldProduct();

  private rotateChangeCallBack = (screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason) => {
    if (reason === SCBRotateChangeReason.ROTATE_BEGIN) {
      log.showInfo(`rotateChangeCallBack rotation: ${screenProperty.rotation}`);
      this.getViewData().isUnavailable = screenProperty.rotation === RotationConstants.ROTATION_0 ||
        screenProperty.rotation === RotationConstants.ROTATION_180;
    }
  }

  constructor() {
    super();
    this.onStart();
  };

  isPersist(): boolean {
    return true;
  }

  onStart(): void {
    this.getViewData().label = $r('app.string.multi_window_widget_name');
    this.getViewData().icon = $r('sys.symbol.rectangle_on_rectangle_fill');
    this.init();
  }

  decorateStyle(style: ToggleStyle): ToggleStyle | undefined {
    style.toggleParam?.isSymbolIcon(true)
      .symbolRendering(SymbolRenderingStrategy.MULTIPLE_COLOR)
      .isSupportRTL(true)
    return style;
  }

  async init(): Promise<void> {
    log.showInfo(`init`);
    try {
      this.getViewData().isOn = DeviceInfoVm.instance.isMultiWinPcMode;
      AppStorage.setOrCreate('pcModeState', this.getViewData().isOn);
      if (this.isThreeFoldProduct) {
        this.getViewData().isUnavailable = true;
      } else {
        ScreenSessionAdapter.registerScreenRotateChangeCallbacks({
          callback: this.rotateChangeCallBack,
          mainScreenId: mainScreenId,
        }, `${TAG}_registerScreenRotateChangeCallbacks`);
      }
    } catch (err) {
      log.error(TAG, 'init failed.', err);
      return;
    }
    log.showInfo(`init success ${this.getViewData().isOn}`);
  }

  async unInit() {
    log.showInfo(`unInit`);
    try {
      if (!this.isThreeFoldProduct) {
        ScreenSessionAdapter.unRegisterScreenRotateChangeCallbacks({
          callback: this.rotateChangeCallBack,
          mainScreenId: mainScreenId,
        }, `${TAG}_unRegisterScreenRotateChangeCallbacks`);
      }
    } catch (err) {
      log.error(TAG, `unInit failed.`, err);
    };
  }

  /**
   * Get the instance of the MultiWindowToggleController class
   */
  public static getInstance(): MultiWindowToggleController {
    return SingletonHelper.getInstance(MultiWindowToggleController, TAG);
  }

  isAvailable(): boolean {
    return SceneSessionAdapter.isSupportPcMode();
  }

  async handleOneClick(): Promise<void> {
    log.showInfo(`handleClick, isOn: ${this.getViewData().isOn}, isUnavailable: ${this.getViewData().isUnavailable}`);
    if (this.getViewData().isUnavailable) {
      let message: Resource = $r('app.string.rotate_to_landscape');
      if (this.isThreeFoldProduct) {
        let isGState: boolean = await ScreenSessionAdapter.isSecondaryFoldablePhoneExpandStatus();
        message = isGState ? message : $r('app.string.unfold_to_g_state');
      }
      PromptAdapter.showToast(ResUtils.getInnerString(message));
      return;
    }

    HiDfxEventUtil.reportToggleClick(PluginSlot.SLOT_CONTROL_MULTI_WINDOW, HiDfxEventUtil.TOGGLE_TYPE_CLICK);
    HiSysEventUtil.reportSwitchFreeMultiWindowMode({
      SWITCH_REASON: SwitchFreeMultiWindowModeReason.CONTROL_CENTER_TOGGLE_TYPE_CLICK_EVENT,
      IS_ENTER: !this.getViewData().isOn
    });

    this.getViewData().isOn = !this.getViewData().isOn;
    if (!this.getViewData().isOn) {
      EventManagerAdapter.startAbility(obtainLocalEvent('onExitPCModeClick', true));
      return;
    }
  }
}