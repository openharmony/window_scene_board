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
import osAccount from '@ohos.account.osAccount';
import { LogDomain, LogHelper, SingletonHelper, CheckEmptyUtils } from '@ohos/basicutils';
import {
  sEventManager,
  unsubscribe,
  TextColor,
  WallpaperColorManager,
  obtainLocalEvent,
} from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager, OccludeKeygaurdScene } from '@ohos/windowscene';
import { RectInfo } from '@ohos/basicutils';
import { ItemUtils, SCBVisualEffectMgr } from '@ohos/componenthelper';
import { ScreenLockToDesktopConsts } from '../constants/ScreenLockToDesktopConsts';
import HashSet from '@ohos.util.HashSet';
import { sysDialogMgr, SysDialogType } from '@ohos/systemuicommon';
import { ClockOneShortConsts } from '../constants/ClockOneShortConsts';
import { screenLockInnerStateManager as screenLockStateManager, ScreenLockState } from './ScreenLockInnerStateManager';
import { GlobalStatusCache } from './GlobalStatusCache';
import { KeyGuardCacheKey } from '../bean/KeyGuardStatusEnum';
import { SystemSwitchUtils } from '../utils/SystemSwitchUtils';
import { ScreenLockUnlockService } from '../services/ScreenLockUnLockService';
import { SlVisualConfigManager } from '../visual/SlVisualConfigManager';
import { CcmOption } from '../constants/CommonConstants';
import sceneSessionManager from '@ohos.sceneSessionManager';
import commonEventManager from '@ohos.commonEventManager';
import { slUiStateMgr } from '../manager/ScreenLockUiStateManager';
import { ClockStaticStateType, SlMainStateType, ClockDeskTop2AodAnimType } from '../constants/SlStateType';
import { VisualEffectConstants } from '@ohos/commonconstants';

const TAG = 'SlClockOneShotToDesktopService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const SLIDE_UP_TO_DO_FONTSIZE_ANIMATION_DELAY = 10;

/**
 * AOD到桌面时钟解锁动效
 */
export enum ClockAodAndDesktopAnimType {
  NONE = 0,
  PART_AOD_AND_DESKTOP = 1,
  FULL_AOD_AND_DESKTOP = 2,
}

export class ClockOneShotAniAvailableFromDesktopStateWrapper {
  isAvailable: boolean = false;
  desktopRectInfo: RectInfo = new RectInfo();
}

export class SlClockOneShotToDesktopService {

  noPwdUnlockJustAnimation: Callback<undefined | osAccount.AuthType> = () => {};

  noPwdUnlockExitKeyguard: Callback<undefined | osAccount.AuthType> = () => {};

  updateClockWidgetParamsOnMove: Callback<number> = () => {};

  prepareForOneShotAnimOnFirstMove: Callback<void> = () => {};

  recoverClockAfterOneShotAnim: Callback<void> = () => {};

  judgeClockOneShotAniAvailableFromDesktop: Callback<ClockOneShotAniAvailableFromDesktopStateWrapper> = () => {};

  setTextColorOfDesktopClock: Callback<string> = () => {};

  setTextColorOfDesktopClockForEffect: Callback<string> | undefined = () => {};

  updateClockAodToDesktopState: Callback<boolean> = () => {};

  isSupportMirrorToEnd: () => boolean = () => {
    return false;
  };

  isSupportConsumerMirror: () => boolean = () => {
    return false;
  };

  exitScreenLock: Callback<void> = () => {};
  screenUnlockAnim: Callback<void> = () => {};

  getClockAodAndDesktopAnimType: () => ClockAodAndDesktopAnimType = () => {
    return ClockAodAndDesktopAnimType.NONE;
  };

