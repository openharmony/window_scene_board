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
import { StaticBaseState } from '../../base/bean/StaticBaseState';
import { BaseObj } from '../../base/constants/BaseType';
import { SlStateId, SlStateProperty, SlViewStaticStPt } from '../constants/SlStateConst';

/**
 * 锁屏组件静态状态基类
 * <T>泛型，标识状态属性集
 */
export class SlViewStaticState<T extends SlStateProperty> extends StaticBaseState {
  protected constructor(name: SlStateId) {
    super(name);
  }

  protected initSetMethods(): void {
  }

  protected initGetMethods(): void {
  }

  public setStateValue(property: SlViewStaticStPt | T, value?: BaseObj): SlViewStaticState<T> {
    return super.setStateValue(property, value) as SlViewStaticState<T>;
  }

  public getStateValue(property: SlViewStaticStPt | T, scene?: BaseObj): BaseObj | undefined {
    return super.getStateValue(property, scene);
  }

  public getStateId(): SlStateId {
    return super.getStateId() as SlStateId;
  }
}