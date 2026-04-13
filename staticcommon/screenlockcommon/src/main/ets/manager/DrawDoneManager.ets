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

import inspector from '@ohos.arkui.inspector';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { sSCBOobeManager } from '@ohos/windowscene';
import { LockEventType, SlServerHelper } from '../utils/SlServerHelper';

const TAG: string = 'DrawDoneManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export default class DrawDoneManager {
  private hasRegisterDraw: boolean = false;
  private componentObserver: inspector.ComponentObserver | undefined = undefined;
  private id: string;
  private drawObserverCallback?: () => void;
  private observerDrawCallback: () => void = () => {
    log.showInfo(`component(${this.id}) has draw down.`);
    if (this.drawObserverCallback) {
      this.drawObserverCallback();
    }
    if (this.componentObserver) {
      this.componentObserver.off('draw', this.observerDrawCallback);
    }
    this.hasRegisterDraw = false;
  };

  constructor(id: string) {
    this.id = id;
  }

  public registerComponentDrawObserver(drawObserverCallback?: () => void): void {
    log.showInfo(`register component(${this.id}) draw observer begin.`);
    this.drawObserverCallback = drawObserverCallback;
    try {
      if (sSCBOobeManager.isEnable()) {
        log.showInfo('oobe is not need to draw, so direct to notify set display on.');
        SlServerHelper.getInstance().sendScreenLockEvent(LockEventType.SCREEN_DRAW_DONE);
        return;
      }

      if (!this.componentObserver) {
        this.componentObserver = inspector.createComponentObserver(this.id);
      }

      if (this.hasRegisterDraw) {
        log.showInfo(`component(${this.id}) has register draw done.`);
        this.componentObserver.off('draw', this.observerDrawCallback);
        this.hasRegisterDraw = false;
      }

      this.componentObserver.on('draw', this.observerDrawCallback);
      this.hasRegisterDraw = true;
    } catch (e) {
      log.showError('register componentDraw observer error');
    }
  }
}