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

import vibrator from '@ohos.vibrator';
import { LogDomain, Logger } from '@ohos/basicutils';
import { CommonConstants } from '../constants/CommonConstants';
import { vibratorMgr } from './VibratorManager';

const TAG = 'DesktopItemVibratorManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

const DEFAULT_EFFECT_ID: string = CommonConstants.VIBRATION_EFFECT_MEDIUM;
const DEFAULT_USAGE_TYPE: vibrator.Usage = CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS;

/**
 * 桌面元素长按振动的管理类
 */
export class DesktopItemVibratorManager {
  private static instance: DesktopItemVibratorManager;
  private effectId: string = DEFAULT_EFFECT_ID;

  /**
   * 获取管理类的单例对象
   *
   * @returns 管理类的单例对象
   */
  public static getInstance(): DesktopItemVibratorManager {
    if (!DesktopItemVibratorManager.instance) {
      DesktopItemVibratorManager.instance = new DesktopItemVibratorManager();
    }
    return DesktopItemVibratorManager.instance;
  }

  /**
   * 修改桌面元素长按振动效果
   *
   * @param effectId 振动效果字符串
   * @param tag 修改振动效果的来源
   */
  public setEffectId(effectId: string, tag: string): void {
    log.showInfo(TAG, `effectId change to ${effectId} by ${tag}`);
    this.effectId = effectId;
  }

  /**
   * 获取桌面元素长按振动效果
   *
   * @returns 振动效果字符串
   */
  public getEffectId(): string {
    return this.effectId;
  }

  /**
   * 重置桌面元素长按振动效果
   */
  public resetEffectId(): void {
    log.showInfo(TAG, 'reset effectId to default effect');
    this.effectId = DEFAULT_EFFECT_ID;
  }

  /**
   * 桌面元素长按振动
   *
   * @param tag 振动来源标志
   * @param effectId 可选自定义长按振动效果
   */
  public longPressVibrator(tag: string, effectId?: string): void {
    let finalEffect: string = effectId ?? this.effectId;
    log.showInfo(TAG, `trigger long press vibration with ${finalEffect} by ${tag}`);
    vibratorMgr.startVibration(finalEffect, DEFAULT_USAGE_TYPE, tag);
  }
}