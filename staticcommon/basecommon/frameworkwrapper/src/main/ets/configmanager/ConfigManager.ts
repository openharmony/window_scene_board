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

import Context from '@ohos.app.ability.common';
import EnvironmentCallback from '@ohos.app.ability.EnvironmentCallback';
import { Configuration } from '@ohos.app.ability.Configuration';
import { ConfigurationEvent, RecentlyUseConfigurationEvent } from '../eventbus/events/Events';
import { EvtBus } from '../eventbus/EventBus';
import { SingletonHelper, LogDomain, LogHelper } from '@ohos/basicutils';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';

const TAG = 'SysUI_ConfigManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * Configuration管理
 *
 * @since 2022-09-16
 */
class ConfigManager {
  /**
   * 属性变化事件
   */
  private configEvent: ConfigurationEvent = new ConfigurationEvent();

  /**
   * 环境回调器
   */
  private environmentCallback: EnvironmentCallback = {
    /**
     * 配置信息变化回调
     *
     * @param config 配置信息
     */
    onConfigurationUpdated(config: Configuration): void {
      log.showInfo('onConfigurationUpdated configChange');
      ConfigMgr.updateConfiguration(config);
    },

    onMemoryLevel(level: AbilityConstant.MemoryLevel): void {
      log.showInfo('Method to trim memory yet not in use, NULL METHOD');
    }
  };

  /**
   * 初始化
   *
   * @param context
   */
  init(context: Context.ExtensionContext): void {
    // 初始属性
    this.configEvent.config = context?.config;
    log.showDebug('init config:language:%{public}s, displayId:%{public}d', this.configEvent.config?.language, this.configEvent.config.displayId);
    // 注册环境回调
    context?.getApplicationContext()?.on('environment', this.environmentCallback);
    // 发送初始属性
    this.postEvent();
    // 注册事件生产者
    EvtBus.produceOn(ConfigurationEvent, (): ConfigurationEvent => this.configEvent);
  }

  /**
   * 属性更新
   *
   * @param config 属性
   */
  updateConfiguration(config: Configuration): void {
    this.configEvent.config = config;
    this.postEvent();
  }

  /**
   * 获取当前属性
   *
   * @return 属性
   */
  getConfiguration(): Configuration | undefined {
    return this.configEvent.config;
  }

  /**
   * 发送事件
   */
  private postEvent(): void {
    // 发送属性变化事件
    EvtBus.post(ConfigurationEvent, this.configEvent);
    EvtBus.post(RecentlyUseConfigurationEvent, this.configEvent);
    log.showDebug('postEvent post config change');
  }
}

// 单例
export let ConfigMgr: ConfigManager = SingletonHelper.getInstance(ConfigManager, TAG);