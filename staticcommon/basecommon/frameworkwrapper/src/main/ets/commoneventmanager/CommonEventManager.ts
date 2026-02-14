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

import commonEvent from '@ohos.commonEvent';
import { Log } from '@ohos/basicutils';
import { CommonEventData } from 'commonEvent/commonEventData';
import { CommonEventSubscribeInfo } from 'commonEvent/commonEventSubscribeInfo';

export interface CommonEventManager {
  subscriberCommonEvent: () => Promise<void>;
  unSubscriberCommonEvent: () => void;
  applyPolicy: (policys: Array<POLICY>) => void;
  release: () => void;
}

export enum POLICY {
  SCREEN_POLICY = 'screenOnOffPolicy',
}

type ClearPolicy = () => void;

export function getCommonEventManager(
  tag: string,
  subscribeInfos: CommonEventSubscribeInfo,
  commonEventCallback: (data: CommonEventData) => void,
  subscribeStateChange?: (isSubscribe: boolean) => void
): CommonEventManager {
  const TAG = `CommonEvent_${tag}`;
  const SUBSCRIBE_INFOS = subscribeInfos;
  let unSubcribers: Array<() => void> = [];
  let policyClearCb: Map<POLICY, ClearPolicy> | undefined = undefined;

  let subscriberCommonEvent = async (): Promise<void> => {
    Log.showDebug(TAG, 'registerSubscriber start');
    let subscriber = await commonEvent.createSubscriber(SUBSCRIBE_INFOS);
    commonEvent.subscribe(subscriber, (err, data) => {
      if (err.code !== 0) {
        Log.error(TAG, 'Cant handle common event, err:', err);
        return;
      }
      Log.showDebug(TAG, 'handle common event:%{public}s', data.event);
      commonEventCallback(data);
    });
    unSubcribers.push(() => commonEvent.unsubscribe(subscriber));
    subscribeStateChange && subscribeStateChange(true);
    Log.showDebug(TAG, `registerSubscriber success, size: ${unSubcribers.length}`);
  }

  let unSubscriberCommonEvent = (): void => {
    Log.showDebug(TAG, `UnSubcribers size: ${unSubcribers.length}`);
    unSubcribers.forEach((unsubscribe) => unsubscribe());
    unSubcribers.length = 0;
    subscribeStateChange && subscribeStateChange(false);
  }

  let applyPolicy = (policys: Array<POLICY>): void => {
    policyClearCb = policyClearCb ?? new Map();
  }

  let release = (): void => {
    policyClearCb?.forEach((cb) => cb());
    policyClearCb?.clear();
    unSubscriberCommonEvent();
  }

  let event: CommonEventManager = {
    subscriberCommonEvent,
    unSubscriberCommonEvent,
    applyPolicy,
    release
  };
  return event;
}
