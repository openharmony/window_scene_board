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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import lazy { DeviceHelper, ScreenState } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import lazy { SCBExpandController, SCBFoldController,
  SCBPropertyChangeReason,
  SCBSceneSessionManager,
  SCBSystemSceneSession,
  SCBTransitionManager } from '@ohos/windowscene/src/main/ets/TsIndex';
import { Singleton, threadCall } from '@ohos/systemuicommon/newTsIndex';
import lazy { SCBTripleController } from '@ohos/windowscene/src/main/ets/animation/SCBTransitionController';
import lazy { UltraScreenAnimationConstants } from '@ohos/launchercommon/src/main/ets/constants/UltraScreenAnimationConstants';
import lazy { FoldExpandAnimUtils } from '@ohos/launchercommon/src/main/ets/utils/FoldExpandAnimUtils';
import lazy { FoldAnimationConstants } from '@ohos/launchercommon/src/main/ets/constants/FoldAnimationConstants';
import lazy {
  UltraScreenExpandAnimUtils,
  SCBTripleStateChange,
} from '@ohos/launchercommon/src/main/ets/utils/UltraScreenExpandAnimUtils';
import { sharedData } from '@ohos/systemuicommon/src/main/ets/model/SendableData';
import lazy { SCBTriFoldManager } from '@ohos/frameworkwrapper/src/main/ets/utils/SCBTriFoldManager';

