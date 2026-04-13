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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SlWidgetId, SlWidgetZIndex } from '@ohos/screenlockcommon/src/main/ets/constants/SlWidgetConst';
import { slStateHelper } from '../../model/helper/SlStateHelper';
import { SlBindState } from '../../model/data/SlBindState';
import lazy OuterScreenLockFormPanel from '@ohos/screenlockwidget/src/main/ets/form/OuterScreenLockFormPanel';
import { MainColor } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/MainColor';
import lazy OuterScreenLockFormViewModel from '@ohos/screenlockwidget/src/main/ets/form/vm/OuterScreenLockFormViewModel';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import { AnyClock } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyClock';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { WBaseProperty } from '@ohos/screenlockcommon';
import { immersiveKgMgr, ImmersiveState, ImmersiveType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { SlOuterFormBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlOuterFormBindState';
import ScreenLockSpaceAnimationViewModel
  from '@ohos/screenlockcomponent/src/main/ets/password/viewmodel/ScreenLockSpaceAnimationViewModel';
import { ScreenLockSpaceAniData } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockSpaceAniOptions';
import { spaceAniHelper } from '@ohos/screenlockcommon/src/main/ets/manager/SpaceAniHelper';

const TAG = 'OuterScreenLockFormPView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Component
export struct OuterScreenLockFormView {
  @Link outerFormViewModel: OuterScreenLockFormViewModel;
  @Link displayMode: number;
  @Link clockStyle: AnyClock;
  @Consume mainColor: MainColor;
  @State slBindState: SlBindState = slStateHelper.getSlBindState();
  @State slClockBindCtrl: SlClockBindState = slStateHelper.getSlClockBindState();
  @State slClockAnimCtrl: WidgetAnimState = slStateHelper.getSlClockAnimCtrl();
  @State immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();
  @State slOuterFormBindCtrl: SlOuterFormBindState | undefined = slStateHelper.getSlOuterFormBindState();
  @State spaceAniFormOpt: ScreenLockSpaceAniData = spaceAniHelper.getSpaceAniCameraState();

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
  }

  private getFormPanelOpacity(): number {
    // 空间感
    if (ScreenLockSpaceAnimationViewModel.isSpaceUnlockAnimation()) {
      log.debug(`getFormPanelOpacity ${this.spaceAniFormOpt.getSpaceOpacity()}`);
      return this.spaceAniFormOpt.getSpaceOpacity();
    }
    // AOD到桌面时钟一镜到底
    if (this.slClockBindCtrl.getClockAodToDesktop()) {
      log.debug(`getFormPanelOpacity aod to desk 0`);
      return 0;
    }
    // 沉浸式动效
    if (this.slOuterFormBindCtrl?.getIsOuterFormImmersiveAnimating()) {
      return 1;
    }
    let alpha = this.slClockBindCtrl.getLayoutOpacity();
    log.debug(`getFormPanelOpacity clockbind alpha:${alpha}`);
    if (this.slClockAnimCtrl?.isSceneAnimating() && !this.slClockBindCtrl.isInDesktopAndAodClockOneShot()) {
      alpha = this.slClockAnimCtrl?.getStateValue(WBaseProperty.ALPHA) as number ?? 1;
      log.debug(`getFormPanelOpacity anim alpha:${alpha}`);
    }
    log.debug(`getFormPanelOpacity global alpha:${this.slBindState.getOpacity()}`);
    return alpha * (1 - this.slBindState.getOpacity() / 150);
  }

  build() {
    if (this.slBindState.isOsAccountUnlocked() && this.immersiveState.immersiveType !== ImmersiveType.TYPE_IMMERSIVE) {
      OuterScreenLockFormPanel({
        outerFormViewModel: this.outerFormViewModel,
        displayMode: this.displayMode,
        isLightWallpaper: this.slBindState.getisLightWallpaper(),
        clockStrokeColor: this.clockStyle.clockStrokeColor,
      })
        .accessibilityLevel('no')
        .opacity(this.getFormPanelOpacity())
        .height(Constants.OUTER_SCREEN_FORM_PANEL_HEIGHT)
        .zIndex(SlWidgetZIndex.Z_INDEX_OUTER_FORM)
        .alignRules({ bottom: { anchor: SlWidgetId.ROOT_ID, align: VerticalAlign.Bottom },
          middle: { anchor: SlWidgetId.ROOT_ID, align: HorizontalAlign.Center } })
    }
  }
}