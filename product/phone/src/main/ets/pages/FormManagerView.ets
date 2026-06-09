/**
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

import { StyleConstants } from '@ohos/launchercommon';
import { Log } from '@ohos/basicutils';

const TAG = 'FormManagerView';

@Entry
@Component
struct FormManagerView {
  onPageShow(): void {
    Log.showInfo(TAG, 'onPageShow');
  }

  onPageHide(): void {
    Log.showInfo(TAG, `onPageHide`);
  }

  onBackPress(): boolean {
    Log.showInfo(TAG, 'onBackPress');
    AppStorage.setOrCreate('formManageExitAnimate', true);
    AppStorage.setOrCreate('formManagerShowFrom', '');
    AppStorage.setOrCreate('formManageShow', false);
    return true;
  }

  build() {
      Column() {
      }
      .width(StyleConstants.DEFAULT_LAYOUT_PERCENTAGE)
      .height(StyleConstants.DEFAULT_LAYOUT_PERCENTAGE)
  }
}