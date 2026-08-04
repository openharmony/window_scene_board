/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import toggleHomePresenter from '../common/presenter/ToggleHomePresenter';
import StyleConstants from '../common/constants/StyleConstants';
import { LogDomain, LogHelper, CheckEmptyUtils, } from '@ohos/basicutils';
import {
  sSCBOobeManager,
  ResUtils
} from '@ohos/windowscene';
import ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import { Constants as StatusbarConstants } from '@ohos/statusbarcomponent/src/main/ets/pc/common/Constants';
import measure from '@ohos.measure';

const TAG = 'ToggleHomeForFixedDock';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const HOME_KEY = 'h1_launcher_feature_toggleHome_showDesktop';
const HOVER_TIPS_DELAY: number = 300;

@Component
export struct ToggleHomeForFixedDock {
  private toggleHomeWidth = StyleConstants.TOGGLE_WIDTH_VP;
  private isMouse = false;
  @State isVisible: boolean = false;
  @StorageProp('currColorMode') @Watch('onColorModeChange') currentMode: number = ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  @State defaultIcon: ResourceStr = $r('app.media.Light_toggle_home');
  @State isPopupShow: boolean = false;
  private hoverDelayTimer: number | null = null;

  aboutToAppear(): void {
    log.showInfo(`ToggleHomeForFixedDock, aboutToAppear ${this.toggleHomeWidth}`);
  }

  aboutToDisappear() {
    log.showInfo('ToggleHomeForFixedDock, aboutToDisappear');
  }

  private onColorModeChange(): void {
    this.defaultIcon = this.currentMode == ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT ? $r('app.media.Light_toggle_home') : $r('app.media.Dark_toggle_home');
  }

  build() {
    Stack({ alignContent: Alignment.End }) {
      Image(this.defaultIcon)
        .width(StyleConstants.TOGGLE_IMAGE_WIDTH_VP)
        .height('100%')
        .visibility(this.isVisible ? Visibility.Visible : Visibility.Hidden)
        .interpolation(ImageInterpolation.Medium)
        .objectFit(ImageFit.Fill)
        .matchTextDirection(true)
      Row() {
      }
      .key(HOME_KEY)
      .width('100%')
      .height('100%')
      .onHover(isHover => {
        this.isVisible = isHover;
        this.delayHoverTips(HOVER_TIPS_DELAY, isHover);
      })
      .onClick((event?: ClickEvent) => {
        this.doHotAreaClickEvent(event);
      })
      .onMouse((event?: MouseEvent) => {
        if (!sSCBOobeManager.isEnable()) {
          if (event?.button == MouseButton.Left && event?.action == MouseAction.Press) {
            this.isMouse = true;
          } else {
            this.isMouse = false;
          }
        }
      })
      .bindPopup(this.popupShowJudge(), {
        builder: this.hoverTipsBuilder(),
        placement: Placement.Top,
        mask: false,
        enableArrow: false,
        autoCancel: true,
        showInSubWindow: true,
        radius: StyleConstants.DEFAULT_8,
        shadow: ShadowStyle.OUTER_DEFAULT_SM,
        backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR,
        offset: {x: 0, y: 0}
      })
    }
    .width(this.toggleHomeWidth)
    .height('100%')
    .margin({ top: 1 })
  }

  private clearHoverDelayTimer(): void {
    log.showDebug(`clearHoverDelayTimer happen`);
    if (this.hoverDelayTimer) {
      clearTimeout(this.hoverDelayTimer);
      this.hoverDelayTimer = null;
    }
  }

  private delayHoverTips(delay: number, isHovered: boolean): void {
    this.clearHoverDelayTimer();
    this.hoverDelayTimer = setTimeout(() => {
      this.isPopupShow = isHovered;
      this.clearHoverDelayTimer();
      log.showDebug(`delayHoverTips happen end, isPopupShow: ${this.isPopupShow}`);
    }, delay);
  }

  @Builder
  hoverTipsBuilder() {
    Row() {
      Text($r('app.string.back_home'))
        .draggable(false)
        .id(`StatusBarPluginForPC_Text_tray`)
        .width(this.getHoverTipsTextWidth(ResUtils.getInnerStringByName('back_home')))
        .height(StyleConstants.POPUP_TEXT_HEIGHT)
        .fontSize($r(StatusbarConstants.PC_HOVER_TIPS_TEXT))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .align(Alignment.Center)
    }
    .height(StyleConstants.POPUP_HEIGHT)
    .justifyContent(FlexAlign.Center)
  }

  private getHoverTipsTextWidth(name: string): number | string {
    let width: number | string = StyleConstants.POPUP_MIN_TEXT_WIDTH;
    if (CheckEmptyUtils.checkStrIsEmpty(name)) {
      return width;
    }
    width = this.getTextWidth(name, width);
    return width;
  }

  private getTextWidth(appName: string, width: number): number {
    let needTextWidth: number = Math.round(px2vp(measure.measureText({
      textContent: appName,
      fontSize: $r('sys.float.ohos_id_text_size_body1'),
      fontWeight: FontWeight.Regular,
      overflow: TextOverflow.Ellipsis,
      maxLines: 1
    }))) + StyleConstants.DEFAULT_16;
    return needTextWidth > width ? needTextWidth : width;
  }

  private popupShowJudge(): boolean {
    log.showInfo(`isPopupShow:${this.isPopupShow}`);
    return this.isPopupShow;
  }

  private doHotAreaClickEvent(event?: ClickEvent) {
    log.showInfo(`doHotAreaClickEvent : event.x: ${event?.x} + event.y: ${event?.y}`);
    toggleHomePresenter.doPresent(this.isMouse);
    this.isMouse = false;
  }
}