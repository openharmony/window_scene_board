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

import systemparameter from '@ohos.systemParameterEnhance';
import settings from '@ohos.settings';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';

const TAG: string = 'EnterpriseSpaceUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class EnterpriseSpaceUtil {
  private static envPass: string = '';
  private static hideAppList: string[] | null = null;
  private static isRegistered: boolean = false;
  private static callbacks: Array<() => void> = [];

  /**
   * 监听vpn下发策略
   * @param callback
   */
  public static onvpnConfigChange(callback: () => void): void {
    log.showInfo(`onvpnConfigChange fire: ${EnterpriseSpaceUtil.isRegistered}, ${EnterpriseSpaceUtil.length}`);
    if (!EnterpriseSpaceUtil.isRegistered) {
      try {
        EnterpriseSpaceUtil.isRegistered = settings.registerKeyObserver(GlobalContext.getContext(), 'hide2BnoNeedApp',
          settings.domainName.USER_PROPERTY, () => {
            log.showInfo(`vpn event listen callback, length: ${EnterpriseSpaceUtil.callbacks.length}`);
            EnterpriseSpaceUtil.updateNeedHiddenAppList();
            EnterpriseSpaceUtil.callbacks.forEach((method) => {
              method?.();
            });
          });
        log.showInfo(`registerHide2BnoNeedAppChangeObserver :${EnterpriseSpaceUtil.isRegistered}`);
      } catch (error) {
        log.showError('registerHide2BnoNeedAppChangeObserver with error %{public}s', error.message);
      }
    }
    if (EnterpriseSpaceUtil.isRegistered) {
      log.showInfo(`callbacks push new observer`);
      EnterpriseSpaceUtil.callbacks.push(callback);
    }
  }

  /**
   * 是否属于需要隐藏的应用中
   * @param bundleName
   * @returns
   */
  public static isAppNeedHidden(bundleName: string): boolean {
    return EnterpriseSpaceUtil.getNeedHiddenAppList().findIndex((item) => item === bundleName) >= 0;
  }

  /**
   * 需要隐藏的应用
   * @returns
   */
  public static getNeedHiddenAppList(): string[] {
    if (EnterpriseSpaceUtil.hideAppList !== null) {
      return EnterpriseSpaceUtil.hideAppList;
    }
    EnterpriseSpaceUtil.updateNeedHiddenAppList();
    return EnterpriseSpaceUtil.hideAppList || [];
  }

  /***
   * 同时满足 1.hwit镜像 2. vpn中配置隐藏
   * 因存在账号未创建前调用情况，无法直接缓存结果。只能满足条件下，缓存结果。
   */
  public static envCheck(): boolean {
    if (EnterpriseSpaceUtil.envPass === 'isPassed') {
      log.showInfo(`enterpriseSpace envCheck use cache ${EnterpriseSpaceUtil.envPass}`);
      return true;
    }

    const isItOS = EnterpriseSpaceUtil.hwItOsCheck();
    // 非it镜像判断同步方法执行速度快，覆盖场景多，提前返回，提升性能
    if (!isItOS) {
      log.showInfo('EnterpriseSpace envCheck false');
      return false;
    }

    const isHide2BnoNeedApp: boolean = EnterpriseSpaceUtil.vpnEnterpriseSpaceConfigCheck();
    log.showInfo(`isHide2BnoNeedApp::${isHide2BnoNeedApp}`);

    if (isItOS && isHide2BnoNeedApp) {
      log.showInfo('EnterpriseSpace envCheck true');
      EnterpriseSpaceUtil.envPass = 'isPassed';
      return true;
    }
    log.showInfo('EnterpriseSpace envCheck false');
    return false;
  }

  /**
   * hwit镜像检测
   * @returns
   */
  public static hwItOsCheck(): Boolean {
    try {
      const params = systemparameter.getSync('const.cust.custPath');
      if (params.startsWith('hwit')) {
        log.showInfo(`os Mode is ${params}`);
        return true;
      }
    } catch (err) {
      log.showError('get os Mode fail');
    }
    log.showInfo('os Mode is not hwit/cn');
    return false;
  }

  /**
   * vpn企业空间特性配置检测
   * @returns
   */
  private static vpnEnterpriseSpaceConfigCheck(): boolean {
    const bundleNames = EnterpriseSpaceUtil.getNeedHiddenAppList();
    log.showInfo(`enterprise space characteristics config: ${bundleNames.length}`);
    return bundleNames.length > 0;
  }

  /**
   * 更新缓存值
   */
  private static updateNeedHiddenAppList(): void {
    try {
      const hide2BnoNeedApp: string = settings.getValueSync(GlobalContext.getContext(), 'hide2BnoNeedApp', '', settings.domainName.USER_PROPERTY);
      log.showInfo(`getNeedHiddenAppList: ${hide2BnoNeedApp}`);
      const bundleNames = hide2BnoNeedApp.split(',');
      EnterpriseSpaceUtil.hideAppList = bundleNames;
    } catch (err) {
      log.showError(`getNeedHiddenAppList error: ${err?.code} ${err?.message}`);
    }
  }
}