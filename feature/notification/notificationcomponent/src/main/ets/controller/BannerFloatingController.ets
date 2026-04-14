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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneMode, SCBSceneSessionManager } from '@ohos/windowscene';
import BundleManager from '@ohos.bundle.bundleManager';
import Want from '@ohos.app.ability.Want';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import type { NotificationEntry } from '../model/NotificationEntry';
import { ExclusiveChecker } from '../model/ExclusiveChecker';
import { WantAgent } from '@ohos.wantAgent';
import { ntfViewConfigManager } from '../vm/config/NtfViewConfigManager';
import { SystemuiConstants } from '@ohos/systemuicommon/src/main/ets/constants/SystemuiConstants';
import { InvokePushAgentParam } from '../model/InvokePushAgentParam';
import { ClickNotificationErrorCode } from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { NotificationBase } from '@ohos/systemuicommon/src/main/ets/model/NotificationBase';
import { NotificationUtil } from '@ohos/systemuicommon/src/main/ets/utils/NotificationUtil';
import { AccessibilityManager } from '@ohos/frameworkwrapper';
import { WantAgentUtil } from '@ohos/systemuicommon/src/main/ets/utils/WantAgentUtil';
import { SceneSessionAdapter, ScreenSessionAdapter } from '@ohos/systemuicommon';

const TAG = 'BannerFloatingController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * display mode for display floating window
 */
export enum FloatingDisplayMode {
  FLOATING_CENTER = 0,
  FLOATING_RIGHT = 1
}

export enum AppStateStatus {
  FOREGROUND = 2,
  FOCUS = 3
}

/**
 * 横幅悬浮窗控制器
 *
 * @since 2023-11-27
 */
export class BannerFloatingController {
  /**
   * 是否支持悬浮窗
   */
  private canOpenFloatingWindow: boolean = true;
  private paramBundleName: string = '';
  private paramModuleName: string = '';
  private paramAbilityName: string = '';
  private want: Want | null = null;
  private floatingCapacityUpdateListeners: Set<FloatingCapacityUpdateListener> = new Set();
  private isAppForeground: boolean = true;
  private wantAgent: WantAgent | null = null;
  private ntfEntry: NotificationEntry | NotificationBase | undefined = undefined;

  /**
   * 注悬浮窗能力变化监听
   *
   * @param listener 监听器
   */
  registerFloatingCapacityChangedListener(listener: FloatingCapacityUpdateListener): void {
    this.floatingCapacityUpdateListeners.add(listener);
  }

  /**
   * 注销悬浮窗能力变化监听
   *
   * @param listener 监听器
   */
  unregisterFloatingCapacityChangedListener(listener: FloatingCapacityUpdateListener): void {
    this.floatingCapacityUpdateListeners.delete(listener);
  }

  /**
   * 通知悬浮窗能力变化
   */
  private async notifyFloatingCapacityChanged(isMidScene: boolean): Promise<void> {
    const isSupportFloating = await this.isSupportFloatingAsync(isMidScene);
    log.showInfo(`notifyFloatingCapacityChanged, isSupportFloating: ${isSupportFloating}`);
    this.floatingCapacityUpdateListeners.forEach((listener) => {
      listener.onFloatingCapacityChanged(isSupportFloating);
    });
  }

  /**
   * 是否实况类型
   * @returns
   */
  private isLiveType(entry: NotificationEntry | NotificationBase): boolean {
    if (entry instanceof NotificationBase) {
      return entry.isLiveView();
    } else {
      return entry.isLiveType();
    }
  }

  public async updateFloatingWindowStatus(entry: NotificationEntry | NotificationBase,
    isMidScene: boolean): Promise<void> {
    log.showInfo(`updateFloatingWindowStatus, wantAgent:${typeof entry?.wantAgent}, want:${typeof entry?.wantAgentInfo?.want}, isMidScene: ${isMidScene}`);
    if (!entry || !entry.wantAgent || isMidScene) {
      this.canOpenFloatingWindow = false;
      this.paramBundleName = '';
      this.paramModuleName = '';
      this.paramAbilityName = '';
      this.isAppForeground = true;
      this.ntfEntry = undefined;
      this.notifyFloatingCapacityChanged(isMidScene);
      return;
    }

    this.ntfEntry = entry;
    this.wantAgent = entry.wantAgent;
    const want = entry.wantAgentInfo?.want;
    if (want) {
      this.paramBundleName = want.bundleName ?? '';
      this.paramModuleName = want.moduleName ?? '';
      this.paramAbilityName = want.abilityName ?? '';
      this.want = want;
      log.showInfo(`bundleName: ${this.paramBundleName} paramModuleName:${this.paramModuleName},` +
        `paramAbilityName: ${this.paramAbilityName}`);
      let queryKey: string = this.paramBundleName + this.paramModuleName + this.paramAbilityName;
      let supportModes =
        await SceneSessionAdapter.getAbilityWindowSupportInfo(queryKey, this.paramBundleName, this.paramAbilityName);
      let supportFloating = supportModes?.indexOf(BundleManager.SupportWindowMode.FLOATING) > -1;
      this.canOpenFloatingWindow = supportFloating && !this.isExcludeForFloating(entry);
      log.showInfo(`canOpenFloatingWindow: ${this.canOpenFloatingWindow} supportFloating: ${supportFloating}`);
      this.updateForegroundStatus(isMidScene);
    }
  }

