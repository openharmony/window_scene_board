/**
 * Copyright (c) 2025-2025 Huawei Device Co., Ltd.
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
import { ViewArea, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { BaseViewController } from '@ohos/frameworkcommon';
import {
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBFoldStatePropertyChangeEvent
} from '@ohos/windowscene';
import SmartDockModel from '@ohos/smartdock/src/main/ets/default/model/SmartDockModel';
import { curves } from '@kit.ArkUI';
import { FixedDockResource } from '@ohos/pcsmartdock/src/main/ets/default/common/constants/FixedDockConstants';

const TAG = 'SCBCentralMask';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const INNER_BORDER_WIDTH: number = 1;
const INNER_BORDER_COLOR: string = '#33FFFFFF';

@Component
export struct SCBCentralMask {
  @Link screenProp: SCBScreenProperty;
  persistentId: number = 0;
  private maskHeight = 0;
  private centralMaskController: BaseViewController =
    new BaseViewController(ViewType.CENTRAL_MASK, this.screenProp.screenId);
  @State isFullScreen: boolean = false;
  @StorageLink('isAppCenterShow') @Watch('onAppCenterViewChange') isAppCenterShow: boolean = false;
  @StorageLink('showRecent') @Watch('onRecentCenterViewChange') isRecentCenterShow: boolean = false;
  @State currColorMode: number = 0;
  @State backgroundEffectOptions: BackgroundEffectOptions | undefined = undefined;
  @State mOpacity: number = 0;
  private isSystemBarDark: boolean = false;
  private bSideWidth: number = 0;

  private onAppCenterViewChange(): void {
    this.updateBrightness();
  }

  private onRecentCenterViewChange(): void {
    this.updateBrightness();
  }

  private updateBrightness(): void {
    let isFullScreen = this.isFullScreen && !this.isRecentCenterShow && !this.isAppCenterShow;
    log.showInfo(`updateBrightness: screen:${this.screenProp.screenId}` +
      ` curr:${this.currColorMode} next:${this.currColorMode} currLayout:${isFullScreen} next:${isFullScreen}`);

    if ((isFullScreen && this.mOpacity === 0) || (!isFullScreen && this.mOpacity === 1)) {
      this.updateOpacity(isFullScreen);
    } else {
      this.updateBackgroundColor(isFullScreen);
    }
  }

  private updateOpacity(isFullScreen: boolean, duration: number = 150): void {
    this.getUIContext()?.animateToImmediately({
      delay: isFullScreen ? 150 : 0,
      duration: duration,
      curve: Curve.Sharp,
    }, () => {
      if (isFullScreen) {
        this.centralMaskController.show(false);
        this.currColorMode = this.isSystemBarDark ? 0 : 1;
        this.mOpacity = 1;
        log.showInfo(`show`);
        return;
      }
      this.centralMaskController.hide();
      this.mOpacity = 0;
      log.showInfo(`hide`);
    });
  }

  private updateBackgroundColor(isFullScreen: boolean): void {
    if (!isFullScreen) {
      return;
    }
    this.getUIContext()?.animateTo({
      duration: 350,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
    }, () => {
      this.currColorMode = this.isSystemBarDark ? 0 : 1;
    });
  }

  private getBrightnessOptions(): BrightnessOptions {
    log.showInfo(`currColorMode: ${this.currColorMode}`);
    return (this.currColorMode === 0 ? FixedDockResource.dockBackgroundBrightnessDarkParam :
      FixedDockResource.dockBackgroundBrightnessLightParam);
  }

  private getBackgroundEffectOptions(): BackgroundEffectOptions {
    return this.currColorMode === 0 ? FixedDockResource.dockBackgroundEffectOptionsDarkParam :
      FixedDockResource.dockBackgroundEffectOptionsLightParam;
  }

  aboutToAppear(): void {
    viewMgrPolicy.registerViewController(ViewType.CENTRAL_MASK, this.centralMaskController);
    this.centralMaskController.updateId(this.persistentId);
    this.init();
  }

  aboutToDisappear(): void {
    viewMgrPolicy.unregisterViewController(ViewType.CENTRAL_MASK);
  }

  private init(): void {
  }

  private updateArea(): void {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    screenProperty.width = this.bSideWidth;
    const newVpRect: ViewArea = {
      left: 0,
      top: this.getUIContext()?.px2vp(screenProperty.height) - this.maskHeight,
      width: this.getUIContext()?.px2vp(screenProperty.width),
      height: this.maskHeight
    };
    this.centralMaskController.updateRect(newVpRect);
  }

  onFoldCreasePropertyChange = (isFullScreen: boolean, color: string) => {
    log.showInfo(`onFoldCreasePropertyChange, isFullScreen: ${isFullScreen}, color: ${color}`);
    this.isFullScreen = isFullScreen;
    if (isFullScreen) {
      if (color === '#FFFFFFFF') {
        this.isSystemBarDark = true;
      } else if (color === '#FF000000') {
        this.isSystemBarDark = false;
      }
    }
    this.updateBrightness();
  }

  build() {
    Row() {
      Row()
        .width('100%')
        .height('100%')
        .border({
          width: { top: INNER_BORDER_WIDTH },
          color: INNER_BORDER_COLOR,
        })
        .backgroundColor('#FFFFFFFF')
        .backgroundBrightnessInternal(this.getBrightnessOptions())
    }
    .id('SCBCentralMask')
    .alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.Center)
    .width(this.getUIContext()?.px2vp(this.screenProp.width))
    .height(this.maskHeight)
    .backgroundEffect(this.getBackgroundEffectOptions())
    .opacity(this.mOpacity)
  }
}