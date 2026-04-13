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

import { ToggleBaseViewModel } from '../vm/ToggleBaseViewModel';

/**
 * 开关模版
 * BASIC: 1*1开关，由两部分组成，上面为圆形按钮，下面为按钮标签
 * TAGGED： 1*2开关，由两部分组成，左边为圆形按钮，右边为按钮的附加信息，例如wifi名称等
 */
export enum ToggleTemplateType {
  BASIC,
  TAGGED
}

/**
 * 开关的使用场景
 * PHONE： 直板机，或者单折叠屏展开态
 * SINGLE_FOLD_OUTER_SCREEN：单折叠外屏
 * PC：PC
 */
export enum ToggleScene {
  PHONE,
  SINGLE_FOLD_OUTER_SCREEN,
  PC
}

/**
 * 开关样式
 * toggleParam： 创建开关UI所需的静态参数，不会伴随业务逻辑变化而变化
 * eventHandler：点击或者长按开关的处理逻辑，衔接开关的viewModel
 * attributes： 开关的差异化属性，如阴影等
 */
export class ToggleStyle {
  public toggleParam?: ToggleParam;
  public eventHandler?: EventHandler;
  public attributes?: AttributeModifier<StackAttribute | RowAttribute>;

  constructor(toggleParam?: ToggleParam, eventHandler?: EventHandler,
    attributes?: AttributeModifier<StackAttribute | RowAttribute>) {
    this.toggleParam = toggleParam;
    this.eventHandler = eventHandler;
    this.attributes = attributes;
  }
}

/**
 * 创建开关UI所需的静态参数，不会伴随业务逻辑变化而变化，如需跟随业务逻辑变化而触发UI刷新，请添加至../vm/ToggleViewData.ets
 */
export class ToggleParam {
  // 规格
  private _hasLabel: boolean = true;
  private _hasSubLabel: boolean = false;

  // label part
  private _labelFocusable?: boolean;
  private _labelHeight?: Length;
  private _labelWidth?: Length;
  private _subLabelOpacity?: number;
  private _subLabelMaxLines?: number;
  private _labelForegroundBrightness?: BrightnessOptions;
  private _labelWordBreak?: WordBreak;
  private _labelConstraintSize?: ConstraintSizeOptions;
  private _labelAlign?: TextAlign;
  private _fontSize?: string | number | Resource;
  private _fontWeight?: string | number | FontWeight;
  private _fontLineHeight?: number;
  private _fontColor?: ResourceColor;
  private _maxFontSize?: number | string | Resource;
  private _minFontSize?: number | string | Resource;
  private _labelPadding?: Padding | Length | LocalizedPadding;
  private _labelArrow?: boolean;

  // Circular Switch Part
  // lottie
  private _hasLottieEffect?: boolean;
  private _canvasDiameter?: Length;

  // Symbol
  private _isSymbolIcon?: boolean;
  private _symbolFontWeight?: number | FontWeight | string;
  private _symbolRendering?: SymbolRenderingStrategy;
  private _symbolEffect?: SymbolEffect;
  private _symbolTriggerValue?: number;

  // icon
  private _iconFocusable?: boolean;
  private _iconDiameter?: Length;
  private _iconBgDiameter?: Length;
  private _iconBgBorderRadius?: Length;
  private _iconBgPointLight?: PointLightStyle;
  private _iconBgBrightness?: BrightnessOptions;
  private _iconFocusBoxStrokeWidth?: LengthMetrics;

  // Whole toggle
  private _bgWidth?: Length;
  private _bgHeight?: Length;
  private _iconLabelPadding?: Padding | Length | LocalizedPadding;
  private _bgPointLight?: PointLightStyle;
  private _bgBorderWidth?: Length;
  private _bgBorderColor?: ResourceColor;
  private _bgBrightness?: BrightnessOptions;
  private _geometryTransitionId?: string;
  private _isSupportRTL?: boolean;

  // dialogComponent
  private _dialogComponent?: CustomBuilder;

  public hasLabel(value: boolean): ToggleParam {
    this._hasLabel = value;
    return this;
  }

