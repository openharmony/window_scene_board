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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AppItemInfo } from '../../bean/AppItemInfo';
import { AppStatus, CommonConstants } from '../../constants/CommonConstants';
import { AppInstallImageVm } from '../viewmodel/AppInstallImageVm';
import { AppInstallImageEvent } from '../viewmodel/AppInstallImageEvent';
import { StyleConstants } from '../../constants/StyleConstants';
import { NotHarmonyUtil } from '../../TsIndex';

const TAG = 'AppInstallImage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

@Component
export struct AppInstallImage {
  private appIconId: string = '';
  private itemInfo: AppItemInfo = new AppItemInfo();
  private onItemAppStatusChange: (status: AppStatus) => void = (status: AppStatus): void => {};
  private isAdaptiveExtendLayout: boolean = false;
  private itemOffset?: Position;

  @Prop iconRadius: number = 0;
  @Link iconSize: number;
  @Prop iconScale: number = 1.0;
  @Prop isLongPressHideMask: boolean = false;
  // 用于小文件夹打开关闭动效设置蒙层透明度
  @Prop iconOpacity: number = 1.0;

  @State installImageVm: AppInstallImageVm = new AppInstallImageVm();
  private installImageEvent: AppInstallImageEvent = new AppInstallImageEvent(this.installImageVm);
  private isOuterDesktop: boolean = false;

  private isInstallingImageVisible(): boolean {
    log.showInfo(`isInstallingImageVisible notInstallState: ${this.installImageVm.notInstallState}, ` +
      `isLongPressHideMask: ${this.isLongPressHideMask}, isOuterDesktop: ${this.isOuterDesktop}`);
    return this.installImageVm.notInstallState === AppStatus.INSTALLING && !this.isLongPressHideMask &&
      !this.isOuterDesktop;
  }

  private isInstallPauseImageVisible(): boolean {
    log.showInfo(`isInstallPauseImageVisible notInstallState: ${this.installImageVm.notInstallState}, ` +
      `isLongPressHideMask: ${this.isLongPressHideMask}, isOuterDesktop: ${this.isOuterDesktop}`);
    return (this.installImageVm.notInstallState === AppStatus.PAUSING ||
      this.installImageVm.notInstallState === AppStatus.WIFI_WAITING) && !this.isLongPressHideMask &&
      !this.isOuterDesktop;
  }

  private getProgressMask(): ProgressMask | null {
    log.showInfo('appInstall getProgressMask[%{public}s] appStatus:%{public}d isShow:%{public}s, progress:%{public}s, isLongPressHideMask %{public}s',
      this.itemInfo.bundleName, this.itemInfo.appStatus, this.installImageVm.isProgressShow,
      this.installImageVm.progress !== null, this.isLongPressHideMask);
    if ((this.itemInfo.appStatus === AppStatus.WAIT_FOR_HARMONY &&
      CommonUtils.jsonStrToMap(this.itemInfo.intent).get(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE) === 1) ||
      this.isOuterDesktop) {
      this.installImageVm.progress = new ProgressMask(0, CommonConstants.MAX_DOWNLOAD_VALUE,
        StyleConstants.APP_ICON_INSTALL_COLOR);
    }
    return this.installImageVm.isProgressShow && !this.isLongPressHideMask ? this.installImageVm.progress : null;
  }

  private getIconSize(): number | string {
    // 下载蒙层稍微扩宽, 避免蒙层不能完全遮罩
    return this.isAdaptiveExtendLayout ? StyleConstants.PERCENTAGE_100 : this.iconSize + px2vp(1);
  }

  aboutToAppear(): void {
    this.installImageEvent.init(this.itemInfo, this.onItemAppStatusChange);
  }

  aboutToDisappear(): void {
    this.installImageEvent.destroy();
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column()
        .draggable(false)
        .enabled(false)
        .width(this.getIconSize())
        .height(this.getIconSize())
        .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL, bottom: PixelRoundCalcPolicy.FORCE_CEIL })
        .mask(this.getProgressMask())
        .renderFit(RenderFit.RESIZE_FILL)
      Image($r('app.media.installing'))
        .draggable(false)
        .visibility(this.isInstallingImageVisible() ? Visibility.Visible : Visibility.None)
        .width(this.getIconSize())
        .height(this.getIconSize())
        .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL, bottom: PixelRoundCalcPolicy.FORCE_CEIL })
        .opacity(this.installImageVm.opacity)
        .enabled(false)
      Image($r('app.media.pause'))
        .draggable(false)
        .visibility(this.isInstallPauseImageVisible() ? Visibility.Visible : Visibility.None)
        .width(this.getIconSize())
        .height(this.getIconSize())
        .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL, bottom: PixelRoundCalcPolicy.FORCE_CEIL })
        .interpolation(ImageInterpolation.None)
        .hitTestBehavior(HitTestMode.None)
        .enabled(false)
    }
    .enabled(false)
    .opacity(this.iconOpacity)
    .width(this.isAdaptiveExtendLayout ? StyleConstants.PERCENTAGE_100 : this.iconSize)
    .height(this.isAdaptiveExtendLayout ? StyleConstants.PERCENTAGE_100 : this.iconSize)
    .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL, bottom: PixelRoundCalcPolicy.FORCE_CEIL })
    .scale({ x: this.iconScale, y: this.iconScale })
    .borderRadius(this.iconRadius)
    .clip(true)
    .alignRules({
      middle: { anchor: this.appIconId, align: HorizontalAlign.Center },
      center: { anchor: this.appIconId, align: VerticalAlign.Center },
    })
    .offset(this.itemOffset)
    .id(`${this.appIconId}_${TAG}`)
    .attributeModifier(this.installImageVm.modifier)
  }
}