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
import { WidgetAnimStateV2 } from '@ohos/screenlockcommon/Index';
import { CardAnimSuffix } from '../../../common/constants/ImmCardConst';
import { ICardItemAnimStHelper } from '../../../common/interface/ICardItemAnimStHelper';
import { ImmCardItemBaseHelper } from './ImmCardItemBaseHelper';

/**
 * 沉浸胶囊条目动效状态辅助工具基类
 */
export class ImmCardItemAnimHelper extends ImmCardItemBaseHelper<WidgetAnimStateV2>
  implements ICardItemAnimStHelper {
  // 动效后缀
  private readonly _suffix: CardAnimSuffix;

  constructor(mgrName: SlStateMgr, suffix: CardAnimSuffix) {
    super(mgrName);
    this._suffix = suffix;
  }

  /**
   * 复写状态类型，动效类型
   *
   * @returns 状态类型
   */
  protected getStateType(): StateType {
    return StateType.ANIM;
  }

  /**
   * 动效后缀区分
   *
   * @returns 后缀
   */
  protected getStSuffix(): CardAnimSuffix {
    return this._suffix;
  }

  /**
   * 复写创建状态实例，动效实例
   *
   * @param childKey 状态标识
   * @returns 实例
   */
  protected createChildState(childKey: string): WidgetAnimStateV2 {
    return BaseState.wrap(WidgetAnimStateV2, childKey);
  }
}