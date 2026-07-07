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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EvtBus } from '../eventbus/EventBus';
import { RssNotifyEvent } from '../eventbus/events/Events';

const TAG = 'AnimPolicyRegistry';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class AnimPolicyConstant {
  // 策略最大长度
  static readonly POLICY_MAX_LENGTH = 500;

  // 延时3s注册，避免rss还没起来注册不上的问题
  static readonly POLICY_REGISTRY_DELAY = 3000;
}

export interface CommonComponent {
  sceneboard: object;
}

export class AnimPolicyRegistry {
  private static rssPolicy: CommonComponent | null = null;

  private static isRealtimeEffect: boolean = true;

  /**
   * 注册RSS模块场景动效参数变化
   */
  public static registerRssCallback(): void {
    // try {
    //   animPolicy.on('rssStatusChange', 'sceneboard', (policyInfo: animPolicy.RssPolicyCallbackInfo) => {
    //     if (policyInfo === null || policyInfo === undefined || policyInfo.policy === null) {
    //       log.showError(`animInfo is null or undefine`);
    //       return;
    //     }
    //     if (policyInfo.policy.length > AnimPolicyConstant.POLICY_MAX_LENGTH) {
    //       log.showError(`animInfo is valid`);
    //       return;
    //     }
    //     AnimPolicyRegistry.rssStatusChange(policyInfo);
    //   });
    // } catch (error) {
    //   log.showError(`registerRssCallback error: ${error}`);
    // }
  }

  /**
   * 反注册RSS模块场景动效参数变化
   */
  public static unregisterRssCallback(): void {
    // try {
    //   animPolicy.off('rssStatusChange', 'sceneboard');
    // } catch (error) {
    //   log.showError(`unregisterRssCallback error: ${error}`);
    // }
  }

  // private static rssStatusChange(policyInfo: animPolicy.RssPolicyCallbackInfo): void {
  //   try {
  //     let modeJson: string = AnimPolicyRegistry.replaceIfContainsSquare(policyInfo.policy);
  //     let parseData = JSON.parse(modeJson) as CommonComponent;
  //     let requestEvent = RssNotifyEvent.create(parseData);
  //     AnimPolicyRegistry.rssPolicy = parseData;
  //     EvtBus.post(RssNotifyEvent, requestEvent);
  //   } catch (error) {
  //     log.showError(`animPolicy rssStatusChange error: ${error}`);
  //   }
  // }

  /**
   * 最后异常消息的ModeJson
   * @returns ModeJson
   */
  public static getRssPolicy(): CommonComponent | null {
    return AnimPolicyRegistry.rssPolicy;
  }

  /**
   * 是否需要实时
   * @returns 是否需要实时
   */
  public static isNeedRealtime(): boolean {
    return AnimPolicyRegistry.isRealtimeEffect;
  }

  private static replaceIfContainsSquare(source: string): string {
    return source.replace(/[\[\]]/g, '');
  }
}
