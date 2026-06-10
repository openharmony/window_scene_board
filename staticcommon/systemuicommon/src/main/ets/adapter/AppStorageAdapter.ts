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

import lazy { AppStorageUtil, DataProperty } from '@ohos/basicutils';
import { threadCall } from '../messageChannel/ThreadCall';

export class AppStorageAdapter {

  @threadCall()
  public static setOrCreate<T>(propName: string, newValue: T): void | Promise<void> {
    AppStorageUtil.setOrCreate(propName, newValue, new DataProperty(true, false));
  }

  @threadCall()
  public static get<T>(propName: string): T | undefined | Promise<T> {
    return AppStorage.get<T>(propName);
  }
}