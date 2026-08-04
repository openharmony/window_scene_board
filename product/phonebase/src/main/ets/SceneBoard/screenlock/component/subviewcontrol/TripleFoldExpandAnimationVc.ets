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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ApsUtils, DeviceHelper } from '@ohos/frameworkwrapper';
import { TripleAnimManagerUtil, TripleStateChange } from '../../utils/TripleAnimManagerUtil';
import { WidgetAnimState } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/bean/WidgetAnimState';
import { TripleAnimConstants } from '../../constant/TripleAnimConstants';
import { slStateHelper } from '../../model/helper/SlStateHelper';
import { slStateHelper as slStateHelperPSDAni } from '@ohos/screenlockcomponent/src/main/ets/common/helper/SlStateHelper';
import { immersiveKgMgr, ImmersiveState } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { DisplayUtils,
  ScreenLockStateManager,
  ThreeFoldStatus } from '@ohos/screenlockcommon';
import { WidgetAnimStateV2 } from '@ohos/screenlockcommon/Index';
import { SlStateBaseMgr, SlStateId, SlStateMgr, StateType } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import {
  SlMainStateType,
  SlStaticStateType,
  SlSubStateType,
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { SlStaticState } from '../../model/data/SlStaticState';
import { performanceMonitor } from '@kit.ArkUI';
import {
  ScreenOnOffService,
  ScreenOnOffListener,
  SleepReason
} from '@ohos/screenlockcommon/src/main/ets/services/ScreenOnOffService';

const TAG = 'TripleFoldExpandAnimation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const CLOCK_SUFFIX = '_Clock';

/**
 * 三折叠产品，锁屏元素开合动效控制类
 */
export class TripleFoldExpandAnimationVc {
  private static mInstance: TripleFoldExpandAnimationVc;
  // 参与锁屏开合动效组件列表
  private widgetList: string[];
  // 锁屏开合动效类型
  private animSceneMap: Map<TripleStateChange, string>;
  private finishSet: Set<string>;
  private preAnimScene: string | undefined;
  private curAnimScene: string | undefined;
  private tripleAnimManageUtil: TripleAnimManagerUtil;
  private curThreeFoldStatus: ThreeFoldStatus | undefined = ThreeFoldStatus.F_STATUS;
  private slStaticState: SlStaticState;
  private isScreenOff: boolean = false; // 当前熄屏状态监测

  constructor() {
    this.widgetList = [TripleAnimConstants.LOCK_ICON, TripleAnimConstants.IMMERSIVE_CAP,
      TripleAnimConstants.IMMERSIVE_LIST, TripleAnimConstants.IMMERSIVE_CARD, TripleAnimConstants.QUICK_TOOLS,
      TripleAnimConstants.BOTTOM_CAMERA, TripleAnimConstants.FOLDABLE_PSD];
    this.animSceneMap = new Map<TripleStateChange, string>([
      [TripleStateChange.F_TO_M, 'tripleAnimationFTM'],
      [TripleStateChange.M_TO_F, 'tripleAnimationMTF'],
      [TripleStateChange.F_TO_G, 'tripleAnimationFTG'],
      [TripleStateChange.G_TO_F, 'tripleAnimationGTF'],
      [TripleStateChange.M_TO_G, 'tripleAnimationMTG'],
      [TripleStateChange.G_TO_M, 'tripleAnimationGTM'],
    ]);
    this.finishSet = new Set<string>('tripleAnimationINVALID');
    this.preAnimScene = undefined;
    this.curAnimScene = undefined;
    this.tripleAnimManageUtil = TripleAnimManagerUtil.getInstance();
    this.curThreeFoldStatus = DisplayUtils.getThreeFoldStatus();
    this.slStaticState = slStateHelper.getSlStaticState();
  }

  public static getInstance(): TripleFoldExpandAnimationVc {
    if (!TripleFoldExpandAnimationVc.mInstance) {
      TripleFoldExpandAnimationVc.mInstance = new TripleFoldExpandAnimationVc();
    }
    return TripleFoldExpandAnimationVc.mInstance;
  }

  public getCurAnimScene(): string | undefined {
    return this.curAnimScene;
  }

  private setCurAnimScene(animScene: string | undefined): void {
    this.curAnimScene = animScene;
  }

  private getWidgetAnimCtrl(widgetName: string): WidgetAnimState | WidgetAnimStateV2 | undefined {
    log.showInfo(`getWidgetAnimCtrl, widget name is ${widgetName}`);
    let widgetAnimCtrl: WidgetAnimState | WidgetAnimStateV2 | undefined;
    switch (widgetName) {
      case TripleAnimConstants.LOCK_ICON:
        widgetAnimCtrl = slStateHelper.getSlLockIconAnimCtrl();
        break;
      case TripleAnimConstants.IMMERSIVE_CAP:
        widgetAnimCtrl = this.getImmCapAnim();
        break;
      case TripleAnimConstants.IMMERSIVE_LIST:
        widgetAnimCtrl = this.getImmListAnim();
        break;
      case TripleAnimConstants.IMMERSIVE_CARD:
        widgetAnimCtrl = this.getImmCardAnim();
        break;
      case TripleAnimConstants.QUICK_TOOLS:
        widgetAnimCtrl = slStateHelper.getSlQtAnimCtrl();
        break;
      case TripleAnimConstants.BOTTOM_CAMERA:
        widgetAnimCtrl = slStateHelper.getSlCameraAnimCtrl();
        break;
      case TripleAnimConstants.FOLDABLE_PSD:
        widgetAnimCtrl = slStateHelperPSDAni.getSlFoldablePSDAnimCtrl();
        break;
      default:
        widgetAnimCtrl = undefined;
        break;
    }
    return widgetAnimCtrl;
  }

  private getImmListAnim(): WidgetAnimState | WidgetAnimStateV2 | undefined {
    let v2Anim = this.getImmV2Anim(SlStateId.SL_LIST_STATE);
    if (v2Anim) {
      return v2Anim;
    }
    return slStateHelper.getSlListStaticState()?.getSlRootListAnimCtrl();
  }

  private getImmCapAnim(): WidgetAnimState | WidgetAnimStateV2 | undefined {
    let v2Anim = this.getImmV2Anim(SlStateId.SL_CAP_STATE);
    if (v2Anim) {
      return v2Anim;
    }
    return slStateHelper.getSlCapStaticState()?.getSlRootCapAnimCtrl();
  }

  private getImmCardAnim(): WidgetAnimState | WidgetAnimStateV2 | undefined {
    let v2Anim = this.getImmV2Anim(SlStateId.SL_CARD_STATE);
    if (v2Anim) {
      return v2Anim;
    }
    return slStateHelper.getSlCardStaticState()?.getSlRootCardAnimCtrl();
  }

  private getImmV2Anim(slId: SlStateId): WidgetAnimStateV2 | undefined {
    if (SlStateBaseMgr.isV2Enable()) {
      return SlStateBaseMgr.getMgr(SlStateMgr.MGR_COMMON)?.getState(StateType.ANIM, slId) as WidgetAnimStateV2;
    }
    return undefined;
  }

  // 判断各组件是否需要刷新动画状态，避免冗余刷新
  private isWidgetAnimExecute(widgetName: string, immersiveState: ImmersiveState): boolean {
    switch (widgetName) {
      case TripleAnimConstants.CLOCK:
      case TripleAnimConstants.QUICK_TOOLS:
      case TripleAnimConstants.BOTTOM_CAMERA:
        return !ScreenLockStateManager.getInstance().isInBouncer;
      case TripleAnimConstants.LOCK_ICON:
        return !ScreenLockStateManager.getInstance().isInEdite;
      case TripleAnimConstants.IMMERSIVE_CAP:
        return immersiveState.isShowCapsule();
      case TripleAnimConstants.IMMERSIVE_LIST:
        return immersiveState.isShowList();
      case TripleAnimConstants.IMMERSIVE_CARD:
        return immersiveState.isShowCard();
      case TripleAnimConstants.FOLDABLE_PSD:
        return ScreenLockStateManager.getInstance().isInBouncer;
      default:
        return false;
    }
  }

  // 设置各个组件动效的初始值
  private setInitialAnimationState(stateChange: TripleStateChange, animScene: string, screenWidth: number,
    isClockAnimating: boolean): void {
    let widgetAnimCtrl: WidgetAnimState | WidgetAnimStateV2 | undefined;
    let immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();
    if (isClockAnimating) {
      widgetAnimCtrl = slStateHelper.getSlClockAnimCtrl();
      let initialTransX: number = this.tripleAnimManageUtil.initTripleAnimTransX(stateChange, screenWidth,
        TripleAnimConstants.CLOCK);
      let initialTransY: number = this.tripleAnimManageUtil.initTripleClockTransY(stateChange);
      if (!widgetAnimCtrl || !this.isWidgetAnimExecute(TripleAnimConstants.CLOCK, immersiveState)) {
        log.showInfo('Unidentified clockAnimCtrl, setClockInitialAnimationState return');
        return;
      }
      widgetAnimCtrl?.setAnimScene({isAnimating: true, animScene: animScene, isForceRemove: true})
        .setTranX(initialTransX)
        .setTranY(initialTransY);
      return;
    }
    this.widgetList.forEach((widgetName: string) => {
      widgetAnimCtrl = this.getWidgetAnimCtrl(widgetName);
      let initialTransX: number = this.tripleAnimManageUtil.initTripleAnimTransX(stateChange, screenWidth, widgetName);
      if (widgetAnimCtrl === undefined || !this.isWidgetAnimExecute(widgetName, immersiveState)) {
        log.showInfo('Unidentified widgetAnimCtrl, setInitialAnimationState return');
        return;
      }
      widgetAnimCtrl?.setAnimScene({isAnimating: true, animScene: animScene, isForceRemove: true})
        .setTranX(initialTransX);
      log.showInfo(`setInitialAnimationState, widget name: ${widgetName}, triple initial value: ${initialTransX}`);
    });
  }

  // 设置各组件动画的终点值
  private setAnimationState(endValue: number, animScene: string, isClockAnimating: boolean): void {
    let widgetAnimCtrl: WidgetAnimState | WidgetAnimStateV2 | undefined;
    let immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();
    if (isClockAnimating) {
      widgetAnimCtrl = slStateHelper.getSlClockAnimCtrl();
      if (widgetAnimCtrl === undefined || !this.isWidgetAnimExecute(TripleAnimConstants.CLOCK, immersiveState)) {
        log.showInfo('Unidentified clockAnimCtrl, setClockAnimationState return');
        return;
      }
      widgetAnimCtrl?.setAnimScene({isAnimating: true, animScene: animScene, isForceRemove: true})
        .setTranX(endValue)
        .setTranY(endValue);
      return;
    }
    this.widgetList.forEach((widgetName: string) => {
      widgetAnimCtrl = this.getWidgetAnimCtrl(widgetName);
      if (widgetAnimCtrl === undefined || !this.isWidgetAnimExecute(widgetName, immersiveState)) {
        log.showInfo('Unidentified widgetAnimCtrl, setAnimationState return');
        return;
      }
      widgetAnimCtrl?.setAnimScene({isAnimating: true, animScene: animScene, isForceRemove: true})
        .setTranX(endValue);
      log.showInfo(`setAnimationState, widget name is ${widgetName}, triple animation endValue value is ${endValue}`);
    });
  }

  // 动画执行完成，取消组件的动画状态
  private endAnimationState(animScene: string, isClockAnimating: boolean): void {
    let widgetAnimCtrl: WidgetAnimState | WidgetAnimStateV2 | undefined;
    if (isClockAnimating) {
      widgetAnimCtrl = slStateHelper.getSlClockAnimCtrl();
      if (widgetAnimCtrl !== undefined) {
        widgetAnimCtrl?.setAnimScene({isAnimating: false, animScene: animScene, isForceRemove: true})
          .setTranX(0)
          .setTranY(0);
      }
      return;
    }
    this.widgetList.forEach((widgetName: string) => {
      widgetAnimCtrl = this.getWidgetAnimCtrl(widgetName);
      if (widgetAnimCtrl !== undefined) {
        widgetAnimCtrl?.setAnimScene({isAnimating: false, animScene: animScene, isForceRemove: true})
          .setTranX();
      }
      log.showInfo(`endAnimationState, widget name is ${widgetName}`);
    });
  }

  // 三折叠开合动画执行点
  public tripleAnimation(isClockAnimating: boolean): void {
    let newThreeFoldStatus = DisplayUtils.getThreeFoldStatus();
    if (this.curThreeFoldStatus === undefined || newThreeFoldStatus === undefined) {
      return;
    }
    let stateChange =
      this.tripleAnimManageUtil.getTripleScreenLockStateChange(this.curThreeFoldStatus, newThreeFoldStatus);
    if (stateChange === TripleStateChange.INVALID) {
      log.showInfo('triple state change value is invalid');
      return;
    }
    let animScene: string = this.animSceneMap.get(stateChange) as string;
    this.addFinishFunction(animScene, isClockAnimating);
    this.removeFinishFunction(this.preAnimScene, isClockAnimating);
    this.setCurAnimScene(animScene);
    let screenWidth: number = this.slStaticState.getScreenSize().width;
    animateTo({
      duration: 0,
    }, () => {
      this.setInitialAnimationState(stateChange, animScene, screenWidth, isClockAnimating);
    });
    if (isClockAnimating) {
      this.curThreeFoldStatus = newThreeFoldStatus;
      this.preAnimScene = animScene;
    }
    if (this.isScreenOff && stateChange === TripleStateChange.F_TO_M) {
      log.showInfo('update without animation');
      this.setAnimationState(0, animScene, isClockAnimating);
      this.removeFinishFunction(animScene, isClockAnimating);
    } else {
      animateTo({
        curve: this.tripleAnimManageUtil.getTripleAnimCurves(stateChange),
        onFinish: () => {
          if (DeviceHelper.isThreeFoldProduct()) {
            log.showInfo(`animScene: ${animScene}, animation finish`);
            this.removeFinishFunction(animScene, isClockAnimating);
            this.setTraceEnd(isClockAnimating, animScene);
          }
        }
      }, () => {
        this.setTraceStart(isClockAnimating, animScene);
        this.setAnimationState(0, animScene, isClockAnimating);
      });
    }
  }

  private addFinishFunction(animScene: string, isClockAnimating: boolean): void {
    let anim: string = animScene;
    if (isClockAnimating) {
      anim = animScene + CLOCK_SUFFIX;
    }
    log.showInfo(`addFinishFunction, cureent animScene is ${anim}`);
    this.finishSet.add(anim);
    return;
  }

  private removeFinishFunction(animScene: string | undefined, isClockAnimating: boolean): void {
    if (animScene === undefined) {
      log.showInfo(`removeFinishFunction, animScene is ${animScene}, isClockAnimating is ${isClockAnimating}`);
      return;
    }
    let anim: string = animScene;
    if (isClockAnimating) {
      anim = animScene + CLOCK_SUFFIX;
    }
    if (this.finishSet.has(anim)) {
      log.showInfo(`removeFinishFunction, cureent remove anmimScene is ${anim}`);
      this.endAnimationState(animScene, isClockAnimating);
      this.finishSet.delete(anim);
    }
    return;
  }

  private setTraceStart(isClockAnimating: boolean, animScene: string): void {
    if (!isClockAnimating) {
      performanceMonitor.begin(TAG + '_' + animScene, performanceMonitor.ActionType.LAST_UP);
      // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, 1);
    }
  }

  private setTraceEnd(isClockAnimating: boolean, animScene: string): void {
    if (!isClockAnimating) {
      performanceMonitor.end(TAG + '_' + animScene);
      // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, 0);
    }
  }

  // 折叠开合回调函数
  private tripleAnimationCtrl: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === SlStaticStateType.SCREEN_BP) {
        if (slStateHelper.getSlStaticState().getSlHostState()) {
          TripleAnimManagerUtil.getInstance().setSkipClockMarginAnimation(true);
          this.tripleAnimation(false);
        } else {
          this.curThreeFoldStatus = DisplayUtils.getThreeFoldStatus();
        }
      }
    }
  }

  private powerStateChangeListener: ScreenOnOffListener = {
    onBeginSleep: (reason: SleepReason) => {
      // 开始进入熄屏模式
      this.isScreenOff = true;
    },
    onEndDisplayOn: () => {
      // 开始亮屏后，恢复动效状态
      this.isScreenOff = false;
    }
  }

  // 注册三折叠开合动效回调监听
  public registerTripleFoldExpandAnimation(): void {
    if (DeviceHelper.isThreeFoldProduct()) {
      slUiStateMgr.registerSlStateChangeListener(this.tripleAnimationCtrl);
      ScreenOnOffService.getInstance().registerObserver(this.powerStateChangeListener);
    }
  }

  // 解注册三折叠开合动效回调监听
  public unRegisterTripleFoldExpandAnimation(): void {
    if (DeviceHelper.isThreeFoldProduct()) {
      slUiStateMgr.unregisterSlStateChangeListener(this.tripleAnimationCtrl);
      ScreenOnOffService.getInstance().unRegisterObserver(this.powerStateChangeListener);
    }
  }
}
