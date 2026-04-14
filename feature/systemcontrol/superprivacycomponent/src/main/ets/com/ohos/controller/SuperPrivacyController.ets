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

// import superPrivacyManager from '@hms.security.superPrivacyManager';
import Want from '@ohos.app.ability.Want';
import { i18n } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Prompt from '@ohos.promptAction';
import { FASlotName } from '@ohos/commonconstants/src/main/ets/constants/Constants';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { AppStorageUtil } from '@ohos/basicutils/src/main/ets/utils/AppStorageUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { PluginClickInfo } from '@ohos/frameworkwrapper/src/main/ets/plugin/PluginParseInfo';
import { default as sSettingsUtil } from '@ohos/frameworkwrapper/src/main/ets/setting/SettingsUtil';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/utils/GlobalContext';
import { obtainLocalEvent } from '@ohos/frameworkwrapper/src/main/ets/utils/EventUtil';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { EdmAdminManager } from '@ohos/systemuicommon/src/main/ets/manager/EdmAdminManager';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleScene, ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { EventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/EventManagerAdapter';
import Constants from '../common/Constants';
import SuperPrivacyData from '../common/SuperPrivacyData';

const TAG = 'Model.SuperPrivacyController:';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const OPEN_PRIVACY_MODE_ALWAYS_PROTECT: string = 'Always protect';
const OPEN_PRIVACY_MODE_FOLD_PROTECT: string = 'Fold protect';
const CLOSE_PRIVACY_MODE: string = 'Off';
const LAST_ENABLED_SUPER_PRIVACY_MODE: string = 'lastEnabledSuperPrivacyMode';
const PERSIST_EDM_LOCATION_CONFIG: string = 'persist.edm.location_policy';
const PERSIST_EDM_CAMERA_KEY: string = 'persist.edm.camera_disable';
const PERSIST_EDM_MICROPHONE_KEY: string = 'persist.edm.mic_disable';
PersistentStorage.persistProp<number>(
  LAST_ENABLED_SUPER_PRIVACY_MODE,
  0
  // superPrivacyManager.SuperPrivacyMode.ON_WHEN_FOLDED
);
enum EdmMode {
  MICROPHONE = 1 << 0,
  CAMERA = 1 << 1,
  LOCATION = 1 << 2,
}

export class SuperPrivacyController extends ToggleBaseViewModel {
  private mSuperPrivacyData: SuperPrivacyData = new SuperPrivacyData();
  private isSuperPrivacyAvailable: boolean = false;
  // private lastEnabledSuperPrivacyMode: number = superPrivacyManager.SuperPrivacyMode.ON_WHEN_FOLDED;
  private isPc: boolean = DeviceHelper.isPC();
  // 超级隐私软模式，不带确认弹窗，通常是pc端，包含某设备的pc模式
  public isSupportSoftSuperPrivacyNoConfirmController(): boolean {
    return this.isPc && Constants.IS_SUPPORT_SOFT_PROTECT && !Constants.IS_PADDLE_DEVICE;
  }
  // 超级隐私软模式，带确认弹窗，通常是移动端，包含某设备的平板模式
  public isSupportSoftSuperPrivacyWithConfirmController(): boolean {
    return !this.isPc && Constants.IS_SUPPORT_SOFT_PROTECT;
  }
  // 折叠保护
  public isSupportFoldSuperPrivacyController(): boolean {
    return Constants.IS_SUPPORT_FOLD_PROTECT;
  }

  public openDetailPageFunc: (() => void) | undefined = () => {
    if (!this.isSuperPrivacyAvailable) {
      log.showWarn('unavailable');
      return;
    }
    log.showInfo('handleLongClick');
    if (this.isSupportFoldSuperPrivacyController()) {
      this.handleOnControlCenterWithScreenLockForUIE((): void => {
        this.openSuperPrivacySubPanel();
      }, true);
    } else if (this.isSupportSoftSuperPrivacyNoConfirmController()) {
      // hopper软模式开关超级隐私不响应长按
      log.showDebug('pc soft superPrivacy handleLongClick do nothing');
    } else {
      this.handleOnControlCenterWithScreenLockForUIE((): void => {
        this.goSuperPrivacy();
      }, false);
    }
  }

  constructor() {
    super();
    this.getViewData().label = $r('app.string.super_privacy_toggle');
    this.getViewData().icon = $r('app.media.ic_super_privacy');
  }

  setCustomCommonData(scene?: ToggleScene | undefined): void {
    if (scene === ToggleScene.PHONE) {
      // 不支持长按事件
      this.customCommonData.isSupportLongClickAction = false;
    }
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    if (!this.isAvailable()) {
      log.showError('current device is not support super privacy');
      return;
    }
    this.updateDisableState();
    if (this.mSuperPrivacyData == null) {
      log.showError('mSuperPrivacyData is null');
      return;
    }
    if (Constants.IS_SUPPORT_FOLD_PROTECT) {
      // this.lastEnabledSuperPrivacyMode = this.getLastEnabledMode();
    }
    try {
      log.showDebug('start onSuperPrivacyModeChange');
      // superPrivacyManager.on('superPrivacyModeChange', this.onSuperPrivacyModeChange);
    } catch (error) {
      log.showError('monitor superPrivacyModeChange failed');
    }
  }

  onStop(): void {
    super.onStop();
    log.showInfo('onStop');
    if (!this.isSuperPrivacyAvailable) {
      log.showError('current device is not support super privacy');
      return;
    }

    try {
      // superPrivacyManager.off('superPrivacyModeChange', this.onSuperPrivacyModeChange);
    } catch (error) {
      log.showError('disabled monitor superPrivacyModeChange failed');
    }
  }

  private updateIconAndLabel(): void {
    if (Constants.IS_SUPPORT_FOLD_PROTECT) {
      switch (this.mSuperPrivacyData.mode) {
        // case superPrivacyManager.SuperPrivacyMode.OFF:
        //   this.getViewData().icon = $r('app.media.ic_super_privacy');
        //   this.getViewData().label = $r('app.string.super_privacy_toggle');
        //   break;
        // case superPrivacyManager.SuperPrivacyMode.ON_WHEN_FOLDED:
        //   this.getViewData().icon = $r('app.media.ic_super_privacy_mini_fold');
        //   this.getViewData().label = $r('app.string.super_privacy_toggle_fold_protect');
        //   break;
        // case superPrivacyManager.SuperPrivacyMode.ALWAYS_ON:
        //   this.getViewData().icon = $r('app.media.ic_super_privacy');
        //   this.getViewData().label = $r('app.string.super_privacy_toggle_always_protect');
        //   break;
        default:
          break;
      }
    }
  }

  updateDisableState(): void {
    if (this.isSupportSoftSuperPrivacyNoConfirmController()) {
      this.getViewData().isUnavailable = !EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_LOCATION_CONFIG) ||
      !EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_CAMERA_KEY) ||
      !EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_MICROPHONE_KEY);
    }
    log.showInfo(`updateDisableState isUnavailable: ${this.getViewData().isUnavailable}`);
  }

  isAvailable(): boolean {
    try {
      this.isSuperPrivacyAvailable =
        this.isSupportSoftSuperPrivacyNoConfirmController() || this.isSupportSoftSuperPrivacyWithConfirmController() ||
        this.isSupportFoldSuperPrivacyController();
      return this.isSuperPrivacyAvailable;
    } catch (err) {
      log.showError('isAvailable err:', err);
      this.isSuperPrivacyAvailable = false;
      return false;
    }
  }

  handleOneClick(): boolean {
    if (!this.isSuperPrivacyAvailable) {
      log.showWarn('unavailable');
      return false;
    }
    log.showInfo(`handleClick, old mode: ${this.mSuperPrivacyData.mode},old status: ${this.getViewData().isOn}`);
    // hopper软模式开关超级隐私不需要确认弹框,pc控制中心页面只出现在解锁状态，handleClickWithScreenLockAndEdit会重复触发解锁事件不要调用
    if (this.isSupportSoftSuperPrivacyNoConfirmController()) {
      try {
        // let newMode = superPrivacyManager.SuperPrivacyMode.OFF;
        // if (this.mSuperPrivacyData.mode === superPrivacyManager.SuperPrivacyMode.OFF) {
        //   newMode = superPrivacyManager.SuperPrivacyMode.ALWAYS_ON;
        // }
        // if (this.getViewData().isUnavailable) {
        //   Prompt.showToast({
        //     message: this.getEdmEnsureResource(),
        //   });
        // } else {
        //   superPrivacyManager.setSuperPrivacyMode(newMode, superPrivacyManager.Source.OTHER);
        // }
      } catch (err) {
        log.showError(`${TAG} setSuperPrivacyMode error code is ${(err as BusinessError).code}`);
      }
    } else {
      this.handleClickWithScreenLockAndEdit((): void => {
        this.goSuperPrivacyDialog(this.getCurrentState());
      });
    }
    return true;
  }

  private getEdmEnsureResource(): ResourceStr {
    let mode = (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_LOCATION_CONFIG) ? EdmMode.LOCATION : 0) |
      (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_CAMERA_KEY) ? EdmMode.CAMERA : 0) |
      (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_MICROPHONE_KEY) ? EdmMode.MICROPHONE : 0);
    switch (mode) {
      case EdmMode.MICROPHONE:
        return $r('app.string.edm_super_privacy_content_mic');
      case EdmMode.CAMERA:
        return $r('app.string.edm_super_privacy_content_cam');
      case EdmMode.LOCATION:
        return $r('app.string.edm_super_privacy_content_loc');
      case (EdmMode.MICROPHONE | EdmMode.CAMERA):
        return $r('app.string.edm_super_privacy_content_cam_mic');
      case (EdmMode.MICROPHONE | EdmMode.LOCATION):
        return $r('app.string.edm_super_privacy_content_mic_loc');
      case (EdmMode.CAMERA | EdmMode.LOCATION):
        return $r('app.string.edm_super_privacy_content_cam_loc');
      case (EdmMode.MICROPHONE | EdmMode.CAMERA | EdmMode.LOCATION):
        return $r('app.string.edm_super_privacy_content_cam_mic_loc');
      default:
        return '';
    }
  }

  getCurrentState(): string {
    if (this.getViewData().isOn) {
      return CLOSE_PRIVACY_MODE;
    }
    if (Constants.IS_SUPPORT_FOLD_PROTECT) {
      // log.showInfo(`last enabled mode: ${this.lastEnabledSuperPrivacyMode}`);
      // if (this.lastEnabledSuperPrivacyMode === superPrivacyManager.SuperPrivacyMode.ALWAYS_ON) {
      //   return OPEN_PRIVACY_MODE_ALWAYS_PROTECT;
      // } else {
      //   return OPEN_PRIVACY_MODE_FOLD_PROTECT;
      // }
    }
    return OPEN_PRIVACY_MODE_ALWAYS_PROTECT;
  }

  /**
   * 获取上一次的超级隐私启用模式
   * @returns SuperPrivacyMode
   */
  private getLastEnabledMode(): number {
    const mode: number = AppStorage.get<number>(LAST_ENABLED_SUPER_PRIVACY_MODE) as number;
    // if (mode !== superPrivacyManager.SuperPrivacyMode.ON_WHEN_FOLDED &&
    //   mode !== superPrivacyManager.SuperPrivacyMode.ALWAYS_ON) {
    //   return superPrivacyManager.SuperPrivacyMode.ON_WHEN_FOLDED;
    // } else {
    //   return mode;
    // }
    return mode;
  }

  /**
   * 获取当前系统语言
   * @returns 系统语言 string
   */
  private getSystemLanguage(): string {
    try {
      const locale: Intl.Locale = new Intl.Locale(i18n.System.getSystemLanguage());
      return locale?.language;
    } catch (error) {
      console.error(`call System.getSystemLanguage failed`);
      return Constants.CHINESE_LANGUAGE_CODE;
    }
  }

  /**
   * 设置当前二级页面的窗体高度
   * @returns 窗体高度（vp）
   */
  private setSubPanelWindowHeight(): number {
    const fontScale: number = Number(sSettingsUtil.getSystemValue('font_scale', '1'));
    const language = this.getSystemLanguage();
    if (isNaN(fontScale)) {
      return Constants.SUB_PANEL_WINDOW_HEIGHT_ZH;
    }
    if (fontScale <= 1) {
      switch (language) {
        case Constants.CHINESE_LANGUAGE_CODE:
          return Constants.SUB_PANEL_WINDOW_HEIGHT_ZH;
        case Constants.ENGLISH_LANGUAGE_CODE:
          return Constants.SUB_PANEL_WINDOW_HEIGHT_EN;
        default:
          return Constants.SUB_PANEL_WINDOW_HEIGHT_OTHERS;
      }
    } else if (fontScale > 1 && fontScale <= 2) {
      switch (language) {
        case Constants.CHINESE_LANGUAGE_CODE:
          return Constants.SUB_PANEL_WINDOW_HEIGHT_ZH_LARGE;
        case Constants.ENGLISH_LANGUAGE_CODE:
          return Constants.SUB_PANEL_WINDOW_HEIGHT_EN_LARGE;
        default:
          return Constants.SUB_PANEL_WINDOW_HEIGHT_OTHERS_LARGE;
      }
    } else {
      return Constants.SUB_PANEL_WINDOW_HEIGHT_HUGE;
    }
  }

  private goSuperPrivacyDialog(switchState: string): void {
    log.showDebug('open SuperPrivacyDialog');
    // 关闭控制中心
    EventManagerAdapter.startAbility(obtainLocalEvent('hideControlPanel', ''));
    let want: Want = {
      bundleName: 'com.ohos.security.privacycenter',
      abilityName: 'SuperPrivacyDialogAbility',
      parameters: {
        'switchState': switchState
      }
    };
    GlobalContext.getContext().startServiceExtensionAbility(want);
    DropDownPanelManager.animToDismissEvent();
  }

  private async goSuperPrivacy(): Promise<void> {
    let want: Want = {
      bundleName: 'com.ohos.settings',
      abilityName: 'com.ohos.settings.MainAbility',
      uri: 'privacy_settings',
      parameters: {
        pushParams: {
          'targetSubRouter': 'search_super_privacy_mode',
          'subUri': 'search_super_privacy_mode',
        }
      }
    };
    GlobalContext.getContext().startAbility(want).then(() => {
      log.showDebug('hideWindowDirectly');
      DropDownPanelManager.hideWindowDirectly();
    });
  }

  private openSuperPrivacySubPanel(): void {
    sToggleSubWindowController.showSubWindowByClickInfo(FASlotName.SUPER_PRIVACY, {
      clickType: 'window',
      bundleName: 'com.ohos.security.privacycenter',
      abilityName: 'SuperPrivacyCardAbility',
      uiExtensionType: 'sys/commonUI',
      windowHeight: this.setSubPanelWindowHeight(),
    } as PluginClickInfo);
  }

  // private onSuperPrivacyModeChange = (mode: superPrivacyManager.SuperPrivacyMode): void => {
  //   log.showInfo('onSuperPrivacyModeChange. current mode: ' + mode + '. this.mode:' + this.mSuperPrivacyData.mode);
  //   this.mSuperPrivacyData.mode = mode;
  //   this.updateIconAndLabel();
  //   this.getViewData().isOn = (this.mSuperPrivacyData.mode !== superPrivacyManager.SuperPrivacyMode.OFF);
  //   if (Constants.IS_SUPPORT_FOLD_PROTECT && this.getViewData().isOn) {
  //     this.lastEnabledSuperPrivacyMode = this.mSuperPrivacyData.mode;
  //     AppStorageUtil.setOrCreate<number>(LAST_ENABLED_SUPER_PRIVACY_MODE, this.mSuperPrivacyData.mode);
  //   }
  // }
}