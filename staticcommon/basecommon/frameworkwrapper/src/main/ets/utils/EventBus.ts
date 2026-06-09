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

import { LogDomain, LogHelper } from '@ohos/basicutils';

export type Callback = (args: any) => void;
const TAG = 'EventBus';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export interface EventBus<T> {
    on(event: T | T[], cb: Callback): () => void;
    once(event: T, cb: Callback): () => void;
    off(event: T | T[] | undefined, cb: Callback): void;
    emit(event: T, args: any): void;
}

export function createEventBus<T extends string>(): EventBus<T> {
    let _cbs: { [key: string]: Set<Callback> } = {};

    function on(events: T | T[], cb: Callback): () => void {
        if (Array.isArray(events)) {
            events.forEach((e) => on(e, cb));
        } else {
            (_cbs[events] || (_cbs[events] = new Set())).add(cb);
      log.showDebug(`add event[${events}] callback, size: ${_cbs[events]?.size}`);
        }
        return () => off(events, cb);
    }

    function once(event: T, cb: Callback): () => void {
        let newCallback = (args: unknown): void => {
            cb(args);
            removeSelf();
        };
        function removeSelf(): void {
            off(event, newCallback);
        }
        return on(event, newCallback);
    }

    function off(event: T | T[] | undefined, cb: Callback): void {
        if (!event) {
            _cbs = {};
      log.showInfo(`remove event[${event}] all callback`);
            return;
        }
        if (Array.isArray(event)) {
            event.forEach((e) => off(e, cb));
            return;
        }
        _cbs[event]?.delete(cb);
    log.showDebug(`remove event[${event}] callback, size: ${_cbs[event]?.size}`);
    }

    function emit(event: T, args: any): void {
        _cbs[event]?.forEach((cb) => cb(args));
    }

    function stickyEmit(event: T, argument: any[]): void {}

    return {
        on,
        once,
        off,
        emit,
    };
}