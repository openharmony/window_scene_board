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

/**
 * VisionGlassExtService定义的回调接口
 */
export default interface IIdlVisionGlassExtServiceCallback {
  onEventChange(event: string, data: string, callback: onEventChangeCallback): void;
}

export type onEventChangeCallback = (errCode: number, data: string) => void;

export const EMPTY_STRING: string = '';

export const WRITE_STRING_MAX_SIZE: number = 12;

export const COMMAND_ON_EVENT_CHANGE: number = 1;

export const SLICE_NUMBER: number = 10000;

export const WRITE_STRING_CAPACITY: number = 480 * 1024;

export const WRITE_STRING_THRESHOLD: number = 5;