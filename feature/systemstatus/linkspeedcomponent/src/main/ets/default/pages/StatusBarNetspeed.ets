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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { PluginSlot } from '@ohos/frameworkwrapper';
import { StyleConfigurationCommon, CommonStyle, StatusBarType} from '@ohos/systemuicommon/Index';
import Constants, { LinkSpeedData } from '../common/constants';
import controller from '../controller/NetSpeedController';
import { AccessibilityVm } from '@ohos/systemuicommon/newIndex';
import { InnerEventUtil } from '@ohos/systemuicommon/newTsIndex';
import { EnableSwitchEvent } from '@ohos/systemuicommon';
// instrument ignore file

const TAG = 'SignalComponent-StatusBarNetspeed';
const COMPONENT_ID_SPEED = TAG + '_Text_speed';
const COMPONENT_ID_UNIT = TAG + '_Text_unit';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export default struct StatusBarNetspeed {
  @StorageProp('linkspeedModel_linkspeedStatus') mLinkSpeedData: LinkSpeedData = controller.getData();
  @StorageLink('speed') @Watch('handleSpeedToDisplay') speed: number = 0;
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  @State speedDisplayStr: string = '0';
  @State unitDisplay: string = 'B/s'
  @State switchIsOn: boolean = true;  // 使能开关是否打开

  /**
   * 内容颜色
   */
  @Consume @Watch('onContentColorChange') contentColor: string;

  onContentColorChange() {
    log.info(`onContentColorChange ${this.contentColor}`);
  }

  aboutToAppear() {
    InnerEventUtil.on(EnableSwitchEvent, this.onEnableSwitchEventChange);
    this.handleSpeedToDisplay();
    log.showInfo(`aboutToAppear,first speedDisplay: ${this.speedDisplayStr}`);
  }

  aboutToDisappear() {
    InnerEventUtil.off(EnableSwitchEvent, this.onEnableSwitchEventChange);
    log.showInfo(`aboutToDisappear,last speedDisplay: ${this.speedDisplayStr}`);
  }

  private onEnableSwitchEventChange = (event: EnableSwitchEvent): void => {
    if (event.subEventType === 'show_real_time_network_speed') {
      log.showInfo(`onEnableSwitchEventChange ${event.subEventType} ${event.shareValue}`)
      this.switchIsOn = event.shareValue ?? false;
      this.handleSpeedToDisplay();
    }
  }

  private handleSpeedToDisplay(): void {
    if (this.mLinkSpeedData.isScreenOff) {
      return;
    }
    let speed = this.speed;
    let unit = Constants.BYTE_SHORT;
    if (speed > Constants.SPEED_THRESHOLD) {
      speed = speed / Constants.BYTE;
      unit = Constants.KILO_BYTE_SHORT;
    }
    if (speed > Constants.SPEED_THRESHOLD) {
      speed = speed / Constants.BYTE;
      unit = Constants.MEGA_BYTE_SHORT;
    }
    if (speed > Constants.SPEED_THRESHOLD) {
      speed = speed / Constants.BYTE;
      unit = Constants.GIGA_BYTE_SHORT;
    }
    if (!this.switchIsOn) {
      log.showInfo(`do not refresh!`);
      return;
    }
    // 大于两位数时不保留小数
    let decimals = speed >= 10 ? 1 : 10;
    const speedDisplay: number = Math.floor(speed * decimals) / decimals;
    this.speedDisplayStr = speedDisplay.toString();
    this.unitDisplay = unit + '/s';
    log.showInfo(`handleSpeedToDisplay :${speed} - ${speedDisplay} - ${this.speedDisplayStr} - ${this.unitDisplay}`);
  }

  build() {
    Column() {
      if (this.mLinkSpeedData.status) {
        Text(this.speedDisplayStr).draggable(false)
          .id(COMPONENT_ID_SPEED)
          .fontColor(this.contentColor)
          .width($r('app.float.linkspeed_width'))
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .fontSize($r('app.float.linkspeed_font_size'))
          .fontFamily('HarmonyOS-Sans') // 使用系统字体，不跟随主题字体切换而切换，与设备保持一致
        Text(this.unitDisplay).draggable(false)
          .id(COMPONENT_ID_UNIT)
          .fontColor(this.contentColor)
          .width($r('app.float.linkspeed_width'))
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .fontSize($r('app.float.linkspeed_font_size'))
          .fontFamily('HarmonyOS-Sans') // 使用系统字体，不跟随主题字体切换而切换，与设备保持一致
          .margin({ top: $r('app.float.linkspeed_margin_top') })
      }
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
  }
}