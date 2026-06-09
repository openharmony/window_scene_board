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

import { StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  ImmersiveKeyguardCardComponent
} from '@ohos/immersivekeyguard/src/main/ets/view/card/ImmersiveKeyguardCardComponent';
import {
  ImmersiveKeyguardListComponent
} from '@ohos/immersivekeyguard/src/main/ets/view/list/ImmersiveKeyguardListComponent';
import { NotificationType } from '@ohos/notificationcomponent/src/main/ets/common/NotificationType';
import { SlWidgetId, SlWidgetZIndex } from '@ohos/screenlockcommon/src/main/ets/constants/SlWidgetConst';
import { KeyGuardMode, SlAreaType, SlVisualControl } from '@ohos/screenlockcommon';
import { SlStateBaseMgr, SlStateMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import lazy { ImmersiveCapView, ImmersiveCardView, ImmersiveListView } from '@ohos/immersivekeyguard';
import { ImmersiveCapsuleComponent } from '@ohos/immersivekeyguard/src/main/ets/view/capsule/ImmersiveCapsuleComponent';
import { slComStateMgr } from '../../model/manager/SlCommonStateManager';
import { SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ImmersiveKeyguardParams, ImmersiveKeyguardVc } from '../subviewcontrol/ImmersiveKeyguardVc';

export interface ImmersiveKeyguardViewParams extends ImmersiveKeyguardParams {
  vc: ImmersiveKeyguardVc;
}

/**
 * 沉浸锁屏通知View
 *
 * @param $$ 沉浸锁屏UI构造需要的参数
 */
@Builder
export function ImmersiveKeyguardView($$: ImmersiveKeyguardViewParams) {
  if ($$ && $$.vc && $$.keyGuardMode === KeyGuardMode.DEFAULT) {
    buildImmersiveKeyguardListComponent($$)
    buildImmersiveKeyguardCardComponent($$)
    buildImmersiveCapsuleComponent($$)
  }
}

@Builder
function buildImmersiveKeyguardListComponent($$: ImmersiveKeyguardViewParams) {
  if (SlStateBaseMgr.isV2Enable()) {
    ImmersiveListView()
      .hitTestBehavior(HitTestMode.Transparent)
      .visibility($$.vc.getImmersiveVisibility($$, true))
      .width(StyleConstants.PERCENTAGE_100)
      .scale($$.vc.getImmersiveKeyguardListScale($$))
      .opacity($$.vc.getImmersiveKeyguardListOpacity($$))
      .id(SlWidgetId.IMMERSIVE_LIST)
      .zIndex($$.vc.getImmersiveListZIndex($$))
      .alignRules({
        top: { anchor: SlWidgetId.LOCK_HEAD, align: VerticalAlign.Bottom },
        bottom: { anchor: SlWidgetId.ROOT_ID, align: VerticalAlign.Bottom },
        left: { anchor: SlWidgetId.ROOT_ID, align: HorizontalAlign.Start }
      })
      .accessibilityLevel('no')
      .onAreaChange((old, newArea) => {
        SlVisualControl.getInstance().updateComponentArea(SlAreaType.NTF_LIST, newArea);
      })
  } else {
    ImmersiveKeyguardListComponent({
      notificationType: NotificationType.TYPE_PHONE_KEYGUARD,
      isNtfFingerprintConflict: $$.isNtfFingerprintConflict
    })
      .hitTestBehavior(HitTestMode.Transparent)
      .visibility($$.vc.getImmersiveVisibility($$, true))
      .width(StyleConstants.PERCENTAGE_100)
      .scale($$.vc.getImmersiveKeyguardListScale($$))
      .opacity($$.vc.getImmersiveKeyguardListOpacity($$))
      .id(SlWidgetId.IMMERSIVE_LIST)
      .zIndex($$.vc.getImmersiveListZIndex($$))
      .alignRules({
        top: { anchor: SlWidgetId.LOCK_HEAD, align: VerticalAlign.Bottom },
        bottom: { anchor: SlWidgetId.ROOT_ID, align: VerticalAlign.Bottom },
        left: { anchor: SlWidgetId.ROOT_ID, align: HorizontalAlign.Start }
      })
      .accessibilityLevel('no')
      .onAreaChange((old, newArea) => {
        SlVisualControl.getInstance().updateComponentArea(SlAreaType.NTF_LIST, newArea);
      })
  }
}

@Builder
function buildImmersiveKeyguardCardComponent($$: ImmersiveKeyguardViewParams) {
  if (SlStateBaseMgr.isV2Enable()) {
    // 内屏沉浸态
    ImmersiveCardView()
      .hitTestBehavior(HitTestMode.Transparent)
      .visibility($$.vc.getImmersiveVisibility($$, true))
      .width(StyleConstants.PERCENTAGE_100)
      .id(SlWidgetId.IMMERSIVE_CARD)
      .scale($$.vc.getImmersiveKeyguardCardScale($$))
      .opacity($$.vc.getImmersiveKeyguardCardOpacity($$))
      .zIndex($$.vc.getImmersiveCardZIndex($$))
      .alignRules($$.vc.getImmersiveCardAlignRules($$))
      .accessibilityLevel('no')
    // 小外屏沉浸态
    if ($$.isDeviceWithOuter) {
      ImmersiveCardView({ stateMgrName: SlStateMgr.MGR_OUTER_SCREEN })
        .hitTestBehavior(HitTestMode.Transparent)
        .visibility($$.vc.getOuterImmVisibility($$))
        .width(StyleConstants.PERCENTAGE_100)
        .id(SlWidgetId.IMMERSIVE_CARD_OUTER)
        .scale($$.vc.getImmersiveKeyguardCardScale($$))
        .opacity($$.vc.getImmersiveKeyguardCardOpacity($$))
        .zIndex($$.vc.getImmersiveCardZIndex($$))
        .alignRules($$.vc.getImmersiveCardAlignRules($$))
        .accessibilityLevel('no')
    }
  } else {
    ImmersiveKeyguardCardComponent({
      notificationType: NotificationType.TYPE_PHONE_KEYGUARD,
      isFoldFullDisplay: $$.isFoldExpand,
      isSmallFoldOuterScreen: $$.isSmallFoldOuterScreen
    })
      .hitTestBehavior(HitTestMode.Transparent)
      .visibility($$.vc.getImmersiveVisibility($$))
      .width(StyleConstants.PERCENTAGE_100)
      .id(SlWidgetId.IMMERSIVE_CARD)
      .scale($$.vc.getImmersiveKeyguardCardScale($$))
      .opacity($$.vc.getImmersiveKeyguardCardOpacity($$))
      .zIndex($$.vc.getImmersiveCardZIndex($$))
      .alignRules($$.vc.getImmersiveCardAlignRules($$))
      .accessibilityLevel('no')
  }
}

@Builder
function buildImmersiveCapsuleComponent($$: ImmersiveKeyguardViewParams) {
  if (SlStateBaseMgr.isV2Enable()) {
    ImmersiveCapView()
      .scale($$.vc.getCapScale($$))
      .opacity($$.vc.getImmersiveCapsuleOpacity($$))
      .visibility($$.vc.getImmersiveCapsuleVisibility($$))
      .id(SlWidgetId.IMMERSIVE_CAP)
      .zIndex(SlWidgetZIndex.Z_INDEX_IMMERSIVE_CAP)
      .alignRules({
        top: { anchor: SlWidgetId.BOTTOM_TOOLS_ICON, align: VerticalAlign.Top },
        middle: { anchor: SlWidgetId.ROOT_ID, align: HorizontalAlign.Center }
      })
      .onAreaChange((old, newArea) => {
        slComStateMgr.setWidgetArea(SlMainStateType.SL_CAP_WG_STATIC_STATE, newArea);
        SlVisualControl.getInstance().updateComponentArea(SlAreaType.CAPSULE, newArea);
      })
  } else {
    ImmersiveCapsuleComponent()
      .scale($$.vc.getCapScale($$))
      .opacity($$.vc.getImmersiveCapsuleOpacity($$))
      .visibility($$.vc.getImmersiveCapsuleVisibility($$))
      .id(SlWidgetId.IMMERSIVE_CAP)
      .zIndex(SlWidgetZIndex.Z_INDEX_IMMERSIVE_CAP)
      .alignRules({
        top: { anchor: SlWidgetId.BOTTOM_TOOLS_ICON, align: VerticalAlign.Top },
        middle: { anchor: SlWidgetId.ROOT_ID, align: HorizontalAlign.Center }
      })
      .onAreaChange((old, newArea) => {
        slComStateMgr.setWidgetArea(SlMainStateType.SL_CAP_WG_STATIC_STATE, newArea);
        SlVisualControl.getInstance().updateComponentArea(SlAreaType.CAPSULE, newArea);
      })
  }
}