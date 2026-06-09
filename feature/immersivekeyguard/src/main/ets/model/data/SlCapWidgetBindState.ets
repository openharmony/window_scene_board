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

import { WidgetBindState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { CapWgBindStateType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';

/**
 * 锁屏组件，沉浸胶囊组件UI绑定状态
 *
 */
@Observed
export class SlCapWidgetBindState extends WidgetBindState<CapWgBindStateType> {
  /**
   * 背景色
   */
  @Track private capBackgroundColor?: ResourceColor;
  /**
   * 提亮参数
   */
  @Track private brightnessOptions?: BrightnessOptions;

  /**
   * 透明度
   */
  @Track private alpha?: number;

  /**
   * 缩放参数
   */
  @Track private capScale?: number;

  /**
   * 通知列表是否会与指纹重叠
   */
  @Track private isNtfFingerprintConflict: boolean = false;

  // 壁纸反色，是否压暗处理
  @Track private _isCapDarkMode: boolean = false;

  constructor() {
    super(SlMainStateType.SL_CAP_WG_BIND_STATE);
  }

  /**
   * 复写WidgetBindState
   *
   */
  protected initSetMethods(): void {
    super.initSetMethods();
    this.setMethods.set(CapWgBindStateType.BACKGROUND_COLOR, this.setMethodBackgroundColor);
    this.setMethods.set(CapWgBindStateType.BRIGHTNESS, this.setMethodBrightness);
    this.setMethods.set(CapWgBindStateType.CAPSULE_ALPHA, this.setMethodAlpha);
    this.setMethods.set(CapWgBindStateType.CAPSULE_SCALE, this.setMethodScale);
    this.setMethods.set(CapWgBindStateType.CAPSULE_CONFLICT,
      (st: SlCapWidgetBindState, value: boolean) => st.setNtfFingerprintConflict(value));
  }

  private setMethodBackgroundColor(st: SlCapWidgetBindState, value: ResourceColor): void {
    st.setBackgroundColor(value);
  }

  private setMethodBrightness(st: SlCapWidgetBindState, value: BrightnessOptions): void {
    st.setBrightness(value);
  }

  private setMethodAlpha(st: SlCapWidgetBindState, value: number): void {
    st.setAlpha(value);
  }

  private setMethodScale(st: SlCapWidgetBindState, value: number): void {
    st.setScale(value);
  }

  private getMethodBackgroundColor(st: SlCapWidgetBindState): ResourceColor | undefined {
    return st.getBackgroundColor();
  }

  private getMethodBrightness(st: SlCapWidgetBindState): BrightnessOptions | undefined {
    return st.getBrightness();
  }

  private getMethodAlpha(st: SlCapWidgetBindState): number | undefined {
    return st.getAlpha();
  }

  private getMethodScale(st: SlCapWidgetBindState): number | undefined {
    return st.getScale();
  }

  private getMethodDarkMode(st: SlCapWidgetBindState): boolean {
    return st.isCapDarkMode();
  }

  /**
   * 复写WidgetBindState
   *
   */
  protected initGetMethods(): void {
    super.initGetMethods();
    this.getMethods.set(CapWgBindStateType.BACKGROUND_COLOR, this.getMethodBackgroundColor);
    this.getMethods.set(CapWgBindStateType.BRIGHTNESS, this.getMethodBrightness);
    this.getMethods.set(CapWgBindStateType.CAPSULE_ALPHA, this.getMethodAlpha);
    this.getMethods.set(CapWgBindStateType.CAPSULE_SCALE, this.getMethodScale);
    this.getMethods.set(CapWgBindStateType.PT_CAP_DARK_MODE, this.getMethodDarkMode);
    this.getMethods.set(CapWgBindStateType.CAPSULE_CONFLICT,
      (st: SlCapWidgetBindState): boolean => st.getNtfFingerprintConflict());
  }

  /**
   * 设置沉浸胶囊背景色
   *
   */
  public setBackgroundColor(color: ResourceColor): SlCapWidgetBindState {
    if (this.capBackgroundColor !== color) {
      this.capBackgroundColor = color;
    }
    return this;
  }

  /**
   * 获取沉浸胶囊背景色
   *
   */
  public getBackgroundColor(): ResourceColor | undefined {
    return this.capBackgroundColor;
  }

  /**
   * 设置沉浸胶囊提亮参数
   *
   */
  public setBrightness(options: BrightnessOptions): SlCapWidgetBindState {
    if (this.brightnessOptions !== options) {
      this.brightnessOptions = options;
    }
    return this;
  }

  /**
   * 获取沉浸胶囊提亮参数
   *
   */
  public getBrightness(): BrightnessOptions | undefined {
    return this.brightnessOptions;
  }

  /**
   * 设置胶囊透明度
   *
   */
  public setAlpha(alpha: number): SlCapWidgetBindState {
    if (this.alpha !== alpha) {
      this.alpha = alpha;
    }
    return this;
  }

  /**
   * 获取胶囊缩放参数
   *
   */
  public getAlpha(): number | undefined {
    return this.alpha;
  }

  /**
   * 设置胶囊缩放参数
   *
   */
  public setScale(scale: number): SlCapWidgetBindState {
    if (this.capScale !== scale) {
      this.capScale = scale;
    }
    return this;
  }

  /**
   * 获取胶囊缩放参数
   *
   */
  public getScale(): number | undefined {
    return this.capScale;
  }

  /**
   * 设置通知与指纹是否重叠
   *
   */
  public setNtfFingerprintConflict(isConflict: boolean): SlCapWidgetBindState {
    if (this.isNtfFingerprintConflict !== isConflict) {
      this.isNtfFingerprintConflict = isConflict;
    }
    return this;
  }

  /**
   * 获取通知与指纹是否重叠
   *
   */
  public getNtfFingerprintConflict(): boolean {
    return this.isNtfFingerprintConflict;
  }

  public setCapDarkMode(isDark?: boolean): SlCapWidgetBindState {
    let result = isDark ?? false;
    if (this._isCapDarkMode !== result) {
      this._isCapDarkMode = result;
      this.notifyStateChange(CapWgBindStateType.PT_CAP_DARK_MODE);
    }
    return this;
  }

  public isCapDarkMode(): boolean {
    return this._isCapDarkMode;
  }
}