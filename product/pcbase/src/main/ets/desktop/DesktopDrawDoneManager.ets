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

import { inspector } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG: string = 'SCBDesktop-DesktopDrawDoneManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 桌面屏幕绘制管理类
 */
export default class DesktopDrawDoneManager {
  private componentId: string;
  private hasRegisterDraw: boolean = false;
  private componentObserver: inspector.ComponentObserver | undefined = undefined;
  private drawObserverCallback?: () => void;
  private observerDrawCallback: () => void = () => {
    log.showInfo(`component(${this.componentId}) has draw done.`);
    if (this.drawObserverCallback) {
      this.drawObserverCallback();
    }
    this.componentObserver?.off('draw', this.observerDrawCallback);
    this.hasRegisterDraw = false;
  };

  constructor(componentId: string) {
    this.componentId = componentId;
  }

  /**
   * 注册组件绘制观察者
   *
   * @param drawObserverCallback 绘制观察者回调
   */
  public registerComponentDrawObserver(drawObserverCallback?: () => void): void {
    log.showInfo(`register component(${this.componentId}) draw observer begin.`);
    this.drawObserverCallback = drawObserverCallback;
    try {
      if (!this.componentObserver) {
        this.componentObserver = inspector.createComponentObserver(this.componentId);
      }
      if (this.hasRegisterDraw) {
        log.showInfo(`component(${this.componentId}) has register draw done`);
        this.componentObserver?.off('draw', this.observerDrawCallback);
        this.hasRegisterDraw = false;
      }
      this.componentObserver?.on('draw', this.observerDrawCallback);
      this.hasRegisterDraw = true;
    } catch (e) {
      log.showError(`register componentDraw observer error: ${e?.message}`);
    }
  }
}