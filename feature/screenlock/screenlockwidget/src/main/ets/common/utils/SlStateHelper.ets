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

import {
  SlMainStateType,
  SlStaticStateType,
  WidgetStaticStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { SlClockBindState } from '../../clock/model/data/SlClockBindState';
import { SlClockStaticState } from '../../clock/model/data/SlClockStaticState';
import { SlSignBindState } from '../../clock/model/data/SlSignBindState';
import lazy { SlOuterFormBindState } from '../../clock/model/data/SlOuterFormBindState';
import lazy { SlOuterFormStaticState } from '../../clock/model/data/SlOuterFormStaticState';
import { SlFormStaticState } from '../../form/vm/SlFormStaticState';
import { SlEditorBindState } from '../../editsheet/models/SlEditorBindState';
import { SlClockEditorBindState } from '../../editsheet/models/SlClockEditorBindState';

// 锁屏状态取用
class SlStateHelper {
  private slStaticState?: ISlState; // 锁屏首页静态状态器
  private slBindState?: ISlState;
  private slLockIconAnimCtrl?: WidgetAnimState; // 锁头动效状态管理
  private slLockGreetAnimCtrl?: WidgetAnimState; // 锁头动效状态管理
  private slClockBindState?: SlClockBindState; // 时钟布局状态管理
  private slClockAnimCtrl?: WidgetAnimState; // 时钟动效状态管理
  private slClockStaticCtrl?: SlClockStaticState; // 时钟静态状态管理
  private slOuterFormBindState?: SlOuterFormBindState; // 小外屏服务卡片布局状态管理
  private slOuterFormAnimCtrl?: WidgetAnimState; // 小外屏服务卡片动效状态管理
  private slOuterFormStaticCtrl?: SlOuterFormStaticState; // 小外屏服务卡片静态状态管理
  private slFormStaticState?: SlFormStaticState; // 卡片静态状态管理
  private slSignBindState?: SlSignBindState; // 签名布局状态管理
  private slRootAnimCtrl?: WidgetAnimState; // 跟节点动效状态管理
  private slEditorBindCtrl?: SlEditorBindState; // 锁屏编辑UI状态管理
  private slClockEditorBindCtrl?: SlClockEditorBindState; // 锁屏时钟编辑UI状态管理

  public getSlStaticState(): ISlState | undefined {
    if (!this.slStaticState) {
      this.slStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE);
    }
    return this.slStaticState;
  }

  public getSlBindState(): ISlState | undefined {
    if (!this.slBindState) {
      this.slBindState =
        slUiStateMgr.getSlState(SlMainStateType.SL_BIND_STATE);
    }
    return this.slBindState;
  }

  public getSlLockAnimState(): WidgetAnimState | undefined {
    if (!this.slLockIconAnimCtrl) {
      this.slLockIconAnimCtrl = slUiStateMgr.getSlState(SlMainStateType.SL_LOCK_ICON_WG_STATIC_STATE)
      ?.getSlState(WidgetStaticStateType.WIDGET_ANIM_CTRL) as WidgetAnimState;
    }
    return this.slLockIconAnimCtrl;
  }

  public getSlLockGreetAnimState(): WidgetAnimState | undefined {
    if (!this.slLockGreetAnimCtrl) {
      this.slLockGreetAnimCtrl = slUiStateMgr.getSlState(SlMainStateType.SL_LOCK_GREET_WG_STATIC_STATE)
      ?.getSlState(WidgetStaticStateType.WIDGET_ANIM_CTRL) as WidgetAnimState;
    }
    return this.slLockGreetAnimCtrl;
  }

  public getSlSignBindState(): SlSignBindState {
    if (!this.slSignBindState) {
      this.slSignBindState =
        slUiStateMgr.getSlState(SlMainStateType.SL_SIGN_WG_BIND_STATE) as SlSignBindState;
    }
    return this.slSignBindState;
  }

  public getSlClockBindState(): SlClockBindState | undefined {
    if (!this.slClockBindState) {
      this.slClockBindState = slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_BIND_STATE) as SlClockBindState;
    }
    return this.slClockBindState;
  }

  public getSlClockStaticState(): SlClockStaticState {
    if (!this.slClockStaticCtrl) {
      this.slClockStaticCtrl = slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE) as SlClockStaticState;
    }
    return this.slClockStaticCtrl;
  }

  public getSlClockAnimState(): WidgetAnimState | undefined {
    if (!this.slClockAnimCtrl) {
      this.slClockAnimCtrl =
        this.getSlClockStaticState()?.getSlState(WidgetStaticStateType.WIDGET_ANIM_CTRL) as WidgetAnimState;
    }
    return this.slClockAnimCtrl;
  }

  public getSlOuterFormBindState(): SlOuterFormBindState | undefined {
    if (!this.slOuterFormBindState) {
      this.slOuterFormBindState =
        slUiStateMgr.getSlState(SlMainStateType.SL_OUTER_FORM_WG_BIND_STATE) as SlOuterFormBindState;
    }
    return this.slOuterFormBindState;
  }

  public getSlOuterFormStaticState(): SlOuterFormStaticState {
    if (!this.slOuterFormStaticCtrl) {
      this.slOuterFormStaticCtrl =
        slUiStateMgr.getSlState(SlMainStateType.SL_OUTER_FORM_WG_STATIC_STATE) as SlOuterFormStaticState;
    }
    return this.slOuterFormStaticCtrl;
  }

  public getSlOuterFormAnimState(): WidgetAnimState | undefined {
    if (!this.slOuterFormAnimCtrl) {
      this.slOuterFormAnimCtrl =
        this.getSlOuterFormStaticState()?.getSlState(WidgetStaticStateType.WIDGET_ANIM_CTRL) as WidgetAnimState;
    }
    return this.slOuterFormAnimCtrl;
  }

  public getSlFormStaticState(): SlFormStaticState | undefined {
    if (!this.slFormStaticState) {
      this.slFormStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_FORM_WG_STATIC_STATE) as SlFormStaticState;
    }
    return this.slFormStaticState;
  }

  public getSlRootAnimState(): WidgetAnimState | undefined {
    if (!this.slRootAnimCtrl) {
      this.slRootAnimCtrl =
        slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)?.
        getSlState(SlStaticStateType.SL_MAIN_ANIM_CTR) as WidgetAnimState;
    }
    return this.slRootAnimCtrl;
  }

  public getEditorBindState(): SlEditorBindState {
    if (!this.slEditorBindCtrl) {
      this.slEditorBindCtrl = new SlEditorBindState();
    }
    return this.slEditorBindCtrl;
  }

  public getClockEditorBindState(): SlClockEditorBindState {
    if (!this.slClockEditorBindCtrl) {
      this.slClockEditorBindCtrl = new SlClockEditorBindState();
    }
    return this.slClockEditorBindCtrl;
  }

}

export let slStateHelper: SlStateHelper = new SlStateHelper();