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

import { FontScaleState } from './FontScaleState';
import systemParameter from '@ohos.systemParameterEnhance';
import { ConfigurationEvent } from '../eventbus/events/Events';
import { EventManager, EvtBus } from '../eventbus/EventBus';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'FontScaleManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class FontScaleManager {
  private static instance: FontScaleManager;
  private fontScaleState = new FontScaleState();
  private eventMgr: EventManager = EvtBus.createEventManager(); // 事件管理器

  private constructor() {
    this.initFontScaleState();
    this.initEventMgr();
  }

  public static getInstance(): FontScaleManager {
    if (!FontScaleManager.instance) {
      FontScaleManager.instance = new FontScaleManager();
    }
    return FontScaleManager.instance;
  }

  /**
   * 获取系统原始字体放大倍数
   */
  public getSysFontScaleState(): FontScaleState {
    return this.fontScaleState;
  }

  /**
   * 设置系统原始字体放大倍数
   *
   * @param scale 字体系数
   */
  public setSysFontScale(scale: number): void {
    this.fontScaleState.fontSizeScale = scale;
  }

  /**
   * 使用从数据库查询的系统字体放大倍数进行初始化
   */
  public initFontScaleState(): void {
    let scaleSize = systemParameter.getSync('persist.sys.font_scale_for_user0', '1');
    log.showInfo(`initialize fontSizeScale:${scaleSize}`);
    this.setSysFontScale(Number(scaleSize));
  }

  private initEventMgr(): void {
    this.eventMgr.on(ConfigurationEvent, this.onConfigurationEvent);
  }

  private onConfigurationEvent = (event: ConfigurationEvent): void => {
    log.showInfo(`onConfigurationEvent, config.fontSizeScale: ${event.config?.fontSizeScale}`);
    this.setSysFontScale(event.config?.fontSizeScale || 1);
  };
}