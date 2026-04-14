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
import { ArgumentMatchers, MockKit, when } from '@ohos/hypium';
import { AnyType, Singleton } from '@ohos/themeservicebase/Index';
import { TsLog } from '@ohos/themeservicebase/src/main/ets/log/TsLog';

export class LoggerMocker {
  private static readonly INSTANCE: Singleton<LoggerMocker> = new Singleton<LoggerMocker>(() => new LoggerMocker());

  private mocker: Nullable<MockKit>;

  private constructor() {
  }

  public static getInstance(): LoggerMocker {
    return LoggerMocker.INSTANCE.get();
  }


  public openDebug(): void {
    let mocker: MockKit = this.mocker ?? new MockKit()
    let isDebugFunction: Function = mocker.mockFunc(TsLog, TsLog.isDebug);
    when(isDebugFunction)(ArgumentMatchers.any).afterReturn(true);

    let debugFunction: Function = mocker.mockFunc(TsLog, TsLog.debug);
    when(debugFunction)(ArgumentMatchers.any).afterAction((tag: string, message: string, ...args: AnyType[]) => {
      TsLog.info(tag, `[debug] ${message}`, args);
    })
  }

  public closeDebug(): void {
    this.mocker?.clear(TsLog);
    this.mocker?.clearAll();
  }
}