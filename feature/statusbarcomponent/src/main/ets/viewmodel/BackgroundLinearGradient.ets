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

const TAG = 'BackgroundLinearGradient';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
/**
 * 背景渐变类型
 */
export enum LinearGradientType {
  NONE, // 无渐变
  BLACK, // 黑色透明度渐变
  WHITE // 白色透明度渐变
}

/*
黑色透明度渐变
 */
const BLACK_LINEAR_GRADIENT: [ResourceColor, number][] =
  [['rgba(0, 0, 0, 0.15)', 0], ['rgba(0, 0, 0, 0.08)', 0.4], ['rgba(0, 0, 0, 0.0)', 1]];
/*
白色透明度渐变
 */
const WHITE_LINEAR_GRADIENT: [ResourceColor, number][] =
  [['rgba(255, 255, 255, 0.15)', 0], ['rgba(255, 255, 255, 0.08)', 0.4], ['rgba(255, 255, 255, 0.0)', 1]];
/*
无渐变
 */
const NONE_LINEAR_GRADIENT: [ResourceColor, number][] =
  [['rgba(255, 255, 255, 0.0)', 0], ['rgba(255, 255, 255, 0.0)', 0.4], ['rgba(255, 255, 255, 0.0)', 1]];

/**
 * 渐变类型和渐变参数取值的对应关系表
 */
const LINEAR_GRADIENT_TYPE_COLORS_MAP: Map<LinearGradientType, [ResourceColor, number][]> = new Map([
  [LinearGradientType.NONE, NONE_LINEAR_GRADIENT],
  [LinearGradientType.BLACK, BLACK_LINEAR_GRADIENT],
  [LinearGradientType.WHITE, WHITE_LINEAR_GRADIENT],
]);
/* 渐变角度 */
const LINEAR_GRADIENT_ANGLE: number = 180;

@Observed
export class BackgroundLinearGradient {
  private linearGradientType: LinearGradientType = LinearGradientType.NONE;

  /**
   * 获取背景渐变色类型
   *
   * @returns
   */
  public getLinearGradientType(): LinearGradientType {
    return this.linearGradientType;
  }

  /*
  设置背景渐变色类型
   */
  public setLinearGradientType(linearGradientType: LinearGradientType) {
    this.linearGradientType = linearGradientType;
  }

  /**
   * 获取背景渐变色角度参数数值
   *
   * @returns 渐变色角度参数数值
   */
  public getLinearGradientColors(): [ResourceColor, number][] {
    let colors: [ResourceColor, number][] | undefined = LINEAR_GRADIENT_TYPE_COLORS_MAP.get(this.linearGradientType);
    if (colors === undefined) {
      log.showInfo(`linear gradient type(${this.linearGradientType}) is invalid, so return no colors.`);
      colors = NONE_LINEAR_GRADIENT;
    }

    return colors;
  }

  /**
   * 获取背景渐变色角度参数数值
   *
   * @returns 渐变色角度参数数值
   */
  public getLinearGradientAngle(): number {
    return LINEAR_GRADIENT_ANGLE;
  }
}