  private unsubscribeSet: HashSet<unsubscribe> = new HashSet();
  private isClockOnMove: boolean = false;
  private isClockVisible: boolean = false;
  private isUserSwitching: boolean = false; // 是否正在进行用户切换
  private authType: osAccount.AuthType | undefined = undefined;
  private isKeyguardExiting: boolean = false; // 是否正在执行解锁流程
  public onExitKeyguardHasDone: boolean = false; // onExitKeyguard是否被调用
  private subscriberForCtrOrNtfCenter: commonEventManager.CommonEventSubscriber | null = null;
  private isCtrOrNtfCenterShow: boolean = false; // 判断当前控制中心或者通知中心是否显示
  private directUnlockReason?: string | undefined;
  private isDesktopToAodAnimAvailable: boolean = false; // 标记桌面到AOD场景,是否支持时钟一镜到底
  private clockAod2DesktopUnlockAnimMap: Map<ClockAodAndDesktopAnimType, string> = new Map([
    [ClockAodAndDesktopAnimType.NONE, ''],
    [ClockAodAndDesktopAnimType.PART_AOD_AND_DESKTOP, ClockOneShortConsts.PART_AOD_TO_DESKTOP_CLOCK_ANIMATION],
    [ClockAodAndDesktopAnimType.FULL_AOD_AND_DESKTOP, ClockOneShortConsts.FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION],
  ]);

  private _startSceneCallback: Function = (bundleName: string, moduleName: string, abilityName: string) => {
    log.showInfo(`screenlock onAppStart, moduleName = ${moduleName} abilityName = ${abilityName}
     bundleName = ${bundleName}`);
    ScreenLockUnlockService.getInstance().hideRootView();
  };

  public isClockOneShotAnimAvailable(isDesktopToAod: boolean = false): boolean {
    // 验证配置是否启用动画
    if (!SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.SCREEN_CLOCK_ONE_SHOT_ANIM_ENABLE)) {
      log.showInfo('isClockOneShotAnimAvailable Animation configuration is not enabled');
      return false;
    }
    // 锁屏纯色模式需求，锁屏时钟一镜到底动效不生效
    if (SlVisualConfigManager.getInstance().getEnable(CcmOption.SOLID)) {
      log.showInfo('isClockOneShotAnimAvailable disable one shot anim for solid mode');
      return false;
    }

