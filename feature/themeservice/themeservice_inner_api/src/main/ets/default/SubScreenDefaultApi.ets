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

import { CalleeMethodSet, TsLog } from '@ohos/themeservicebase/Index';
import { SubScreenApi } from '../api/SubScreenApi';

const TAG: string = 'SubScreenDefaultApi';

export class SubScreenDefaultApi implements SubScreenApi {
  init(): Promise<void> {
    TsLog.info(TAG, 'Method[init] not implemented.');
    return Promise.resolve();
  }

  removeOnlineThemes(): Promise<void> {
    TsLog.info(TAG, 'Method[removeOnlineThemes] not implemented.');
    return Promise.resolve();
  }

  registerRemoteMethod(methodSet: CalleeMethodSet): void {
    TsLog.info(TAG, 'Method[registerRemoteMethod] not implemented.');
  }
}