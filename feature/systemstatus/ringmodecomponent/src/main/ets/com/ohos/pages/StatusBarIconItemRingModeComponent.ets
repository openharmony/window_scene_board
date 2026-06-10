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

import audio from '@ohos.multimedia.audio';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RingModeController } from '../controller/RingModeController';
import { StyleConfigurationCommon, CommonStyle } from '@ohos/systemuicommon/Index';
import StyleConfiguration, { StatusRingModeComponentStyle } from '../common/StyleConfiguration';
import { RingModeData } from '../common/Constants';
import { PluginSlot } from '@ohos/frameworkwrapper';
import { AccessibilityVm } from '@ohos/systemuicommon/newIndex';
import { GlobalContext } from '@ohos/frameworkwrapper';
// instrument ignore file

const TAG = 'ringmode-StatusBarIconItemRingModeComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const COMPONENT_ID_RING_MODE = TAG + '_Image_ringMode';

@Component
export default struct StatusBarIconItemRingModeComponent {
  @StorageProp('RingModeModel_RingModeStatus') @Watch('onRingModeDataChange') ringModeData: RingModeData = RingModeController.getInstance().getData();
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  @State style: StatusRingModeComponentStyle = StyleConfiguration.getStatusRingModeComponentStyle();
  private showResource?: Resource;
  private ringModeIcons: Array<Resource> = [];
  /**
   * 内容颜色
   */
  @Consume contentColor: string;

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    const res = GlobalContext.getContext()?.resourceManager;
    if (this.ringModeData.mode === audio.AudioRingMode.RINGER_MODE_SILENT) {
      return res.getStringByNameSync('accessibility_status_bar_ring_off_filled');
    } else {
      return res.getStringByNameSync('accessibility_status_bar_vibration_on');
    }
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.ringModeIcons = [];
    this.ringModeIcons[audio.AudioRingMode.RINGER_MODE_SILENT.toString()] = $r('app.media.ic_statusbar_ring_off_filled');
    this.ringModeIcons[audio.AudioRingMode.RINGER_MODE_VIBRATE.toString()] = $r('app.media.ic_statusbar_vibration_on');
    // normal状态默认置为静音图标，在实际执行中，会在controller中通过EvtBus.post隐藏图标，在实际显示时该图标不显示。
    // 这样设计是为了避免从静音切到normal状态时连续两次刷新组件，导致图标闪动。（1.ringModeData变化刷新；2.EvtBus.post发送事件刷新）
    this.ringModeIcons[audio.AudioRingMode.RINGER_MODE_NORMAL.toString()] = $r('app.media.ic_statusbar_ring_off_filled');
    log.showInfo(`${this.style.statusBarRingModeWidth}, ${this.style.statusBarRingOffWidth}`)
    this.showResource = this.ringModeIcons[this.ringModeData.mode.toString()];
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  onRingModeDataChange() {
    if (this.ringModeData.mode === audio.AudioRingMode.RINGER_MODE_NORMAL) {
      return;
    }
    this.showResource = this.ringModeIcons[this.ringModeData.mode.toString()];
  }

  build() {
    Row() {
      Image(this.showResource)
        .draggable(false)
        .id(COMPONENT_ID_RING_MODE)
        .objectFit(this.ringModeData.mode ===
        audio.AudioRingMode.RINGER_MODE_VIBRATE ? ImageFit.Cover : ImageFit.Contain)
        .width(this.ringModeData.mode === audio.AudioRingMode.RINGER_MODE_VIBRATE ?
        this.style.statusBarRingModeWidth : this.style.statusBarRingOffWidth)
        .height(this.style.statusBarRingModeHeight)
        .fillColor(this.contentColor)
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .opacity($r('app.float.icon_component_opacity'))
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }
}