  public getHasLabel(): boolean {
    return this._hasLabel;
  }

  public hasSubLabel(value: boolean): ToggleParam {
    this._hasSubLabel = value;
    return this;
  }

  public getHasSubLabel(): boolean {
    return this._hasSubLabel;
  }

  public labelFocusable(value: boolean | undefined): ToggleParam {
    this._labelFocusable = value;
    return this;
  }

  public getLabelFocusable(): boolean | undefined {
    return this._labelFocusable;
  }

  public labelWordBreak(value: WordBreak | undefined): ToggleParam {
    this._labelWordBreak = value;
    return this;
  }

  public getLabelWordBreak(): WordBreak | undefined {
    return this._labelWordBreak;
  }

  public labelHeight(value: Length | undefined): ToggleParam {
    this._labelHeight = value;
    return this;
  }

  public getLabelHeight(): Length | undefined {
    return this._labelHeight;
  }

  public labelWidth(value: Length | undefined): ToggleParam {
    this._labelWidth = value;
    return this;
  }

  public getLabelWidth(): Length | undefined {
    return this._labelWidth;
  }

  public subLabelOpacity(value: number | undefined): ToggleParam {
    this._subLabelOpacity = value;
    return this;
  }

  public getSubLabelOpacity(): number | undefined {
    return this._subLabelOpacity;
  }

  public subLabelMaxLines(value: number | undefined): ToggleParam {
    this._subLabelMaxLines = value;
    return this;
  }

  public getSubLabelMaxLines(): number | undefined {
    return this._subLabelMaxLines;
  }

  public fontSize(value: string | number | Resource | undefined): ToggleParam {
    this._fontSize = value;
    return this;
  }

  public getFontSize(): string | number | Resource | undefined {
    return this._fontSize;
  }

  public fontWeight(value: string | number | FontWeight | undefined): ToggleParam {
    this._fontWeight = value;
    return this;
  }

  public getFontWeight(): string | number | FontWeight | undefined {
    return this._fontWeight;
  }

  public fontLineHeight(value: number | undefined): ToggleParam {
    this._fontLineHeight = value;
    return this;
  }

  public getFontLineHeight(): number | undefined {
    return this._fontLineHeight;
  }

  public fontColor(value: ResourceColor | undefined): ToggleParam {
    this._fontColor = value;
    return this;
  }

  public getFontColor(): ResourceColor | undefined {
    return this._fontColor;
  }

  public maxFontSize(value: number | string | Resource | undefined): ToggleParam {
    this._maxFontSize = value;
    return this;
  }

  public getMaxFontSize(): number | string | Resource | undefined {
    return this._maxFontSize;
  }

  public minFontSize(value: number | string | Resource | undefined): ToggleParam {
    this._minFontSize = value;
    return this;
  }

  public getMinFontSize(): number | string | Resource | undefined {
    return this._minFontSize;
  }

  public labelPadding(value: Padding | Length | LocalizedPadding | undefined): ToggleParam {
    this._labelPadding = value;
    return this;
  }

  public getLabelPadding(): Padding | Length | LocalizedPadding | undefined {
    return this._labelPadding;
  }

  public labelArrow(value: boolean | undefined): ToggleParam {
    this._labelArrow = value;
    return this;
  }

  public getLabelArrow(): boolean | undefined {
    return this._labelArrow;
  }

  public labelConstraintSize(value: ConstraintSizeOptions | undefined): ToggleParam {
    this._labelConstraintSize = value;
    return this;
  }

  public getLabelConstraintSize(): ConstraintSizeOptions | undefined {
    return this._labelConstraintSize;
  }

  public hasLottieEffect(value: boolean | undefined): ToggleParam {
    this._hasLottieEffect = value;
    return this;
  }

  public getHasLottieEffect(): boolean | undefined {
    return this._hasLottieEffect;
  }

  public canvasDiameter(value: Length | undefined): ToggleParam {
    this._canvasDiameter = value;
    return this;
  }

  public getCanvasDiameter(): Length | undefined {
    return this._canvasDiameter;
  }

  public isSymbolIcon(value: boolean | undefined): ToggleParam {
    this._isSymbolIcon = value;
    return this;
  }

