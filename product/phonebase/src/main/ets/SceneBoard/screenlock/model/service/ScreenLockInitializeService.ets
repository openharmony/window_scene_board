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

import { SlStateBaseMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { CcmConfigHelper, SlStateCmMgr, SlStateOuterMgr } from '@ohos/screenlockcommon/Index';
import { SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { IInitialized } from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/interface/IInitialized';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { slStateHelper } from '../helper/SlStateHelper';
import lazy { slV2ComStHelper, slV2OuterStHelper } from '../helper/v2/SlV2StateHelper';

/**
 * 锁屏面板模块初始化服务
 */
export class ScreenLockInitializeService implements IInitialized {
  public init(ctx?: Context): void { // 复写IInitialized
    slUiStateMgr.setSlState(SlMainStateType.SL_STATIC_STATE, slStateHelper.getSlStaticState());
    slUiStateMgr.setSlState(SlMainStateType.SL_BIND_STATE, slStateHelper.getSlBindState());
    slUiStateMgr.setSlState(SlMainStateType.SL_LIST_WG_BIND_STATE, slStateHelper.getSlListBindState());
    slUiStateMgr.setSlState(SlMainStateType.SL_QT_WG_STATIC_STATE, slStateHelper.getSlQtStaticState());
    slUiStateMgr.setSlState(SlMainStateType.SL_CAP_WG_STATIC_STATE, slStateHelper.getSlCapStaticState());
    slUiStateMgr.setSlState(SlMainStateType.SL_CAMERA_WG_STATIC_STATE, slStateHelper.getSlCameraStaticState());
    slUiStateMgr.setSlState(SlMainStateType.SL_LOCK_ICON_WG_BIND_STATE, slStateHelper.getSlLockIconBindState());
    slUiStateMgr.setSlState(SlMainStateType.SL_LOCK_ICON_WG_STATIC_STATE, slStateHelper.getSlLockIconStaticState());
    slUiStateMgr.setSlState(SlMainStateType.SL_LOCK_GREET_WG_BIND_STATE, slStateHelper.getSlLockGreetBindState());
    slUiStateMgr.setSlState(SlMainStateType.SL_LOCK_GREET_WG_STATIC_STATE, slStateHelper.getSlLockGreetStaticState());
    slUiStateMgr.setSlState(SlMainStateType.SL_CLOCK_WG_BIND_STATE, slStateHelper.getSlClockBindState());
    slUiStateMgr.setSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE, slStateHelper.getSlClockStaticState());
    slUiStateMgr.setSlState(SlMainStateType.SL_OUTER_FORM_WG_BIND_STATE, slStateHelper.getSlOuterFormBindState());
    slUiStateMgr.setSlState(SlMainStateType.SL_OUTER_FORM_WG_STATIC_STATE, slStateHelper.getSlOuterFormStaticState());
    slUiStateMgr.setSlState(SlMainStateType.SL_SIGN_WG_BIND_STATE, slStateHelper.getSlSignBindState());
    slUiStateMgr.setSlState(SlMainStateType.SL_SIGN_WG_STATIC_STATE, slStateHelper.getSlSignStaticState());
    slUiStateMgr.setSlState(SlMainStateType.SL_CARD_WG_STATIC_STATE, slStateHelper.getSlCardStaticState());
    slUiStateMgr.setSlState(SlMainStateType.SL_LIST_WG_STATIC_STATE, slStateHelper.getSlListStaticState());
    slUiStateMgr.setSlState(SlMainStateType.SL_CAP_WG_BIND_STATE, slStateHelper.getSlCapBindState());
    slUiStateMgr.setSlState(SlMainStateType.SL_CARD_WG_BIND_STATE, slStateHelper.getSlCardBindState());
    slUiStateMgr.setSlState(SlMainStateType.SL_DOF_WALLPAPER_BIND_STATE, slStateHelper.getDofWallpaperBindState());
    slUiStateMgr.setSlState(SlMainStateType.SL_DOF_WALLPAPER_STATIC_STATE, slStateHelper.getDofWallpaperStaticState());
    slUiStateMgr.setSlState(SlMainStateType.SL_FINGERPRINT_WG_BIND_STATE,
      slStateHelper.getSlFingerprintBindState());
    slUiStateMgr.setSlState(SlMainStateType.SL_FINGERPRINT_WG_STATIC_STATE,
      slStateHelper.getSlFingerprintStaticState());
    slUiStateMgr.setSlState(SlMainStateType.SL_FORM_WG_STATIC_STATE, slStateHelper.getSlFormStaticState());
    slUiStateMgr.setSlState(SlMainStateType.SL_FORM_WG_BIND_STATE, slStateHelper.getSlFormBindState());
    slUiStateMgr.setSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE, slStateHelper.getOneMirrorState());
    slUiStateMgr.setSlState(SlMainStateType.SL_EDIT_STATIC_STATE, slStateHelper.getEditStaticState());
    slUiStateMgr.setSlState(SlMainStateType.SL_FOLDABLE_PSD_STATIC_STATE, slStateHelper.getSlFoldablePSDStaticState());
    slUiStateMgr.setSlState(SlMainStateType.SL_EDIT_BIND_STATE, slStateHelper.getEditUIState());

    // V2状态初始化
    this.initV2();
  }

  /**
   * V2状态初始化
   */
  private initV2(): void {
    const isV2Enable = CcmConfigHelper.getInstance().isImmKgV2Enable();
    SlStateBaseMgr.setV2Enable(isV2Enable);
    if (!isV2Enable) {
      return;
    }
    // 通用锁屏状态配置
    let mgr: SlStateBaseMgr = SlStateCmMgr.getInstance();
    let helper = slV2ComStHelper;
    mgr.addState(helper.getSlComStaticState());
    mgr.addState(helper.getSlComBindState());
    mgr.addState(helper.getSlImmBindState());
    mgr.addState(helper.getSlListStaticState());
    mgr.addState(helper.getSlListBindState());
    mgr.addState(helper.getSlListAnimState());
    mgr.addState(helper.getSlListStyleState());
    mgr.addState(helper.getSlListCacheState());
    mgr.addState(helper.getSlCapStaticState());
    mgr.addState(helper.getSlCapBindState());
    mgr.addState(helper.getSlCapAnimState());
    mgr.addState(helper.getSlCapStyleState());
    mgr.addState(helper.getSlCapCacheState());
    mgr.addState(helper.getSlCardStaticState());
    mgr.addState(helper.getSlCardBindState());
    mgr.addState(helper.getSlCardAnimState());
    mgr.addState(helper.getSlCardStyleState());
    mgr.addState(helper.getSlCardCacheState());

    // 状态加载完毕，初始化状态配置
    helper.initStyleConfig();

  }
}