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

import Account from '@ohos.account.osAccount';
import commonEventManager from '@ohos.commonEventManager';
import { ActivateEventData, EventId } from '@ohos/themeservice_inner_api/Index';
import { EventEmitter, Singleton, TsLog } from '@ohos/themeservicebase/Index';
import { NOTIFY_UPDATE_SCENE_THEME } from './api/ThemeVipService';
import { TsCommonEventSubscribe } from './api/TsCommonEventSubscribe';
import { SubscribeActivateThemeImpl } from './impl/subscribe/SubscribeActivateThemeImpl';
import { SubscribeChangedThemeImpl } from './impl/subscribe/SubscribeChangedImpl';
import { themeVipService } from './impl/ThemeVipServiceImpl';
import { presetRecommendService } from './impl/TsPresetRecommendImpl';
import { SubscribeUserSwitchedImpl } from './impl/subscribe/SubscribeUserSwitchedImpl';
import { SubscribeUserUnlockedImpl } from './impl/subscribe/SubscribeUserUnlockedImpl';


const TAG: string = 'TsEventProvider';

/**
 * 主题应用服务对外事件提供类：
 * 1、监听主题SA使能事件，发送TS主题使能事件
 * 2、监听账号变化、时间变化事件，触发主题App更新会员在线资源缓存
 */
export class TsEventProvider {
  /**
   * 单例对象
   */
  private static readonly INSTANCE: Singleton<TsEventProvider> =
    new Singleton<TsEventProvider>(() => new TsEventProvider);

  /**
   * 当前是否只是锁屏时钟样式使能，默认false：非锁屏时钟使能
   */
  private isOnlyClockActive: boolean = false;

  /**
   * 公共事件订阅器-主题使能（需要全局变量存在，否则不会收到公共事件回调）
   */
  private themeSubscriber?: commonEventManager.CommonEventSubscriber;

  /**
   * 公共事件订阅器-账号、时间变更（需要全局变量存在，否则不会收到公共事件回调）
   */
  private changeSubscriber?: commonEventManager.CommonEventSubscriber;

  /**
   * 公共事件订阅器-系统账号前后台切换监听
   */
  private userSwitchedSubscriber?: commonEventManager.CommonEventSubscriber;

  /**
   * 公共事件订阅器-冷启动开机首次解锁监听
   */
  private userUnlockedSubscriber?: commonEventManager.CommonEventSubscriber;

  /**
   * 获取单例对象
   *
   * @returns 对象
   */
  public static getInstance(): TsEventProvider {
    return TsEventProvider.INSTANCE.get();
  }

  /**
   * 私有构造方法
   */
  private constructor() {
  }

  /**
   * 注册对SA主题使能公共事件的监听
   */
  public async initSubscriber(): Promise<void> {
    try {
      // 监听主题使能SA公共事件
      const localId: number = await this.getAccountLocalId();
      // 注册主题使能监听（需要全局变量存在，否则不会收到公共事件回调）
      this.themeSubscriber = await this.createSubscriber(new SubscribeActivateThemeImpl(), localId);
      // 注册账号变更、时间变更监听（需要全局变量存在，否则不会收到公共事件回调）
      this.changeSubscriber = await this.createSubscriber(new SubscribeChangedThemeImpl(), localId);
      // 注册系统账号前后台切换监听（需要全局变量存在，否则不会收到公共事件回调）
      this.userSwitchedSubscriber = await this.createSubscriber(new SubscribeUserSwitchedImpl(), localId);
      // 冷启动开机首次解锁监听
      this.userUnlockedSubscriber = await this.createSubscriber(new SubscribeUserUnlockedImpl(), localId);
      // 监听Ts内部主题使能结果事件
      EventEmitter.on(EventId.EVENT_ACTIVATE_THEME, async (data: ActivateEventData) => {
        presetRecommendService.get().onThemeActivated(data);
        themeVipService().notifyUpdateOnlineTheme(false, NOTIFY_UPDATE_SCENE_THEME);
      });
    } catch (err) {
      TsLog.error(TAG, `Failed on creating event subscriber`, err);
    }
  }

  /**
   * 设置当前是否只是锁屏时钟样式使能
   * @param isOnlyClockActive false：非锁屏时钟使能
   */
  public setOnlyClockActive(isOnlyClockActive: boolean): void {
    this.isOnlyClockActive = isOnlyClockActive;
  }

  /**
   * 获取当前是否只是锁屏时钟样式使能
   * @returns false：非锁屏时钟使能
   */
  public getIsOnlyClockActive(): boolean {
    return this.isOnlyClockActive;
  }

  /**
   * 获取当前进程的用户号
   * @returns 当前进程的用户号
   */
  private async getAccountLocalId(): Promise<number> {
    TsLog.info(TAG, `Query local id start`);
    let localId: number = 100;
    try {
      localId = await Account.getAccountManager().getOsAccountLocalId();
    } catch (err) {
      TsLog.error(TAG, `Query current local id  exception`, err);
    }
    TsLog.info(TAG, `Query current local id:${localId}`);
    return localId;
  }

  /**
   * 创建公共事件订阅
   * @param tsCommonEventSubscribe 封装的公共事件处理类
   * @param localId 当前进程绑定的用户号
   */
  private async createSubscriber(tsCommonEventSubscribe: TsCommonEventSubscribe,
    localId: number): Promise<Nullable<commonEventManager.CommonEventSubscriber>> {
    try {
      const data: commonEventManager.CommonEventSubscriber =
        await commonEventManager.createSubscriber(tsCommonEventSubscribe.getSubscribeInfo(localId));
      if (data === undefined) {
        TsLog.error(TAG, 'Failed to create subscriber , subscriber is undefined.');
        return undefined;
      }
      TsLog.info(TAG, 'Success to create subscriber');
      commonEventManager.subscribe(data, tsCommonEventSubscribe.getCallback());
      return data;
    } catch (e) {
      TsLog.error(TAG, `Failed to create subscriber`, e);
      return undefined;
    }
  }
}

