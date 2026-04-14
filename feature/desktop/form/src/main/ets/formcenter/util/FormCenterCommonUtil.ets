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

import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import { SearchState, SearchStateMgr } from '../view/atomicview/SearchComponent';

const TAG: string = 'FormCenterCommonUtil';
const log: Logger = Logger.getLogHelper(LogDomain.FORM);

export class FormCenterCommonUtil {
  public static clearSearchFocus(context: UIContext): void {
    if (SearchStateMgr.getInstance().getState() !== SearchState.FOCUSED) {
      log.showDebug(TAG, 'search component not focused, no need clear');
      return;
    }

    try {
      context.getFocusController().clearFocus();
    } catch (error) {
      log.showError(TAG, `clearFocus failed, code :${error?.code}, message :${error?.message}`);
    }
  }
}