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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import { ATTRIBUTE_TYPE } from '../FolderCommonConstant';
import { IObserver } from './IObserver';

const TAG: string = 'BaseObserver';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const INVALID_VALUE = 0;

/**
 * 组件observer基类，提供透明度、位移，缩放基础值的更新与查询操作
 */
@ObservedV2
export class BaseObserver implements IObserver {
  /* 透明度 */
  @Trace public opacity: number = NumberConstants.CONSTANT_NUMBER_ONE;
  /* 缩放值 */
  @Trace public scale: number = NumberConstants.CONSTANT_NUMBER_ONE;
  /* X方向缩放值 */
  @Trace public scaleX: number = NumberConstants.CONSTANT_NUMBER_ONE;
  /* Y方向缩放值 */
  @Trace public scaleY: number = NumberConstants.CONSTANT_NUMBER_ONE;
  /* X方向位移值 */
  @Trace public transX: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  /* Y方向位移值 */
  @Trace public transY: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  /* X方向偏移值 */
  @Trace public offsetX: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  /* Y方向偏移值 */
  @Trace public offsetY: number = NumberConstants.CONSTANT_NUMBER_ZERO;

  /**
   * 更新属性
   *
   * @param type 属性类型
   * @param value 更新值
   */
  public setAttribute(type: number, value: number): void {
    switch (type) {
      case ATTRIBUTE_TYPE.OPACITY:
        this.opacity = value;
        break;
      case ATTRIBUTE_TYPE.SCALE_X:
        this.scaleX = value;
        break;
      case ATTRIBUTE_TYPE.SCALE_Y:
        this.scaleY = value;
        break;
      case ATTRIBUTE_TYPE.TRANS_X:
        this.transX = value;
        break;
      case ATTRIBUTE_TYPE.TRANS_Y:
        this.transY = value;
        break;
      case ATTRIBUTE_TYPE.OFFSET_X:
        this.offsetX = value;
        break;
      case ATTRIBUTE_TYPE.OFFSET_Y:
        this.offsetY = value;
        break;
      case ATTRIBUTE_TYPE.SCALE:
        this.scale = value;
        break;
      default:
        log.showError('update attribute for type %{public}d error', type);
        break;
    }
  }

  /**
   * 获取属性值
   *
   * @param type 属性类型
   * @returns
   */
  public getAttribute(type: number): number {
    switch (type) {
      case ATTRIBUTE_TYPE.OPACITY:
        return this.opacity;
      case ATTRIBUTE_TYPE.SCALE_X:
        return this.scaleX;
      case ATTRIBUTE_TYPE.SCALE_Y:
        return this.scaleY;
      case ATTRIBUTE_TYPE.TRANS_X:
        return this.transX;
      case ATTRIBUTE_TYPE.TRANS_Y:
        return this.transY;
      case ATTRIBUTE_TYPE.OFFSET_X:
        return this.offsetX;
      case ATTRIBUTE_TYPE.OFFSET_Y:
        return this.offsetY;
      case ATTRIBUTE_TYPE.SCALE:
        return this.scale;
      default:
        log.showError('get attribute for type %{public}d error', type);
        break;
    }
    return INVALID_VALUE;
  }
}