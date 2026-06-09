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

import { Singleton } from '../utils/Singleton';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { commonEventManager } from '@kit.BasicServicesKit';
import { ResUtils } from '@ohos/windowscene';
import { promptAction } from '@kit.ArkUI';

const TAG = 'Ctrl.EdmAdminManager';
const log = LogHelper.getLogHelper(LogDomain.CC, TAG);

const PERSIST_EDM_CONFIG: string = 'persist.edm.edm_enable';
const EDM_ENABLE_EVENT_NAME: string = 'com.ohos.edm.edmadminenabled';
const EDM_DISABLE_EVENT_NAME: string = 'com.ohos.edm.edmadmindisabled';
const EDM_PUBLISHER_PERMISSION: string = 'ohos.permission.PUBLISH_ENTERPRISE_POLICY_EVENT';
const EDM_POLICY_NONE: string = 'none';
const EDM_POLICY_DISALLOW: string = 'disallow';
const EDM_POLICY_FORCE_OPEN: string = 'force_open';

export class EdmAdminManager {
  @Singleton.decorate()
  public static get instance(): EdmAdminManager {
    return new EdmAdminManager();
  }

  private edmSubscriber?: commonEventManager.CommonEventSubscriber;

  private edmAdminEnabled: boolean = false;

  public isEdmAdminEnabled(): boolean {
    return this.edmAdminEnabled;
  }

  /**
   * 初始化
   */
  public init(): void {
    // 获取edm管控状态
    this.initEdmEnableStatus();
    // 监听edm管控状态
    this.subscribeEdmEnableStatus();
    log.showInfo(`initEdmEnableStatus: ${this.edmAdminEnabled}`);
  }

  private subscribeEdmEnableStatus(): void {
    try {
      commonEventManager.createSubscriber({
        'events': [EDM_ENABLE_EVENT_NAME, EDM_DISABLE_EVENT_NAME],
        'publisherPermission': EDM_PUBLISHER_PERMISSION
      }, (error, commonEventSubscriber) => {
        if (error) {
          log.error('create commonEvent subscriber failed, error: ' + error?.message);
          return;
        }
        this.edmSubscriber = commonEventSubscriber;
        this.subscribeEdmCommonEvent();
      });
    } catch (error) {
      log.showError(`commonEventManager failed, error: ${error}`);
    }
  }

  private subscribeEdmCommonEvent(): void {
    if (!this.edmSubscriber) {
      log.showWarn('edmSubscriber is undefined');
    }
    try {
      commonEventManager.subscribe(this.edmSubscriber, (err, data) => {
        if (data?.event === EDM_ENABLE_EVENT_NAME) {
          log.showInfo('EDM_ENABLE');
          this.edmAdminEnabled = true;
        } else if (data?.event === EDM_DISABLE_EVENT_NAME) {
          log.showInfo('EDM_DISABLE');
          this.edmAdminEnabled = false;
        }
        AppStorage.setOrCreate('EdmAdminEnable', this.edmAdminEnabled);
      });
    } catch (e) {
      log.showError('commonEvent subscriber fail error', e);
    }
  }

  private initEdmEnableStatus(): void {
    try {
      this.edmAdminEnabled = systemParameterEnhance.getSync(PERSIST_EDM_CONFIG, 'false') === 'true';
    } catch (error) {
      log.showError('get EDM config parameter fail', error);
    }
  }

  /**
   * 获取指定edm配置的具体策略
   *
   * @param edmConfig
   * @returns
   */
  private getEdmPolicy(edmConfig: string): string {
    // 如果edm没有开启，就返回无策略
    if (!this.edmAdminEnabled) {
      return EDM_POLICY_NONE;
    }
    let edmPolicyResult: string = EDM_POLICY_NONE;
    try {
      edmPolicyResult = systemParameterEnhance.getSync(edmConfig, 'false');
      log.showInfo(`get EDM config ${edmConfig}, edmPolicy ${edmPolicyResult}`);
      if (edmPolicyResult === 'true') {
        edmPolicyResult = EDM_POLICY_DISALLOW;
      } else if (edmPolicyResult === 'false') {
        edmPolicyResult = EDM_POLICY_NONE;
      }
    } catch (error) {
      log.showError(`get EDM config fail`, error);
    }
    return edmPolicyResult;
  }

  /**
   * 判读当前EDM策略下开关是否可用
   * @param edmConfig
   * @returns
   */
  public isEdmPolicyAvailable(edmConfig: string): boolean {
    const edmPolicy: string = this.getEdmPolicy(edmConfig);
    log.showInfo(`isEdmPolicyAvailable edmConfig: ${edmConfig}, edmPolicy: ${edmPolicy}`);
    return edmPolicy !== EDM_POLICY_FORCE_OPEN && edmPolicy !== EDM_POLICY_DISALLOW;
  }

  /**
   * 被管控开关备操作后toast提示
   */
  public showToastWhenInoperable(): void {
    log.showInfo(`showToastWhenInoperable`);
    promptAction.showToast({
      message: ResUtils.getInnerString($r('app.string.edm_operate_prohibit_tip')),
      bottom: 80,
      showMode: 2
    });
  }
}
