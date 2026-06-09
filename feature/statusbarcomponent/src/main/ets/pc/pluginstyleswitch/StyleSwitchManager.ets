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
import { StatusBarType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { Constants } from '../common/Constants';
import { settings } from '@kit.BasicServicesKit';
import type ctx from '@ohos.app.ability.common';
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlobalContext, SettingsUtil } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { StyleSwitchControlBase } from './StyleSwitchControlBase';
import { WinStyleSwitchControl } from './WinStyleSwitchControl';
import { PluginDisplayStyle } from '../common/PluginConstants';
import { PluginStyleUtil } from '../common/PluginStyleUtil';

const TAG = 'StyleSwitchManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const DEFAULT_INIT_TIMES = 6;
const WAIT_INTERVAL = 200;
const sleep = (delay: number): Promise<number> => new Promise((resolve) => setTimeout(resolve, delay));

export class StyleSwitchManager {
  private static mInstance: StyleSwitchManager;

  /**
   * 数据变化监听器集
   */
  private dataListeners: Array<PluginStyleChangeListener> = [];

  private styleSwitchControlMap: Map<PluginDisplayStyle, StyleSwitchControlBase> = new Map()
    .set(PluginDisplayStyle.WINDOWS_STYLE, new WinStyleSwitchControl());

  /**
   * 是否成功注册observer
   */
  private isRegisterObserver: boolean = false;

  public static getInstance(): StyleSwitchManager {
    if (!StyleSwitchManager.mInstance) {
      StyleSwitchManager.mInstance = new StyleSwitchManager();
    }
    return StyleSwitchManager.mInstance;
  }

  public init(): void {
    let statusBarType = this.readStatusBarType();
    PluginStyleUtil.setCurStatusBarType(statusBarType);
    this.notifyStyleChange(statusBarType, PluginDisplayStyle.INVALID);
    this.registerSettingsKeyObserver();
  }

  public deInit(): void {
    settings.unregisterKeyObserver(GlobalContext.getContext(), Constants.SETTINGS_KEY,
      settings.domainName.USER_SECURITY);
  }

  /**
   * 注册数据变化监听
   *
   * @param listener 监听器
   */
  registerDataChangeListener(listener: PluginStyleChangeListener): void {
    ArrayUtils.updateArr(this.dataListeners, listener);
    listener.notifyPluginStyleChange(PluginStyleUtil.getCurStatusBarType(), PluginDisplayStyle.INVALID);
  }

  /**
   * 注销数据变化监听
   *
   * @param listener 监听器
   */
  unregisterDataChangeListener(listener: PluginStyleChangeListener): void {
    ArrayUtils.deleteArr(this.dataListeners, listener);
  }

  /**
   * 状态栏风格切换回调
   *
   * @param statusBarType 状态栏类型
   */
  private onStatusBarTypeChange = async (statusBarType: PluginDisplayStyle) => {
    let lastStatusBarType = PluginStyleUtil.getCurStatusBarType();
    if (lastStatusBarType === statusBarType) {
      log.showInfo('statusBarType not change, no need switch, current style:' + statusBarType.toString());
      return;
    }
    await this.styleSwitchControlMap.get(lastStatusBarType)?.requestStyleExit();
    PluginStyleUtil.setCurStatusBarType(statusBarType);
    this.notifyStyleChange(statusBarType, lastStatusBarType);
    await this.styleSwitchControlMap.get(statusBarType)?.requestStyleEnter();
  }

  private notifyStyleChange(newStyle: PluginDisplayStyle, oldStyle: PluginDisplayStyle): void {
    this.dataListeners.forEach(listener => listener.notifyPluginStyleChange(newStyle, oldStyle));
  }

  private async registerSettingsKeyObserver(): Promise<void> {
    for (let i = 0; i < DEFAULT_INIT_TIMES && !this.isRegisterObserver; i++) {
      try {
        await sleep(WAIT_INTERVAL);
        settings.unregisterKeyObserver(GlobalContext.getContext(), Constants.SETTINGS_KEY,
          settings.domainName.USER_SECURITY);
        let result = settings.registerKeyObserver(GlobalContext.getContext(),
          Constants.SETTINGS_KEY, settings.domainName.USER_SECURITY,
          () => {
            let statusBarType = this.readStatusBarType();
            log.showInfo(`switch statusBarType:${statusBarType}`);
            this.onStatusBarTypeChange(statusBarType);
            let statusBarTypeValue: number = PluginStyleUtil.getStatusBarTypeValue(statusBarType);
            this.getContext()?.eventHub.emit('WindowStyleChange', statusBarTypeValue);
          });
        log.showDebug('registerSettingsKeyObserver result ' + result);
        if (result) {
          this.isRegisterObserver = true;
        }
      } catch (err) {
        log.showError('registerKeyObserver err:' + err);
      }
    }
  }

  private getContext(): ctx.ServiceExtensionContext {
    return GlobalContext.getContext();
  }

  /**
   * 读取settings里的状态栏类型信息
   *
   * @returns 状态栏类型
   */
  private readStatusBarType(): PluginDisplayStyle {
    let statusBarTypeStr = SettingsUtil.getSecureValue(Constants.SETTINGS_KEY);
    let statusBarType = Number(statusBarTypeStr);
    statusBarType = StatusBarType.isWindowStyle(statusBarType) ? PluginDisplayStyle
      .WINDOWS_STYLE : PluginDisplayStyle.MAC_STYLE
    log.showInfo('readStatusBarType statusBarType: ' + statusBarType);
    return statusBarType;
  }
}

/**
 * 通知注冊方风格切换
 */
export interface PluginStyleChangeListener {
  notifyPluginStyleChange(newStyle: PluginDisplayStyle, oldStyle: PluginDisplayStyle): void;
}