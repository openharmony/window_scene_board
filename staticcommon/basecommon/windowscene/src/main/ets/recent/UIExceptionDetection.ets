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

import { CommonUtils, LogDomain, Logger, SingletonHelper } from '@ohos/basicutils';
import { HiSysReportEvent, ReportDomain } from '@ohos/frameworkwrapper';
import {
  UIExceptionParams,
  FollowingAppExceptionParams
} from '@ohos/frameworkwrapper/src/main/ets/hisysevent/ReportParams';

const TAG = 'UIExceptionDetection';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);

export class UIExceptionDetection {
  private static readonly BACKGROUND_BLUR_EXCEPTION = 'BACKGROUND_BLUR_EXCEPTION';
  private static readonly CLEAR_ALL_ICON_EXCEPTION = 'CLEAR_ALL_ICON_EXCEPTION';
  private static readonly FOLLOWING_APP_EXCEPTION = 'FOLLOWING_APP_EXCEPTION';
  private readonly report: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain.SCENE_BOARD_UE);
  private callbacks: Map<UIExceptionType, UIExceptionCallback> = new Map<UIExceptionType, UIExceptionCallback>()
  private followingAppName: string = '';
  private isBlurException: boolean = false;
  private isClearAllIconException: boolean = false;

  public static getInstance(): UIExceptionDetection {
    return SingletonHelper.getInstance(UIExceptionDetection, TAG);
  }

  /**
   * 模糊背景异常检测
   *
   * @param reason 检测场景
   */
  public backgroundBlurExceptionDetection(reason: UIExceptionCaller): void {
    let backgroundBlurCallback: UIExceptionCallback | undefined = this.callbacks.get(UIExceptionType.BACKGROUND_BLUR);
    if (!backgroundBlurCallback) {
      this.isBlurException = false;
      log.showInfo(TAG, 'backgroundBlurCallback is null');
      return;
    }
    this.isBlurException = backgroundBlurCallback.exceptionDetection();
    log.showInfo(TAG, 'backgroundBlur exception detection result:' + this.isBlurException);
    if (this.isBlurException) {
      let param: UIExceptionParams = backgroundBlurCallback.getExceptionParams();
      param.REASON = reason;
      this.report.reportFault(UIExceptionDetection.BACKGROUND_BLUR_EXCEPTION, param);
    }
  }

  /**
   * 修复UI异常
   */
  public restoreUIException(): void {
    if (this.isBlurException) {
      this.callbacks.get(UIExceptionType.BACKGROUND_BLUR)?.exceptionRestore();
      this.isBlurException = false;
    }
    if (this.isClearAllIconException) {
      this.callbacks.get(UIExceptionType.CLEAR_ALL_ICON)?.exceptionRestore();
      this.isClearAllIconException = false;
    }
  }

  /**
   * 垃圾桶图标异常检测
   *
   * @param reason 检测场景
   */
  public clearAllIconExceptionDetection(reason: UIExceptionCaller): void {
    let clearAllIconCallback: UIExceptionCallback | undefined = this.callbacks.get(UIExceptionType.CLEAR_ALL_ICON);
    if (!clearAllIconCallback) {
      this.isClearAllIconException = false;
      log.showInfo(TAG, 'clearAllIconCallback is null');
      return;
    }
    this.isClearAllIconException = clearAllIconCallback.exceptionDetection();
    log.showInfo(TAG, 'clearAllIcon exception detection result:' + this.isClearAllIconException);
    if (this.isClearAllIconException) {
      let param: UIExceptionParams = clearAllIconCallback.getExceptionParams();
      param.REASON = reason;
      this.report.reportFault(UIExceptionDetection.CLEAR_ALL_ICON_EXCEPTION, param);
    }
  }

  /**
   * 注册回调
   *
   * @param exceptionType 异常类型
   * @param callback 检测回调
   */
  public registerUIExceptionCallback(exceptionType: UIExceptionType, callback: UIExceptionCallback): void {
    if (this.callbacks.has(exceptionType)) {
      log.showWarn(TAG, `this type ${exceptionType} callback exists`);
      return;
    }
    this.callbacks.set(exceptionType, callback);
  }

  /**
   * 取消注册回调
   *
   * @param exceptionType 异常类型
   */
  public unRegisterUIExceptionCallback(exceptionType: UIExceptionType): void {
    this.callbacks.delete(exceptionType);
  }

  /**
   * 设置跟手应用的名称，用以后面检测是否发生了变化
   *
   * @param appName 跟手的应用名称
   */
  public setFollowingAppName(appName: string): void {
    if (this.followingAppName === appName) {
      return;
    }
    this.followingAppName = appName;
  }

  /**
   * 跟手应用异常检测
   *
   * @param appName 当前跟手的应用名称
   * @param reason 检测场景
   */
  public followingAppExceptionDetection(appName: string, reason: string): void {
    if (CommonUtils.isEmpty(this.followingAppName)) {
      return;
    }
    let isError = this.followingAppName !== appName;
    if (isError) {
      let param: FollowingAppExceptionParams = {
        ORIGINAL_NAME: this.followingAppName,
        NEW_NAME: appName,
        REASON: reason
      };
      this.report.reportFault(UIExceptionDetection.FOLLOWING_APP_EXCEPTION, param);
    }
    this.followingAppName = '';
  }
}

export interface UIExceptionCallback {
  exceptionDetection: () => boolean;
  exceptionRestore: () => void;
  getExceptionParams: () => UIExceptionParams;
}

export enum UIExceptionType {
  BACKGROUND_BLUR = 0,
  CLEAR_ALL_ICON = 1,
  FOLLOWING_APP = 2
}

export enum UIExceptionCaller {
  RECENT_EXIT_TO_HOME = 'recentExitToHome',
  APP_EXIT_TO_HOME = 'appExitToHome',
  APP_DESTROY_TO_HOME = 'appDestroyToHome',
  UNLOCK_TO_HOME = 'unlockToHome'
}