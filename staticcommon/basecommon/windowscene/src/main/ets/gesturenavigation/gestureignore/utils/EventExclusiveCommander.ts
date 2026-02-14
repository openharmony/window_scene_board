/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { SingletonHelper } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { EventExclusiveConfig, EventType } from '../configs/EventExclusiveConfig';
import { scbEventExclusiveManager } from '../SCBEventExclusiveManager';

const TAG = 'EventExclusiveCommander';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

const COMMAND_ITEM_LENGTH = 30;
const COMMAND_LINE_LENGTH = 90;

export class EventExclusiveCommander {
  private eventExclusiveMap: Map<EventType, [boolean, string]> = new Map();

  public static getInstance(): EventExclusiveCommander {
    return SingletonHelper.getInstance(EventExclusiveCommander, TAG);
  }

  /**
   * 手势互斥-Debug命令
   */
  public registerDebugCommands(exclusiveMap: Map<EventType, [boolean, string]>): void {
    this.eventExclusiveMap = exclusiveMap;
    let cmds: DebugCommand[] = [
      {
        cmdName: 'getAllEventExclusiveCaller',
        callback: (args: Array<string>): string => {
          return this.debugGetAllEventExclusive();
        }
      },
      {
        cmdName: 'setEventExclusive',
        callback: (args: Array<string>): string => {
          return this.debugSetEventExclusive(args);
        }
      },
    ];
    DebugCommandManager.getInstance().register(TAG, cmds);
  }

  private debugGetAllEventExclusive(): string {
    let allEventExclusiveCaller = `\nThere are ${this.eventExclusiveMap.size} callers: \n\n` +
    `Caller`.padEnd(COMMAND_ITEM_LENGTH, ' ') +
    `SetEventExclusive`.padEnd(COMMAND_ITEM_LENGTH, ' ') +
    `Time`.padEnd(COMMAND_ITEM_LENGTH, ' ') + `\n` +
    `-`.padEnd(COMMAND_LINE_LENGTH, '-') + `\n`;

    this.eventExclusiveMap.forEach((value: [boolean, string], key: EventType) => {
      allEventExclusiveCaller +=
      `${EventExclusiveConfig.getEventTypeName(key)}`.padEnd(COMMAND_ITEM_LENGTH, ' ') +
      `${value[0]}`.padEnd(COMMAND_ITEM_LENGTH, ' ') +
      `${value[1]}`.padEnd(COMMAND_ITEM_LENGTH, ' ') + `\n`;
    });
    return allEventExclusiveCaller;
  }

  private debugSetEventExclusive(args: Array<string>): string {
    if (!EventExclusiveConfig.getEventType(args[0])) {
      return 'invalid event type.';
    }
    if (args[1] === 'true') {
      log.showInfo(`EventType:${args[0]} debugSetEventExclusive ${args[1]}.`);
      scbEventExclusiveManager.setEventExclusive(EventExclusiveConfig.getEventType(args[0]), true);
    } else if (args[1] === 'false') {
      log.showInfo(`EventType:${args[0]} debugSetEventExclusive ${args[1]}.`);
      scbEventExclusiveManager.setEventExclusive(EventExclusiveConfig.getEventType(args[0]), false);
    } else {
      return 'invalid event exclusive value.';
    }

    return `EventType:${args[0]} debugSetEventExclusive ${args[1]}.`;
  }
}

export const eventExclusiveCommander = EventExclusiveCommander.getInstance();