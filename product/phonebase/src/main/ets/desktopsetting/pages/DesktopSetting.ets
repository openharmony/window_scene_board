/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import DeviceInfo from '@ohos.deviceInfo';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ContextManager } from '../ability/ContextManager';
import common from '@ohos.app.ability.common';

let storage = LocalStorage.getShared();
const TAG = 'SettingPage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCS, TAG);

@Entry(storage)
@Component
export default struct SettingPage {
  public static readonly PIFLOOW_MINE_STATE: string = 'piflow_mine_state';
  @StorageLink('autoAlignStatus') autoAlignStatus: boolean = false;
  deviceType: string = DeviceInfo.deviceType || 'phone';
  @State cardMargin: number = 16;

  @Styles
  normalStyles() {
    .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_xl'))
  }

  @Styles
  pressedStyles() {
    .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_xl'))
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.cardMargin = this.deviceType === 'phone' ? 16 : 24;
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  onPageHide(): void {
    log.showInfo('onPageHide');
  }

  // 标题
  @Builder
  title() {
    Row() {
      Row() {
        Image($r('app.media.ic_public_arrow_left_filled'))
          .width(24).height(24)
          .fillColor($r('sys.color.ohos_id_color_primary'))
          .draggable(false)
      }
      .width(40)
      .height(40)
      .justifyContent(FlexAlign.Center)
      .stateStyles({
        normal: this.normalStyles,
        pressed: this.pressedStyles,
      })
      .onClick(() => {
        try {
          storage?.get<UIExtensionContentSession>('session')?.sendData({ 'action': 'pop' })
        } catch (error) {
          log.showError(`${TAG}, registerCallBack error, ${error}`);
        }
      })

      Text($r('app.string.Desktop_setting'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontSize($r('sys.float.ohos_id_text_size_headline8'))
        .fontWeight(700)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ left: 8 })
    }
    .width('100%').height(56)
  }

  // 桌面布局
  @Builder
  desktopLayoutSwitch() {
    Row() {
      Text($r('app.string.desktop_layout'))
        .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontWeight(FontWeight.Medium)
        .fontFamily('HarmonyHeiTi-Medium')
        .padding({ left: 12 })
    }
    .width('100%')
    .margin({ bottom: 10, top: 28 })

    // bottom
    Row() {
      Column() {
        Text($r('app.string.auto_align'))
          .fontSize($r('sys.float.ohos_id_text_size_sub_title2'))
          .fontWeight(500)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontFamily('HarmonyHeiTi')
          .textAlign(TextAlign.Start)
          .width('100%')
        Text($r('app.string.auto_align_content'))
          .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .fontWeight(FontWeight.Medium)
          .fontFamily('HarmonyHeiTi-Medium')
          .margin({ top: 6 })
          .width('100%')
          .textAlign(TextAlign.Start)
      }
      .flexShrink(1)

      Toggle({ type: ToggleType.Switch, isOn: this.autoAlignStatus as boolean })
        .onChange((isOn: boolean) => {
          log.showInfo(`autoAlignStatus, isOn:${isOn}`);
          this.autoAlignStatus = isOn;
        })
        .hoverEffect(HoverEffect.None)
    }
    .padding({ left: 12, right: 12, top: 14, bottom: 14 })
    .backgroundColor($r('sys.color.ohos_id_color_card_bg'))
    .borderRadius(16)
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    Column() {
      this.title()
      Scroll() {
        Column() {
          this.desktopLayoutSwitch()
        }
        .padding({ top: 28, bottom: 14 })
      }
      .layoutWeight(1)
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.Top)
      .scrollable(ScrollDirection.Vertical).scrollBar(BarState.Off)
    }
    .padding({left: this.cardMargin, right: this.cardMargin}).width('100%').height('100%')
    .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
  }
}