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

import { BaseState, SlStateMgr, StateType } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { IImmItemStyleStHelper } from '../../../common/interface/IImmItemStyleStHelper';
import { ImmListItemBaseHelper } from './ImmListItemBaseHelper';

/**
 * 沉浸列表条目样式状态辅助工具基类
 */
export class ImmListItemStyleHelper extends ImmListItemBaseHelper<WidgetStyleStateV2>
implements IImmItemStyleStHelper {
  // 样式后缀
  private readonly _suffix: ListStyleSuffix;

  constructor(mgrName: SlStateMgr, suffix: ListStyleSuffix) {
    super(mgrName);
    this._suffix = suffix;
  }

  /**
   * 复写状态类型，样式类型
   *
   * @returns 状态类型
   */
  protected getStateType(): StateType {
    return StateType.STYLE;
  }

  /**
   * 样式后缀区分
   *
   * @returns 后缀
   */
  protected getStSuffix(): ListStyleSuffix {
    return this._suffix;
  }

  /**
   * 复写创建状态实例，样式实例
   *
   * @param childKey 状态标识
   * @returns 实例
   */
  protected createChildState(childKey: string): WidgetStyleStateV2 {
    return BaseState.wrap(WidgetStyleStateV2, childKey);
  }
}