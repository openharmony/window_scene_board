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

import systemParameterEnhance from '@ohos.systemParameterEnhance';
import lazy { windowMgr } from '@ohos/windowscene/src/main/ets/windowmanager/WindowManagerProxy';
import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {
  DeviceHelper,
  obtainLocalEvent,
  PluginClickInfo,
  sEventManager,
} from '@ohos/frameworkwrapper';
import { StartAbilityUtilAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/StartAbilityUtilAdapter';
import { FASlotName } from '@ohos/commonconstants';
import Constants from '../common/Constants';
import { EdmAdminManager } from '@ohos/systemuicommon/src/main/ets/manager/EdmAdminManager';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import NearLinkManager from './NearLinkManager';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';
import { ToggleScene, ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';

const TAG = 'Ctrl.NearLinkToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const NEAR_LINK_CCM_CONFIG = 'const.nearlink.enable';
const PERSIST_EDM_NEAR_LINK_CONFIG = 'persist.edm.near_link_disallowed';
const ISWAIT_CLEAR_TIMEOUT: number = 5000;

export default class NearLinkToggleController extends ToggleBaseViewModel {
  private isWaitingLastActionDone: boolean = false;
  private callbackTimeoutTimeId: number = -1;
  private nearLinkManager: NearLinkManager | undefined = undefined;

  public openDetailPageFunc: (() => void) | undefined = () => {
    if (this.getViewData().isUnavailable) {
      log.showWarn('nearlink openDetailPageFunc disabled');
      if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_NEAR_LINK_CONFIG)) {
        EdmAdminManager.instance.showToastWhenInoperable();
      }
      return;
    }
    if (DeviceHelper.isPC()) {
      if (ControlCenterPluginMgr.isPcMode) {
        windowMgr.showWindowWithAnim(FASlotName.NEAR_LINK)
        return;
      }
      log.showInfo('handleLongClick: long-click event is supported.');
      this.openNearLinkSubPanelLabelClick();
    } else {
      log.showInfo('handleLongClick');
      this.handleOnControlCenterWithScreenLockForUIE((): void => this.openNearLinkSubPanel(), true);
    }
  }

  constructor() {
    super();
    this.getViewData().label = $r('app.string.control_center_complex_toggle_nearlink_title');
    this.getViewData().icon = $r('app.media.ic_nearlink');
  }

  getLottieOpenDarkName(): string {
    return Constants.LOTTIE_DATA_OPEN_DARK;
  }

  getLottieCloseDarkName(): string {
    return Constants.LOTTIE_DATA_CLOSE_DARK;
  }

  getNewLottieCloseName(): string {
    return Constants.NEW_LOTTIE_DATA_CLOSE;
  }

  getNewLottieOpenName(): string {
    return Constants.NEW_LOTTIE_DATA_OPEN;
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

  isDarkReverse(): boolean {
    return true;
  }

  async onStart(): Promise<void> {
    super.onStart();
    log.showInfo('onStart');
    this.nearLinkManager = await NearLinkManager.getInstance();
    // 初始化开关状态
    this.initNearLinkState();
    // 监听注册监听
    this.nearLinkManager.subscribeNearLinkState(this.onNearLinkStateChange);
    this.updateDisableState();
  }

  initNearLinkState() {
    if (this.nearLinkManager === undefined) {
      log.showInfo(`initNearLinkState nearLinkManager undefined`)
      return;
    }
    try {
      let nearLinkState = this.nearLinkManager.getNearLinkState();
      log.showInfo(`init near link status : ${nearLinkState}`)
      this.switchNearLinkStatus(nearLinkState);
    } catch (error) {
      log.showError('initNearLinkState error', error);
    }
  }

  private onNearLinkStateChange = (status: boolean) => {
    log.showInfo(`near link state change, state : ${status}`);
    this.switchNearLinkStatus(status);
  }

  switchNearLinkStatus(status: boolean) {
    if (this.isWaitingLastActionDone) {
      this.isWaitingLastActionDone = false;
      if (status !== this.getViewData().isOn) {
        this.switchNearLinkState(this.getViewData().isOn);
      }
      return;
    }
    if (this.getViewData().isOn != status) {
      this.getViewData().isOn = status;
    }
  }

  onStop(): void {
    log.showInfo('onStop');
    this.nearLinkManager?.unSubscribeNearLinkState();
  }

  isAvailable(): boolean {
    if (DeviceHelper.isEmulator()) {
      log.showInfo('Disable the NearLink on the simulator');
      return false;
    }
    let isSupport: string = 'false';
    try {
      isSupport = systemParameterEnhance.getSync(NEAR_LINK_CCM_CONFIG, 'false');
    } catch (error) {
      log.showError('get isSupportNearLink fail', error);
    }
    return isSupport === 'true';
  }

  /**
   * 更新快捷开关的置灰状态
   */
  public updateDisableState(): void {
    if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_NEAR_LINK_CONFIG)) {
      this.getViewData().isUnavailable = true;
      return;
    }
    this.getViewData().isUnavailable = false;
  }

  handleOneClick(): boolean {
    log.showInfo(`handleClick start old status: ${this.getViewData()?.isOn}  ${this.isWaitingLastActionDone}`);
    if (this.getViewData().isUnavailable) {
      log.showWarn('nearlink disabled');
      if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_NEAR_LINK_CONFIG)) {
        EdmAdminManager.instance.showToastWhenInoperable();
      }
      return false;
    }
    this.getViewData().isOn = !this.getViewData().isOn;
    if (!this.isWaitingLastActionDone) {
      this.isWaitingLastActionDone = true;
      this.handleCallbackTimeout();
      this.switchNearLinkState(this.getViewData().isOn);
    }
    return true;
  }

  private handleCallbackTimeout(): void {
    if (this.callbackTimeoutTimeId !== -1) {
      clearTimeout(this.callbackTimeoutTimeId);
      this.callbackTimeoutTimeId = -1;
    }
    this.callbackTimeoutTimeId = setTimeout(() => {
      log.showInfo('reset wait action flag');
      this.isWaitingLastActionDone = false;
      this.callbackTimeoutTimeId = -1;
    }, ISWAIT_CLEAR_TIMEOUT);
  }

  private switchNearLinkState(isOn: boolean): void {
    if (this.nearLinkManager === undefined) {
      log.showInfo(`switchNearLinkState nearLinkManager undefined`)
      return;
    }
    this.nearLinkManager.changeNearLinkStateConcurrent(isOn);
    this.isWaitingLastActionDone = false;
  }

  openNearLinkSubPanel(): void {
    sToggleSubWindowController.showSubWindowByClickInfo(FASlotName.NEAR_LINK, {
      clickType: 'window',
      bundleName: 'com.ohos.settings',
      abilityName: 'NearLinkUIExtensionSettingsAbility',
      uiExtensionType: 'sys/commonUI',
      windowHeight: 370
    } as PluginClickInfo);
  }

  openNearLinkSubPanelLabelClick(): void {
    log.showDebug('handleLabelClick');
    sEventManager.publish(obtainLocalEvent('hideControlPanel', ''));
    StartAbilityUtilAdapter.startServiceExtensionAbility({
      bundleName: 'com.ohos.settings',
      abilityName: 'NearLinkWindowSettingsAbility',
    });
  }
}