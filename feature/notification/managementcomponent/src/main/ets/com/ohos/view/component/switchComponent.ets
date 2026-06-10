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

import ConfigData from '../../common/constants';
import { LogDomain, LogHelper, NotificationConfigEvent } from '../../common/BasicCommon';
import { DeviceHelper } from '../../common/DeviceHelper';
import { LengthMetrics } from '@ohos.arkui.node';
import { notificationSettingManager } from '../../manager/NotificationSettingManager';

const TAG = 'ManagementComponent-SwitchComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const COMPONENT_ID_TITLE = TAG + '_Text_title';
const COMPONENT_ID_DESCRIBE = TAG + '_Text_describe';
const COMPONENT_ID_APP_SWITCH = TAG + '_Toggle_appSwitch';
/* 全场景开关条目出现事件的key */
const NTF_DISTRIBUTION_BUTTON_EVENT = 'notification.event.DISTRIBUTED_DEVICE_TYPES_CHANGE';

@Component
export default struct SwitchComponent {
  @State describe: string = '';
  private title: ResourceStr = '';
  private isDistributed = false;
  private initializationAction?: (params?: boolean) => Promise<boolean>;
  private settingAction?: (params?: boolean) => void;
  private register?: (listener: (stateValue: boolean) => void) => void;
  private unRegister?: () => void;

  private registerListener = (stateValue: boolean) => {
    log.showInfo(`initState ${stateValue}`);
    this.initState = stateValue;
  }
  @State initState: boolean = false;

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      this.buildSwitchContent();
      this.buildSwitchToggle();
    }.width(ConfigData.WH_100_100)
    .border({
      color: Color.Transparent,
      radius: $r('app.float.border_radius')
    })
    .backgroundColor(Color.Transparent)
  }

  @Builder
  buildSwitchContent() {
    Row() {
      Column() {
        Text(this.title).draggable(false)
          .id(COMPONENT_ID_TITLE)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .maxFontScale(2)
          .fontWeight(FontWeight.Medium)
          .align(Alignment.Start)
        Text(this.describe).draggable(false)
          .id(COMPONENT_ID_DESCRIBE)
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .maxFontScale(2)
          .align(Alignment.Start)
          .margin({ top: $r('app.float.switchComp_text_margin') })
          .visibility((this.describe ? true : false) ? Visibility.Visible : Visibility.None)
      }.alignItems(HorizontalAlign.Start)
    }
    .margin({ start: LengthMetrics.resource($r('app.float.switchComp_padding_r')) })
    .constraintSize(this.getHeight())
    .alignItems(VerticalAlign.Center)
    .align(Alignment.Start)
    .padding({ end: LengthMetrics.resource($r('app.float.switchComp_padding_r')) })
    .width(ConfigData.WH_80_100)
  }

  @Builder
  buildSwitchToggle() {
    Toggle({ type: ToggleType.Switch, isOn: this.initState })
      .id(COMPONENT_ID_APP_SWITCH)
      .align(Alignment.End)
      .offset({ x: $r('app.float.noDisturb_offset_x'), y: -1 })
      .selectedColor($r('sys.color.comp_background_emphasize'))
      .switchPointColor($r('sys.color.ohos_id_color_foreground_contrary'))
      .width($r('app.float.toggle_comp_width'))
      .height($r('app.float.toggle_comp_height'))
      .onChange((data: boolean) => {
        log.showInfo(`Toggle onChange data:${data}`);
        if (data != this.initState) {
          this.initState = data;
          if (this.settingAction) {
            this.settingAction(data);
          }
        }
      })
      .hoverEffect(DeviceHelper.isPC() ? HoverEffect.Auto : HoverEffect.None)
      .margin({ end: LengthMetrics.resource($r('app.float.switchComp_padding_r')) })
  }

  private getHeight(): ConstraintSizeOptions {
    return this.describe ? { minHeight: $r('app.float.switchComp_height_double_text') } : { minHeight: $r('app.float.status_bar_switchComp_height') };
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    if (this.register) {
      log.showInfo(`aboutToAppear register listener`);
      this.register(this.registerListener);
    }
    if (this.initializationAction) {
      this.initializationAction().then((data: boolean) => {
        log.showInfo(`initializationAction:${data}`);
        this.initState = data;
      });
    }
    if (this.isDistributed) {
      log.showInfo(`distribution event is subscribed`);
      notificationSettingManager.subscribeDistributionChangeEvent(this.onDistributionChange);
    }
  }

  aboutToDisappear(): void {
    if (this.unRegister) {
      log.showInfo(`aboutToDisappear unregister listener`);
      this.unRegister();
    }
    if (this.isDistributed) {
      log.showInfo(`distribution event is unsubscribed`);
      notificationSettingManager.unsubscribeChangeEvent(this.onDistributionChange);
    }
  }

  private onDistributionChange = (event: NotificationConfigEvent): void => {
    if (event[0] !== NTF_DISTRIBUTION_BUTTON_EVENT) {
      return;
    }
    if (this.initializationAction) {
      this.initializationAction().then((data: boolean) => {
        this.initState = data;
      });
    }
  }
}