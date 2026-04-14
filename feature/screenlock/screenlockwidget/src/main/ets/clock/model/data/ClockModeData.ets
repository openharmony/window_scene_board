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
import { ISlState, SlSubStateType, SlObject } from '@ohos/screenlockcommon';
import { ClockModeDataType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import { ClockLayout, ClockTextAlign } from '../../../common/WidgetParam';

/**
 * 来自主题的时钟原始数据结构,用于替代AnyClock
 */
@Observed
export class ClockModeData implements ISlState {
  @Track public slStateChangeListener?: ISlStateChangeListener | undefined;
  @Track public widgetStateChangeListener?: ISlStateChangeListener | undefined;
  @Track private setMethods: Map<ClockModeDataType, Function> = new Map(); // 状态赋值函数
  @Track private getMethods: Map<ClockModeDataType, Function> = new Map(); // 状态取值函数
  /**
   * 状态切换监听器集
   */
  @Track private _stateListener?: ISlStateChangeListener | undefined;
  @Track private _layout: ClockLayout = ClockLayout.DEFAULT_CLOCK_LAYOUT;
  @Track private _x: number = 1;
  @Track private _y: number = 0;
  @Track private _alignment: ClockTextAlign = ClockTextAlign.CENTER;
  @Track private _clockStrokeColor: string = '';
  @Track private _clockFontFamily: string = '';
  @Track private _isDof: boolean = false;
  // 景深时钟样式
  @Track private _dofClockLayout?: ClockLayout | undefined = ClockLayout.DEFAULT_CLOCK_LAYOUT;
  // 景深时钟X坐标
  @Track private _dofClockX: number = 0;
  // 景深时钟X坐标
  @Track private _dofClockY: number = 0;
  @Track private _isClockTextShadowEnabled: boolean = true;
  @Track private _isClockTextBlurEffectEnabled: boolean = true;
  @Track private _isClockDateVisible: boolean = true;
  @Track private _isClockLunarVisible: boolean = true;
  @Track private _isClockSignatureVisible: boolean = true;
  @Track private _clockSignatureText: string = '';
  @Track private _clockDegreeNumber: number = 1;
  @Track private _radius: number = 50;
  @Track private _saturation: number = 1.5;
  @Track private _brightness: number = 1.3;
  @Track private _needColor: string = '#59FFFFFF';
  @Track private _isShadow: boolean = true;
  @Track private _isChangeColor: boolean = false;
  @Track private _isLightWallpaper?: boolean | undefined = false;

  getSlStateType(): SlMainStateType {
    return SlMainStateType.SL_CLOCK_MODE_STATE;
  }

  setSlState(subType: ClockModeDataType, value: SlObject): ISlState {
    this.setMethods.get(subType)?.(this, value);
    return this;
  }

  getSlState(subType: ClockModeDataType, scene?: SlObject): SlObject {
    return this.getMethods.get(subType)?.(this, scene);
  }

  public set stateListener(value: ISlStateChangeListener | undefined) {
    this._stateListener = value;
  }

  public get stateListener(): ISlStateChangeListener | undefined {
    return this._stateListener;
  }

  public set layout(value: ClockLayout) {
    if (this._layout !== value) {
      this._layout = value;
      this.notifyStateChange(ClockModeDataType.LAYOUT);
    }
  }

  public get layout(): ClockLayout {
    return this._layout;
  }

  public set x(value: number) {
    if (this._x !== value) {
      this._x = value;
      this.notifyStateChange(ClockModeDataType.POS_X);
    }
  }

  public get x(): number {
    return this._x;
  }

  public set y(value: number) {
    if (this._y !== value) {
      this._y = value;
      this.notifyStateChange(ClockModeDataType.POS_Y);
    }
  }

  public get y(): number {
    return this._y;
  }

  public set alignment(value: ClockTextAlign) {
    if (this._alignment !== value) {
      this._alignment = value;
      this.notifyStateChange(ClockModeDataType.ALIGNMENT);
    }
  }

  public get alignment(): ClockTextAlign {
    return this._alignment;
  }

  public set clockStrokeColor(value: string) {
    if (this._clockStrokeColor !== value) {
      this._clockStrokeColor = value;
      this.notifyStateChange(ClockModeDataType.CLOCK_STROKE_COLOR);
    }
  }

  public get clockStrokeColor(): string {
    return this._clockStrokeColor;
  }

  public set clockFontFamily(value: string) {
    if (this._clockFontFamily !== value) {
      this._clockFontFamily = value;
      this.notifyStateChange(ClockModeDataType.CLOCK_FONT_FAMILY);
    }
  }

  public get clockFontFamily(): string {
    return this._clockFontFamily;
  }

  public set isDof(value: boolean) {
    if (this._isDof !== value) {
      this._isDof = value;
      this.notifyStateChange(ClockModeDataType.IS_DOF);
    }
  }

  public get isDof(): boolean {
    return this._isDof;
  }

  public set dofClockLayout(value: ClockLayout | undefined) {
    if (this._dofClockLayout !== value) {
      this._dofClockLayout = value;
      this.notifyStateChange(ClockModeDataType.DOF_CLOCK_LAYOUT);
    }
  }

  public get dofClockLayout(): ClockLayout | undefined {
    return this._dofClockLayout;
  }


  public set dofClockX(value: number) {
    if (this._dofClockX !== value) {
      this._dofClockX = value;
      this.notifyStateChange(ClockModeDataType.DOF_CLOCK_X);
    }
  }

  public get dofClockX(): number {
    return this._dofClockX;
  }

  public set dofClockY(value: number) {
    if (this._dofClockY !== value) {
      this._dofClockY = value;
      this.notifyStateChange(ClockModeDataType.DOF_CLOCK_Y);
    }
  }

  public get dofClockY(): number {
    return this._dofClockY;
  }

  public set isClockTextShadowEnabled(value: boolean) {
    if (this._isClockTextShadowEnabled !== value) {
      this._isClockTextShadowEnabled = value;
      this.notifyStateChange(ClockModeDataType.IS_CLOCK_TEXT_SHADOW_ENABLED);
    }
  }

  public get isClockTextShadowEnabled(): boolean {
    return this._isClockTextShadowEnabled;
  }

  public set isClockTextBlurEffectEnabled(value: boolean) {
    if (this._isClockTextBlurEffectEnabled !== value) {
      this._isClockTextBlurEffectEnabled = value;
      this.notifyStateChange(ClockModeDataType.IS_CLOCK_TEXT_BLUR_EFFECT_ENABLED);
    }
  }

  public get isClockTextBlurEffectEnabled(): boolean {
    return this._isClockTextBlurEffectEnabled;
  }

  public set isClockDateVisible(value: boolean) {
    if (this._isClockDateVisible !== value) {
      this._isClockDateVisible = value;
      this.notifyStateChange(ClockModeDataType.IS_CLOCK_DATE_VISIBLE);
    }
  }

  public get isClockDateVisible(): boolean {
    return this._isClockDateVisible;
  }

  public set isClockLunarVisible(value: boolean) {
    if (this._isClockLunarVisible) {
      this._isClockLunarVisible = value;
      this.notifyStateChange(ClockModeDataType.IS_CLOCK_LUNAR_VISIBLE);
    }
  }

  public get isClockLunarVisible(): boolean {
    return this._isClockLunarVisible;
  }

  public set isClockSignatureVisible(value: boolean) {
    if (this._isClockSignatureVisible !== value) {
      this._isClockSignatureVisible = value;
      this.notifyStateChange(ClockModeDataType.IS_CLOCK_SIGNATURE_VISIBLE);
    }
  }

  public get isClockSignatureVisible(): boolean {
    return this._isClockSignatureVisible;
  }

  public set clockSignatureText(value: string) {
    if (this.clockSignatureText !== value) {
      this._clockSignatureText = value;
      this.notifyStateChange(ClockModeDataType.CLOCK_SIGNATURE_TEXT);
    }
  }

  public get clockSignatureText(): string {
    return this._clockSignatureText;
  }

  public set clockDegreeNumber(value: number) {
    if (this._clockDegreeNumber !== value) {
      this._clockDegreeNumber = value;
      this.notifyStateChange(ClockModeDataType.CLOCK_DEGREE_NUMBER);
    }
  }

  public get clockDegreeNumber(): number {
    return this._clockDegreeNumber;
  }

  public set radius(value: number) {
    if (this._radius !== value) {
      this._radius = value;
      this.notifyStateChange(ClockModeDataType.RADIUS);
    }
  }

  public get radius(): number {
    return this._radius;
  }

  public set saturation(value: number) {
    if (this._saturation !== value) {
      this._saturation = value;
      this.notifyStateChange(ClockModeDataType.SATURATION);
    }
  }

  public get saturation(): number {
    return this._saturation;
  }


  public set brightness(value: number) {
    if (this._brightness !== value) {
      this._brightness = value;
      this.notifyStateChange(ClockModeDataType.BRIGHTNESS);
    }
  }

  public get brightness(): number {
    return this._brightness;
  }

  public set needColor(value: string) {
    if (this._needColor !== value) {
      this._needColor = value;
      this.notifyStateChange(ClockModeDataType.NEED_COLOR);
    }
  }

  public get needColor(): string {
    return this._needColor;
  }

  public set isShadow(value: boolean) {
    if (this._isShadow !== value) {
      this._isShadow = value;
      this.notifyStateChange(ClockModeDataType.IS_SHADOW);
    }
  }

  public get isShadow(): boolean {
    return this._isShadow;
  }

  public set isChangeColor(value: boolean) {
    if (this._isChangeColor !== value) {
      this._isChangeColor = value;
      this.notifyStateChange(ClockModeDataType.IS_CHANGE_COLOR);
    }
  }

  public get isChangeColor(): boolean {
    return this._isChangeColor;
  }

  public set isLightWallpaper(value: boolean | undefined) {
    if (this._isLightWallpaper !== value) {
      this._isLightWallpaper = value;
      this.notifyStateChange(ClockModeDataType.IS_LIGHT_WALLPAPER);
    }
  }

  public get isLightWallpaper(): boolean | undefined {
    return this._isLightWallpaper;
  }

  private notifyStateChange(subType: ClockModeDataType): void {
    this._stateListener?.onSlStateChange?.(SlMainStateType.SL_CLOCK_MODE_STATE, subType);
  }
}