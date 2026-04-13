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

import { ImmDataType } from '../../../common/ImmersiveConstants';
import { ImmBaseData } from './ImmBaseData';

/**
 * 沉浸列表数据结构
 */
@ObservedV2
export class ImmListData extends ImmBaseData<ImmListData> {
  /**
   * 标示列表类型
   *
   * @returns 列表类型
   */
  protected getImmDataType(): ImmDataType {
    return ImmDataType.DATA_LIST;
  }

  /**
   * 新实例
   *
   * @returns 新实例
   */
  protected createNewData(): ImmListData {
    return new ImmListData(this._oriData);
  }

  /**
   * 获取简略主文本
   *
   * @returns 简略文本
   */
  @Computed get mainContent(): ResourceStr {
    return this.getPrivacyContentText(this._childrenCount) ?? '';
  }
}