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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AudioDeviceController } from '../controller/AudioDeviceController';
import { StyleConfigurationCommon, CommonStyle } from '@ohos/systemuicommon/Index';
import StyleConfiguration, { StatusEarphoneComponentStyle } from '../common/StyleConfiguration';
import audio from '@ohos.multimedia.audio'
import { GlobalContext, PluginSlot } from '@ohos/frameworkwrapper';
import { AccessibilityVm } from '@ohos/systemuicommon/newIndex';

const TAG = 'EarPhoneData-StatusBarIconItemEarPhoneComponent';
const COMPONENT_ID_EARPHONE = TAG + '_Image_earphone';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

interface CurOutputDev {
  deviceType: number;
  deviceId: number;
}

@Component
export default struct StatusBarIconItemEarPhoneComponent {
  @StorageLink('CurDevSelect') @Watch('curDevChange') curOutputDev: CurOutputDev = {
    deviceType: audio.DeviceType.SPEAKER,
    deviceId: -1
  };
  controller: AudioDeviceController = AudioDeviceController.getInstance();
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  @State style: StatusEarphoneComponentStyle = StyleConfiguration.getStatusEarphoneComponentStyle();

  /**
   * 内容颜色
   */
  @Consume contentColor: string;

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    const res = GlobalContext.getContext()?.resourceManager;
    return res.getStringByNameSync('accessibility_status_bar_ear');
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.curDevChange();
  }

  curDevChange() {
    log.showWarn(`curDevChange, device type: ${this.curOutputDev.deviceType}`);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  build() {
    Row() {
      Image($r('app.media.ic_connection_headphone'))
        .draggable(false)
        .id(COMPONENT_ID_EARPHONE)
        .objectFit(ImageFit.Contain)
        .width(this.style.statusBarEarphoneWidth)
        .height(this.style.statusBarEarphoneHeight)
        .fillColor(this.contentColor)
    }
    .height('100%')
    .opacity($r('app.float.icon_component_opacity'))
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }
}