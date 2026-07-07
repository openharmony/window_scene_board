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
import rpc from '@ohos.rpc';
import { LogDomain, Logger } from '@ohos/basicutils';
import { GlobalContext, SCBDesktopCacheManager } from '@ohos/frameworkwrapper';
import { FloatingNavigationManager } from './FloatingNavigationManager';
import { AiBarRegisterFunc, IdlCode, SCBAiBarProxyManager } from './SCBAiBarProxyManager';
import { systemParameter } from '@kit.BasicServicesKit';
import bundleManager from '@ohos.bundle.bundleManager';
import { VoiceConstant } from '@ohos/voiceagent';
import { launcherStatusUtil, SCBScreenSessionManager } from '@ohos/windowscene';
import { AiBarVisualEffectManager } from '@ohos/componenthelper/src/main/ets/manager/AiBarVisualEffectManager';

const TAG = 'SCBAiBarCallBack';
const log: Logger = Logger.getLogHelper(LogDomain.GESTURE);

export class SCBAiBarCallBack extends rpc.RemoteObject {
  constructor(str: string) {
    super(str);
  }

  async onRemoteMessageRequest(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence,
    options: rpc.MessageOption): Promise<boolean> {
    log.showInfo(TAG, 'onRemoteMessageRequest');
    if (!data) {
      log.showError(TAG, 'data is null');
      return false;
    }
    try {
      const bundleName = await bundleManager.getBundleNameByUid(this.getCallingUid());
      const applicationInfo = bundleManager.getApplicationInfoSync(bundleName,
        bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT);
      if (bundleName !== VoiceConstant.BUNDLE_NAME && applicationInfo?.systemApp) {
        log.showError(TAG, 'bundleName is invalid');
        return false;
      }
    } catch (error) {
      log.showError(TAG, 'getBundleNameByUid is error');
      return false;
    }
    let proxyManager = SCBAiBarProxyManager.getInstance();
    if (code === IdlCode.RECEIVE_AIBAR_HIDE) {
      log.showInfo(TAG, 'callBack success RECEIVE_AIBAR_HIDE');
      const isFullEffect = AiBarVisualEffectManager.getInstance().isFullEffect();
      const isInOutLauncher: boolean = launcherStatusUtil.getShowOutLauncherStatus();
      if (!isFullEffect || isInOutLauncher) {
        // 隐藏回缩一起
        if (!FloatingNavigationManager.getInstance().getFloatingBallStatus()) {
          FloatingNavigationManager.getInstance().setIsHiddenScene(true);
          FloatingNavigationManager.getInstance().setFloatingNavStatus(false, false);
        }
        proxyManager.executeCallbackByType(AiBarRegisterFunc.AIBAR_HIDE_FUNC);
        proxyManager.executeCallbackByType(AiBarRegisterFunc.AIBAR_EXIT_FUNC);
      }
    }
    if (code === IdlCode.RECEIVE_AIBAR_SHOW) {
      log.showInfo(TAG, 'callBack success RECEIVE_AIBAR_SHOW');
      FloatingNavigationManager.getInstance().setIsHiddenScene(false);
      FloatingNavigationManager.getInstance().setShowVerifyImmersiveState();
      proxyManager.executeCallbackByType(AiBarRegisterFunc.AIBAR_SHOW_FUNC);
    }
    return true;
  }
}