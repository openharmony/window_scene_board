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
import { AbstractObserverManager } from '@ohos/screenlockcommon';
import { ICommand } from './Command';
import { IEvent } from './Event';

const TAG = 'Invoker';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 命令调用者
 */
export class Invoker extends AbstractObserverManager<ICommand> {
  /**
   * 根据通信事件调用命令
   *
   * @param event 通信事件
   */
  onEvent(event: IEvent): void {
    if (!this.hasInit()) {
      log.showWarn('sendEvent fail for channel has not init');
    }
    if (!event) {
      log.error('sendEvent fail for invalid event');
    }
    log.showInfo(`onEvent:${event.getEventType()}, scene:${event.getScene()}`);
    this.broadcastDataChange((command: ICommand) => {
      command.execute(event);
    });
  }
}
