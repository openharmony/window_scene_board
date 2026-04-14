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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import IdlVisionGlassExtServiceCallbackStub from './IdlVisionGlassExtServiceCallbackStub';
import { onEventChangeCallback } from './IIdlVisionGlassExtServiceCallback';

const TAG = 'VisionGlassExtCallbackStub';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

export class VisionGlassExtServiceCallbackStub extends IdlVisionGlassExtServiceCallbackStub {
  private static readonly SUCCESS = 0;
  private static readonly FAIL = 1;
  private cb: RemoteCallback | undefined = undefined;

  constructor(callBack: RemoteCallback) {
    super(TAG);
    this.cb = callBack;
  }

  async onEventChange(event: string, data: string, callback: onEventChangeCallback): Promise<void> {
    try {
      if (!this.cb) {
        log.showWarn(`onEventChange handle cancel,callback is not exist`);
        return;
      }
      const resultData = await this.cb(event, data);
      if (resultData !== undefined) {
        callback(VisionGlassExtServiceCallbackStub.SUCCESS, resultData);
      }
    } catch (error) {
      log.error(`onEventChange failed, code:${error?.code} msg:${error?.message}`);
      callback(VisionGlassExtServiceCallbackStub.FAIL, '');
    }
  }

  public release(): void {
    this.cb = undefined;
  }
}

export type RemoteCallback = (event: string, data: string) => Promise<string | undefined>;