/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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

import { EventType, ResUtils, scbEventExclusiveManager } from '@ohos/windowscene';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import curves from '@ohos.curves';
import { RecentStyle } from './RecentStyle';
import { defaultRecentDeleteConfig, RecentDelete, RecentDeleteConfig } from './scenepanel/recentpanel/RecentDelete';
import { RecentColorMode } from './scenepanel/recentpanel/RecentColorMode';
import { SCBScenePanelFSM } from './scenepanel/SCBScenePanelFSM';
import { RecentClickReason } from './scenepanel/ScenePanelStates';
import { UIExceptionDetection, UIExceptionType } from '@ohos/windowscene/Index';
import { RecentStateManager } from '../recent/innerstate/RecentStates';
import {
  UIExceptionParams,
  ClearAllIconExceptionParams
} from '@ohos/frameworkwrapper/src/main/ets/hisysevent/ReportParams';

const TAG = 'RecentClearAllView';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

/**
 * RecentClearAllView component for recent missions.
 */
@Component
export default struct RecentClearAllView {
  private clearRecentMissions?: Function = undefined;
  @Prop recentDeleteConfig: RecentDeleteConfig = defaultRecentDeleteConfig;
  @StorageLink('isInRecentEventViewGesture') isInRecentEventViewGesture: boolean = false;
  @State colorModeVM: RecentColorMode = new RecentColorMode();
  private getPosition: Function = (): Position => {
    return RecentDelete.getClearAllButtonPos();
  }

  aboutToAppear(): void {
    UIExceptionDetection.getInstance().registerUIExceptionCallback(UIExceptionType.CLEAR_ALL_ICON, {
      exceptionDetection: () => {
        return RecentStateManager.getInstance().isInRecentView();
      },
      exceptionRestore: (): void => {
        RecentStateManager.getInstance().onInit();
      },
      getExceptionParams: (): UIExceptionParams => {
        let param: ClearAllIconExceptionParams = {
          RECENT_STATE: RecentStateManager.getInstance().currentState
        }
        return param;
      }
    });
  }

  aboutToDisappear(): void {
    UIExceptionDetection.getInstance().unRegisterUIExceptionCallback(UIExceptionType.CLEAR_ALL_ICON);
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
      }
      .width(this.recentDeleteConfig.recentDeleteSymbolColumnRadius)
      .height(this.recentDeleteConfig.recentDeleteSymbolColumnRadius)
      .backgroundColor(this.colorModeVM.themeAllClearButtonBgColor)
      .borderRadius(this.recentDeleteConfig.recentDeleteSymbolBorderRadius)
      .backgroundBrightnessInternal(this.colorModeVM.themeAllClearButtonBgOptions)

      SymbolGlyph($r('sys.symbol.trash_fill'))
        .draggable(false)
        .id(`${TAG}_Image_deleteFull`)
        .width(this.recentDeleteConfig.recentDeleteSymbolSize)
        .height(this.recentDeleteConfig.recentDeleteSymbolSize)
        .fontSize(this.recentDeleteConfig.recentDeleteSymbolSize)
        .fontColor([RecentStyle.RECENT_DELETE_SYMBOL_COLOR])
        .opacity(RecentStyle.DEFAULT_DELETE_SYMBOL_OPACITY)
    }
    .focusable(false)
    .id(`${TAG}_Stack_deleteFull`)
    .size({
      width: this.recentDeleteConfig.recentDeleteImageColumSize,
      height: this.recentDeleteConfig.recentDeleteImageColumSize
    })
    .position(this.getPosition())
    .accessibilityText(ResUtils.getInnerString($r('app.string.close_all_recent_apps')))
    .accessibilityRole(AccessibilityRoleType.BUTTON)
    .onClick(() => {
      if (scbEventExclusiveManager.isExclusive(EventType.RECENT_CARD_CLICK)) {
        return;
      }
      log.showInfo('delete button clicked, clear all recent missions now.');

      SCBScenePanelFSM.getInstance().onClick(RecentClickReason.CLEAR_ALL_MISSION);
      this.clearRecentMissions?.();
    })
    .transition(TransitionEffect.asymmetric(TransitionEffect.OPACITY.animation({
      curve: curves.springMotion(0.3, 1, 0)
    })
      .combine(TransitionEffect.scale({ x: 0, y: 0 }).animation({ curve: curves.springMotion(0.3, 0.8, 0) })),
      TransitionEffect.OPACITY.animation({ curve: Curve.Friction, duration: 250 })
        .combine(TransitionEffect.scale({ x: 0.85, y: 0.85 }).animation({ curve: Curve.Friction, duration: 400 }))))
  }
}