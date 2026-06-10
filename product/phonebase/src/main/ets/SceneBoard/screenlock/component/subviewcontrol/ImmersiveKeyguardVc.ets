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

import { SlWidgetId, SlWidgetZIndex } from '@ohos/screenlockcommon/src/main/ets/constants/SlWidgetConst';
import {
  GlobalStatusCache,
  KeyGuardMode,
  StatusCacheConst,
  VerifyDataManager,
  VerifyInfo,
} from '@ohos/screenlockcommon';
import { MpStateTypeUtils, MpStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/MainPageFsm';
import { SlBindState } from '../../model/data/SlBindState';
import { immersiveKgMgr, ImmersiveState } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { SlListWidgetBindState } from '@ohos/immersivekeyguard/src/main/ets/model/data/SlListWidgetBindState';
import { ScreenLockSpaceAniData } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockSpaceAniOptions';
import ScreenLockSpaceAnimationViewModel
  from '@ohos/screenlockcomponent/src/main/ets/password/viewmodel/ScreenLockSpaceAnimationViewModel';
import MirrorAniConfig from '@ohos/screenlockcomponent/src/main/ets/onemirror/model/MirrorAnimationConf';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';
import {
  SlFingerprintBindState
} from '@ohos/screenlockcomponent/src/main/ets/screenlockstate/model/data/SlFingerprintBindState';
import {
  ImmUeDataHelper,
  UeDataComp,
  UeDataType
} from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/immersivekg/helper/ImmUeDataHelper';

const TAG = 'ImmersiveKeyguardVc';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export interface ImmersiveKeyguardParams {
  /**
   * 锁屏模式
   */
  keyGuardMode: KeyGuardMode;
  slBindState: SlBindState;
  isNtfFingerprintConflict: boolean;
  slClockBindCtrl: SlClockBindState;
  isDeviceWithOuter: boolean;
  isSmallFoldOuterScreen: boolean;
  slListWidgetBindState: SlListWidgetBindState;
  spaceAniViewModel: ScreenLockSpaceAnimationViewModel;
  listAnimState?: WidgetAnimState;
  isFoldExpand: boolean;
  cardAnimState?: WidgetAnimState;
  toggleAnimState?: WidgetAnimState;
  spaceAniOpt: ScreenLockSpaceAniData;
  notificationConf: MirrorAniConfig;
  slFingerprintBindState: SlFingerprintBindState;
  currentState: MpStateType;
}

/**
 * 沉浸锁屏通知Vc
 */
export class ImmersiveKeyguardVc {
  private immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();

  public getImmersiveVisibility(immersiveKeyguardParams: ImmersiveKeyguardParams, isList: boolean = false): Visibility {
    let visibility = this.getListVisibility(immersiveKeyguardParams, isList);
    ImmUeDataHelper.getInstance().setVisualParam(UeDataComp.LIST_ZERO, UeDataType.VISIBILITY, visibility);
    return visibility;
  }

  private getListVisibility(immersiveKeyguardParams: ImmersiveKeyguardParams, isList: boolean = false): Visibility {
    if (!immersiveKeyguardParams) {
      log.showError('Get immersive visibility error, params is null.');
      return Visibility.Hidden;
    }
    if (immersiveKeyguardParams.slClockBindCtrl?.getClockAodToDesktop()) {
      return Visibility.Hidden;
    }
    if (immersiveKeyguardParams.isSmallFoldOuterScreen && isList) {
      return Visibility.Hidden;
    }
    return immersiveKeyguardParams.slListWidgetBindState?.getVisibility() ?? Visibility.Hidden;
  }

  public getOuterImmVisibility(immKgParams: ImmersiveKeyguardParams): Visibility {
    if (!immKgParams) {
      log.showError('Get immersive visibility error, params is null.');
      return Visibility.Hidden;
    }
    if (immKgParams.slClockBindCtrl?.getClockAodToDesktop()) {
      return Visibility.Hidden;
    }
    if (!immKgParams.isSmallFoldOuterScreen) {
      return Visibility.Hidden;
    }
    return immKgParams.slListWidgetBindState?.getVisibility() ?? Visibility.Hidden;
  }

  public getImmersiveKeyguardListScale(immersiveKeyguardParams: ImmersiveKeyguardParams): ScaleOptions | undefined {
    return immersiveKeyguardParams?.spaceAniViewModel?.getImmersiveKeyguardListScale(
      ScreenLockSpaceAnimationViewModel.isSpaceUnlockAnimation());
  }

  public getImmersiveKeyguardListOpacity(immersiveKeyguardParams: ImmersiveKeyguardParams): number | undefined {
    let opacity = this.getListOpacity(immersiveKeyguardParams);
    ImmUeDataHelper.getInstance().setVisualParam(UeDataComp.LIST_ZERO, UeDataType.OPACITY, opacity);
    return opacity;
  }

  private getListOpacity(immersiveKeyguardParams: ImmersiveKeyguardParams): number | undefined {
    if (ScreenLockSpaceAnimationViewModel.isSpaceUnlockAnimation()) {
      return immersiveKeyguardParams?.spaceAniViewModel?.getImmersiveKeyguardListOpacity(true);
    }
    return 1 - immersiveKeyguardParams?.slBindState?.getOpacity() / 150;
  }

  public getImmersiveListZIndex(immersiveKeyguardParams: ImmersiveKeyguardParams): number | undefined {
    let defaultIndex = SlWidgetZIndex.Z_INDEX_IMMERSIVE_LIST;
    if (immersiveKeyguardParams?.listAnimState?.isSceneAnimating()) {
      return immersiveKeyguardParams.listAnimState?.getZIndex() ?? defaultIndex;
    }
    // 默认层级
    return defaultIndex;
  }

  public getImmersiveKeyguardCardScale(immersiveKeyguardParams: ImmersiveKeyguardParams): ScaleOptions | undefined {
    return immersiveKeyguardParams?.spaceAniViewModel?.getImmersiveKeyguardCardScale(
      ScreenLockSpaceAnimationViewModel.isSpaceUnlockAnimation());
  }

  public getImmersiveKeyguardCardOpacity(immersiveKeyguardParams: ImmersiveKeyguardParams): number | undefined {
    if (ScreenLockSpaceAnimationViewModel.isSpaceUnlockAnimation()) {
      return immersiveKeyguardParams?.spaceAniViewModel?.getImmersiveKeyguardCardOpacity(true);
    }
    return 1 - immersiveKeyguardParams?.slBindState?.getOpacity() / 150;
  }

  public getImmersiveCardZIndex(immersiveKeyguardParams: ImmersiveKeyguardParams): number | undefined {
    let defaultIndex = SlWidgetZIndex.Z_INDEX_IMMERSIVE_CARD;
    // 胶囊到卡片动效中，卡片显示在胶囊上层
    if (immersiveKeyguardParams?.cardAnimState?.isSceneAnimating()) {
      return immersiveKeyguardParams.cardAnimState.getZIndex() ?? defaultIndex;
    }
    if (immersiveKeyguardParams?.toggleAnimState?.isSceneAnimating()) {
      return immersiveKeyguardParams.toggleAnimState.getZIndex() ?? defaultIndex;
    }
    // 默认层级
    return defaultIndex;
  }

  public getImmersiveCardAlignRules(immersiveKeyguardParams: ImmersiveKeyguardParams): LocalizedAlignRuleOptions {
    return immersiveKeyguardParams?.isSmallFoldOuterScreen ?
      {
        top: { anchor: SlWidgetId.ROOT_ID, align: VerticalAlign.Top },
        bottom: { anchor: SlWidgetId.ROOT_ID, align: VerticalAlign.Bottom },
        start: { anchor: SlWidgetId.ROOT_ID, align: HorizontalAlign.Start }
      } :
      {
        top: { anchor: SlWidgetId.LOCK_HEAD, align: VerticalAlign.Bottom },
        bottom: { anchor: SlWidgetId.BOTTOM_TOOLS_ICON, align: VerticalAlign.Top },
        start: { anchor: SlWidgetId.ROOT_ID, align: HorizontalAlign.Start }
      };
  }

  public getCapScale(immersiveKeyguardParams: ImmersiveKeyguardParams): ScaleOptions {
    if (ScreenLockSpaceAnimationViewModel.isSpaceUnlockAnimation() && !this.immersiveState.isShowCapsule()) {
      return {};
    }
    if (ScreenLockSpaceAnimationViewModel.isSpaceUnlockAnimation()) {
      let screenWidth: number =
        GlobalStatusCache.getInstance().getStatus(StatusCacheConst.SCREEN_WIDTH_KEY, 0) as number
      let screenHeight: number =
        GlobalStatusCache.getInstance().getStatus(StatusCacheConst.SCREEN_HEIGHT_KEY, 0) as number;
      return {
        x: immersiveKeyguardParams?.spaceAniOpt?.getSpaceScale() ?? 1,
        y: immersiveKeyguardParams?.spaceAniOpt?.getSpaceScale() ?? 1,
        centerX: ScreenLockSpaceAnimationViewModel.getScaleCenterX(SlWidgetId.IMMERSIVE_CAP, screenWidth),
        centerY: ScreenLockSpaceAnimationViewModel.getScaleCenterY(SlWidgetId.IMMERSIVE_CAP, screenHeight)
      };
    }
    // 一镜到底场景
    return {
      x: immersiveKeyguardParams?.notificationConf?.getScaleX() ?? 1,
      y: immersiveKeyguardParams?.notificationConf?.getScaleY() ?? 1
    };
  }

  public getImmersiveCapsuleOpacity(immersiveKeyguardParams: ImmersiveKeyguardParams): number {
    let opacity = this.getCapsuleOpacity(immersiveKeyguardParams);
    ImmUeDataHelper.getInstance().setVisualParam(UeDataComp.CAP_ZERO, UeDataType.OPACITY, opacity);
    return opacity;
  }

  private getCapsuleOpacity(immersiveKeyguardParams: ImmersiveKeyguardParams): number {
    if (ScreenLockSpaceAnimationViewModel.isSpaceUnlockAnimation() && !this.immersiveState.isShowCapsule()) {
      return 1;
    }
    if (ScreenLockSpaceAnimationViewModel.isSpaceUnlockAnimation()) {
      return immersiveKeyguardParams?.spaceAniOpt?.getSpaceOpacity() ?? 1;
    }
    let oneMirrorAlpha: number = 1;
    if (immersiveKeyguardParams?.notificationConf) {
      oneMirrorAlpha = immersiveKeyguardParams.notificationConf.getAlpha() ?? 1;
    }
    return oneMirrorAlpha * (1 - immersiveKeyguardParams?.slBindState?.getOpacity() ?? 0 / 150);
  }

  public getImmersiveCapsuleVisibility(immersiveKeyguardParams: ImmersiveKeyguardParams): Visibility {
    let visibility = this.getCapsuleVisibility(immersiveKeyguardParams);
    ImmUeDataHelper.getInstance().setVisualParam(UeDataComp.CAP_ZERO, UeDataType.VISIBILITY, visibility);
    return visibility;
  }

  private getCapsuleVisibility(immersiveKeyguardParams: ImmersiveKeyguardParams): Visibility {
    if ((MpStateTypeUtils.isEditState(immersiveKeyguardParams.currentState) ||
    MpStateTypeUtils.isBouncerState(immersiveKeyguardParams.currentState) ||
    MpStateTypeUtils.isUnlockState(immersiveKeyguardParams.currentState))) {
      log.showInfo('getImmersiveCapsuleVisibility hidden');
      return Visibility.Hidden;
    }
    let fingerprintInfo: VerifyInfo = VerifyDataManager.getInstance().getVerifyInfo(AuthType.FINGERPRINT);
    if (!fingerprintInfo) {
      log.showError('fingerprintInfo is null, show capsule anyway');
      return Visibility.Visible;
    }
    if (fingerprintInfo.isSupportUnlock &&
    fingerprintInfo.hasLowFingerprint && immersiveKeyguardParams?.slFingerprintBindState?.getEnable()) {
      log.showInfo('there is low fingerprint enable, hide capsule');
      return Visibility.Hidden;
    }
    if (immersiveKeyguardParams?.isSmallFoldOuterScreen) {
      return Visibility.Hidden;
    }
    return Visibility.Visible;
  }
}