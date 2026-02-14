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
import type Want from '@ohos.app.ability.Want';
export type EventTarget = 'local' | 'remote' | 'ability' | 'serviceExt' | 'commonEvent';
export type Event = {
    target: EventTarget;
    data: { [key: string]: any };
};
export type EventParser = {
    [key in EventTarget]: (data: any) => boolean;
};
export type LocalEvent = {
    eventName: string;
    args: any;
};

export const START_ABILITY_EVENT = 'startAbilityEvent';
export const START_SERVICE_EXT_EVENT = 'startServiceExtEvent';
export const PUBLISH_COMMON_EVENT = 'publishCommonEvent';

const TAG = 'EventUtil';
const LOCAL_EVENT_TYPE = 'local';
const START_ABILITY_TYPE = 'ability';
const START_SERVICE_EXT_TYPE = 'serviceExt';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export function obtainLocalEvent(event: string, args: any): Event & { data: LocalEvent } {
    return {
        target: LOCAL_EVENT_TYPE,
        data: {
            eventName: event,
            args,
        },
    };
}

export function obtainStartAbility(bundleName: string, abilityName: string, moduleName?: string,
  parameters?: Record<string, Object>): Event {
    return {
        target: START_ABILITY_TYPE,
        data: {
            bundleName,
            abilityName,
            moduleName,
            parameters
        },
    };
}

export function obtainStartAbilityWithWant(want: Want): Event {
  return {
    target: START_ABILITY_TYPE,
    data : want
  };
}

export function obtainStartServiceExt(bundleName: string, abilityName: string,
  parameters?: Record<string, Object>): Event {
  return {
    target: START_SERVICE_EXT_TYPE,
    data: {
      bundleName,
      abilityName,
      parameters
    },
  };
}

export function parseEventString(eventString: string | undefined): Event | undefined {
  // string must be "local=eventName|args" or "ability=bundleName|abilityName"
  if (!eventString) {
    return undefined;
  }
  let [eventType, eventData] = eventString.split('=');
  if (eventType === LOCAL_EVENT_TYPE && eventData) {
    let [localEventName, args] = eventData.split('|');
    if (localEventName) {
      log.showDebug(`parseEventData name:${localEventName}, args: ${args}`);
      return obtainLocalEvent(localEventName, args);
    }
  }
  if (eventType === START_ABILITY_TYPE && eventData) {
    let [bundleName, abilityName, moduleName] = eventData.split('|');
    if (bundleName && abilityName) {
      log.showDebug(`parseEventData bundleName:${bundleName}, abilityName: ${abilityName}`);
      return obtainStartAbility(bundleName, abilityName, moduleName);
    }
  }
  if (eventType === START_SERVICE_EXT_TYPE && eventData) {
    let [bundleName, abilityName] = eventData.split('|');
    if (bundleName && abilityName) {
      log.showDebug(`parseEventData bundleName:${bundleName}, abilityName: ${abilityName}`);
      return obtainStartServiceExt(bundleName, abilityName);
    }
  }
  log.showError(`Can't parse event data: ${eventString}`);
  return undefined;
}
