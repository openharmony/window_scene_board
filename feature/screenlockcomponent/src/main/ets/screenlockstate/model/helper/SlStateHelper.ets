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
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { SlMainStateType, WidgetStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { SlFormStaticState } from '@ohos/screenlockwidget/src/main/ets/form/vm/SlFormStaticState';
import { ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { SlDofWallpaperBindState } from '../data/SlDofWallpaperBindState';
import { OneMirrorStaticState } from '../data/OneMirrorStaticState';
import { SlFingerprintBindState } from '../data/SlFingerprintBindState';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';

// 锁屏各模块状态器统一管理
class SlStateHelper {
  private slStaticState?: ISlState; // 锁屏首页静态状态器
  private slBindState?: ISlState; // 锁屏首页UI状态器
  private slFormStaticState?: SlFormStaticState; // 服务卡片静态状态器
  private slImmersiveCardBindState?: ISlState; // 沉浸卡片UI状态器
  private slImmersiveCardAnimState?: WidgetAnimState; // 沉浸卡片动效管理
  private slImmersiveCapBindState?: ISlState; // 沉浸胶囊UI状态器
  private slImmersiveCapAnimState?: WidgetAnimState; // 沉浸胶囊动效管理
  private slDofWallpaperBindState?: SlDofWallpaperBindState; // 景深壁纸布局状态管理
  private slDofWallpaperAnimState?: WidgetAnimState; // 景深壁纸动效状态管理
  private slImmersiveListBindState?: ISlState; // 通知列表UI状态器
  private slImmersiveListAnimState?: WidgetAnimState; // 通知列表UI状态器
  private slImmersiveListStaticState?: ISlState; // 锁屏沉浸列表静态状态
  private slFingerprintBindState?: SlFingerprintBindState; // 锁屏指纹UI状态器
  private slFingerprintAnimState?: WidgetAnimState; // 指纹动效状态器
  private slOneMirrorStaticState?: OneMirrorStaticState; // 一镜到底服务静态状态
  private slDeliverBadgeBindState?: ISlState; // 沉浸锁屏克隆应用角标组件状态

  public getSlStaticState(): ISlState | undefined {
    if (!this.slStaticState) {
      this.slStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE);
    }
    return this.slStaticState;
  }

  public getSlBindState(): ISlState | undefined {
    if (!this.slBindState) {
      this.slBindState = slUiStateMgr.getSlState(SlMainStateType.SL_BIND_STATE);
    }
    return this.slBindState;
  }

  public getSlFormStaticState(): SlFormStaticState {
    if (!this.slFormStaticState) {
      this.slFormStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_FORM_WG_STATIC_STATE) as SlFormStaticState;
    }
    return this.slFormStaticState;
  }

  public getImmersiveCardBindState(): ISlState | undefined {
    if (!this.slImmersiveCardBindState) {
      this.slImmersiveCardBindState =
        slUiStateMgr.getSlState(SlMainStateType.SL_CARD_WG_BIND_STATE);
    }
    return this.slImmersiveCardBindState;
  }

  public getImmersiveCapBindState(): ISlState | undefined {
    if (!this.slImmersiveCapBindState) {
      this.slImmersiveCapBindState =
        slUiStateMgr.getSlState(SlMainStateType.SL_CAP_WG_BIND_STATE);
    }
    return this.slImmersiveCapBindState;
  }

  public getImmersiveCapAnimState(): WidgetAnimState | undefined {
    if (!this.slImmersiveCapAnimState) {
      this.slImmersiveCapAnimState =
        slUiStateMgr.getSlState(SlMainStateType.SL_CAP_WG_STATIC_STATE)?.getSlState(
          WidgetStaticStateType.WIDGET_ANIM_CTRL) as WidgetAnimState;
    }
    return this.slImmersiveCapAnimState;
  }

  public getImmersiveListBindState(): ISlState | undefined {
    if (!this.slImmersiveListBindState) {
      this.slImmersiveListBindState =
        slUiStateMgr.getSlState(SlMainStateType.SL_LIST_WG_BIND_STATE);
    }
    return this.slImmersiveListBindState;
  }

  public getImmersiveListAnimState(): WidgetAnimState | undefined {
    if (!this.slImmersiveListAnimState) {
      this.slImmersiveListAnimState =
        slUiStateMgr.getSlState(SlMainStateType.SL_LIST_WG_STATIC_STATE)?.getSlState(
        WidgetStaticStateType.WIDGET_ANIM_CTRL) as WidgetAnimState;
    }
    return this.slImmersiveListAnimState;
  }

  public getImmersiveListStaticState(): ISlState | undefined {
    if (!this.slImmersiveListStaticState) {
      this.slImmersiveListStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_LIST_WG_STATIC_STATE) as ISlState;
    }
    return this.slImmersiveListStaticState;
  }

  public getImmersiveCardAnimState(): WidgetAnimState | undefined {
    if (!this.slImmersiveCardAnimState) {
      this.slImmersiveCardAnimState =
        slUiStateMgr.getSlState(SlMainStateType.SL_CARD_WG_STATIC_STATE)?.getSlState(
          WidgetStaticStateType.WIDGET_ANIM_CTRL) as WidgetAnimState;
    }
    return this.slImmersiveCardAnimState;
  }

  public getDofWallpaperAnimState(): WidgetAnimState | undefined {
    if (!this.slDofWallpaperAnimState) {
      this.slDofWallpaperAnimState = slUiStateMgr.getSlState(SlMainStateType.SL_DOF_WALLPAPER_STATIC_STATE)
      ?.getSlState(WidgetStaticStateType.WIDGET_ANIM_CTRL) as WidgetAnimState;
    }
    return this.slDofWallpaperAnimState;
  }

  public getDofWallpaperBindState(): SlDofWallpaperBindState | undefined {
    if (!this.slDofWallpaperBindState) {
      this.slDofWallpaperBindState =
        slUiStateMgr.getSlState(SlMainStateType.SL_DOF_WALLPAPER_BIND_STATE) as SlDofWallpaperBindState;
    }
    return this.slDofWallpaperBindState;
  }

  public getFingerprintAnimState(): WidgetAnimState | undefined {
    if (!this.slFingerprintAnimState) {
      this.slFingerprintAnimState = slUiStateMgr.getSlState(SlMainStateType.SL_FINGERPRINT_WG_STATIC_STATE)
      ?.getSlState(WidgetStaticStateType.WIDGET_ANIM_CTRL) as WidgetAnimState;
    }
    return this.slFingerprintAnimState;
  }

  public getFingerprintBindState(): SlFingerprintBindState | undefined {
    if (!this.slFingerprintBindState) {
      this.slFingerprintBindState =
        slUiStateMgr.getSlState(SlMainStateType.SL_FINGERPRINT_WG_BIND_STATE) as SlFingerprintBindState;
    }
    return this.slFingerprintBindState;
  }

  public getOneMirrorStaticState(): OneMirrorStaticState | undefined {
    if (!this.slOneMirrorStaticState) {
      this.slOneMirrorStaticState =
        slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE) as OneMirrorStaticState;
    }
    return this.slOneMirrorStaticState;
  }

  public getImmerseDeliverBadgeBindState(): ISlState | undefined {
    if (!this.slDeliverBadgeBindState) {
      this.slDeliverBadgeBindState =
        slUiStateMgr.getSlState(SlMainStateType.SL_DELIVER_BADGE_BIND_STATE);
    }
    return this.slDeliverBadgeBindState;
  }
}

// 单例
export const slStateHelper: SlStateHelper = new SlStateHelper();