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

import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { image } from '@kit.ImageKit';
import { NormalPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import StyleConfiguration, { ClickableMenuStyle, SoundDeviceStyle } from '../common/StyleConfiguration';
import Constants from '../common/Constants';
import MicrophonePanelViewModel from '../viewmodel/MicrophonePanelViewModel';

const TAG = 'MicrophonePanel-AppCapturerCardItem';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const COMPONENT_ID_APP_ICON = TAG + '_image_appIcon';
const COMPONENT_ID_APP_NAME = TAG + '_text_appName';
const COMPONENT_ID_APP_BUNDLENAME = TAG + '_App_BundleName_';

@Component
export default struct AppCapturerCardItem {
  // setting for UI
  private mBundleName: string = '';
  private mAppName: string = '';
  private mIcon: image.PixelMap | ResourceStr | DrawableDescriptor | null = null;
  @State styleClickable: ClickableMenuStyle = StyleConfiguration.getClickableMenuStyle();
  @State isSelected: boolean = false;
  @State isHover: boolean = false;
  @Consume isRTL: boolean;
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Consume persistentId: number;
  style: SoundDeviceStyle = StyleConfiguration.getSoundDeviceStyle();

  @Styles normalStyles() {
    .border( {
      width: '2vp',
      color: '#00000000'
    })
  }

  @Styles focusedStyles() {
    .border( {
      width: '2vp',
      color: '#ff0a59f7'
    })
  }

  aboutToAppear() {
    log.showInfo(`${TAG} aboutToAppear`);
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
    MicrophonePanelViewModel.registerStateChangeListener(this);
  }

  aboutToDisappear() {
    log.showInfo(`${TAG} aboutToDisappear`);
    MicrophonePanelViewModel.unregisterStateChangeListener(this);
  }

  build() {
    Row() {
      Row() {
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
          Image(this.mIcon).draggable(false)
            .id(COMPONENT_ID_APP_ICON)
            .width(this.style.imageWidth)
            .height(this.style.imageHeight)
            .rotate({ y: 1, angle: this.isRTL ? 180 : 0 })

          Text(this.mAppName).draggable(false)
            .id(COMPONENT_ID_APP_NAME)
            .fontColor(this.colorModeViewData.wifiOffTextColor)
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .fontSize(this.panelInfo?.listTextSize)
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .focusable(true)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .margin({
              left: this.style.soundDeviceGap,
              right: this.style.soundDeviceGap
            })
        }
        .key(COMPONENT_ID_APP_BUNDLENAME + this.mBundleName)
        .backgroundColor(this.getBackgroundColor())
        .height(this.styleClickable.stackHeight)
        .borderRadius(this.panelInfo?.hoverRadius)
        .padding({
          left: this.styleClickable.stackPadding,
          right: this.styleClickable.stackPadding,
        })
        .onClick((event?: ClickEvent): void => {
          if (event) {
            this.onClickEvent(event);
          }
        })
        .onHover((isHover) => {
          this.isHover = !!isHover;
        })
        .onTouch((event?: TouchEvent): void => {
          if (event) {
            this.onTouchEvent(event);
          }
        })
      }
      .justifyContent(FlexAlign.Center)
      .height(Constants.CARD_NOISE_HEIGHT)
      .borderRadius(this.panelInfo?.hoverRadius)
      .stateStyles({
        normal: this.normalStyles,
        focused: this.focusedStyles
      })
    }
    .padding({ left: this.style.menuMarginLeftRight, right: this.style.menuMarginLeftRight})
    .width(Constants.CARD_WIDTH)
    .height(Constants.CARD_NOISE_HEIGHT)
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

  private onTouchEvent(event: TouchEvent) {
    if (event.type === TouchType.Down) {
      this.isSelected = true;
    } else if (event.type === TouchType.Up) {
      this.isSelected = false;
    }
  }

  private onClickEvent(event: ClickEvent) {
    // 预留打点事件，点击无业务操作

  }

  private reset(): void {
    this.isSelected = false;
    this.isHover = false;
  }

  onStateChange(panelState: boolean): void {
    log.showInfo(`onStateChange panelState: ${panelState}`);
    if (!panelState) {
      this.reset();
    }
  }
}
