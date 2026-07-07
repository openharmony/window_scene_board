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

import { SlMainStateType, WidgetStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState'
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';

// 沉浸锁屏状态取用
class ImmersiveStateHelper {
  // 锁屏首页UI绑定状态
  private slBindState?: ISlState;
  // 锁屏首页静态状态
  private slStaticState?: ISlState;
  // 锁屏首页子组件，通知列表UI绑定状态
  private slListBindState?: ISlState;
  // 锁屏沉浸列表状态
  private slListStaticState?: ISlState;
  // 锁屏沉浸列表动效
  private slListAnimState?: WidgetAnimState;
  // 锁屏时钟状态
  private slClockStaticCtrl?: ISlState;
  // 沉浸态卡片静态状态
  private slImmerseCardStaticState?: ISlState;
  // 沉浸态卡片UI绑定状态
  private slImmerseCardBindState?: ISlState;
  // 沉浸态卡片动效管理状态
  private slImmerseCardAnimState?: WidgetAnimState;
  // 锁屏沉浸胶囊状态
  private slCapsuleWidgetBindState?: ISlState;
  // 沉浸态沉浸动效管理状态
  private slCapsuleAnimState?: WidgetAnimState;
  // 沉浸态胶囊静态状态
  private slImmerseCapStaticState?: ISlState;
  // 一镜到底服务静态状态
  private slOneMirrorStaticState?: ISlState;
  // 沉浸锁屏克隆应用角标组件状态
  private slDeliverBadgeBindState?: ISlState;

  public getSlBindState(): ISlState | undefined {
    if (!this.slBindState) {
      this.slBindState = slUiStateMgr.getSlState(SlMainStateType.SL_BIND_STATE);
    }
    return this.slBindState;
  }

  public getSlStaticState(): ISlState | undefined {
    if (!this.slStaticState) {
      this.slStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE);
    }
    return this.slStaticState;
  }

  public getSlListBindState(): ISlState | undefined {
    if (!this.slListBindState) {
      this.slListBindState = slUiStateMgr.getSlState(SlMainStateType.SL_LIST_WG_BIND_STATE);
    }
    return this.slListBindState;
  }

  public getSlListStaticState(): ISlState | undefined {
    if (!this.slListStaticState) {
      this.slListStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_LIST_WG_STATIC_STATE) as ISlState;
    }
    return this.slListStaticState;
  }

  public getSlListAnimState(): WidgetAnimState | undefined {
    if (!this.slListStaticState) {
      this.getSlListStaticState();
    }

    if (!this.slListAnimState) {
      this.slListAnimState =
        this.slListStaticState?.getSlState(WidgetStaticStateType.WIDGET_ANIM_CTRL) as WidgetAnimState;
    }
    return this.slListAnimState;
  }

  public getSlClockBindState(): ISlState | undefined {
    if (!this.slClockStaticCtrl) {
      this.slClockStaticCtrl = slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE);
    }
    return this.slClockStaticCtrl;
  }

  public getImmerseCardBindState(): ISlState | undefined {
    if (!this.slImmerseCardBindState) {
      this.slImmerseCardBindState = slUiStateMgr.getSlState(SlMainStateType.SL_CARD_WG_BIND_STATE);
    }
    return this.slImmerseCardBindState;
  }

  public getImmerseCardStaticState(): ISlState | undefined {
    if (!this.slImmerseCardStaticState) {
      this.slImmerseCardStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_CARD_WG_STATIC_STATE);
    }
    return this.slImmerseCardStaticState;
  }

  public getImmerseCardAnimState(): WidgetAnimState | undefined {
    if (this.slImmerseCardStaticState === undefined) {
      this.getImmerseCardStaticState();
    }

    if (!this.slImmerseCardAnimState) {
      this.slImmerseCardAnimState =
        this.slImmerseCardStaticState?.getSlState(WidgetStaticStateType.WIDGET_ANIM_CTRL) as WidgetAnimState;
    }
    return this.slImmerseCardAnimState;
  }

  public getSlCapsuleWidgetBindState(): ISlState | undefined {
    if (!this.slCapsuleWidgetBindState) {
      this.slCapsuleWidgetBindState = slUiStateMgr.getSlState(SlMainStateType.SL_CAP_WG_BIND_STATE);
    }
    return this.slCapsuleWidgetBindState;
  }

  public getSlCapsuleStaticState(): ISlState | undefined {
    if (!this.slImmerseCapStaticState) {
      this.slImmerseCapStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_CAP_WG_STATIC_STATE);
    }
    return this.slImmerseCapStaticState;
  }

  public getImmerseCapsuleAnimState(): WidgetAnimState | undefined {
    if (!this.slImmerseCapStaticState) {
      this.getSlCapsuleStaticState();
    }

    if (!this.slCapsuleAnimState) {
      this.slCapsuleAnimState =
        this.slImmerseCapStaticState?.getSlState(WidgetStaticStateType.WIDGET_ANIM_CTRL) as WidgetAnimState;
    }
    return this.slCapsuleAnimState;
  }

  public getOneMirrorStaticState(): ISlState | undefined {
    if (!this.slOneMirrorStaticState) {
      this.slOneMirrorStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE);
    }
    return this.slOneMirrorStaticState;
  }

  public getImmerseDeliverBadgeBindState(): ISlState | undefined {
    if (!this.slDeliverBadgeBindState) {
      this.slDeliverBadgeBindState = slUiStateMgr.getSlState(SlMainStateType.SL_DELIVER_BADGE_BIND_STATE);
    }
    return this.slDeliverBadgeBindState;
  }
}

export let immersiveStateHelper: ImmersiveStateHelper = new ImmersiveStateHelper();