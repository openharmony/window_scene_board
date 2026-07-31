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
import type ctx from '@ohos.app.ability.common';
import { UIExtensionContentSession, Want } from '@kit.AbilityKit';
import { uiExtensionHost, window } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';

const TAG: string = 'NotificationManangerContextManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class ContextManager {
  private static contextStack: ctx.UIExtensionContext[] = [];
  public static context: ctx.Context;
  public static want: Want;
  public static session?: UIExtensionContentSession;
  public static naviBarHeightByVp: number = 0;
  public static windowWidthByVp: number = 0;
  public static windowHeightByVp: number = 0;
  public static ntfAndStatusBarTopPadding: number = 0;

  static setContext(context: ctx.UIExtensionContext): void {
    ContextManager.context = context;
    ContextManager.contextStack.unshift(context);
  }

  static getContext(): ctx.Context {
    return ContextManager.context;
  }

  static removeContext(context: ctx.UIExtensionContext): void {
    ContextManager.contextStack = ContextManager.contextStack.filter((c) => c !== context);
    ContextManager.context = ContextManager.contextStack[0];
  }

  static getTopContext(): ctx.UIExtensionContext {
    return ContextManager.contextStack[0];
  }

  static loadWindow(): uiExtensionHost.UIExtensionHostWindowProxy | undefined {
    try {
      const windowProxy = ContextManager.session?.getUIExtensionHostWindowProxy();
      if (!windowProxy) {
        log.showWarn('InitContextManager error by null windowProxy');
        return;
      }
      // 通过代理窗口获取NAVIBar的高度
      const avoidArea = windowProxy.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      ContextManager.naviBarHeightByVp = ArkUIAdapter.px2vp(avoidArea?.bottomRect?.height ?? 0);

      const windowProxyRect = windowProxy.properties?.uiExtensionHostWindowProxyRect;
      if (windowProxyRect) {
        ContextManager.windowWidthByVp = ArkUIAdapter.px2vp(windowProxyRect.width);
        ContextManager.windowHeightByVp = ArkUIAdapter.px2vp(windowProxyRect.height);
      } else {
        log.showWarn('WindowProxyRect is undefined');
      }
      return windowProxy;
    } catch (err) {
      log.showError(`getWindowAvoidArea error: ${err}`);
      return;
    }
  }
}