    // 如果是锁屏动效且时钟位置未保存返回动效条件不满足
    let clockRectInfo: RectInfo | undefined = slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE)
    ?.getSlState(ClockStaticStateType.CLOCK_DIGITAL_RECT_EXPAND) as RectInfo | undefined;
    if (isDesktopToAod && (!clockRectInfo || clockRectInfo.width === 0)) {
      log.showWarn('isClockOneShotAnimAvailable doDesktopToAodClockAnim clock rectInfo invalid');
      return false;
    }

    let stateWrapper = new ClockOneShotAniAvailableFromDesktopStateWrapper();
    this.judgeClockOneShotAniAvailableFromDesktop(stateWrapper);
    let isSysDialogShowing = sysDialogMgr.isSysDialogShowing(SysDialogType.TYPE_DEFAULT);
    let isDesktopClockOccludedByScenePanel = this.isDesktopClockOccluded(stateWrapper.desktopRectInfo);
    let isFullScreenOcclude = this.isFullScreenOcclude();
    const res = stateWrapper.isAvailable && !isSysDialogShowing && this.isClockVisible && !this.isUserSwitching &&
      !isDesktopClockOccludedByScenePanel && !isFullScreenOcclude && !this.isCtrOrNtfCenterShow;
    if (!res) {
      log.showInfo(`call isClockAnimationAvailable stateWrapper.isAvailable=${stateWrapper.isAvailable}
      isSysDialogShowing=${isSysDialogShowing} isClockVisible=${this.isClockVisible}
      isUserSwitching=${this.isUserSwitching} isDesktopClockOccludedByScenePanel=${isDesktopClockOccludedByScenePanel}
      isFullScreenOcclude=${isFullScreenOcclude} isCtrOrNtfCenterShow=${this.isCtrOrNtfCenterShow}`);
    }
    return res;
  }

  private isFullScreenOcclude(): boolean {
    let occludedState = GlobalStatusCache.getInstance()
      .getStatus(KeyGuardCacheKey.OCCLUDED_STATUS, OccludeKeygaurdScene.NONE) as number;
    log.showDebug(`isFullScreenOcclude occludedState is: ${occludedState}`);
    return occludedState === OccludeKeygaurdScene.SPECIAL;
  }

  /**
   * 查询灭屏时时钟是否支持桌面到全屏AOD一镜到底动效
   *
   * @param update 是否更新标志位, true表示更新, false表示不更新(取缓存的值)
   * @returns 灭屏时时钟是否支持桌面到全屏AOD一镜到底动效
   */
  public isClockDesktopToAodAnimAvailable(update: boolean = false): boolean {
    if (update) {
      this.isDesktopToAodAnimAvailable = this.isClockOneShotAnimAvailable(true);
    }
    return this.isDesktopToAodAnimAvailable && this.isSupportMirrorToEnd();
  }

  /**
   * 查询时钟是否支持全屏AOD到桌面一镜到底动效
   *
   * @returns 时钟是否支持全屏AOD到桌面一镜到底动效
   */
  public isClockAodToDesktopAnimAvailable(): boolean {
    return this.isClockOneShotAnimAvailable() && this.isSupportMirrorToEnd();
  }

  private isDesktopClockOccluded(desktopRect: RectInfo): boolean {
    let homeOccludedPanels = SCBSceneSessionManager.getInstance().getHomeOccludedPanels();
    log.showDebug(`homeOccludedPanels.size = ${homeOccludedPanels.size}`);
    if (homeOccludedPanels.size === 0) {
      return false;
    }

    let isDesktopClockOccluded = false;
    homeOccludedPanels.forEach((sessions: sceneSessionManager.SceneSession[]) => {
      if (isDesktopClockOccluded) {
        return;
      }
      sessions.forEach((session: sceneSessionManager.SceneSession) => {
        let sceneId = session?.type === sceneSessionManager.SessionType.TYPE_PIP ?
          'SCBPipSceneOverlay' : `session${session?.persistentId}`;
        let rectInfo = ItemUtils.getRectById(sceneId);
        if (rectInfo.width !== 0) {
          log.showInfo(`sceneRectInfo: left:${rectInfo.left} top:${rectInfo.top} right:${rectInfo.right} bottom:${rectInfo.bottom}`);
          isDesktopClockOccluded = !(rectInfo.right < desktopRect.left || rectInfo.left > desktopRect.right ||
            rectInfo.bottom < desktopRect.top || rectInfo.top > desktopRect.bottom);
        }
      });
    });

    return isDesktopClockOccluded;
  }

  public updateClockOnMove(isOnMove: boolean): void {
    this.isClockOnMove = isOnMove;
  }

  public updateClockVisible(isClockVisible: boolean): void {
    this.isClockVisible = isClockVisible;
  }

  public updateUserSwitching(isUserSwitching: boolean): void {
    this.isUserSwitching = isUserSwitching;
  }

  public doDesktopToAodClockAnim(): void {
    const animType: ClockAodAndDesktopAnimType = this.getClockAodAndDesktopAnimType();
    log.showInfo(`doDesktopToAodClockAnim animType: ${animType}`);
    if (animType === ClockAodAndDesktopAnimType.PART_AOD_AND_DESKTOP) {
      this.doDesktopToPartAodClockAnim();
      return;
    }
    const needClockDesktopToAodOneShot = screenLockStateManager.getPreState() === ScreenLockState.EXIT_KEYGUARD &&
      this.isClockDesktopToAodAnimAvailable();
    if (needClockDesktopToAodOneShot) {
      log.showInfo('publish event DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION');
      // 创建灭屏时钟一镜到底动画事件
      slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE)?.setSlState(
        ClockStaticStateType.DESKTOP_TO_AOD_ANIM_TYPE, ClockDeskTop2AodAnimType.DESKTOP_TO_FULL_AOD);
      sEventManager.publish(obtainLocalEvent(ClockOneShortConsts.DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION, false));
    } else {
      slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE)?.setSlState(
        ClockStaticStateType.DESKTOP_TO_AOD_ANIM_TYPE, ClockDeskTop2AodAnimType.NONE);
    }
  }

  public doAodToDesktopClockAnim(callback?: Callback<void>): void {
    if (SystemSwitchUtils.isUseNewScreenLock()) {
      if (this.isClockAodToDesktopAnimAvailable()) {
        this.updateClockAodToDesktopState(true);
        log.showInfo('publish event FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION');
        sEventManager.publish(obtainLocalEvent(ClockOneShortConsts.FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION, false));
        this.noPwdUnlockJustAnimation(undefined);
      }
      return;
    }
    if (this.isClockAodToDesktopAnimAvailable()) {
      if (callback) {
        callback();
      } else {
        log.showError('callback is null or undefined');
      }
      log.showInfo('publish event FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION');
      sEventManager.publish(obtainLocalEvent(ClockOneShortConsts.FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION, false));
    }
  }

  public doDesktopToPartAodClockAnim(): void {
    const needClockDesktopToAodOneShot = screenLockStateManager.getPreState() === ScreenLockState.EXIT_KEYGUARD &&
    slClockOneShotToDesktopService.isClockOneShotAnimAvailable();
    if (needClockDesktopToAodOneShot) {
      slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE)?.setSlState(
        ClockStaticStateType.DESKTOP_TO_AOD_ANIM_TYPE, ClockDeskTop2AodAnimType.DESKTOP_TO_PART_AOD);
      log.showInfo('publish event DESKTOP_TO_PART_AOD_CLOCK_ANIMATION');
      sEventManager.publish(obtainLocalEvent(ClockOneShortConsts.DESKTOP_TO_PART_AOD_CLOCK_ANIMATION, false));
    } else {
      slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE)?.setSlState(
        ClockStaticStateType.DESKTOP_TO_AOD_ANIM_TYPE, ClockDeskTop2AodAnimType.DESKTOP_TO_PART_AOD_NO_ANIM);
      sEventManager.publish(obtainLocalEvent(ClockOneShortConsts.DESKTOP_TO_PART_AOD_NO_ANIM, false));
    }
  }

  public doPartAodToDesktopClockAnim(): void {
    if (slClockOneShotToDesktopService.isClockOneShotAnimAvailable() &&
    slClockOneShotToDesktopService.isSupportMirrorToEnd()) {
      log.showInfo('publish event PART_AOD_TO_DESKTOP_CLOCK_ANIMATION');
      sEventManager.publish(obtainLocalEvent(ClockOneShortConsts.PART_AOD_TO_DESKTOP_CLOCK_ANIMATION, false));
    }
  }

  public doSlToPartAodClockAnim(): void {
    sEventManager.publish(obtainLocalEvent(ClockOneShortConsts.SL_TO_PART_AOD_CLOCK_ANIMATION, false));
  }

  public doPartAodToSlClockAnim(): void {
    sEventManager.publish(obtainLocalEvent(ClockOneShortConsts.PART_AOD_TO_SL_CLOCK_ANIMATION, false));
  }

  public doNoMirrorToPartAod(): void {
    sEventManager.publish(obtainLocalEvent(ClockOneShortConsts.NO_ANIM_SL_TO_PART_AOD, false));
  }

  public doNoMirrorPartAodToSl(): void {
    sEventManager.publish(obtainLocalEvent(ClockOneShortConsts.NO_ANIM_PART_AOD_TO_SL, false));
  }

  public updateKeyguardExitingState(isKeyguardExiting: boolean): void {
    this.isKeyguardExiting = isKeyguardExiting;
  }

  public updateAuthType(authType: osAccount.AuthType | undefined): void {
    this.authType = authType;
  }

  /**
   * init
   */
  init(): void {
    log.showInfo('init');
    this.subscribeAnimationAndUnlocking();
    this.subscriberCtrOrNtfCenterVisible();
  }

  setNoPwdUnlockJustAnimation(callback: Callback<undefined | osAccount.AuthType>): void {
    this.noPwdUnlockJustAnimation = callback;
  }

  setNoPwdUnlockExitKeyguard(callback: Callback<undefined | osAccount.AuthType>): void {
    this.noPwdUnlockExitKeyguard = callback;
  }

  setSetTextColorOfDesktopClock(callback: Callback<string>): void {
    this.setTextColorOfDesktopClock = callback;
  }

  setSetTextColorOfDesktopClockForEffect(callback: Callback<string> | undefined): void {
    this.setTextColorOfDesktopClockForEffect = callback;
  }

  getTextColorOfDesktopClock(): string {
    let textColorObj: TextColor | undefined = WallpaperColorManager.getInstance()?.mTextColor;
    let textColor = '#FFFFFFFF'; // 默认值
    if (CheckEmptyUtils.checkStrIsEmpty(textColorObj?.mTextColor)) {
      log.showWarn('textColor from wallpaperColorManager params error');
    } else {
      textColor = textColorObj?.mTextColor ?? '#FFFFFFFF';
    }
    return textColor;
  }

  notifyUpdateTextColorOfDesktopClock(): void {
    let textColor = this.getTextColorOfDesktopClock();

    if (this.setTextColorOfDesktopClock) {
      this.setTextColorOfDesktopClock(textColor);
    }
    if (this.setTextColorOfDesktopClockForEffect) {
      this.setTextColorOfDesktopClockForEffect(textColor);
    }
  }

  setJudgeClockAniAvailableFromDesktop(callback: Callback<ClockOneShotAniAvailableFromDesktopStateWrapper>): void {
    this.judgeClockOneShotAniAvailableFromDesktop = callback;
  }

  setUpdateClockWidgetParamsOnMove(callback: Callback<number>): void {
    this.updateClockWidgetParamsOnMove = callback;
  }

  setPrepareForOneShotAnimOnFirstMove(callback: Callback<void>): void {
    this.prepareForOneShotAnimOnFirstMove = callback;
  }

  setRecoverClockAfterOneShotAnim(callback: Callback<void>): void {
    this.recoverClockAfterOneShotAnim = callback;
  }

  setUpdateClockAodToDesktopState(callback: Callback<boolean>): void {
    this.updateClockAodToDesktopState = callback;
  }

  setIsSupportMirrorToEnd(callback: () => boolean): void {
    this.isSupportMirrorToEnd = callback;
  }

  setIsSupportConsumerMirror(fun: () => boolean): void {
    this.isSupportConsumerMirror = fun;
  }

  setClockAodAndDesktopAnimType(callback: () => ClockAodAndDesktopAnimType): void {
    this.getClockAodAndDesktopAnimType = callback;
  }

  notifyUpdateClockWidgetParamsOnMove(slidingDistance: number): void {
    if (this.updateClockWidgetParamsOnMove) {
      this.updateClockWidgetParamsOnMove(slidingDistance);
    }
  }

  notifyPrepareForOneShotAnimOnFirstMove(): void {
    if (this.prepareForOneShotAnimOnFirstMove) {
      this.prepareForOneShotAnimOnFirstMove();
    }
  }

  notifyRecoverClockAfterOneShotAnim(): void {
    if (this.recoverClockAfterOneShotAnim && this.isClockOnMove) {
      this.recoverClockAfterOneShotAnim();
    }
  }

  notifyNoPwdUnlockHasExitKeyguard(): void {
    if (this.isKeyguardExiting) {
      log.showInfo('noPwdUnlockExitKeyguard');
      this.onExitKeyguardHasDone = true;
      this.onFinishForUnlock(this.authType);
      this.onExitKeyguardHasDone = false; // 恢复标志位
    }
  }

  /**
   * destroy
   */
  destroy(): void {
    for (let item of this.unsubscribeSet) {
      if (item && typeof item === 'function') {
        item();
      }
    }
    this.unsubscribeSet.clear();

    if (this.subscriberForCtrOrNtfCenter) {
      commonEventManager.unsubscribe(this.subscriberForCtrOrNtfCenter);
      this.subscriberForCtrOrNtfCenter = null;
    }
  }

  private subscribeAnimationAndUnlocking(): void {
    if (this.unsubscribeSet.isEmpty()) {
      this.unsubscribeSet.add(
        sEventManager.subscribe(ScreenLockToDesktopConsts.FACE_TO_DESKTOP_UNLOCKING,
          () => {
            log.showInfo('receive FACE_TO_DESKTOP_UNLOCKING');
            this.onFinishForUnlock(osAccount.AuthType.FACE);
          })
      );

      this.unsubscribeSet.add(
        sEventManager.subscribe(ScreenLockToDesktopConsts.FINGERPRINT_TO_DESKTOP_UNLOCKING,
          () => {
            log.showInfo('receive FINGERPRINT_TO_DESKTOP_UNLOCKING');
            this.onFinishForUnlock(osAccount.AuthType.FINGERPRINT);
          })
      );

      this.unsubscribeSet.add(
        sEventManager.subscribe(ScreenLockToDesktopConsts.KEYPRESS_TO_DESKTOP_UNLOCKING,
          () => {
            log.showInfo('receive KEYPRESS_TO_DESKTOP_UNLOCKING');
            this.onFinishForUnlock();
          })
      );

      this.unsubscribeSet.add(
        sEventManager.subscribe(ScreenLockToDesktopConsts.SLIDE_UP_TO_DESKTOP_UNLOCKING,
          () => {
            log.showInfo('receive SLIDE_UP_TO_DESKTOP_UNLOCKING');
            this.onFinishForUnlock();
          })
      );

      this.unsubscribeSet.add(
        sEventManager.subscribe(ClockOneShortConsts.AOD_TO_DESKTOP_UNLOCKING,
          () => {
            log.showInfo('receive AOD_TO_DESKTOP_UNLOCKING');
            this.onFinishForUnlock();
          })
      );

      this.unsubscribeSet.add(
        sEventManager.subscribe(ClockOneShortConsts.DESKTOP_TO_FULL_AOD_CLOCK_LOCKING,
          () => {
            log.showInfo('receive DESKTOP_TO_FULL_AOD_CLOCK_LOCKING');
            if (this.recoverClockAfterOneShotAnim) {
              this.recoverClockAfterOneShotAnim();
            }
          })
      );
    }
  }

  private subscriberCtrOrNtfCenterVisible(): void {
    const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: ['sysui_window_state_change'],
      publisherPermission: 'ohos.permission.SUBSCRIBE_NOTIFICATION_WINDOW_STATE'
    };
    try {
      commonEventManager.createSubscriber(subscribeInfo).then((res) => {
        this.subscriberForCtrOrNtfCenter = res;
        try {
          this.setCtrOrNtfCenterState();
        } catch (err) {
          log.error('subscribe err:', err);
        }
      });
    } catch (err) {
      log.error('create subscribe err:', err);
    }
  }

  private setCtrOrNtfCenterState(): void {
    commonEventManager.subscribe(this.subscriberForCtrOrNtfCenter, (err, data) => {
      log.showInfo(`receive sysui_window_state_change event, err: ${err?.code}, ${err?.message}`);
      if (data?.parameters?.window === 'ctr_center' || data?.parameters?.window === 'ntf_center') {
        this.isCtrOrNtfCenterShow = data.parameters.isShow;
        log.showInfo(`ctr center or ntf center isShow ${this.isCtrOrNtfCenterShow}`);
      }
    });
  }

  public setExitScreenLock(callback: Callback<void>): void {
    this.exitScreenLock = callback;
  }

  public setScreenUnlockAnim(callback: Callback<void>): void {
    this.screenUnlockAnim = callback;
  }

  // 请求解锁时
  public requestDirectUnlock(reason: string): void {
    this.directUnlockReason = reason;
    // 全屏遮盖模式不需要延迟隐藏锁屏窗口
    if (!this.isFullScreenOcclude()) {
      ScreenLockUnlockService.getInstance().delayHideRootView();
    }
    this.exitScreenLock();
    log.info(`requestDirectUnlock ${reason}`);
  }

  public finishRequestDirectUnlock(): void {
    this.directUnlockReason = undefined;
    ScreenLockUnlockService.getInstance().hideRootView();
    log.info('finishRequestDirectUnlock');
  }

  /**
   * 时钟一镜到底解锁动效
   *
   * @param screenUnlockAnim 锁屏解锁动效
   * @returns true: 时钟一镜到底动效；false：未执行时钟一镜到底动效；
   */
  public doUnlockAnimationForClockOneshot(): boolean {
    if (this.directUnlockReason === ClockOneShortConsts.NO_ANIM_PART_AOD_TO_DESKTOP) {
      // 恢复锁屏参数
      log.showInfo(`consumer Aod revcover clock param`);
      sEventManager.publish(obtainLocalEvent(ClockOneShortConsts.NO_ANIM_PART_AOD_TO_SL, false));
      return false;
    }
    if (!slClockOneShotToDesktopService.isClockOneShotAnimAvailable()) {
      return false;
    }
    log.showInfo(`doUnlockAnimationForClockOneshot start: ${this.directUnlockReason}`);
    let needClockOneshot = true;
    switch (this.directUnlockReason) {
      case ScreenLockToDesktopConsts.SLIDE_UP_TO_DESKTOP_CLOCK_ANIMATION:
        this.slideToDesktopClockUnlock();
        break;
      case ScreenLockToDesktopConsts.FACE_TO_DESKTOP_CLOCK_ANIMATION:
        this.faceToDeskClockUnlock();
        break;
      case ScreenLockToDesktopConsts.FINGERPRINT_TO_DESKTOP_CLOCK_ANIMATION:
        this.fingerprintToDeskClockUnlock();
        break;
      case ScreenLockToDesktopConsts.KEYPRESS_TO_DESKTOP_CLOCK_ANIMATION:
        this.keypressToDeskClockUnlock();
        break;
      case ClockOneShortConsts.AOD_TO_DESKTOP_CLOCK_ANIMATION:
        needClockOneshot = this.handleAodDesktopClockAnimMsg();
        break;
      default:
        log.warn('doUnlockAnimationForClockOneshot no oneshot anim');
        return false;
    }
    log.info('doUnlockAnimationForClockOneshot end');
    SCBSceneSessionManager.getInstance().registerStartSceneListener(this._startSceneCallback);
    return needClockOneshot;
  }

  private handleAodDesktopClockAnimMsg(): boolean {
    const animType: ClockAodAndDesktopAnimType = this.getClockAodAndDesktopAnimType();
    const message: string | undefined = this.clockAod2DesktopUnlockAnimMap.get(animType);
    log.info(`handleAodDesktopClockAnimMsg msg: ${message}`);
    if (message) {
      sEventManager.publish(obtainLocalEvent(message, false));
      this.screenUnlockAnim();
      return true;
    }
    return false;
  }

  private slideToDesktopClockUnlock(): void {
    sEventManager.publish(obtainLocalEvent(ScreenLockToDesktopConsts.SLIDE_UP_TO_DESKTOP_CLOCK_ANIMATION, 0));
    this.screenUnlockAnim();
    setTimeout(() => {
      log.showInfo('publish SLIDE_UP_TO_DO_FONTSIZE_ANIMATION for oneshot');
      sEventManager.publish(obtainLocalEvent(ScreenLockToDesktopConsts.SLIDE_UP_TO_DO_FONTSIZE_ANIMATION, 0));
    }, SLIDE_UP_TO_DO_FONTSIZE_ANIMATION_DELAY);
    log.info('slideToDesktopClockUnlock');
  }

  private faceToDeskClockUnlock(): void {
    log.info('faceToDeskClockUnlock');
    sEventManager.publish(obtainLocalEvent(ScreenLockToDesktopConsts.FACE_TO_DESKTOP_CLOCK_ANIMATION, 0));
    this.screenUnlockAnim();
  }

  private fingerprintToDeskClockUnlock(): void {
    log.info('fingerprintToDeskClockUnlock');
    sEventManager.publish(obtainLocalEvent(ScreenLockToDesktopConsts.FINGERPRINT_TO_DESKTOP_CLOCK_ANIMATION, 0));
    this.screenUnlockAnim();
  }

  private keypressToDeskClockUnlock(): void {
    log.info('keypressToDeskClockUnlock');
    sEventManager.publish(obtainLocalEvent(ScreenLockToDesktopConsts.KEYPRESS_TO_DESKTOP_CLOCK_ANIMATION, 0));
    this.screenUnlockAnim();
  }

  private onFinishForUnlock(authType?: osAccount.AuthType): void {
    this.noPwdUnlockExitKeyguard(authType);
    SCBSceneSessionManager.getInstance().unregisterStartSceneListener();
    if (this.recoverClockAfterOneShotAnim) {
      this.recoverClockAfterOneShotAnim();
    } else {
      log.showWarn('this.recoverClockAfterOneShotAnim is undefined');
    }
  }
}

let slClockOneShotToDesktopService = SingletonHelper.getInstance(SlClockOneShotToDesktopService, TAG);

export default slClockOneShotToDesktopService as SlClockOneShotToDesktopService;