  public getIsSymbolIcon(): boolean | undefined {
    return this._isSymbolIcon;
  }

  public symbolFontWeight(value: number | FontWeight | string | undefined): ToggleParam {
    this._symbolFontWeight = value;
    return this;
  }

  public getSymbolFontWeight(): number | FontWeight | string | undefined {
    return this._symbolFontWeight;
  }

  public symbolRendering(value: SymbolRenderingStrategy | undefined): ToggleParam {
    this._symbolRendering = value;
    return this;
  }

  public getSymbolRendering(): SymbolRenderingStrategy | undefined {
    return this._symbolRendering;
  }

  public symbolEffect(value: SymbolEffect | undefined): ToggleParam {
    this._symbolEffect = value;
    return this;
  }

  public getSymbolEffect(): SymbolEffect | undefined {
    return this._symbolEffect;
  }

  public symbolTriggerValue(value: number | undefined): ToggleParam {
    this._symbolTriggerValue = value;
    return this;
  }

  public getSymbolTriggerValue(): number | undefined {
    return this._symbolTriggerValue;
  }

  public isSupportRTL(value: boolean | undefined): ToggleParam {
    this._isSupportRTL = value;
    return this;
  }

  public getIsSupportRTL(): boolean | undefined {
    return this._isSupportRTL;
  }

  public iconFocusable(value: boolean | undefined): ToggleParam {
    this._iconFocusable = value;
    return this;
  }

  public getIconFocusable(): boolean | undefined {
    return this._iconFocusable;
  }

  public iconDiameter(value: Length | undefined): ToggleParam {
    this._iconDiameter = value;
    return this;
  }

  public getIconDiameter(): Length | undefined {
    return this._iconDiameter;
  }

  public iconBgDiameter(value: Length | undefined): ToggleParam {
    this._iconBgDiameter = value;
    return this;
  }

  public getIconBgDiameter(): Length | undefined {
    return this._iconBgDiameter;
  }

  public iconBgBorderRadius(value: Length | undefined): ToggleParam {
    this._iconBgBorderRadius = value;
    return this;
  }

  public getIconBgBorderRadius(): Length | undefined {
    return this._iconBgBorderRadius;
  }

  public iconBgPointLight(value: PointLightStyle | undefined): ToggleParam {
    this._iconBgPointLight = value;
    return this;
  }

  public getIconBgPointLight(): PointLightStyle | undefined {
    return this._iconBgPointLight;
  }

  public iconFocusBoxStrokeWidth(value: LengthMetrics | undefined): ToggleParam {
    this._iconFocusBoxStrokeWidth = value;
    return this;
  }

  public getIconFocusBoxStrokeWidth(): LengthMetrics | undefined {
    return this._iconFocusBoxStrokeWidth;
  }

  public bgWidth(value: Length | undefined): ToggleParam {
    this._bgWidth = value;
    return this;
  }

  public getBgWidth(): Length | undefined {
    return this._bgWidth;
  }

  public bgHeight(value: Length | undefined): ToggleParam {
    this._bgHeight = value;
    return this;
  }

  public getBgHeight(): Length | undefined {
    return this._bgHeight;
  }

  public iconLabelPadding(value: Padding | Length | LocalizedPadding | undefined): ToggleParam {
    this._iconLabelPadding = value;
    return this;
  }

  public getIconLabelPadding(): Padding | Length | LocalizedPadding | undefined {
    return this._iconLabelPadding;
  }

  public bgPointLight(value: PointLightStyle | undefined): ToggleParam {
    this._bgPointLight = value;
    return this;
  }

  public getBgPointLight(): PointLightStyle | undefined {
    return this._bgPointLight;
  }

  public bgBorderWidth(value: Length | undefined): ToggleParam {
    this._bgBorderWidth = value;
    return this;
  }

  public getBgBorderWidth(): Length | undefined {
    return this._bgBorderWidth;
  }

  public bgBorderColor(value: ResourceColor | undefined): ToggleParam {
    this._bgBorderColor = value;
    return this;
  }

  public getBgBorderColor(): ResourceColor | undefined {
    return this._bgBorderColor;
  }

