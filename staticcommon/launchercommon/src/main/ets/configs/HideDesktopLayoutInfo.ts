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

import { HideAppAutoAlignStatus } from '@ohos/commonconstants/src/main/ets/constants/Constants';
import { BaseBundleInfo } from '../bean/BaseBundleInfo';

export default class HideAppsInfo {
  public hideAppsBundleInfo: BaseBundleInfo[] = [];
  public autoAlignStatus: HideAppAutoAlignStatus;

  public constructor() {
    // 隐藏应用后是否自动补齐桌面布局，0（不补齐） 取值1（默认补齐）
    this.autoAlignStatus = HideAppAutoAlignStatus.AUTO_ALIGN;
  }
};
