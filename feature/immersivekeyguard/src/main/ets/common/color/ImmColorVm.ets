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

import { SystemUIColorVm } from '@ohos/systemuicommon/newIndex';

/**
 * 通知列表颜色控制
 */
export class ImmColorVm extends SystemUIColorVm {
  private static sInstance?: ImmColorVm;
  // 是否已初始化
  private hasInit: boolean = false;

  public init(): void {
    if (this.hasInit) {
      return;
    }
    this.hasInit = true;
    super.init();
  }

  /**
   * 单例
   */
  public static getInstance(): ImmColorVm {
    if (!ImmColorVm.sInstance) {
      ImmColorVm.sInstance = new ImmColorVm();
    }
    return ImmColorVm.sInstance;
  }
}