/**
 * Copyright (c) 2025-2025 Huawei Device Co., Ltd.
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

const TAG = 'PcTouchOutSideMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

type PointFunction = (x: number, y: number) => void;

export class TouchOutsideListener {
  public onDealTouchOutside: PointFunction = (x: number, y: number) => {
  };
}

export class PcTouchOutSideMgr {
  private static instance: PcTouchOutSideMgr;
  private touchOutsideListeners: TouchOutsideListener[] = [];

  static getInstance(): PcTouchOutSideMgr {
    if (!PcTouchOutSideMgr.instance) {
      PcTouchOutSideMgr.instance = new PcTouchOutSideMgr();
    }
    return PcTouchOutSideMgr.instance;
  }

  public registerDataChangeListener(listener: TouchOutsideListener): void {
    if (this.touchOutsideListeners.indexOf(listener) >= 0) {
      return;
    }
    this.touchOutsideListeners.push(listener);
  }

  public unregisterDataChangeListener(listener: TouchOutsideListener): void {
    const pos: number = this.touchOutsideListeners.indexOf(listener);
    if (pos >= 0) {
      this.touchOutsideListeners.splice(pos, 1);
    }
  }

  public notifyTouchOutside(x: number, y: number): void {
    log.showInfo(`notifyTouchOutside, x:${x}, y:${y}`);
    this.touchOutsideListeners.forEach(listener => {
      listener.onDealTouchOutside(x, y);
    });
  }
}