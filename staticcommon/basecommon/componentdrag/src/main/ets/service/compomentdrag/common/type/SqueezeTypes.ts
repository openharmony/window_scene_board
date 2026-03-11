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
import { SqueezeEngineChain } from '../../squeeze/engine/SqueezeEngineChain';
import { DragCallbackParams, DragGridItem, DragGridPosition } from './CommonTypes';

/**
 * 挤位引擎类型
 *
 * @since 2024/03/12
 */
export enum SqueezeEngineType {
  FORWARD_SINGLE_ITEM_SQUEEZE = 'FORWARD_SINGLE_ITEM_SQUEEZE',
  BACKWARD_SINGLE_ITEM_SQUEEZE = 'BACKWARD_SINGLE_ITEM_SQUEEZE',
  AUTO_SINGLE_ITEM_SQUEEZE = 'AUTO_SINGLE_ITEM_SQUEEZE',
  MULTI_ITEM_SQUEEZE = 'MULTI_ITEM_SQUEEZE',
}

/**
 * 挤位检查器的返回结果
 *
 * @since 2024/03/12
 */
export enum SqueezeCheckResult {
  SQUEEZE = 0,
  COMBINE = 1,
  MOVE = 2,
  ERROR = 3,
}

/**
 * 挤位结果
 */
export interface SqueezeResult {
  /**
   * 起始宫格位置
   */
  origin: DragGridPosition;

  /**
   * 目标宫格位置
   */
  target: DragGridPosition;
}

/**
 * 挤位管理模块入参
 *
 * @since 2024/03/12
 */
export interface SqueezeParams {
  /**
   * 挤位引擎责任链
   */
  squeezeEngineChain?: SqueezeEngineChain;

  /**
   * 被拖ITEM下一步操作回调
   *
   * @param callbackParam 通用回调参数
   * @param coveredItem 被覆盖元素
   * @returns 操作结果，如挤位、合并
   */
  itemCheckCallback?: (callbackParam: DragCallbackParams, coveredItem: DragGridItem) => SqueezeCheckResult;

  /**
   * 被拖ITEM移动回调
   *
   * @param callbackParam 通用回调参数
   * @param coveredItem 被覆盖元素
   */
  itemMoveCallback?: (callbackParam: DragCallbackParams, coveredItem: DragGridItem) => void;

  /**
   * 被拖ITEM合并回调
   *
   * @param callbackParam 通用回调参数
   * @param coveredItem 被覆盖元素
   */
  itemCombineCallback?: (callbackParam: DragCallbackParams, coveredItem: DragGridItem) => void;

  /**
   * 取消合并的回调
   *
   * @param callbackParam 通用回调参数
   * @param coveredItem 被覆盖元素
   */
  itemCancelCombineCallback?: (callbackParam: DragCallbackParams, coveredItem: DragGridItem) => void;

  /**
   * 被拖ITEM挤位回调
   *
   * @param callbackParam 通用回调参数
   * @param squeezeResult 挤位结果
   */
  itemSqueezeCallback?: (callbackParam: DragCallbackParams, squeezeResult: Map<DragGridItem, SqueezeResult>) => void;

  /**
   * 取消挤位的回调
   *
   * @param callbackParam 通用回调参数
   * @param squeezeResult 挤位结果
   */
  itemCancelSqueezeCallback?: (callbackParam: DragCallbackParams, squeezeResult: Map<DragGridItem, SqueezeResult>)
  => void;
}