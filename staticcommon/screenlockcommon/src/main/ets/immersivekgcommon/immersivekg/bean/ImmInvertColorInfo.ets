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
// 反色使用颜色
export enum InvertColor {
  COLOR_WHITE = '#FFFFFF',
  COLOR_BLACK = '#000000',
}

/**
 * 沉浸态反色信息
 */
export class ImmInvertColorInfo {
  // 反色生效时，状态栏内容颜色
  private _sbContentColor?: InvertColor = InvertColor.COLOR_WHITE;

  // 反色生效时，状态栏渐变背景是否开启
  private _isSbBgGradientEnable: boolean = false;

  // 反色生效时，沉浸态返回按钮颜色
  private _immBackBtnColor: InvertColor = InvertColor.COLOR_WHITE;

  /**
   * 赋值状态栏内容反色颜色
   *
   * @param color 反色颜色
   * @returns true值修改
   */
  public setSbContentColor(color?: InvertColor): boolean {
    if (this._sbContentColor !== color) {
      this._sbContentColor = color;
      return true;
    }
    return false;
  }

  /**
   * 取值状态栏内容反色颜色
   *
   * @returns 反色颜色
   */
  public getSbContentColor(): InvertColor | undefined {
    return this._sbContentColor;
  }

  /**
   * 赋值状态栏渐变背景开关
   *
   * @param isEnable true开启状态栏渐变背景
   * @returns true值修改
   */
  public setSbBgGradientEnable(isEnable: boolean): boolean {
    if (this._isSbBgGradientEnable !== isEnable) {
      this._isSbBgGradientEnable = isEnable;
      return true;
    }
    return false;
  }

  /**
   * 状态栏渐变背景是否开启
   *
   * @returns true状态栏渐变背景开启
   */
  public isSbBgGradientEnable(): boolean {
    return this._isSbBgGradientEnable;
  }

  /**
   * 赋值沉浸态返回按钮反色颜色
   *
   * @param color 反色颜色
   * @returns true值修改
   */
  public setImmBackBtnColor(color?: InvertColor): boolean {
    let result = color ?? InvertColor.COLOR_WHITE;
    if (this._immBackBtnColor !== result) {
      this._immBackBtnColor = result;
      return true;
    }
    return false;
  }

  /**
   * 取值沉浸态返回按钮反色颜色
   *
   * @returns 反色颜色
   */
  public getImmBackBtnColor(): InvertColor {
    return this._immBackBtnColor;
  }

  /**
   * 返回按钮是否使用白色
   *
   * @returns true白色按钮
   */
  public isBtnColorWhite(): boolean {
    return this._immBackBtnColor === InvertColor.COLOR_WHITE;
  }
}