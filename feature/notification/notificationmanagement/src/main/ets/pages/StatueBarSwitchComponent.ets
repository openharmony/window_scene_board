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

import ConfigData from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { DeviceHelper } from '@ohos/managementcomponent';
import { LengthMetrics } from '@ohos.arkui.node';

const TAG = 'ManagementComponent-StatueBarSwitchComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const COMPONENT_ID_TITLE = TAG + '_Text_title';
const COMPONENT_ID_DESC = TAG + '_Text_describe';


@Component
export default struct StatueBarSwitchComponent {
  @Link title: Resource;
  @State describe: string = '';
  private initializationAction?: (params? : boolean) => Promise<boolean>;
  private settingAction?: (params?: boolean, lastUserSwitchState?: boolean) => void;
  private initlastUserSwitchState?: (params? : boolean) => Promise<boolean>;
  @State currentState: boolean = false;
  @Prop @Watch('onExternalChange') externalChange: boolean = false;

  /**
   * 最近一次用户手动设置的状态
   */
  private lastUserSwitchState: boolean = false;

  /**
   * 开关状态变化是否是外部触发（非用户手动设置）
   */
  private isFromExtend: boolean = false;

  /**
   * 监听纯净显示开关状态
   */
  async onExternalChange(): Promise<void> {
    log.showInfo('onExternalChange:' + this.externalChange);
    if (this.externalChange) {
      if (this.currentState) {
        this.isFromExtend = true;
        this.currentState = false;
      }
    } else {
      if (this.currentState !== this.lastUserSwitchState) {
        this.isFromExtend = true;
        this.currentState = this.lastUserSwitchState;
      }
    }
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems:ItemAlign.Center }) {
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
            .id(COMPONENT_ID_DESC)
            .minFontSize($r('sys.float.ohos_id_text_size_body3'))
            .maxFontSize($r('sys.float.ohos_id_text_size_body2'))
            .heightAdaptivePolicy(TextHeightAdaptivePolicy.LAYOUT_CONSTRAINT_FIRST)
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .maxFontScale(2)
            .align(Alignment.Start)
            .margin({ top: $r('app.float.switchComp_text_margin') })
            .visibility((this.describe ? true : false) ? Visibility.Visible : Visibility.None)
        }.alignItems(HorizontalAlign.Start)
      }
      .margin({ start: LengthMetrics.resource($r('app.float.switchComp_padding_r')) })
      .alignItems(VerticalAlign.Center)
      .align(Alignment.Start)
      .width(ConfigData.WH_80_100)

      Toggle({ type: ToggleType.Switch, isOn: this.currentState })
        .align(Alignment.End)
        .offset({ x: $r('app.float.noDisturb_offset_x'), y: 0 })
        .selectedColor($r('sys.color.comp_background_emphasize'))
        .switchPointColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .onChange((data) => {
          log.showInfo(`Toggle onChange data:${data}`);
          this.changeStatus(data);
        })
        .hoverEffect(DeviceHelper.isPC() ? HoverEffect.Auto : HoverEffect.None)
        .margin({ end: LengthMetrics.resource($r('app.float.switchComp_padding_r')) })
    }
    .constraintSize({ minHeight: $r('app.float.status_bar_switchComp_height') })
    .width(ConfigData.WH_100_100)
    .padding({ top: $r('app.float.ntf_hide_banner_content_item_padding'), bottom: $r('app.float.ntf_hide_banner_content_item_padding') })
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    if (this.initializationAction) {
      this.initializationAction().then((data : boolean) => {
        log.showInfo(`initializationAction:${data}`);
        this.currentState = data;
      });
    }
    if (this.initlastUserSwitchState) {
      this.initlastUserSwitchState().then((data: boolean) => {
        log.showInfo(`initlastUserSwitchState: ${data}`);
        this.lastUserSwitchState = data;
      })
    }
  }

  changeStatus(data: boolean) {
    this.currentState = data;
    if (this.isFromExtend) {
      this.isFromExtend = false;
    } else {
      this.lastUserSwitchState = data;
    }
    if (this.settingAction) {
      this.settingAction(data, this.lastUserSwitchState);
    }
  }
}