/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
import {
  badgeInfo,
  BadgeConfigure,
  CustomBadgeManager,
  StyleConstants,
  AppIconModel
} from '@ohos/launchercommon';
import { LogHelper, LogDomain } from '@ohos/basicutils';

const TAG = 'AppStartBadge';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

@Component
export default struct AppStartBadge {
  public screenHeight: number = 0;
  public screenWidth: number = 0;
  public bundleName: string = '';
  public appIndex: number = 0;
  private readonly badgeScale: number = StyleConstants.BADGE_SCALE;
  private badgeNumber: number = 0;
  private badgeParameter: BadgeConfigure = new BadgeConfigure();
  @Prop badgeAlpha: number = 0;
  @Prop badgeVisibility: boolean = true;
  @StorageLink('showDesktopBadges') showDesktopBadges: boolean = true;

  aboutToAppear(): void {
    this.initBadgeNumber();
    this.initBadgeConfigure();
  }

  private initBadgeNumber(): void {
    this.badgeNumber = CustomBadgeManager.getInstance().getAppBadgeValue({
      bundleName: this.bundleName,
      appIndex: this.appIndex
    });
    log.showInfo(`app ${this.bundleName} startup badge number: ${this.badgeNumber}`);
  }

  private initBadgeConfigure(): void {
    if (this.badgeNumber === 0) {
      return;
    }
    if (this.badgeNumber > 0 && this.badgeNumber <= 9) {
      this.badgeParameter = badgeInfo.get('From1to9') as BadgeConfigure;
    } else if (this.badgeNumber >= 10 && this.badgeNumber <= 99) {
      this.badgeParameter = badgeInfo.get('From10to99') as BadgeConfigure;
    } else {
      this.badgeParameter = badgeInfo.get('MoreThan99') as BadgeConfigure;
    }
  }

  private getXoffset(): number {
    let offset = px2vp(Math.min(this.screenWidth, this.screenHeight)) -
      (this.badgeParameter.textWidth - this.badgeParameter.badgeDistanceIcon) * this.badgeScale;
    return offset;
  }

  private getYoffset(): number {
    let offset = -this.badgeParameter.badgeDistanceIcon * this.badgeScale;
    return offset;
  }

  build() {
    if (this.showDesktopBadges && this.badgeNumber > 0 &&
      !AppIconModel.getInstance().isIconBadgeInvisible(this.bundleName)) {
      Text(this.badgeNumber > 99 ? '99+' : this.badgeNumber.toString())
        .fontSize(this.badgeParameter.textFontSize * this.badgeScale)
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
        .backgroundColor(Color.Red)
        .width(this.badgeParameter.textWidth * this.badgeScale)
        .height(this.badgeParameter.textHeight * this.badgeScale)
        .borderRadius(this.badgeParameter.textHeight / 2 * this.badgeScale)
        .offset({
          start: LengthMetrics.vp(this.getXoffset()),
          top: LengthMetrics.vp(this.getYoffset()),
        })
        .opacity(this.badgeAlpha)
        .renderFit(RenderFit.CENTER)
        .visibility(this.badgeVisibility ? Visibility.Visible : Visibility.None)
        .maxFontScale(this.badgeParameter.textFontSize === StyleConstants.DEFAULT_12 ?
          StyleConstants.FONT_MAX_SCALE_BADGE_TEXT : StyleConstants.FONT_MAX_SCALE_BADGE_SMALL_TEXT)
    }
  }
}