  public async canOpenFloatingAsync(isSwipe: boolean, isImmersive?: boolean): Promise<boolean> {
    if (isSwipe || isImmersive) {
      return await this.isSupportFloatingAsync();
    }
    let deviceSupport = false;
    try {
      deviceSupport = (await ScreenSessionAdapter.isFoldablePhoneExpandStatus() || DeviceHelper.isPad());
    } catch (exception) {
      log.error('get display fold status failed');
    }
    return await this.isSupportFloatingAsync() && deviceSupport;
  }

  /**
   * @deprecated
   */
  public canOpenFloating(isSwipe: boolean, isImmersive?: boolean): boolean {
    if (isSwipe || isImmersive) {
      return this.isSupportFloating();
    }
    let deviceSupport = false;
    return this.isSupportFloating() && deviceSupport;
  }

  public startFloatingWindowForClick(): void {
    this.startFloatingWindow(FloatingDisplayMode.FLOATING_RIGHT);
  }

  public startFloatingWindowForSwipe(): void {
    this.startFloatingWindow(FloatingDisplayMode.FLOATING_CENTER);
  }

  public async isSupportFloatingAsync(isMidScene?: boolean): Promise<boolean> {
    if (AccessibilityManager.getInstance().getIsAccessibilityMode()) {
      return false;
    }
    if (!ntfViewConfigManager.getListContentConfig().isSupportFloating) {
      return false;
    }
    if (isMidScene) {
      return false;
    }
    if (!this.isAppForeground) {
      return this.canOpenFloatingWindow;
    } else {
      let isMinimized = await SceneSessionAdapter.getMinimizedBundleIndex(this.paramBundleName) != -1;
      return this.canOpenFloatingWindow && isMinimized;
    }
  }

  /**
   * @deprecated
   */
  public isSupportFloating(): boolean {
    if (AccessibilityManager.getInstance().getIsAccessibilityMode()) {
      return false;
    }
    if (!ntfViewConfigManager.getListContentConfig().isSupportFloating) {
      return false;
    }
    if (!this.isAppForeground) {
      return this.canOpenFloatingWindow;
    } else {
      let isMinimized = SCBSceneSessionManager.getInstance().getFloatingSessionList().findIndex((floatingSession) =>
      floatingSession?.mainSession.sceneInfo.bundleName === this.paramBundleName &&
      floatingSession?.floatingParam.isMinimized) != -1;
      return this.canOpenFloatingWindow && isMinimized;
    }
  }

  /**
   * 通知悬浮窗是否存在业务互斥，如果是则不支持悬浮窗
   * @returns
   */
  private isExcludeForFloating(entry: NotificationEntry | NotificationBase): boolean {
    const exclusive = ExclusiveChecker.check(entry.creatorBundleName, 'FLOATING', false);
    return exclusive.result;
  }

  private updateForegroundStatus(isMidScene: boolean): void {
    const callerBundle = this.ntfEntry?.creatorBundleName ?? '';
    const callerIndex = this.ntfEntry?.appIndex ?? 0;
    this.isAppForeground = NotificationUtil.isTargetAppForeground(callerBundle, callerIndex, this.want);
    log.showWarn(`isTargetAppForeground: ${this.isAppForeground}`);
    this.notifyFloatingCapacityChanged(isMidScene);
  }

  private async startFloatingWindow(displayMode: FloatingDisplayMode): Promise<void> {
    log.showInfo('startFloatingWindow, mode: %{public}d, want not null:%{public}s', displayMode, this.want != null);
    if (this.want) {
      let pushWantInfo = InvokePushAgentParam.getPushWantAgentInfo(this.want);
      InvokePushAgentParam.removePushWantAgentForInvokeThdApp(this.want);
      try {
        await WantAgentUtil.triggerAsync(this.wantAgent, {
          code: 0,
          extraInfos: {
            'floatingDisplayMode': displayMode,
            'ohos.params.launchReasonMessage': SystemuiConstants.NC_LAUNCH_REASON_MESSAGE,
          },
          startOptions: { windowMode: SCBSceneMode.FLOATING },
        });
        InvokePushAgentParam.startPushAgent(new InvokePushAgentParam(pushWantInfo, SystemuiConstants.INVOKE_APP_SUCCESS,
          SystemuiConstants.INVOKE_APP_SUCCESS, ''));
        log.showInfo('start wantAgent to floating window end');
      } catch (err) {
        InvokePushAgentParam.startPushAgent(new InvokePushAgentParam(pushWantInfo, SystemuiConstants.INVOKE_APP_FAIL,
          ClickNotificationErrorCode.TRIGGER_WANTAGENT_FAIL, 'startFloatingWindow trigger error: ' + err));
        log.error('start wantAgent to floating window err:', err);
      }
      this.wantAgent = null;
    }
  }
}

/**
 * swipe处理结果回调
 */
export interface SwipeCallback {
  /**
   * 更新通知条目竖向移动距离
   *
   * @param tranY 移动距离
   */
  onUpdateItemTranY(tranY: number): void;

  /**
   * 更新通知条目隐藏事件
   */
  onHideBanner(): void;

  /**
   * 更新通知条目竖向移动动画
   *
   * @param itemAnim 动画
   */
  onUpdateItemVerticalAnim(itemAnim: AnimateParam): void;
}

/**
 * 悬浮窗能力监听
 */
export interface FloatingCapacityUpdateListener {
  /**
   * 悬浮窗能力改变
   *
   * @param isSupportFloating 悬浮窗能力
   */
  onFloatingCapacityChanged(isSupportFloating: boolean): void;
}