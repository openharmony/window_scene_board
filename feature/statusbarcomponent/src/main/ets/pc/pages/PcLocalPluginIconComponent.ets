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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { PluginLocalInfo, PluginSlot, AbsResourceManager as ResourceManager } from '@ohos/frameworkwrapper';
import PcBatteryIcon from '@ohos/batterycomponent/src/main/ets/pc/pages/PcBatteryIcon';
import ClockIcon from '@ohos/clockcomponent/src/main/ets/default/pages/clockIcon';
import StatusBarIconItemLocationComponent
 from '@ohos/locationcomponent/src/main/ets/com/ohos/pages/StatusBarIconItemLocationComponent';
import StatusBarIconItemUSBComponent
 from '@ohos/usbcomponent/src/main/ets/pages/StatusBarIconItemUSBComponent';
import InputMethodSubTypeIcon from '@ohos/inputmethodcomponent/src/main/ets/default/pages/inputMethodSubTypeIcon';
import InputMethodIcon from '@ohos/inputmethodcomponent/src/main/ets/default/pages/inputMethodIcon';
import { SuperPrivacyStatusBarIcon } from '@ohos/superprivacy/src/main/ets/pages/SuperPrivacyStatusBarIcon';
import { StatusBarTint } from '../../common/StatusBarTint';
import CameraIndicatorIcon from '@ohos/cameraindicator/src/main/ets/com/ohos/pages/cameraIndicatorIcon';
import EnterpriseSpaceIcon from '@ohos/enterprisespacecomponent/src/main/ets/pages/EnterpriseSpaceIcon';
import { PluginProperty } from '../viewdata/PluginProperty';
import lazy StatusBarManager from '../manager/StatusBarManager';
import { StaticComponent } from './StaticComponent';
import {
  AudioDeviceController
} from '@ohos/earphonecomponent/src/main/ets/default/controller/AudioDeviceController';
import { PluginDisplayStyle } from '../common/PluginConstants';
import { PluginStyleUtil } from '../common/PluginStyleUtil';

const TAG = 'LocalPluginIconComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const COMPONENT_ID_ICON = TAG + '_Image_icon';

const SEPARATOR_BRIGHT_COLOR = '#99ffffff';
const SEPARATOR_DARK_COLOR = '#99000000';

/**
 * 本地状态栏图标
 *
 * @since 2022-11-06
 */
@Component
export struct PcLocalPluginIconComponent {
  @ObjectLink property: PluginProperty;
  @Consume contentColor: string;
  private controller: AudioDeviceController = AudioDeviceController.getInstance();
  private resourceMgr: ResourceManager | null = null;

  aboutToAppear(): void {
    // 图标内容颜色变更事件
    log.showInfo(`aboutToAppear contentColor: ${this
      .contentColor} statusBarType:${PluginDisplayStyle[PluginStyleUtil.getCurStatusBarType()]}`);
    this.resourceMgr = StatusBarManager.getInstance().getResourceManager();
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear slot ' + this.property.getSlot());
  }

  build() {
    if (this.hasStaticIcon() && this.property.pluginInfo) { // 静态图标类型
      StaticComponent({
        pluginInfo: this.property?.pluginInfo,
        componentId: COMPONENT_ID_ICON,
        resourceMgr: this.resourceMgr,
      })
    } else { // 定制图标
      this.createCustomIcon()
    }
  }

  @Builder
  createCustomIcon() {
    if (this.isBattery()) { // 电池
      PcBatteryIcon({
        resourceMgr: this.resourceMgr,
      })
    } else if (this.isClock()) { // PC时钟
      ClockIcon()
    } else if (this.isInputMethodSubType()) {
      InputMethodSubTypeIcon()
    } else if (this.isInputMethod()) {
      InputMethodIcon()
    } else if (this.isPcEnterpriseSpace()) {
      EnterpriseSpaceIcon()
    } else if (this.isPcSuperPrivacy()) {
      SuperPrivacyStatusBarIcon()
    } else if (this.isLocation()) { // 位置信息
      StatusBarIconItemLocationComponent()
    } else if (this.isUSB()) { // usb监听
      StatusBarIconItemUSBComponent()
    }
  }

  /**
   * 判断是否为USB
   *
   * @return true
   */
  private isUSB(): boolean {
    return this.property.getSlot() === PluginSlot.SLOT_STATUS_USB;
  }

  /**
   * 判断是否为位置信息
   *
   * @return true位置信息
   */
  private isLocation(): boolean {
    return this.property.getSlot() == PluginSlot.SLOT_STATUS_LOCATION;
  }

  private getShadow(): ShadowOptions {
    if (this.contentColor === StatusBarTint.CONTENT_COLOR_WHITE) {
      return {
        radius: 6,
        offsetY: 2,
        color: '#26000000'
      };
    } else {
      return { radius: 0 };
    }
  }

  private getSeparatorColor(): ResourceColor {
    if (this.contentColor === StatusBarTint.CONTENT_COLOR_BLACK) {
      return SEPARATOR_DARK_COLOR;
    } else {
      return SEPARATOR_BRIGHT_COLOR;
    }
  }

  /**
   * 判断是否为分割线
   *
   * @return true分割线
   */
  private isSeparator(): boolean {
    return this.property.getSlot() == PluginSlot.SLOT_STATUS_SEPARATOR;
  }

  /**
   * 判断是否为电池图标
   *
   * @return true电池
   */
  private isBattery(): boolean {
    return this.property.getSlot() == PluginSlot.SLOT_STATUS_BATTERY_PANEL;
  }

  /**
   * 判断是否为企业空间
   *
   * @return true个人中心
   */
  private isPcEnterpriseSpace(): boolean {
    return this.property.getSlot() === PluginSlot.SLOT_STATUS_ENTERPRISE_SPACE;
  }

  /**
   * 判断是否为pc超级隐私
   *
   * @return true个人中心
   */
  private isPcSuperPrivacy(): boolean {
    return this.property.getSlot() === PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT ||
      this.property.getSlot() === PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE;
  }

  /**
   * 判断是否为时钟
   *
   * @return true时钟
   */
  private isClock(): boolean {
    return this.property.getSlot() == PluginSlot.SLOT_STATUS_CLOCK_PANEL;
  }

  /**
   * 输入法子类型
   * @returns
   */
  private isInputMethodSubType(): boolean {
    return this.property.getSlot() === PluginSlot.SLOT_STATUS_INPUT_PANEL;
  }

  /**
   * 输入法
   * @returns
   */
  private isInputMethod(): boolean {
    return this.property.getSlot() === PluginSlot.SLOT_STATUS_INPUT_METHOD;
  }

  /**
   * 判断是否静态图标
   *
   * @return true静态图标
   */
  private hasStaticIcon(): boolean {
    if (this.property.getSlot() === PluginSlot.SLOT_STATUS_PERSONAL ||
      this.property.getSlot() === PluginSlot.SLOT_STATUS_CONTROL_CENTER ||
      this.property.getSlot() === PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL ||
      this.property.getSlot() === PluginSlot.SLOT_STATUS_SOUND_PANEL ||
      this.property.getSlot() === PluginSlot.SLOT_STATUS_MICROPHONE_PANEL) {
      return true;
    }

    return !CommonUtils.isInvalid((this.property.pluginInfo as PluginLocalInfo)?.icon);
  }
}