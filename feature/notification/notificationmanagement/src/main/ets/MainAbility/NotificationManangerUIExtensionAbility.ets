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
import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { Configuration } from '@ohos.app.ability.Configuration';
import { LogDomain, LogHelper,
  PinTopLimitDialogVmManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import Want from '@ohos.app.ability.Want';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';
import window from '@ohos.window';
import { DeviceHelper, fontScaleManager } from '@ohos/managementcomponent';
import { BusinessError, systemParameter } from '@kit.BasicServicesKit';
import { ExtensionResult } from '../common/NotificationMgmtCommon';
import {
  NtfSettingSysEventReporter
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingSysEventReporter';
import {
  notificationSettingManager
} from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/NotificationSettingManager';
import { NotificationConfigEntity } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { AccessibilityManager } from '../common/AccessibilityManager';
import { PageStorages } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/PageStorages';
import { PageConstants } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { uiExtensionHost } from '@kit.ArkUI';
import { SheetModel } from '../model/SheetModel';
import sSettingsUtil from '@ohos/managementcomponent/src/main/ets/com/ohos/common/SettingsUtil';
import { NotificationMgmtPinTopLimitDialogVm } from '../vm/NotificationMgmtPinTopLimitDialogVm';
import NtfConfigUtil from '../config/NtfConfigUtil';
import { StatusBarModel } from '../model/StatusBarModel';
import { EnterpriseConfig } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicUiCommon';
import { KeyValPair } from '@ohos/managementcomponent/src/main/ets/com/ohos/model/SystemUISettingSession';

const TAG: string = 'NotificationManangerUIExtensionAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export default class NotificationManangerUIExtensionAbility extends UIExtensionAbility {
  private windowProxy?: uiExtensionHost.UIExtensionHostWindowProxy;

  onCreate(): void {
    log.showInfo('onCreate');
    this.initSetFontScale();
    globalThis.mContext = this.context;
    ContextManager.setContext(this.context);
    notificationSettingManager.init();
    AccessibilityManager.init(this.context);
    sSettingsUtil.initContext(this.context);
    EnterpriseConfig.loadConfig(this.context);
    if (DeviceHelper.isPC()) {
      NtfConfigUtil.initPcConfig();
    }
    // 置顶弹框初始化
    PinTopLimitDialogVmManager.setVm(new NotificationMgmtPinTopLimitDialogVm());
  }

  onDestroy(): void {
    log.showInfo('onDestroy');
    AccessibilityManager.getInstance()?.unRegisterAccessibilityModeListener();
    this.unregisterWindowSizeChange();
  }

  onForeground(): void {
    log.showInfo('onForeground');
  }

  onBackground(): void {
    log.showInfo('onBackground');
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    if (newConfig.fontSizeScale) {
      fontScaleManager.setSysFontScale(newConfig.fontSizeScale);
    }
  }

  /**
   * 隐藏非安全窗口
   * @param session UIExtensionContentSession
   * @param flag boolean
   */
  private setHideNonSecureWindows(session: UIExtensionContentSession, flag: boolean): void {
    log.showInfo(`setHideNonSecureWindows flag: ${flag}`);
    try {
      const extensionHostWindow = session.getUIExtensionHostWindowProxy();
      extensionHostWindow.hideNonSecureWindows(flag);
    } catch (err) {
      const code = (err as BusinessError).code;
      const message = (err as BusinessError).message;
      log.showError(`setHideNonSecureWindows failed code: ${code}, message: ${message} `);
    }
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession) {
    log.showInfo(`start onSessionCreate`);

    const bundleName: string = want.parameters ? want.parameters['ohos.aafwk.param.callerBundleName'] as string : '';
    const uid: number = want.parameters ? want.parameters['ohos.aafwk.param.callerUid'] as number : -1;

    if (!bundleName || uid === -1) {
      log.showError('bundleName is [%{public}s], uid is [%{public}d]', bundleName, uid);
      this.reportPullUpOperate(bundleName, 0);
      session.terminateSelfWithResult( {resultCode: ExtensionResult.PARAM_ERROR} );
      return;
    }
    // 初始化ContextManager值
    this.initContextManager(session);
    notificationSettingManager.getAppItem(uid, bundleName).then((ntfConfig: NotificationConfigEntity | undefined) => {
      if (!ntfConfig) {
        log.showWarn('Entry is none for %{public}d', uid);
        this.reportPullUpOperate(bundleName, 0);
        session.terminateSelfWithResult({ resultCode: ExtensionResult.GET_BUNDLE_INFO_ERROR });
        return;
      }
      let bundleInfo: KeyValPair = {};
      bundleInfo.appTitle = ntfConfig.label;
      bundleInfo.appVersion = ntfConfig.versionName;
      bundleInfo.appBundleName = ntfConfig.bundle;
      bundleInfo.appUid = ntfConfig.uid;
      bundleInfo.systemApp = ntfConfig.systemApp;
      bundleInfo.appIcon = ntfConfig.icon;
      bundleInfo.appIndex = ntfConfig.appIndex;
      session.loadContent(PageConstants.NTF_MGMT_HALF_PATH, PageStorages.wrapPageCtxStorage({
        session, isFromHome: false,
        bundleInfo: bundleInfo
      }));
      session.setWindowBackgroundColor('#00ffffff'); // 设置窗口透明色
      this.setHideNonSecureWindows(session, true);
      this.reportPullUpOperate(bundleName, 1);
    });
    this.registerWindowSizeChange();
  }

  onSessionDestroy(session: UIExtensionContentSession): void {
    this.setHideNonSecureWindows(session, false);
  }

  private initContextManager(session: UIExtensionContentSession) {
    try {
      ContextManager.session = session;
      this.windowProxy = ContextManager.loadWindow();
      if (!this.windowProxy) {
        return;
      }
      const statusBarAvoidArea: window.AvoidArea =
        this.windowProxy.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      StatusBarModel.get().height = px2vp(statusBarAvoidArea?.topRect?.height ?? 0);
    } catch (err) {
      log.showError('getWindowAvoidArea error: [%{public}s], [%{public}s]', err.name, err.message);
    }
  }

  private initSetFontScale(): void {
    try {
      const PERSIST_SYS_FONT_SIZE_SCALE: string = 'persist.sys.font_scale_for_user0';
      const systemFontScale = systemParameter.getSync(PERSIST_SYS_FONT_SIZE_SCALE, '1');
      fontScaleManager.setSysFontScale(Number(systemFontScale) || 1);
      log.showInfo(`systemFontScale: ${systemFontScale}`);
    } catch (err) {
      log.showError('systemParameter error: [%{public}s], [%{public}s]', err.name, err.message);
    }
  }

  private async reportPullUpOperate(bundleName: string, isSuccess: number): Promise<void> {
    try {
      NtfSettingSysEventReporter.notificationPullUpHalfMode({
        FROM_APP: bundleName,
        IS_SUCCESS: isSuccess
      });
    } catch (e) {
      log.showError('reportPullUpOperate Error. bundleName: %{public}s isSuccess: %{public}s',
        bundleName, isSuccess);
    }
  }

  private registerWindowSizeChange() {
    try {
      // 监听窗口变化，重新设置半模态高度
      this.windowProxy?.on('windowSizeChange', (data) => {
        ContextManager.windowWidthByVp = px2vp(data.width);
        ContextManager.windowHeightByVp = px2vp(data.height);
        SheetModel.get().calcHeight();
      });
    } catch (e) {
      log.showError('registerWindowSizeChange error: %{public}s', e);
    }
  }

  private unregisterWindowSizeChange() {
    try {
      this.windowProxy?.off('windowSizeChange');
    } catch (e) {
      log.showError('unregisterWindowSizeChange error: %{public}s', e);
    }
  }
}