const TAG = 'FoldExpandAniVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class FoldExpandAniVm {
  @Singleton.decorate()
  public static get instance(): FoldExpandAniVm { return new FoldExpandAniVm(); }
  constructor() {
  }

  private foldController?: SCBFoldController;
  private expandController?: SCBExpandController;
  private tripleController?: SCBTripleController;

  public initInMainForTheadCall() {

  }

  @threadCall()
  public init(): void {
    log.showInfo('init');
    // fold screen animation
    this.registerFoldExpandAnimationController();
    // fold screen animation in triple fold product
    this.registerTripleAnimationController();
  }

  @threadCall()
  public unInit(): void {
    log.showInfo('unInit');
    SCBTransitionManager.getInstance().unRegisterFoldAnimationController(this.foldController);
    SCBTransitionManager.getInstance().unRegisterExpandAnimationController(this.expandController);
    if (DeviceHelper.isUltraScreenProduct()) {
      SCBTransitionManager.getInstance().unRegisterTripleAnimationController(this.tripleController);
    }
  }

  // fold screen animation
  private foldedAnimation(): void {
    log.showInfo('statusbar execute foldedAnimation');
    let systemSceneSession: SCBSystemSceneSession =
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(sharedData.statusBarPersistentId);
    if (systemSceneSession) {
      systemSceneSession.translateX =
        FoldExpandAnimUtils.getStatusBarTranslateX(FoldAnimationConstants.FOLD_FACTOR, px2vp(sharedData.statusBarWidth));
      systemSceneSession.opacity = 0;
    }
    animateTo({
      curve: FoldAnimationConstants.TRANSLATE_CURVES,
    }, () => {
      if (systemSceneSession) {
        systemSceneSession.translateX = 0;
      }
    })
    animateTo(FoldExpandAnimUtils.getStatusBarAlphaAnimParam(), () => {
      if (systemSceneSession) {
        systemSceneSession.opacity = 1;
      }
    })
  }

  private expandedAnimation(): void {
    log.showInfo('statusbar execute expandedAnimation');
    let systemSceneSession: SCBSystemSceneSession =
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(sharedData.statusBarPersistentId);
    if (systemSceneSession) {
      systemSceneSession.translateX =
        FoldExpandAnimUtils.getStatusBarTranslateX(FoldAnimationConstants.EXPAND_FACTOR, px2vp(sharedData.statusBarWidth));
      systemSceneSession.opacity = 0;
    }
    animateTo({
      curve: FoldAnimationConstants.TRANSLATE_CURVES,
    }, () => {
      if (systemSceneSession) {
        systemSceneSession.translateX = 0;
      }
    })
    animateTo(FoldExpandAnimUtils.getStatusBarAlphaAnimParam(), () => {
      if (systemSceneSession) {
        systemSceneSession.opacity = 1;
      }
    })
  }

  private tripleAnimation(oldState: ScreenState, newState: ScreenState, isNeedAnimation: boolean): void {
    if (!isNeedAnimation) {
      log.showInfo(`statusbar noneed tripleAnimation`);
      return;
    }
    log.showInfo(`statusbar execute tripleAnimation, oldState is ${oldState}, newState is ${newState}`);
    let systemSceneSession: SCBSystemSceneSession =
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(sharedData.statusBarPersistentId);
    let stateChange: SCBTripleStateChange = UltraScreenExpandAnimUtils.getTripleDesktopStateChange(newState, oldState);
    if (stateChange === SCBTripleStateChange.INVALID) {
      log.showWarn('get stateChange invalid, return;');
      return;
    }
    if (systemSceneSession) {
      systemSceneSession.translateX =
        UltraScreenExpandAnimUtils.initTripleStatusBarTransX(px2vp(sharedData.statusBarWidth), stateChange);
    }
    animateTo({
      curve: UltraScreenAnimationConstants.TRANSLATE_CURVES
    }, () => {
      if (systemSceneSession) {
        systemSceneSession.translateX = 0;
      }
    });
  }

  private registerFoldExpandAnimationController(): void {
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(sharedData.statusBarPersistentId)
    this.foldController = {
      itemId: `${TAG}_${systemSceneSession?.name}_${systemSceneSession?.id}`,
      onFoldAnimation: () => this.foldedAnimation(),
    };
    this.expandController = {
      itemId: `${TAG}_${systemSceneSession?.name}_${systemSceneSession?.id}`,
      onExpandAnimation: () => this.expandedAnimation(),
    };
    SCBTransitionManager.getInstance().registerFoldAnimationController(this.foldController);
    SCBTransitionManager.getInstance().registerExpandAnimationController(this.expandController);
  }

  private registerTripleAnimationController(): void {
    if (!DeviceHelper.isUltraScreenProduct()) {
      return;
    }
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(sharedData.statusBarPersistentId);
    this.tripleController = {
      itemId: `${TAG}_${systemSceneSession?.name}_${systemSceneSession?.id}`,
      onTripleAnimation: (oldState: ScreenState, newState: ScreenState,
        isNeedAnimation: boolean) => this.tripleAnimation(oldState, newState, isNeedAnimation),
    };
    SCBTransitionManager.getInstance().registerTripleAnimationController(this.tripleController);
  }

  @threadCall()
  public StatusBarFoldOrExpandAnimation(reason: SCBPropertyChangeReason): void {
    if (this.isUltraScreenFMSwitch()) {
      return;
    }
    if (reason === SCBPropertyChangeReason.EXPAND_TO_FOLD) {
      this.windowsFoldedAnimation();
    }
    if (reason === SCBPropertyChangeReason.FOLD_TO_EXPAND) {
      this.windowsExpandedAnimation();
    }
  }

  /**
   * ���۵�Ӧ����ǰ̨����������F��M̬״̬����Ч
   * @returns
   */
  private isUltraScreenFMSwitch(): boolean {
    if (!DeviceHelper.isUltraScreenProduct()) {
      return false;
    }
    const currentTripleState = SCBTriFoldManager.getInstance().getCurTriFoldState();
    const prevTripleState = SCBTriFoldManager.getInstance().getPrevTriFoldState();
    const stateChange = UltraScreenExpandAnimUtils.getTripleStateChange(currentTripleState, prevTripleState);
    if (stateChange === SCBTripleStateChange.F_TO_M || stateChange === SCBTripleStateChange.M_TO_F) {
      return true;
    }
    return false;
  }

  private windowsFoldedAnimation(): void {
    log.showInfo(`statusbar execute foldedAnimation in windows scene(${sharedData.statusBarPersistentId})`);
    let systemSceneSession: SCBSystemSceneSession =
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(sharedData.statusBarPersistentId);
    if (!systemSceneSession) {
      log.showError('err: System Session is null');
      return;
    }
    systemSceneSession.translateX =
      FoldExpandAnimUtils.getStatusBarTranslateX(FoldAnimationConstants.FOLD_FACTOR, px2vp(sharedData.statusBarWidth));
    systemSceneSession.opacity = FoldExpandAnimUtils.getStatusBarStartOpacity();
    animateTo({
      curve: FoldAnimationConstants.SYSTEM_TRANSLATE_CURVES,
    }, () => {
      if (systemSceneSession) {
        systemSceneSession.translateX = 0;
      }
    })
    animateTo({
      curve: FoldAnimationConstants.ALPHA_CURVES,
    }, () => {
      if (systemSceneSession) {
        systemSceneSession.opacity = 1;
      }
    })
  }

  private windowsExpandedAnimation(): void {
    log.showInfo(`statusbar execute expandedAnimation in windows scene(sharedData.statusBarPersistentId ${sharedData.statusBarPersistentId})`);
    let systemSceneSession: SCBSystemSceneSession =
      SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(sharedData.statusBarPersistentId);
    if (!systemSceneSession) {
      log.showError('err: System Session is null');
      return;
    }
    systemSceneSession.translateX =
      FoldExpandAnimUtils.getStatusBarTranslateX(FoldAnimationConstants.EXPAND_FACTOR, px2vp(sharedData.statusBarWidth));
    systemSceneSession.opacity = FoldExpandAnimUtils.getStatusBarStartOpacity();
    animateTo({
      curve: FoldAnimationConstants.SYSTEM_TRANSLATE_CURVES,
    }, () => {
      if (systemSceneSession) {
        systemSceneSession.translateX = 0;
      }
    })
    animateTo({
      curve: FoldAnimationConstants.ALPHA_CURVES,
    }, () => {
      if (systemSceneSession) {
        systemSceneSession.opacity = 1;
      }
    })
  }
}