  public geometryTransitionId(value: string | undefined): ToggleParam {
    this._geometryTransitionId = value;
    return this;
  }

  public getGeometryTransitionId(): string | undefined {
    return this._geometryTransitionId;
  }

  public iconBgBrightness(value: BrightnessOptions | undefined): ToggleParam {
    this._iconBgBrightness = value;
    return this;
  }

  public getIconBgBrightness(): BrightnessOptions | undefined {
    return this._iconBgBrightness;
  }

  public bgBrightness(value: BrightnessOptions | undefined): ToggleParam {
    this._bgBrightness = value;
    return this;
  }

  public getBgBrightness(): BrightnessOptions | undefined {
    return this._bgBrightness;
  }

  public labelAlign(value: TextAlign | undefined): ToggleParam {
    this._labelAlign = value;
    return this;
  }

  public getLabelAlign(): TextAlign | undefined {
    return this._labelAlign;
  }

  public setDialogComponent(component: CustomBuilder) {
    this._dialogComponent = component;
  }

  public getDialogComponent(): CustomBuilder {
    return this._dialogComponent;
  }
}

type ClickHandler = (viewModel: ToggleBaseViewModel, event?: ClickEvent, toggleId?: string) => void;
type GestureHandler = (viewModel: ToggleBaseViewModel, event?: GestureEvent, toggleId?: string) => void;

export class EventHandler {
  // icon part
  private _onIconClick?: ClickHandler;
  private _onIconLongPressOnAction?: GestureHandler;
  private _onIconLongPressOnActionEnd?: GestureHandler;

  // label part
  private _onLabelClick?: ClickHandler;
  private _onLabelLongPressOnAction?: GestureHandler;
  private _onLabelLongPressOnActionEnd?: GestureHandler;

  // 设置图标点击事件处理函数
  public onIconClick(handler:
    (viewModel: ToggleBaseViewModel, event?: ClickEvent) => void): EventHandler {
    this._onIconClick = handler;
    return this;
  }

  public getOnIconClick(): ClickHandler | undefined {
    return this._onIconClick;
  }

  // 设置图标长按开始事件处理函数
  public onIconLongPressOnAction(handler:
    (viewModel: ToggleBaseViewModel, event?: GestureEvent, toggleId?: string) => void): EventHandler {
    this._onIconLongPressOnAction = handler;
    return this;
  }

  public getOnIconLongPressOnAction(): GestureHandler | undefined {
    return this._onIconLongPressOnAction;
  }

  // 设置图标长按结束事件处理函数
  public onIconLongPressOnActionEnd(handler:
    (viewModel: ToggleBaseViewModel, event?: GestureEvent) => void): EventHandler {
    this._onIconLongPressOnActionEnd = handler;
    return this;
  }

  public getOnIconLongPressOnActionEnd(): GestureHandler | undefined {
    return this._onIconLongPressOnActionEnd;
  }


  // 设置标签点击事件处理函数
  public onLabelClick(handler:
    (viewModel: ToggleBaseViewModel, event?: ClickEvent, toggleId?: string) => void): EventHandler {
    this._onLabelClick = handler;
    return this;
  }

  public getOnLabelClick(): ClickHandler | undefined {
    return this._onLabelClick;
  }

  // 设置标签长按开始事件处理函数
  public onLabelLongPressOnAction(handler:
    (viewModel: ToggleBaseViewModel, event?: GestureEvent, toggleId?: string) => void): EventHandler {
    this._onLabelLongPressOnAction = handler;
    return this;
  }

  public getOnLabelLongPressOnAction(): GestureHandler | undefined {
    return this._onLabelLongPressOnAction;
  }

  // 设置标签长按结束事件处理函数
  public onLabelLongPressOnActionEnd(handler:
    (viewModel: ToggleBaseViewModel, event?: GestureEvent) => void): EventHandler {
    this._onLabelLongPressOnActionEnd = handler;
    return this;
  }

  public getOnLabelLongPressOnActionEnd(): GestureHandler | undefined {
    return this._onLabelLongPressOnActionEnd;
  }
}
