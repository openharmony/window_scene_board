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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { threadCall, ThreadCallType } from '../messageChannel/ThreadCall';

const TAG = 'PowerStatusMonitorAdapter';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

interface PowerStatusMonitorCallback{
  stage: string;
  callback: () => void;
};

export enum PowerStatusEnum {
  BEGIN_WAKE_UP = 'BEGIN_WAKE_UP',
  END_WAKE_UP = 'END_WAKE_UP',
  BEGIN_SLEEP = 'BEGIN_SLEEP',
  END_SLEEP = 'END_SLEEP',
  BEGIN_DISPLAY_ON = 'BEGIN_DISPLAY_ON',
  END_DISPLAY_ON = 'END_DISPLAY_ON',
  BEGIN_DISPLAY_OFF = 'BEGIN_DISPLAY_OFF',
  END_DISPLAY_OFF = 'END_DISPLAY_OFF',
  BEGIN_DESKTOP_READY = 'BEGIN_DESKTOP_READY',
  END_DESKTOP_READY = 'END_DESKTOP_READY',
}

type ObserverCallback<T> = (args?: T) => void;

export interface IPowerStatusMonitor  {
  subscribe(stage: string, callback: ObserverCallback<Object>): void;
  unsubscribe(eventType: string, callback: ObserverCallback<Object>): void;
}

export class PowerStatusMonitorAdapter {
  private static api?: IPowerStatusMonitor;

  public static init(api: IPowerStatusMonitor) {
    log.showInfo('Init api');
    PowerStatusMonitorAdapter.api = api;
  }

  @threadCall(ThreadCallType.Register)
  public static subscribe(powerStatusMonitorCallback: PowerStatusMonitorCallback, tag: string): void {
    log.showInfo(`subscribe tag ${tag}`);
    PowerStatusMonitorAdapter.api?.subscribe(powerStatusMonitorCallback.stage, powerStatusMonitorCallback.callback);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static unsubscribe(powerStatusMonitorCallback: PowerStatusMonitorCallback, tag: string): void {
    log.showInfo(`unsubscribe tag ${tag}`);
    PowerStatusMonitorAdapter.api?.unsubscribe(powerStatusMonitorCallback.stage, powerStatusMonitorCallback.callback);
  }
}