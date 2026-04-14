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
import { StateType } from '../constants/BaseType';
import { WidgetPropertyState } from './WidgetPropertyState';

/**
 * 组件样式状态基类
 */
@Observed
export class WidgetStyleState extends WidgetPropertyState<WidgetStyleState> {
  protected getTarInstance(): WidgetStyleState {
    return this;
  }

  /**
   * 复写IBaseState，状态类型
   *
   * @returns 状态类型
   */
  public getStateType(): StateType {
    return StateType.STYLE;
  }
}