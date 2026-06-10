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

import { SlQtStaticState } from '@ohos/screenlockcomponent/src/main/ets/quicktools/model/data/SlQtStaticState';
import { SlCameraStaticState } from '@ohos/screenlockcomponent/src/main/ets/camera/model/data/SlCameraStaticState';
import { SlListWidgetBindState } from '@ohos/immersivekeyguard/src/main/ets/model/data/SlListWidgetBindState';
import { SlCapStaticState } from '@ohos/immersivekeyguard/src/main/ets/model/data/SlCapStaticState';
import { SlCardStaticState } from '@ohos/immersivekeyguard/src/main/ets/model/data/SlCardStaticState';
import { SlListStaticState } from '@ohos/immersivekeyguard/src/main/ets/model/data/SlListStaticState';
import { SlBindState } from '../data/SlBindState';
import { SlStaticState } from '../data/SlStaticState';
import { SlLockIconBindState } from '@ohos/screenlockcomponent/src/main/ets/password/viewmodel/SlLockIconBindState';
import { SlLockIconStaticState } from '@ohos/screenlockcomponent/src/main/ets/password/viewmodel/SlLockIconStaticState';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';
import { SlClockLocateState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockLocateState';
import { SlClockStaticState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockStaticState';
import lazy { SlOuterFormBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlOuterFormBindState';
import lazy { SlOuterFormStaticState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlOuterFormStaticState';
import { SlSignBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlSignBindState';
import { SlSignStaticState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlSignStaticState';
import { SlFormStaticState } from '@ohos/screenlockwidget/src/main/ets/form/vm/SlFormStaticState';
import { SlCapWidgetBindState } from '@ohos/immersivekeyguard/src/main/ets/model/data/SlCapWidgetBindState';
import { SlCardWidgetBindState } from '@ohos/immersivekeyguard/src/main/ets/model/data/SlCardWidgetBindState';
import {
  SlDofWallpaperBindState
} from '@ohos/screenlockcomponent/src/main/ets/screenlockstate/model/data/SlDofWallpaperBindState';
import {
  SlDofWallpaperStaticState
} from '@ohos/screenlockcomponent/src/main/ets/screenlockstate/model/data/SlDofWallpaperStaticState';
import { SlFingerprintBindState } from '@ohos/screenlockcomponent/src/main/ets/screenlockstate/model/data/SlFingerprintBindState';
import {
  SlFingerprintStaticState
} from '@ohos/screenlockcomponent/src/main/ets/screenlockstate/model/data/SlFingerprintStaticState';
import { SlMainStateType, WidgetStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import {
  OneMirrorStaticState
} from '@ohos/screenlockcomponent/src/main/ets/screenlockstate/model/data/OneMirrorStaticState';
import { SlGreetSBindState } from '@ohos/screenlockcomponent/src/main/ets/greet/model/data/SlGreetSBindState';
import { SlGreetStaticState } from '@ohos/screenlockcomponent/src/main/ets/greet/model/data/SlGreetStaticState';
import { SlEditStaticState } from '@ohos/screenlockcomponent/src/main/ets/screenlockstate/model/data/SlEditStaticState';
import lazy { SlOuterToolsBindState } from '../data/SlOuterToolsBindState';
import lazy { SlOuterToolsStaticState } from '../data/SlOuterToolsStaticState';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  SlFoldablePSDStaticState
} from '@ohos/screenlockcomponent/src/main/ets/password/model/data/SlFoldablePSDStaticState';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { ClockAdapterFactory } from '@ohos/screenlockwidget/src/main/ets/clock/adapter/ClockAdapter';
import { UseScene } from '@ohos/screenlockwidget/src/main/ets/common/adapter/Constans';
import { slStateHelper as screenLockStateHelper } from '@ohos/screenlockwidget/src/main/ets/common/utils/SlStateHelper';
import { SlEditorBindState } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/SlEditorBindState';
import { SlClockEditorBindState } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/SlClockEditorBindState';
import { SlFormBindState } from '@ohos/screenlockcomponent/src/main/ets/screenlockstate/model/data/SlFormBindState';

// 锁屏状态取用
class SlStateHelper {
  // 锁屏首页静态状态
  private slStaticState: SlStaticState = new SlStaticState();
  // 锁屏首页UI绑定状态
  private slBindState: SlBindState = new SlBindState();
  // 锁屏首页子组件，通知列表UI绑定状态
  private slListBindState: SlListWidgetBindState = new SlListWidgetBindState();
  // 锁屏首页子组件，快捷工具图标静态状态
  private slQtStaticState: SlQtStaticState = new SlQtStaticState();
  // 锁屏首页子组件，沉浸胶囊静态状态
  private slCapStaticState: SlCapStaticState = new SlCapStaticState();
  // 锁屏首页子组件，相机图标静态状态
  private slCameraStaticState: SlCameraStaticState = new SlCameraStaticState();
  // 锁屏首页子组件，锁头UI绑定状态
  private slLockIconBindState: SlLockIconBindState = new SlLockIconBindState();
  // 锁屏首页子组件，锁头静态状态
  private slLockIconStaticState: SlLockIconStaticState = new SlLockIconStaticState();
  private slLockGreetBindState: SlGreetSBindState = new SlGreetSBindState();
  // 锁屏首页子组件，锁头静态状态
  private slLockGreetStaticState: SlGreetStaticState = new SlGreetStaticState();
  // 锁屏首页子组件，时钟UI绑定形变状态
  private slClockLocateState: SlClockLocateState = new SlClockLocateState();
  // 锁屏首页子组件，外屏服务卡片UI绑定状态
  private slOuterFormBindState: SlOuterFormBindState | undefined = undefined;
  // 锁屏首页子组件，外屏服务卡片静态状态
  private slOuterFormStaticState: SlOuterFormStaticState | undefined = undefined;
  // 锁屏首页子组件，外屏底部工具UI绑定状态
  private slOuterToolsBindState: SlOuterToolsBindState | undefined = undefined;
  // 锁屏首页子组件，外屏底部工具静态状态
  private slOuterToolsStaticState: SlOuterToolsStaticState | undefined = undefined;
  // 锁屏首页子组件，沉浸卡片静态状态
  private slCardStaticState: SlCardStaticState = new SlCardStaticState();
  // 锁屏首页子组件，通知列表静态状态
  private slListStaticState: SlListStaticState = new SlListStaticState();
  // 锁屏首页子组件，沉浸胶囊UI绑定状态
  private slCapBindState: SlCapWidgetBindState = new SlCapWidgetBindState();
  // 锁屏首页子组件，沉浸卡片UI绑定状态
  private slCardBindState: SlCardWidgetBindState = new SlCardWidgetBindState();
  // 锁屏首页子组件，景深壁纸UI绑定状态
  private slDofWallpaperBindState: SlDofWallpaperBindState = new SlDofWallpaperBindState();
  // 锁屏首页子组件，景深壁纸静态状态
  private slDofWallpaperStaticState: SlDofWallpaperStaticState = new SlDofWallpaperStaticState();
  // 锁屏首页子组件，服务卡片静态状态
  private slFormStaticState: SlFormStaticState = new SlFormStaticState();
  // 锁屏首页子组件，指纹UI绑定状态
  private slFingerprintBindState: SlFingerprintBindState =
    new SlFingerprintBindState(SlMainStateType.SL_FINGERPRINT_WG_BIND_STATE);
  // 锁屏首页子组件，指纹静态状态
  private slFingerprintStaticState: SlFingerprintStaticState = new SlFingerprintStaticState();
  // 锁屏一镜到底服务静态状态
  private slOneMirrorStaticState: OneMirrorStaticState = new OneMirrorStaticState();
  // 锁屏编辑静态状态
  private slEditStaticState: SlEditStaticState = new SlEditStaticState();
  // 密码面板静态状态
  private slFoldablePSDStaticState: SlFoldablePSDStaticState = new SlFoldablePSDStaticState();
  // 锁头动效管理器
  private slLockIconAnimCtrl?: WidgetAnimState;
  // 锁屏编辑UI绑定状态
  private slEditUIState?: SlEditorBindState;

  private slFormBindState: SlFormBindState = new SlFormBindState();

  // 时钟组件数据管理器
  private clockDataManager = ClockAdapterFactory.wrapper(UseScene.MAIN_PAGE).getDataManager();

  private slClockEditorBindCtrl?: SlClockEditorBindState; // 锁屏时钟编辑UI状态管理

  public getSlStaticState(): SlStaticState {
    return this.slStaticState;
  }

  public getSlBindState(): SlBindState {
    return this.slBindState;
  }

  public getClockViewAnimSt(): WidgetAnimState {
    return this.getSlClockStaticState().getClockViewAnimSt();
  }

  public getSlListBindState(): SlListWidgetBindState {
    return this.slListBindState;
  }

  public getSlQtStaticState(): SlQtStaticState {
    return this.slQtStaticState;
  }

  public getSlQtAnimCtrl(): WidgetAnimState | undefined {
    return this.slQtStaticState.getSlQtAnimCtrl();
  }

  public getSlCapStaticState(): SlCapStaticState {
    return this.slCapStaticState;
  }

  public getSlCameraStaticState(): SlCameraStaticState {
    return this.slCameraStaticState;
  }

  public getSlCameraAnimCtrl(): WidgetAnimState | undefined {
    return this.slCameraStaticState.getSlCameraAnimCtrl();
  }

  public getSlLockIconBindState(): SlLockIconBindState {
    return this.slLockIconBindState;
  }

  public getSlLockIconStaticState(): SlLockIconStaticState {
    return this.slLockIconStaticState;
  }

  public getSlLockIconAnimCtrl(): WidgetAnimState | undefined {
    if (!this.slLockIconAnimCtrl) {
      this.slLockIconAnimCtrl = slUiStateMgr.getSlState(SlMainStateType.SL_LOCK_ICON_WG_STATIC_STATE)
        ?.getSlState(WidgetStaticStateType.WIDGET_ANIM_CTRL) as WidgetAnimState;
    }
    return this.slLockIconAnimCtrl;
  }

  public getSlClockBindState(): SlClockBindState {
    let slClockBindState = this.clockDataManager.getSlClockBindState();
    if (!slClockBindState) {
      return new SlClockBindState();
    }
    return slClockBindState;
  }

  public getSlClockLocateState(): SlClockLocateState {
    return this.slClockLocateState;
  }

  public getSlClockStaticState(): SlClockStaticState {
    let slClockStaticState = this.clockDataManager.getSlClockStaticState();
    if (!slClockStaticState) {
      return new SlClockStaticState();
    }
    return slClockStaticState;
  }

  public getSlClockAnimCtrl(): WidgetAnimState {
    return this.getSlClockStaticState()?.getSlClockAnimCtrl();
  }

  public getSlOuterFormBindState(): SlOuterFormBindState | undefined {
      return undefined;
  }

  public getSlOuterFormStaticState(): SlOuterFormStaticState | undefined {
      return undefined;
  }

  public getSlOuterFormAnimCtrl(): WidgetAnimState | undefined {
      return undefined;
  }

  public getSlOuterToolsBindState(): SlOuterToolsBindState | undefined {
      return undefined;
  }

  public getSlOuterToolsStaticState(): SlOuterToolsStaticState | undefined {
      return undefined;
  }

  public getSlOuterToolsAnimCtrl(): WidgetAnimState | undefined {
      return undefined;
  }

  public getSlSignBindState(): SlSignBindState {
    let slSignBindState = this.clockDataManager.getSlSignBindState();
    if (!slSignBindState) {
      return new SlSignBindState();
    }
    return slSignBindState;
  }

  public getSlSignStaticState(): SlSignStaticState {
    let slSignStaticState = this.clockDataManager.getSlSignStaticState();
    if (!slSignStaticState) {
      return new SlSignStaticState();
    }
    return slSignStaticState;
  }

  public getSlCardStaticState(): SlCardStaticState {
    return this.slCardStaticState;
  }

  public getSlListStaticState(): SlListStaticState {
    return this.slListStaticState;
  }

  public getSlCapBindState(): SlCapWidgetBindState {
    return this.slCapBindState;
  }

  public getSlCardBindState(): SlCardWidgetBindState {
    return this.slCardBindState;
  }

  public getDofWallpaperBindState(): SlDofWallpaperBindState {
    return this.slDofWallpaperBindState;
  }

  public getDofWallpaperStaticState(): SlDofWallpaperStaticState {
    return this.slDofWallpaperStaticState;
  }

  public getSlFormStaticState(): SlFormStaticState {
    return this.slFormStaticState;
  }

  public getSlFingerprintBindState(): SlFingerprintBindState {
    return this.slFingerprintBindState;
  }

  public getSlFingerprintStaticState(): SlFingerprintStaticState {
    return this.slFingerprintStaticState;
  }

  public getOneMirrorState(): OneMirrorStaticState {
    return this.slOneMirrorStaticState;
  }

  public getSlLockGreetBindState(): SlGreetSBindState {
    return this.slLockGreetBindState;
  }

  public getSlLockGreetStaticState(): SlGreetStaticState {
    return this.slLockGreetStaticState;
  }

  public getEditStaticState(): SlEditStaticState {
    return this.slEditStaticState;
  }

  public getSlFoldablePSDStaticState(): SlFoldablePSDStaticState {
    return this.slFoldablePSDStaticState;
  }

  public getSlFoldablePSDAnimCtrl(): WidgetAnimState | undefined {
    return this.slFoldablePSDStaticState.getSlFoldablePSDAnimCtrl();
  }

  public getEditUIState(): SlEditorBindState {
    this.slEditUIState = screenLockStateHelper.getEditorBindState();
    if (!this.slEditUIState) {
      this.slEditUIState = new SlEditorBindState('SlEditor');
    }
    return this.slEditUIState;
  }

  public getSlFormBindState(): SlFormBindState {
    return this.slFormBindState;
  }

  public getSlFormAnimState(): WidgetAnimState {
    return this.slFormStaticState.getSlFormAnimCtrl();
  }

  public getClockEditorBindState(): SlClockEditorBindState {
    this.slClockEditorBindCtrl = screenLockStateHelper.getClockEditorBindState();
    if (!this.slClockEditorBindCtrl) {
      this.slClockEditorBindCtrl = new SlClockEditorBindState();
    }
    return this.slClockEditorBindCtrl;
  }
}

export let slStateHelper: SlStateHelper = new SlStateHelper();