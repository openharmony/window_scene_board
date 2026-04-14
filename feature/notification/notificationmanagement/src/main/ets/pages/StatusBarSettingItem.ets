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

import { fontScaleManager, FontScaleState } from '@ohos/managementcomponent';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { SettingsKeyConstants } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { NtfSettingRtlUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingRtlUtil';
import { ICON_INFO, DESCRIPTION_INFO, SYMBOL_ICON_INFO } from '../common/StatusBarSettingEnum';
import { StatusBarSettingModel } from '../model/StatusBarSettingModel';

const TAG = 'StatusBarSettingItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const DEFAULT_PERCENT: number = 100;
const DEFAULT_ICON_WIDTH: number = 24;
const DEFAULT_ICON_MARGIN: number = 16;
const DEFAULT_TOGGLE_WIDTH: number = 36;
const DEFAULT_SPACE: number = 2;

@Component
export struct StatusBarSettingItem {
  @State settingKey: SettingsKeyConstants = SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED;
  @State @Watch('onSettingModelChange') settingModel: StatusBarSettingModel = StatusBarSettingModel.getInstance();
  @State switchState: boolean = this.settingModel.getSwitchState(this.settingKey);
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  @State dynamicFontPadding: number = 17;
  @State itemWidth: number = 1;
  @State desWidthPercent: number = 1;
  @State widthOpacity: number = 0;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @Consume statusBarSettingIconColor: string;

  onSettingModelChange() {
    const curState = this.settingModel.getSwitchState(this.settingKey);
    if (this.switchState !== curState) {
      log.showInfo(`onSettingModelChange ${this.settingKey}: ${curState} -> ${this.switchState}`)
      this.switchState = curState;
    };
  }

  aboutToAppear(): void {
    // 依据大字体的缩放比例调整文本的上下内边距
    if (this.fontScaleState.fontSizeScale >= 1.75) {
      this.dynamicFontPadding = 24;
      if (this.fontScaleState.fontSizeScale < 2) {
        this.dynamicFontPadding = 16;
      } else if (this.fontScaleState.fontSizeScale < 3.2) {
        this.dynamicFontPadding = 20;
      }
    } else {
      this.dynamicFontPadding = 17
    }
    log.showInfo(`aboutToAppear ${this.settingKey} ${this.fontScaleState.fontSizeScale} ${this.dynamicFontPadding}`);
    this.settingModel.getSettingData(this.settingKey).then((value) => {
      this.switchState = value;
    });
  }

  getIconInfo(): Resource | undefined {
    if (this.settingKey === SettingsKeyConstants.SHOW_NEARLINK_ICON && !this.settingModel.supportNearLink) {
      return $r('app.media.ic_statusbar_bluetooth_conect');
    }
    return ICON_INFO.get(this.settingKey);
  }

  @Builder
  IconItem() {
    Image(this.getIconInfo())
      .width($r('app.float.setting_icon_size'))
      .height($r('app.float.setting_icon_size'))
      .margin(
        NtfSettingRtlUtil.getSystemRTL() ? { left: $r('app.float.setting_icon_margin_r') } : { right: $r('app.float.setting_icon_margin_r') }
      )
      .fillColor(this.statusBarSettingIconColor)
      .draggable(false)
  }

  @Builder
  IconSymbol() {
    SymbolGlyph(SYMBOL_ICON_INFO.get(this.settingKey))
      .width($r('app.float.setting_icon_size'))
      .height($r('app.float.setting_icon_size'))
      .fontSize($r('app.float.setting_icon_size'))
      .fontWeight(this.settingKey === SettingsKeyConstants.SHOW_VPN_ICON ? FontWeight.Bolder : FontWeight.Normal)
      .margin(
        NtfSettingRtlUtil.getSystemRTL() ? { left: $r('app.float.setting_icon_margin_r') } : { right: $r('app.float.setting_icon_margin_r') }
      )
      .fontColor([this.statusBarSettingIconColor])
      .draggable(false)
  }

  @Builder
  createToggle() {
    Stack({ alignContent: Alignment.End }) {
      Toggle({ type: ToggleType.Switch, isOn: this.switchState })
        .align(Alignment.End)
        .selectedColor($r('sys.color.comp_background_emphasize'))
        .switchPointColor($r('sys.color.ohos_id_color_foreground_contrary'))
        .accessibilityLevel('yes')
        .width($r('app.float.toggle_comp_width'))
        .height($r('app.float.toggle_comp_height'))
        .onChange((data) => {
          this.switchStateChange(data);
          log.showInfo(`Toggle onChange data:${data} ${this.switchState}`);
        })
    }
    .width($r('app.float.status_bar_switchComp_height'))
    .height($r('app.float.status_bar_switchComp_height'))
  }

  @Builder
  createDes() {
    if (DESCRIPTION_INFO.has(this.settingKey)) {
      // 描述
      Row(){
        Text(this.settingModel.getDescription(this.settingKey))
          .fontSize(this.fontScaleState.getScaleSize($r('app.float.setting_description_size')))
          .fontWeight(FontWeight.Medium)
          .fontFamily('HarmonyHeiTi')
          .lineHeight(this.fontScaleState.getScaleSize($r('app.float.setting_description_height')))
          .padding({ top: this.dynamicFontPadding, bottom: this.dynamicFontPadding, right: DEFAULT_SPACE })
      }.width(`${this.desWidthPercent}%`)
    }
  }

  @Builder
  createIcon() {
    if (ICON_INFO.has(this.settingKey)) {
      // Image图标
      this.IconItem();
    } else if (SYMBOL_ICON_INFO.get(this.settingKey)) {
      // Symbol图标
      this.IconSymbol();
    }
  }

  hasIcon(): boolean {
    if (ICON_INFO.has(this.settingKey) || SYMBOL_ICON_INFO.get(this.settingKey)) {
      return true;
    }
    return false;
  }

  hasDes(): boolean {
    return DESCRIPTION_INFO.has(this.settingKey);
  }

  build() {
    Flex({ alignItems: ItemAlign.Center }) {
      this.createIcon();
      this.createDes();
      this.createToggle();
    }
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      this.itemWidth = Number(newValue.width);
      let defaultPercent: number = DEFAULT_PERCENT;
      let iconWidth = DEFAULT_ICON_WIDTH;
      let iconMargin = DEFAULT_ICON_MARGIN;
      let toggleWidth = DEFAULT_TOGGLE_WIDTH;
      try {
        const res = getContext(this).resourceManager;
        iconWidth = px2vp(res.getNumber($r('app.float.setting_icon_size').id));
        iconMargin = px2vp(res.getNumber($r('app.float.setting_icon_margin_r').id));
        toggleWidth = px2vp(res.getNumber($r('app.float.toggle_comp_width').id));
      } catch (error) {
        log.showInfo(`getNumber error ${error}`)
      }
      if (this.hasIcon()) {
        defaultPercent -= (iconWidth + iconMargin) / this.itemWidth * DEFAULT_PERCENT;
      }
      defaultPercent -= toggleWidth / this.itemWidth * DEFAULT_PERCENT;
      log.showInfo(`defaultPercent ${defaultPercent} ${iconWidth} ${iconMargin} ${toggleWidth}`)
      this.desWidthPercent = defaultPercent;
      this.widthOpacity = 1;
    })
    .margin({
      left: $r('app.float.setting_item_padding_left_right'),
      right: $r('app.float.setting_item_padding_left_right')
    })
    .opacity(this.widthOpacity)
    .accessibilityGroup(this.isAccessibilityMode)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }

  private getAccessibilityText(): string {
    if (!this.isAccessibilityMode) {
      return '';
    }
    let accessibilityText = '';
    try {
      const res = getContext(this).resourceManager;
      accessibilityText = res.getStringSync(this.settingModel.getDescription(this.settingKey));
    } catch (err) {
      log.showError(`getAccessibilityText failed, err: ${err.message}`);
    }
    return accessibilityText;
  }

  private switchStateChange(newState: boolean): void {
    if (newState === this.switchState) {
      return;
    }
    this.switchState = newState;
    this.settingModel.setSettingData(this.settingKey, newState);
  }
}