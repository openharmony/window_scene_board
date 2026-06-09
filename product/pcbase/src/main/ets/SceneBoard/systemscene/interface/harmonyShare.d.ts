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

import { Callback } from '@kit.BasicServicesKit';
import { systemShare } from '@kit.ShareKit';

/**
 * Provide methods make the host (data owner) application can conveniently wrap shared data,
 * make show the system share panel.
 *
 * @namespace systemShare
 * @syscap SystemCapability.Collaboration.SystemShare
 * @since 4.1.0(11)
 */
declare namespace harmonyShare {
  export enum SharableErrorCode {
    NO_CONTENT_ERROR = 1,
    NO_INTERNET_ERROR = 2,
    DOWNLOAD_ERROR = 3
  }

  export enum ShareResultCode {
    SHARE_SUCCESS = 0,
    SEND_FAILED = 1,
    CANCEL_BY_SENDER = 2,
    CANCEL_BY_RECEIVER = 3,
    REJECT_BY_RECEIVER = 4,
  }

  export interface SharableTarget {
    share(data: systemShare.SharedData): Promise<void>;
    reject(error: SharableErrorCode): Promise<void>;
  }

  export interface ReceivableTarget {
    receive(receiveUri: string, callback: ReceiveCallback): Promise<void>;
  }

  export interface BaseCapabilityRegistry {
    windowId: number;
  }

  export interface RecvCapability {
    utd: string;
    maxSupportedCount: number;
  }

  export interface RecvCapabilityRegistry extends BaseCapabilityRegistry {
    capabilities: RecvCapability[];
  }

  export interface SendCapabilityRegistry extends BaseCapabilityRegistry {}

  export interface ResultReason {
    message: ShareResultCode;
  }

  export interface TransferBaseResults {
    onResult?: Callback<ResultReason>;
  }

  export interface ReceiveCallback extends TransferBaseResults {
    onDataReceived: Callback<systemShare.SharedData>;
  }

  export function on(event: 'knockShare', callback: Callback<SharableTarget>): void;

  export function off(event: 'knockShare', callback?: Callback<SharableTarget>): void;

  export function on(event: 'knockShare', capability: SendCapabilityRegistry, callback: Callback<SharableTarget>): void;

  export function off(event: 'knockShare', capability: SendCapabilityRegistry, callback?: Callback<SharableTarget>): void;

  export function on(event: 'dataReceive', capability: RecvCapabilityRegistry, callback: Callback<ReceivableTarget>): void;

  export function off(event: 'dataReceive', capability: RecvCapabilityRegistry, callback?: Callback<ReceivableTarget>): void;
}

export default harmonyShare;