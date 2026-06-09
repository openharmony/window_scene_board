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

import {
  EvtBus,
  EventManager,
  ConfigurationEvent,
  TimeChangeEvent,
  ScreenOnOffEvent,
} from '@ohos/frameworkwrapper';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { TimeFormatEvent } from '@ohos/systemuicommon';
import { Configuration } from '@ohos.app.ability.Configuration';

const TAG = 'SysUI_BaseVM_';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 各个时间组件数据处理
 *
 * @since 2022-12-10
 */
export abstract class BaseVM {
  /**
   * 多事件统一管理
   */
  protected eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 配置信息
   */
  protected config: Configuration | null = null;

  /**
   * 默认24小时制
   */
  protected isDateFormat24: boolean = true;

  /**
   * 最终时间文本
   */
  private timeText: string = '';

  /**
   * 唯一标示
   */
  private tag: string = '';

  /**
   * 回调器
   */
  private callback: ViewCallback | null = null;

  /**
   * 组件初始化
   *
   * @param slot 唯一标示
   * @param callback 回调器
   */
  init(slot: string, callback: ViewCallback): void {
    this.tag = TAG + slot;
    this.callback = callback;
    // Configuration切换事件
    this.eventMgr.on(ConfigurationEvent, this.onConfigurationEvent)
      // 时间小时制事件
      .on(TimeFormatEvent, this.onTimeFormatEvent)
      // 时间变化事件
      .on(TimeChangeEvent, this.onTimeChangeEvent)
      // 监听亮灭屏事件
      .on(ScreenOnOffEvent, this.onScreenOnOffEvent);
  }

  /**
   * 组件销毁
   */
  onDestroy(): void {
    this.eventMgr.offAll();
    this.callback = null;
  }

  /**
   * 更新时间文本
   *
   * @return 更新后的时间文本
   */
  protected abstract updateTime(): Promise<string>;

  /**
   * 延时更新时间文本的时刻值
   * 默认每次tick都更新
   *
   * @return 时刻值
   */
  protected getSoonestUpdateTime(): number {
    return 0;
  }

  /**
   * Configuration变化事件
   *
   * @param event 事件
   */
  private onConfigurationEvent = (event: ConfigurationEvent): void => {
    let configuration = event.config;
    if (!configuration) {
      log.showDebug('onConfigurationEvent event is invalid');
      return;
    }
    // 语言、分辨率变化，刷新时间文本
    if (this.config?.language != configuration.language ||
      this.config?.screenDensity != configuration.screenDensity) {
      log.showInfo('onConfigurationEvent, config change need to update time');
      this.config = configuration;
      this.checkUpdateTime();
      log.showDebug('onConfigurationEvent:' + this.timeText);
    }
  }

  /**
   * 时间小时制变化事件
   *
   * @param event 事件
   */
  private onTimeFormatEvent = (event: TimeFormatEvent): void => {
    // 小时制切换，刷新UI
    let isFormat24 = event.isTimeFormat24();
    if (CommonUtils.isInvalid(isFormat24)) {
      log.showInfo('onTimeFormatEvent: isFormat24 is invalid');
      return;
    }
    if (this.isDateFormat24 != isFormat24) {
      log.showInfo('onTimeFormatEvent, DateFormat change need to update time');
      this.isDateFormat24 = isFormat24;
      this.checkUpdateTime();
    }
  }

  /**
   * 时间变化事件
   *
   * @param event 事件
   */
  private onTimeChangeEvent = (event: TimeChangeEvent): void => {
    // 时间tick变化时，需判断是否达到更新时刻值
    if (TimeChangeEvent.EVENT_TIME_TICK == event.event) {
      if (Date.now() < this.getSoonestUpdateTime()) {
        return;
      }
    }
    // 其他场景，直接更新
    log.showInfo(`onTimeChangeEvent, need to update time, event: ${event.event}`);
    this.checkUpdateTime();
  }

  /**
   * 亮灭屏事件
   *
   * @param event 事件
   */
  private onScreenOnOffEvent = (event: ScreenOnOffEvent): void => {
    // 亮屏刷新时间文本
    if (event.isScreenOn()) {
      // 刷新时间
      this.checkUpdateTime();
    }
  }

  /**
   * 检测时间文本更新
   */
  protected checkUpdateTime(): void {
    // 无configuration，不做处理
    if (CommonUtils.isInvalid(this.config)) {
      return;
    }
    this.updateTime().then((timeText) => {
      this.timeText = timeText;
      this.callback?.onTimeTextUpdate(this.timeText);
    });
  }
}

/**
 * 组件通信回调
 */
export interface ViewCallback {
  /**
   * 时间文本更新回调
   *
   * @param timeText 新时间文本
   */
  onTimeTextUpdate: (timeText: string) => void;
}