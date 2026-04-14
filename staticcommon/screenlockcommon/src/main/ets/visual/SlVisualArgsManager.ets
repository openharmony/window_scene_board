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
import { SlVisualArgs } from './SlVisualData';
import { SlVisualSolidUtils } from './SlVisualUtils';
import effectKit from '@ohos.effectKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import CommonConstants, { SlPositionType } from '../constants/CommonConstants';
import lazy { SolidColorAlgorithmUtils } from '@ohos/basicutils/src/main/ets/utils/SolidColorAlgorithmUtils';

const TAG = 'SlBrightnessManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁屏组件视效参数管理
 */
export class SlVisualArgsManager {
  /**
   * 锁屏时钟、卡片等业务视效参数
   */
  private visualArgsMap: Map<SlPositionType, SlVisualArgs> = new Map();

  /**
   * 同一视效参数注册次数计数
   * 组件多个实例重复注册视效参数，计算+1
   */
  private countMap: Map<string, number> = new Map();

  /**
   * 提供给feature层各个模块注册视效参数
   *
   * @param args 视效参数
   * @returns true 对于标识相同的视效参数，只有第一次注册时会返回true
   */
  registerVisualOption(args: SlVisualArgs): boolean {
    if (!args || !args.positionType) {
      log.showWarn('registerBrightOption fail for invalid param');
      return false;
    }

    if (!this.countMap.has(args.positionType)) {
      this.countMap.set(args.positionType, 0);
    }

    let oldCount: number = this.countMap.get(args.positionType) ?? 0;
    // 限制同一个组件视效参数注册的最大次数
    if (oldCount >= CommonConstants.MAX_REGISTER_COUNT) {
      log.showError('registerBrightOption fail for too many times');
      return false;
    }

    this.countMap.set(args.positionType, oldCount + 1);
    this.visualArgsMap.set(args.positionType, args);
    return (this.countMap.get(args.positionType) ?? 0) <= 1;
  }

  /**
   * 注销视效参数
   *
   * @param args 视效参数
   * @returns true 只有对应标识的视效参数个数为0, 表示实际删除了参数时才会返回true
   */
  unregisterVisualOption(args: SlVisualArgs): boolean {
    let key = args.positionType;
    let registerNum: number | undefined = this.countMap.get(key);
    if (!this.hasArgs(key) || registerNum === undefined || registerNum <= 0) {
      return false;
    }
    this.countMap.set(key, registerNum - 1);
    if (this.countMap.get(key) === 0) {
      this.visualArgsMap.delete(key);
      return true;
    } else {
      return false;
    }
  }

  /**
   * 查询视效参数是否已注册
   *
   * @param key 视效参数唯一标识
   * @returns true 已注册
   */
  hasArgs(key: SlPositionType): boolean {
    return this.visualArgsMap.has(key);
  }

  /**
   * 查询所有组件视效参数
   *
   */
  getAllVisualArgs(): Map<SlPositionType, SlVisualArgs> {
    return this.visualArgsMap;
  }

  /**
   * 查询组件视效参数
   *
   * @param key 参数唯一标识
   * @returns 视效参数
   */
  getVisualArgs(key: SlPositionType): SlVisualArgs | undefined {
    return this.visualArgsMap.get(key);
  }

  /**
   * 更新计算的纯色
   *
   * @param key 纯色参数唯一标识
   * @param color 计算的纯色
   * @param isLight true 浅色背景，需要压暗
   */
  updateBrightColor(key: SlPositionType, color: effectKit.Color, isLight: boolean): void {
    let args = this.getVisualArgs(key);
    if (!args || !color) {
      return;
    }
    let newBrightColor = SolidColorAlgorithmUtils.calSolidColor(args.brightness, color);
    let newDarkColor = SolidColorAlgorithmUtils.calSolidColor(args.darkness, color);
    args.brightColor = SlVisualSolidUtils.getColorString(newBrightColor);
    args.darkColor = SlVisualSolidUtils.getColorString(newDarkColor);
    args.needBright = !isLight;
  }
}