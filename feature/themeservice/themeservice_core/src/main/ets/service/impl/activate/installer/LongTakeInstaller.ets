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
import { TARGET_LONG_TAKE, ThemeInfo } from '@ohos/themeservice_inner_api/Index';
import { ResourceBasicInstaller } from './ResourceBasicInstaller';

export class LongTakeInstaller extends ResourceBasicInstaller {
  constructor(themeInfo: ThemeInfo) {
    super(TARGET_LONG_TAKE, themeInfo);
  }

  protected overlayMode(): boolean {
    if (super.getThemeTypeCustomPath()) {
      return false;
    }
    return true;
  }
}