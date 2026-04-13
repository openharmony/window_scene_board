/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import badgeInfo, { BadgeConfigure } from '@ohos/launchercommon';
import { CustomBadgeManager } from '@ohos/launchercommon';
import { StyleConstants } from '@ohos/launchercommon';
import { SCBSceneContainerSession, SCBScreenProperty } from '@ohos/windowscene';

const TAG = 'AppStartBadgeView';

@Component
export default struct AppStartBadgeView {
  @ObjectLink screenProperty: SCBScreenProperty;
  @ObjectLink sceneContainerSession: SCBSceneContainerSession;
  private badgeNumber: number = 0;
  private badgeParameter: BadgeConfigure = new BadgeConfigure();
  @Prop badgeAlpha: number = 0;
  @Prop badgeVisibility: boolean = true;
  private badgeScale: number = StyleConstants.BADGE_SCALE;

  aboutToAppear(): void {
    this.badgeNumber = this.getBadgeNumber();
    this.setBadgeInfo(this.sceneContainerSession.primarySession?.sceneInfo.bundleName as string);
  }

  private setBadgeConfigure(badgeNumber: number): void {
    if (badgeNumber === 0) {
      return;
    }
    if (badgeNumber > 0 && badgeNumber <= 9) {
      this.badgeParameter = badgeInfo.get('From1to9') as BadgeConfigure;
    } else if (badgeNumber >= 10 && badgeNumber <= 99) {
      this.badgeParameter = badgeInfo.get('From10to99') as BadgeConfigure;
    } else {
      this.badgeParameter = badgeInfo.get('MoreThan99') as BadgeConfigure;
    }
  }

  private getBadgeNumber(): number {
    let bundleName: string = this.sceneContainerSession.primarySession?.sceneInfo.bundleName as string;
    return CustomBadgeManager.getInstance().getAppBadgeValue(bundleName);
  }

  private setBadgeInfo(bundleName: string): void {
    CustomBadgeManager.getInstance().clearAppStarBadge(bundleName);
    this.setBadgeConfigure(this.badgeNumber);
  }

  build() {
    if (this.badgeNumber > 0) {
      Text(this.badgeNumber > 99 ? '99+' : this.badgeNumber.toString())
        .fontSize(this.badgeParameter.textFontSize * this.badgeScale)
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
        .backgroundColor(Color.Red)
        .width(this.badgeParameter.textWidth * this.badgeScale)
        .height(this.badgeParameter.textHeight * this.badgeScale)
        .borderRadius(this.badgeParameter.textHeight / 2 * this.badgeScale)
        .offset({
          x: px2vp(Math.min(this.screenProperty?.width, this.screenProperty?.height)) -
            (this.badgeParameter.textWidth - this.badgeParameter.badgeDistanceIcon) * this.badgeScale,
          y: -this.badgeParameter.badgeDistanceIcon * this.badgeScale
        })
        .opacity(this.badgeAlpha)
        .renderFit(RenderFit.CENTER)
        .visibility(this.badgeVisibility ? Visibility.Visible : Visibility.None)
    }
  }
}
