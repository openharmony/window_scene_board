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

import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import {
  LogDomain,
  LogHelper,
  PinTopLimitDialogVmManager,
  EvtBus
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import sSettingsUtil from '@ohos/managementcomponent/src/main/ets/com/ohos/common/SettingsUtil';
import { DeviceHelper } from '@ohos/managementcomponent';
import Want from '@ohos.app.ability.Want';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';
import type {
  KeyValPair,
  PageContext,
  PushParam,
  SessionMarginValue
} from '@ohos/managementcomponent/src/main/ets/com/ohos/model/SystemUISettingSession';
import window from '@ohos.window';
import uiExtensionHost from '@ohos.uiExtensionHost';
import { BusinessError } from '@ohos.base';
import { AccessibilityManager } from '../common/AccessibilityManager';
import { PageStorages } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/PageStorages';
import { PageConstants } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import { JSON } from '@kit.ArkTS';
import { StatusBarModel } from '../model/StatusBarModel';
import { Configuration } from '@ohos.app.ability.Configuration';
import { fontScaleManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/fontScaleManager';
import { NotificationMgmtPinTopLimitDialogVm } from '../vm/NotificationMgmtPinTopLimitDialogVm';
import NtfConfigUtil from '../config/NtfConfigUtil';
import lazy BundleResourceModel from '@ohos/managementcomponent/src/main/ets/com/ohos/model/bundleResourceModel';
import { EnterpriseConfig } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicUiCommon';
import { ColorModeEvent } from '../common/Events';
import lazy { initLazyModules } from '../common/LazyModuleLoader';
import Constants from '../common/constants';

const TAG: string = 'NotificationUIExtAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const TITLE_BAR_MARGIN_CHANGE: string = 'eventTitleBarMarginChange';

export default class NotificationUIExtAbility extends UIExtensionAbility {
  onCreate(): void {
    log.showInfo('onCreate');
    globalThis.mContext = this.context;
    ContextManager.setContext(this.context);
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
    ContextManager.removeContext(this.context);
    AccessibilityManager.getInstance()?.unRegisterAccessibilityModeListener();
    this.unregisterAvoidAreaChange();
  }

  onForeground(): void {
    log.showInfo('onForeground');
  }

  onBackground(): void {
    log.showInfo('onBackground');
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession) {
    log.showInfo(`start onSessionCreate`);
    this.initAppStorage(session);
    this.initContextManager(session);
    this.registerAvoidAreaChange();
    const param = new LaunchParam(want, session);
    AppStorage.setOrCreate<number>('navigationMode', param.navMode);

    if (param.isLaunchHomePage()) {
      this.loadNtfAndStatusBarPage(session);
    } else if (param.isLaunchByExternal()) {
      this.loadSubPageByHome(param);
    } else {
      // 设置内其他界面进入
      this.loadSubPageDirectly(param);
    }
  }

  onConfigurationUpdate(newConfig: Configuration): void {
    if (newConfig.colorMode !== undefined) {
      const configEvent: ColorModeEvent = new ColorModeEvent();
      log.showInfo(`switch color mode is  ${newConfig?.colorMode}`);
      configEvent.colorMode = newConfig.colorMode;
      EvtBus.post(ColorModeEvent, configEvent);
    }

    if (newConfig.fontSizeScale) {
      fontScaleManager.setSysFontScale(newConfig.fontSizeScale);
    }
  }

  private loadNtfAndStatusBarPage(session: UIExtensionContentSession): void {
    log.showInfo('LoadNtfAndStatusBarPage.');
    this.loadContentByNtfAndStatusBar(session);
  }

  private loadContentByNtfAndStatusBar(session: UIExtensionContentSession, param?: LocalStorage): void {
    if (DeviceHelper.isPC()) {
      const localStorage = param ?? PageStorages.wrapPageCtxStorage({ session });
      session.loadContent(PageConstants.NTF_AND_STATUS_BAR_PC_PATH, localStorage);
    } else {
      const localStorage = param ?? PageStorages.wrapPageCtxStorage({
        session,
        isFromHome: true,
        isLaunch2SubPage: false,
        mainPageName: PageConstants.NTF_AND_STATUS_BAR_NAME
      });
      session.loadContent(PageConstants.HOME_NAVIGATION_VIEW_PATH, localStorage);
    }
  }

  /**
   * 通过首页跳转到子页面，实现逐级返回
   * @param param
   * @returns
   */
  private async loadSubPageByHome(param: LaunchParam): Promise<void> {
    const localStorage = PageStorages.wrapPageCtxStorage({
      session: param.session,
      isFromHome: true,
      bundleInfo: param.bundleName ? await this.getBundleInfo(param) : undefined,
      appIndex: param.appIndex,
      isLaunch2SubPage: true,
      subPageName: param.subPageName,
      isMetaService: param.isMetaService,
    })
    this.loadContentByNtfAndStatusBar(param.session, localStorage);
  }

  /**
   * 直接加载子页面，一步返回
   * @param param
   * @returns
   */
  private async loadSubPageDirectly(param: LaunchParam): Promise<void> {
    initLazyModules();

    const pageContext: PageContext = {
      session: param.session,
      isFromHome: false,
      isLaunch2SubPage: true,
      subPageName: this.getMobileDeviceSubPageName(param),
      isMetaService: param.isMetaService,
    };

    if (param.bundleName) {
      pageContext.bundleInfo = await this.getBundleInfo(param);
      pageContext.appIndex = param.appIndex;
    }

    const localStorage: LocalStorage = PageStorages.wrapPageCtxStorage(pageContext);
    if (DeviceHelper.isPC()) {
      param.session.loadContent(this.getSubPagePath(param), localStorage);
    } else {
      param.session.loadContent(PageConstants.HOME_NAVIGATION_VIEW_PATH, localStorage);
    }
  }

  private async getBundleInfo(param: LaunchParam): Promise<KeyValPair> {
    return await new BundleResourceModel().getBundleInfoAsync(param);
  }

  private getSubPagePath(param: LaunchParam): string {
    if (param.isMetaService) {
      return PageConstants.META_SERVICE_MGMT_VIEW_PATH;
    } else if (param.bundleName) {
      return PageConstants.NTF_MGMT_VIEW_PATH;
    } else if (param.subPageName === PageConstants.NTF_MORE_SETTING_NAME) {
      return PageConstants.NTF_MORE_SETTING_PATH;
    } else if (param.subPageName === PageConstants.STATUS_BAR_SETTING_NAME) {
      return PageConstants.STATUS_BAR_SETTING_PATH;
    } else if (param.subPageName === PageConstants.NTF_LIVE_VIEW_SWITCH_PAGE_NAME) {
      return PageConstants.NTF_LIVE_VIEW_SWITCH_PAGE_PATH;
    } else {
      return '';
    }
  }

  private getMobileDeviceSubPageName(param: LaunchParam): string {
    if (param.isMetaService) {
      return PageConstants.META_SERVICE_MGMT_VIEW_NAME;
    } else if (param.bundleName) {
      return PageConstants.NTF_MGMT_VIEW_NAME;
    } else {
      return param.subPageName ?? '';
    }
  }

  private initAppStorage(session: UIExtensionContentSession) {
    // 从设置获取navMode
    session.setReceiveDataCallback((data: Record<string, Object>) => {
      this.onReceiveNavigationModeCallback(data);
      this.parseTitleAvoidData(data);
      this.onReceiveTitleAnimationDurationChanged(data);
    });
  }

  private onReceiveNavigationModeCallback(data: Record<string, Object>) {
    let navigationMode = data['navigationMode'] as number;
    log.showInfo(`navigationMode from setting changed: ${navigationMode}`);
    if (navigationMode !== undefined) {
      AppStorage.setOrCreate<number>('navigationMode', navigationMode);
    }
  }

  private onReceiveTitleAnimationDurationChanged(data: Record<string, Object>): void {
    const duration = data['titleAnimationDuration'];
    if (typeof duration === 'number') {
      log.showInfo('onReceiveTitleAnimationDurationChanged for %{public}d', duration);
      AppStorage.setOrCreate(Constants.TITLE_ANIMATION_DURATION_KEY, duration);
    } else {
      log.showWarn('titleAnimationDuration is not number: ' + duration);
    }
  }

  /**
   * PC融合标题适配，页面顶部需设置标题避让边距。以免重叠
   * @param data
   */
  private parseTitleAvoidData(data: Record<string, Object>) {
    if (!DeviceHelper.isPC()) {
      return;
    }

    let eventType: string = data['eventType'] as string;
    let marginValue: SessionMarginValue = data['value'] as SessionMarginValue;
    let titleBarMargin: number = marginValue?.end?.value ?? 0;
    log.showInfo(`eventTitleBarMargin from setting: ${titleBarMargin}`);
    if (eventType !== undefined && eventType === TITLE_BAR_MARGIN_CHANGE && marginValue !== undefined &&
      titleBarMargin !== undefined) {
      AppStorage.setOrCreate<number>('titleBarMargin', titleBarMargin);
      log.showInfo(`updateSearchBarMargin success! titleBarAvoid: ${titleBarMargin}`);
    } else {
      log.showError(`updateSearchBarMargin failed! eventType: ${eventType}, titleBarAvoid: ${titleBarMargin}`);
    }
  }

  private windowProxy?: uiExtensionHost.UIExtensionHostWindowProxy;

  private initContextManager(session: UIExtensionContentSession) {
    const windowProxy: uiExtensionHost.UIExtensionHostWindowProxy | undefined = this.getWindowProxy(session);
    if (!windowProxy) {
      log.showWarn('InitContextManager error by null windowProxy');
      return;
    }

    const aiBarAvoidArea = windowProxy.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
    ContextManager.aiBarHeightByVp = px2vp(aiBarAvoidArea?.bottomRect?.height ?? 0);

    const windowProxyRect = windowProxy.properties?.uiExtensionHostWindowProxyRect;
    if (windowProxyRect) {
      ContextManager.windowWidthByVp = px2vp(windowProxyRect.width);
      ContextManager.windowHeightByVp = px2vp(windowProxyRect.height);
    } else {
      log.showWarn('WindowProxyRect is undefined');
    }
    if (DeviceHelper.isPC()) {
      ContextManager.ntfAndStatusBarTopPadding = 5;
      return;
    }
    let statusBarAvoidArea: window.AvoidArea = windowProxy.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
    StatusBarModel.get().height = px2vp(statusBarAvoidArea?.topRect?.height ?? 0);
    this.windowProxy = windowProxy;
  }

  private registerAvoidAreaChange() {
    try {
      // 监听状态栏变化，重新设置状态栏高度，PAD适配自由多窗
      this.windowProxy?.on('avoidAreaChange', (data) => {
        if (data?.type === window.AvoidAreaType.TYPE_SYSTEM) {
          let newStatusBarHeight = px2vp(data.area?.topRect?.height ?? 0);
          if (StatusBarModel.get().height === newStatusBarHeight) {
            return;
          }
          StatusBarModel.get().height = newStatusBarHeight;
          log.showInfo(`refresh status bar height: ${StatusBarModel.get().height}`);
        }
      });
    } catch (e) {
      log.showError('registerAvoidAreaChange error: %{public}s', e);
    }
  }

  private unregisterAvoidAreaChange() {
    try {
      this.windowProxy?.off('avoidAreaChange');
    } catch (e) {
      log.showError('unregisterAvoidAreaChange error: %{public}s', e);
    }
  }

  private getWindowProxy(session: UIExtensionContentSession): uiExtensionHost.UIExtensionHostWindowProxy | undefined {
    try {
      const proxy = session.getUIExtensionHostWindowProxy();
      if (proxy) {
        return proxy;
      } else {
        log.showWarn('GetWindowProxy is undefined');
        return undefined;
      }
    } catch (err) {
      log.showError('GetWindowProxyError. %{public}d', (err as BusinessError)?.code);
      return undefined;
    }
  }
};

class LaunchParam {
  public session: UIExtensionContentSession;
  public originParameter: Record<string, Object>;
  public pushParam: PushParam;
  public isFromNc: boolean;
  public navMode: number;
  public appIndex: number = 0;
  public bundleName?: string;
  public subPageName?: string;
  public startReason?: string;
  public uid?: number;
  public isMetaService?: boolean = false;

  constructor(want: Want, session: UIExtensionContentSession) {
    this.session = session;
    this.originParameter = want.parameters ?? {};
    this.pushParam = this.parsePushParam();
    this.isFromNc = this.pushParam.config?.isFromNc ?? false;
    this.appIndex = this.pushParam.config?.appIndex ?? this.pushParam.appIndex ?? 0;
    this.bundleName = this.pushParam.config?.bundleName ?? this.pushParam.bundleName;
    this.uid = this.pushParam.config?.uid;
    this.isMetaService = this.pushParam.config?.isMetaService;
    this.startReason = this.originParameter['startReason'] as string;
    this.subPageName = this.parseSubPageName();
    this.navMode = this.originParameter['navigationMode'] as number ?? -1;
    this.logInfo();
  }

  private parsePushParam(): PushParam {
    const originPushParams = this.originParameter.pushParams;
    if (originPushParams && typeof originPushParams === 'string') {
      return {};
    } else {
      return originPushParams as PushParam ?? {};
    }
  }

  private parseSubPageName(): string | undefined {
    const originPushParams = this.originParameter.pushParams;
    if (originPushParams && typeof originPushParams === 'string') {
      return originPushParams as string;
    } else if (this.bundleName) {
      return this.isMetaService ? PageConstants.META_SERVICE_MGMT_VIEW_NAME : PageConstants.NTF_MGMT_VIEW_NAME;
    } else {
      return undefined;
    }
  }

  public logInfo(): void {
    log.showInfo(
      'pushParam: %{public}s, ' +
        'subPageName: %{public}s, ' +
        'isFromNc: %{public}s, ' +
        'startReason: %{public}s, ' +
        'navMode: %{public}d, ' +
        'bundleName: %{public}s, ' +
        'appIndex: %{public}d',
      JSON.stringify(this.pushParam),
      this.subPageName,
      this.isFromNc,
      this.startReason,
      this.navMode,
      this.bundleName,
      this.appIndex
    );
  }

  public isLaunchByExternal(): boolean {
    return this.startReason === 'from_external';
  }

  public isLaunchBySettingSearch(): boolean {
    return this.startReason === 'from_search';
  }

  public isLaunchHomePage(): boolean {
    if (this.bundleName) {
      return false;
    }
    if (PageConstants.isValidSubPage(this.subPageName)) {
      return false;
    } else {
      log.showWarn('SubPageName isInValid %{public}s', this.subPageName);
      return true;
    }
  }
}