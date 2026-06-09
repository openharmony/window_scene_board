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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { obtainLocalEvent, sEventManager, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { Alarm } from '@ohos/componenthelper';
import { ScreenLockEditConstants } from '../constants/ScreenLockEditConstants';
import { MeshRange } from '../meshsystem/MeshSystem';
import { GlobalStatusCache, StatusCacheConst } from './GlobalStatusCache';
import { KeyGuardPage } from '../bean/KeyGuardStatusEnum';
import { KeyguardStatusService } from '../manager/KeyguardStatusService';
import { ScreenLockToDesktopConsts } from '../constants/ScreenLockToDesktopConsts';
import slClockOneShotToDesktopService from './SlClockOneShotToDesktopService';
import { SystemSwitchUtils } from '../utils/SystemSwitchUtils';
import PerformanceMonitorUtil, { LockscreenEditWeekParams, PosterFontParams } from '../record/report/PerformanceMonitorUtil';
import { BaseMeshViewModel, ComponentType } from './BaseMeshViewModel';
import { slUiStateMgr } from '../manager/ScreenLockUiStateManager';
import { SlMainStateType, ClockBindStateType } from '../constants/SlStateType';

const TAG = 'ScreenLockInnerStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const CLOCK_LAYOUT_TAB: number = 1;
const POSTER_LAYOUT_TAB: number = 2;

/**
 * @deprecated
 */
export enum ScreenLockState {
  HOST,
  THEME_EDITOR,
  THEME_EDITOR_FULL,
  THEME_EDITOR_FULL_CLOCK,
  THEME_EDITOR_FULL_FORM,
  THEME_EDITOR_FORM_DETAIL,
  THEME_EDITOR_CLOCK_DRAG,
  THEME_EDITOR_FORM_DRAG,
  BOUNCER,
  EXIT_KEYGUARD,
  ENTER_OTHER_APP
}

export enum ScreenLockTransitionState {
  LOCK,
  UNLOCK
}

const EDIT_STATE_ARRAY: ScreenLockState[] =
  [ScreenLockState.THEME_EDITOR, ScreenLockState.THEME_EDITOR_FULL, ScreenLockState.THEME_EDITOR_FULL_CLOCK,
    ScreenLockState.THEME_EDITOR_FULL_FORM, ScreenLockState.THEME_EDITOR_FORM_DETAIL,
    ScreenLockState.THEME_EDITOR_CLOCK_DRAG, ScreenLockState.ENTER_OTHER_APP, ScreenLockState.THEME_EDITOR_FORM_DRAG];

/**
 * @deprecated
 */
export interface ScreenLockStateListener {
  /**
   * 触发进入锁屏首页
   *
   * @param isNeedAnimation 是否需要播放动效
   */
  onEnterHost?: (preState: ScreenLockState, isSaveConfig: boolean) => void;
  /**
   * 触发进入个性化编辑页面
   */
  onEnterThemeEditor?: (preState: ScreenLockState) => void;
  /**
   * 触发进入全屏编辑页面
   */
  onEnterFullEditor?: (preState: ScreenLockState, fullState: ScreenLockState) => void;
  /**
   * 触发进入密码输入界面
   */
  onEnterBouncer?: (preState: ScreenLockState, keyboardPosition: number) => void;
  /**
   * 触发退出锁屏
   */
  onExitKeyguard?: () => void;
  /**
   * 进入主题/壁纸/AOD界面
   */
  onEnterOtherApp?: () => void;
  /**
   * 进入壁纸/AOD界面
   */
  onEnterOtherAppBorderShow?: () => void;
  /**
   * 进入主题界面
   */
  onEnterOtherAppBorderHide?: () => void;

  /**
   * 指纹认证成功
   */
  onAuthFPSuccess?: () => void;

  /**
   * 开始过渡动画
   */
  onTransitionStart?: (state: ScreenLockTransitionState) => void;
}

class ScreenLockMeshRange {
  public topHead?: MeshRange;
  public centerContent?: MeshRange;
}

/**
 * 锁屏页面状态管理
 *
 * @since 2024-03-22
 * @deprecated
 */
class ScreenLockInnerStateManager extends BaseMeshViewModel {
  public currentState: ScreenLockState = ScreenLockState.EXIT_KEYGUARD;

  public isUnlock2Editor: boolean = false;

  private stateListeners: ScreenLockStateListener[] = [];

  private preState: ScreenLockState = ScreenLockState.HOST;

  private screenLockMeshRange: ScreenLockMeshRange = new ScreenLockMeshRange();

  private reportAlarm: Alarm = new Alarm();

  private onEnterHostCallback: Function | undefined;
  private onEnterBouncerCallback: Function | undefined;
  private isScreenLockDisabled: Function | undefined;

  /**
   * 注册锁屏状态变化监听
   *
   * @param listener 监听对象
   */
  public registerScreenLockState(listener: ScreenLockStateListener): void {
    if (!listener) {
      log.showInfo('Empty registration is not allowed.');
      return;
    }

    let item: ScreenLockStateListener | undefined = this.stateListeners.find(item => item === listener);
    if (item) {
      log.showInfo('Repeated registration is not allowed.');
      return;
    }
    this.stateListeners.push(listener);

    if (this.currentState === ScreenLockState.THEME_EDITOR) {
      listener.onEnterThemeEditor?.(this.preState);
    }

    if (this.currentState === ScreenLockState.THEME_EDITOR_FULL) {
      listener.onEnterFullEditor?.(this.preState, this.currentState);
    }

    if (this.currentState === ScreenLockState.HOST) {
      listener.onEnterHost?.(this.preState, false);
    }
  }

  /**
   * 取消注册锁屏状态变化监听
   *
   * @param listener 监听对象
   */
  public unregisterScreenLockState(listener: ScreenLockStateListener | undefined): void {
    if (!listener) {
      log.showInfo('Empty registration don\'t need to be deregistered.');
      return;
    }

    let index: number = this.stateListeners.indexOf(listener);
    if (index === -1) {
      log.showInfo('Unregistered listener don\'t need to be deregistered.');
      return;
    }
    this.stateListeners.splice(index, 1);
  }

  /**
   * 触发进入锁屏首页
   *
   * @param isNeedAnimation 是否需要播放动画
   */
  public onEnterHost(isSaveConfig?: boolean): void {
    if (this.currentState === ScreenLockState.HOST) {
      log.showDebug('current is host state, skip');
      return;
    }
    log.info('onEnterHost');
    this.preState = this.currentState;
    this.currentState = ScreenLockState.HOST;
    if (!SystemSwitchUtils.isUseNewScreenLock()) {
      if (this.isScreenLockDisabled && !this.isScreenLockDisabled?.()) {
        viewMgrPolicy.showView(ViewType.KEYGUARD);
        KeyguardStatusService.switchToPage(KeyGuardPage.HOME_PAGE);
        AppStorage.SetOrCreate('isHomeVisible', true);
        if (!GlobalStatusCache.getInstance().getStatus(StatusCacheConst.IS_PLAY_PWD_BACK_ANIMATION, false)) {
          viewMgrPolicy.hideView(ViewType.KEYGUARD_BOUNCER);
          AppStorage.setOrCreate<boolean>('isPwdVisible', false);
        }
      } else if (!this.isScreenLockDisabled) {
        log.showError('onEnterHost isScreenLockDisabled undefined');
      }
    }
    this.stateListeners.forEach((listener: ScreenLockStateListener) => {
      listener?.onEnterHost?.(this.preState, !!isSaveConfig);
    });
    this.isUnlock2Editor = false;
    if (!SystemSwitchUtils.isUseNewScreenLock()) {
      if (this.onEnterHostCallback) {
        this.onEnterHostCallback?.();
      } else {
        log.showError('onEnterHost onEnterHostCallback undefined');
      }
    }
  }

  /**
   * 触发进入锁屏个性化编辑界面
   */
  public onEnterThemeEditor(): void {
    log.showWarn('onEnterThemeEditor');
    this.preState = this.currentState;
    this.currentState = ScreenLockState.THEME_EDITOR;
    if (!SystemSwitchUtils.isUseNewScreenLock()) {
      viewMgrPolicy.showView(ViewType.KEYGUARD);
      viewMgrPolicy.hideView(ViewType.KEYGUARD_BOUNCER);
    }
    this.stateListeners.forEach((listener: ScreenLockStateListener) => {
      listener?.onEnterThemeEditor?.(this.preState);
    });
    this.isUnlock2Editor = false;
  }

  /**
   * 触发进入锁屏全屏编辑界面
   */
  public onEnterFullEditor(fullState: ScreenLockState): void {
    log.showInfo('onEnterFullEditor: ' + fullState);
    this.preState = this.currentState;
    this.currentState = fullState;
    this.stateListeners.forEach((listener: ScreenLockStateListener) => {
      listener?.onEnterFullEditor?.(this.preState, fullState);
    });
    if (fullState === ScreenLockState.THEME_EDITOR_FULL_CLOCK) {
      let clocklayout = slUiStateMgr
        .getSlState(SlMainStateType.SL_CLOCK_WG_BIND_STATE)?.getSlState(ClockBindStateType.CLOCK_LAYOUT) as number;
      PerformanceMonitorUtil.reportLockscreenEditTimeClick(clocklayout < 200 ? CLOCK_LAYOUT_TAB : POSTER_LAYOUT_TAB);
    }
  }

  /**
   * 触发进入锁屏密码输入界面
   */
  public onEnterBouncer(keyboardPosition: number = 0): void {
    log.showInfo('onEnterBouncer keyboardPosition:' + keyboardPosition);
    if (!SystemSwitchUtils.isUseNewScreenLock()) {
      if (this.onEnterBouncerCallback) {
        this.onEnterBouncerCallback?.();
      } else {
        log.showError('onEnterHost onEnterHostCallback undefined');
      }
    }
    this.preState = this.currentState;
    this.currentState = ScreenLockState.BOUNCER;
    if (!SystemSwitchUtils.isUseNewScreenLock()) {
      viewMgrPolicy.showView(ViewType.KEYGUARD_BOUNCER);
      KeyguardStatusService.switchToPage(KeyGuardPage.PWD_PAGE);
    }
    this.stateListeners.forEach((listener: ScreenLockStateListener) => {
      listener?.onEnterBouncer?.(this.preState, keyboardPosition);
    });
  }

  public onAuthFPSuccess(): void {
    log.showInfo('onAuthFPSuccess');
    this.stateListeners.forEach((listener: ScreenLockStateListener) => {
      listener?.onAuthFPSuccess?.();
    });
  }

  /**
   * 触发退出锁屏界面
   */
  public onExitKeyguard(): void {
    log.showWarn('onExitKeyguard, publish DESKTOP_CLOCK_ANIMATION_START');
    this.preState = this.currentState;
    this.currentState = ScreenLockState.EXIT_KEYGUARD;
    if (!SystemSwitchUtils.isUseNewScreenLock()) {
      viewMgrPolicy.hideView(ViewType.KEYGUARD);
      viewMgrPolicy.hideView(ViewType.KEYGUARD_BOUNCER);
      KeyguardStatusService.switchToPage(KeyGuardPage.EXIT_PAGE);
    }
    this.stateListeners.forEach((listener: ScreenLockStateListener) => {
      listener?.onExitKeyguard?.();
    });
    this.isUnlock2Editor = false;
    if (!SystemSwitchUtils.isUseNewScreenLock()) {
      log.showInfo('publish DESKTOP_CLOCK_ANIMATION_START');
      sEventManager.publish(obtainLocalEvent(ScreenLockToDesktopConsts.DESKTOP_CLOCK_ANIMATION_START, null));
      slClockOneShotToDesktopService.notifyNoPwdUnlockHasExitKeyguard();
    }
  }

  /**
   * 触发退出锁屏界面
   *
   * @param type 锁屏界面类型
   */
  public onEnterOtherApp(): void {
    log.showInfo('onEnterOtherApp');
    this.preState = this.currentState;
    this.currentState = ScreenLockState.ENTER_OTHER_APP;
    this.stateListeners.forEach((listener: ScreenLockStateListener) => {
      listener?.onEnterOtherApp?.();
    });
    this.isUnlock2Editor = false;
  }

  /**
   * 触发进入壁纸/aod界面
   */
  public onEnterOtherAppBorderShow(): void {
    log.showInfo('onEnterOtherAppBorderShow');
    this.preState = this.currentState;
    this.currentState = ScreenLockState.ENTER_OTHER_APP;
    this.stateListeners.forEach((listener: ScreenLockStateListener) => {
      listener?.onEnterOtherAppBorderShow?.();
    });
    this.isUnlock2Editor = false;
  }

  /**
   * 触发进入主题界面
   */
  public onEnterOtherAppBorderHide(): void {
    log.showInfo('onEnterOtherAppBorderHide');
    this.preState = this.currentState;
    this.currentState = ScreenLockState.ENTER_OTHER_APP;
    this.stateListeners.forEach((listener: ScreenLockStateListener) => {
      listener?.onEnterOtherAppBorderHide?.();
    });
    this.isUnlock2Editor = false;
  }

  /**
   * 通知过渡状态开始
   *
   * @param state 过渡状态
   */
  public onTransitionStart(state: ScreenLockTransitionState): void {
    this.stateListeners.forEach((listener: ScreenLockStateListener) => {
      listener?.onTransitionStart?.(state);
    });
  }

  /**
   * 获取需要的网格数
   *
   * @param componentType 组件类型
   * @param meshRange 网格范围
   * @param resultCallback 网格信息回调
   */
  public async requestUseMesh(componentType: string, meshRange: MeshRange,
    resultCallback?: (meshRange?: MeshRange) => void): Promise<void> {
    log.showInfo(`componentType is ${componentType}, requestUseMesh`);
    if (this.isEditor(this.currentState) || (SystemSwitchUtils.isUseNewScreenLock() && this.isUnlock2Editor)) {
      return;
    }
    switch (componentType) {
      case ComponentType.TOP_HEAD:
        this.screenLockMeshRange.topHead = meshRange;
        this.updateCenterContentMeshInfo();
        break;
      case ComponentType.CENTER_CONTENT:
        this.screenLockMeshRange.centerContent = meshRange;
        this.updateHeadMeshInfo();
        this.onCenterContentStateChange();
        break;
      default:
        break;
    }
    if (resultCallback) {
      resultCallback(this.screenLockMeshRange.centerContent);
    }
  }

  public isEditor(screenLockState?: ScreenLockState): boolean {
    return EDIT_STATE_ARRAY.includes(screenLockState ? screenLockState : this.currentState);
  }

  private updateCenterContentMeshInfo(): void {
    if (!this.screenLockMeshRange.centerContent) {
      log.showInfo('screenLockMeshRange centerContent is null');
      return;
    }
    if (this.screenLockMeshRange.topHead?.rangeEnd !== this.screenLockMeshRange.centerContent.rangeStart) {
      this.screenLockMeshRange.centerContent.rangeStart = this.screenLockMeshRange.topHead?.rangeEnd ?? 0;
    }
  }

  private updateHeadMeshInfo(): void {
    if (!this.screenLockMeshRange.topHead) {
      this.screenLockMeshRange.topHead = new MeshRange(0, this.screenLockMeshRange.centerContent?.rangeStart);
    }
    if (this.screenLockMeshRange.topHead.rangeEnd !== this.screenLockMeshRange.centerContent?.rangeStart) {
      this.screenLockMeshRange.topHead.rangeEnd = this.screenLockMeshRange.centerContent?.rangeStart ?? 0;
    }
    log.showInfo(`screenLockMeshRange topHead rangeEnd is ${this.screenLockMeshRange.topHead.rangeEnd}`);
  }

  private onCenterContentStateChange(): void {
    this.handleComponentCallback(ComponentType.TOP_HEAD, this.screenLockMeshRange.topHead);
  }

  /**
   * 开始计时
   *
   * @returns void
   */
  public startReportAlarm(
    reportWeekParams: LockscreenEditWeekParams,
    type?: number,
    posterFontParams?: PosterFontParams,
    isDof?: boolean
  ): void {
    const reportFunction = () => {
      PerformanceMonitorUtil.reportLockscreenEditStateNowWeek(reportWeekParams, type, posterFontParams, isDof, false);
    }
    this.startReportAlarmWithFunc(reportFunction);
  }

  public startReportAlarmWithFunc(reportFunction: () => void): void {
    this.reportAlarm.setHandler(null);
    this.reportAlarm.cancelAlarm();
    let date = new Date();
    // 1、计算当天剩余的毫秒数
    let todayRestMs = ScreenLockEditConstants.ONE_DAY_MILL -
      ((date.getHours() * ScreenLockEditConstants.ONE_HOUR_MILL) +
      (date.getMinutes() * ScreenLockEditConstants.ONE_MINUTE_MILL) +
      (date.getSeconds() * ScreenLockEditConstants.ONE_SECOND_MILL) +
      date.getMilliseconds());

    // 2、计算距离周日还有多少天，
    let restDay = ScreenLockEditConstants.ONE_WEEK_DAYS - date.getDay();

    // 3、计算距离周日还有多少毫秒
    let totalRestMs = todayRestMs + restDay * ScreenLockEditConstants.ONE_DAY_MILL;

    // 4、设置定时器，当倒计时结束，说明已经到周日了
    this.reportAlarm.setHandler({
      onAlarm: () => {
        if(reportFunction){
          reportFunction();
        }
      }
    });
    this.reportAlarm.setAlarm(totalRestMs);
  }

  public getPreState(): ScreenLockState {
    return this.preState;
  }

  public initInnerStateCallback(onEnterHostCallback: Function, onEnterBouncerCallback: Function,
    isScreenLockDisabled: Function): void {
    log.showInfo(`initInnerStateCallback`);
    this.onEnterHostCallback = onEnterHostCallback;
    this.onEnterBouncerCallback = onEnterBouncerCallback;
    this.isScreenLockDisabled = isScreenLockDisabled;
  }

  public clearInnerStateCallback(): void {
    log.showInfo(`clearInnerStateCallback`);
    this.onEnterHostCallback = undefined;
    this.onEnterBouncerCallback = undefined;
    this.isScreenLockDisabled = undefined;
  }
}

/**
 * @deprecated
 */
export const screenLockInnerStateManager = SingletonHelper.getInstance(ScreenLockInnerStateManager, TAG);