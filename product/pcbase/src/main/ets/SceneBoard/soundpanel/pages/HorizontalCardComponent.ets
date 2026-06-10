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

import { LengthMetrics } from '@kit.ArkUI';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import StyleConfiguration, { ClickableMenuStyle, SoundDeviceStyle } from '../common/StyleConfiguration';
import { NormalPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import { PanelManager, PanelStateChangeListener } from '../manager/PanelManager';

const TAG = 'SoundPanel-HorizontalCardComponent';

@Component
export struct HorizontalCardComponent {
  @Prop title: ResourceStr;
  @Prop isChecked: boolean = false;
  clickFunc?: (clickEvent: ClickEvent) => void;
  @Consume persistentId: number;
  @State isSelected: boolean = false;
  @State isHover: boolean = false;
  @State style: SoundDeviceStyle = StyleConfiguration.getSoundDeviceStyle();
  @State styleClickable: ClickableMenuStyle = StyleConfiguration.getClickableMenuStyle();
  @State panelInfo: NormalPanelInfo = StatusBarPanelManager.getInstance()
    .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @BuilderParam imageHeader?: () => void;

  @Styles
  normalStyles() {
    .border({
      width: '2vp',
      color: '#00000000'
    })
  }

  @Styles
  focusedStyles() {
    .border({
      width: '2vp',
      color: '#ff0a59f7'
    })
  }

  build() {
    this.RowLayout()
  }

  @Builder
  RowLayout() {
    Row() {
      Row() {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
          if (this.imageHeader) {
            this.imageHeader();
          }

          Text(this.title)
            .draggable(false)
            .fontColor(this.getCheckedColor())
            .foregroundBrightness(this.isChecked ? undefined : this.colorModeViewData.foregroundPrimaryOption)
            .fontSize(this.panelInfo?.listTextSize)
            .fontWeight(this.getCheckedFontWeight())
            .fontFamily('HarmonyHeiTi')
            .focusable(true)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({
              start: this.imageHeader ? LengthMetrics.resource($r('app.float.sound_device_gap')) :
                LengthMetrics.resource($r('app.float.ntf_list_first_item_margin_top')),
              end: LengthMetrics.resource($r('app.float.sound_device_gap'))
            })
            .layoutWeight(1)

          if (this.isChecked) {
            Image($r('app.media.ic_selected'))
              .draggable(false)
              .width(this.style.imageWidth)
              .height(this.style.imageHeight)
              .fillColor(this.panelInfo?.selectedListTextColor)
              .edgeAntialiasing(0.4)
          }
        }
        .backgroundColor(this.getBackgroundColor())
        .height(this.styleClickable.stackHeight)
        .borderRadius(this.panelInfo?.hoverRadius)
        .padding({
          left: this.styleClickable.stackPadding,
          right: this.styleClickable.stackPadding,
        })
        .onClick((clickEvent: ClickEvent) => {
          if (this.isSelected) {
            return;
          }
          this.clickFunc?.(clickEvent);
        })
        .onHover((isHover: boolean) => {
          this.isHover = isHover;
        })
        .onTouch((event: TouchEvent): void => {
          if (event.type === TouchType.Down) {
            this.isSelected = true;
          } else if (event.type === TouchType.Up) {
            this.isSelected = false;
          }
        })
      }
      .justifyContent(FlexAlign.Center)
      .height($r('app.float.sound_panel_component_slider_margin_bottom'))
      .borderRadius(this.panelInfo?.hoverRadius)
      .stateStyles({
        normal: this.normalStyles,
        focused: this.focusedStyles
      })
    }
    .padding({ left: this.style.menuMarginLeftRight, right: this.style.menuMarginLeftRight })
    .width('100%')
    .height($r('app.float.sound_panel_component_slider_margin_bottom'))
  }

  aboutToAppear(): void {
    PanelManager.getInstance().registerPanelStateChangeListener(this.panelStateChangeListener, TAG);
  }

  aboutToDisappear(): void {
    PanelManager.getInstance().unregisterPanelStateChangeListener(this.panelStateChangeListener, TAG);
  }

  private panelStateChangeListener: PanelStateChangeListener = {
    onPanelForegroundStatusChange: (isPanelForeground: boolean) => {
      if (!isPanelForeground) {
        this.reset();
      }
    }
  };

  private reset(): void {
    this.isSelected = false;
    this.isHover = false;
  }

  private getCheckedColor(): ResourceColor | undefined {
    return this.isChecked ? this.panelInfo?.selectedListTextColor : this.colorModeViewData.wifiOffTextColor;
  }

  private getCheckedFontWeight(): string | FontWeight {
    return this.isChecked ? 600 : FontWeight.Medium;
  }

  private getBackgroundColor(): ResourceColor {
    if (this.isSelected) {
      return this.styleClickable.stackBgColorSelected;
    }
    if (this.isHover) {
      return this.styleClickable.stackBgColorHover;
    }
    return this.styleClickable.stackBgColorUnSelected;
  }
}