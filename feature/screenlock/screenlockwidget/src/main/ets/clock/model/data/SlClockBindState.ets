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

import { LogDomain, Logger } from '@ohos/basicutils';
import { SlVisualArgs } from '@ohos/screenlockcommon';
import { WidgetBindState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { ClockBindStateType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ClockLayout, ClockTextAlign } from '../../../common/WidgetParam';
import { BatteryLayout } from '../../../common/WidgetParam';

const TAG = 'SlClockBindState';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

// 锁屏时钟组件UI绑定状态
@Observed
export class SlClockBindState extends WidgetBindState<ClockBindStateType> {
  // 背景色
  @Track private backgroundColor?: ResourceColor;
  // 提亮参数
  @Track private brightnessOptions?: BrightnessOptions;
  // 是否已添加服务卡片
  @Track private hasFormCard?: boolean;
  // 当前时钟组件是否从AOD到桌面一镜到底
  @Track private isClockAodToDesktop?: boolean;
  // 当前时钟组件是否从桌面到AOD一镜到底
  @Track private isClockDesktopToAod?: boolean;
  // 当前动效场景
  @Track private currentAnimScene?: string;
  // 是否清除文字提亮
  @Track private removeBrightness: boolean = false;
  // 是否清除文字模糊
  @Track private clearTextBlurEffect: boolean = false;
  // 桌面字体的颜色
  @Track private textColorOfDesktopClock: string = '#FFFFFFFF';
  // 电量图标可见性
  @Track private batteryVisibility: Visibility = Visibility.None;
  // 时钟是否赋色
  @Track private isChangeColor?: boolean = false;
  // 锁屏时钟位移
  @Track private translateOptions?: TranslateOptions;
  // 当前状态（暂态）阴影是否可用
  @Track private textShadow: boolean = false;
  // 是否完全关闭时钟阴影
  @Track private enableShadowSwitch: boolean = false;
  // 是否模糊
  @Track private textBlurEffect: boolean = false;
  // 是否提亮
  @Track private enableBright: boolean = true;
  // 是否小外屏
  @Track private isSmallOuter: boolean = false;
  // 是否显示通知
  @Track private isNotificationVisible: boolean = true;
  // 文字颜色
  @Track private _textColor: string = '#B3FFFFFF';
  // X坐标
  @Track private _positionX?: number;
  // Y坐标
  @Track private _positionY?: number;
  // 时钟布局
  @Track private _clockLayout: ClockLayout = ClockLayout.NORMAL_CLOCK_LAYOUT;
  // 签名是否可见
  @Track private _signatureVisible?: boolean;
  // 字体
  @Track private _fontFamily: string = 'HarmonyHeiTi';
  // 签名内容
  @Track private _signatureText: string = '';
  // 文字对齐方式
  @Track private _textAlign?: ClockTextAlign;
  // 时钟笔划颜色
  @Track private _clockStrokeColor: string = '#FFFFFF';
  // 时钟角度
  @Track private _clockDegree: number = 0;
  // 时钟布局左边距
  @Track private clockWidgetLeftMargin: number = 0;
  // 时钟布局上边距
  @Track private clockWidgetTopMargin: number = 0;
  // 时钟边界左边距
  @Track private clockBorderLeftMargin: number = 0;
  // 时钟边界上边距
  @Track private clockBorderTopMargin: number = 0;
  // 时钟整体布局左边距动态偏移
  @Track private leftDynamicMargin: number = 0;
  // 时钟整体布局上边距动态偏移
  @Track private topDynamicMargin: number = 0;
  // 缓存时钟展开样式的上边距动态偏移
  @Track private topExpandDynamicMargin: number = 0;
  // 外层时钟组件偏移
  @Track private clockViewOffset: Position = { x: 0, y: 0 };
  // 时钟是否是AOD展开态显示
  @Track private isClockExpandOnAodAnimEnd: boolean = false;
  // 时钟外边框的位置
  @Track private clockBoardArea?: Area;
  // 标识时钟是否可见，此参数来自于主题
  @Track private isClockVisible: boolean = true;
  // 海报签名阴影是否可用
  @Track private isPosterShadow: boolean = false;

  constructor() {
    super(SlMainStateType.SL_CLOCK_WG_BIND_STATE);
  }

  protected initSetMethods(): void {
    this.setMethods.set(ClockBindStateType.BACKGROUND_COLOR, this.setMethodBackgroundColor);
    this.setMethods.set(ClockBindStateType.BRIGHTNESS, this.setMethodBrightness)
    this.setMethods.set(ClockBindStateType.IS_CHANGE_COLOR, this.setMethodChangeColorState);
    this.setMethods.set(ClockBindStateType.FONT_FAMILY, this.setMethodFontFamily);
    this.setMethods.set(ClockBindStateType.IS_POSTER_SHADOW, this.setMethodPosterShadow);
  }

  private setMethodBackgroundColor(st: SlClockBindState, value: ResourceColor): void {
    st.setBackgroundColor(value);
  }

  private setMethodBrightness(st: SlClockBindState, value: BrightnessOptions): void {
    st.setBrightness(value);
  }

  private setMethodChangeColorState(st: SlClockBindState, value: boolean): void {
    st.setChangeColorState(value);
  }

  private setMethodFontFamily(st: SlClockBindState, value: string): void {
    st.setFontFamily(value);
  }

  private setMethodPosterShadow(st: SlClockBindState, value: boolean): void {
    st.setPosterShadow(value);
  }

  private getMethodChangeColorState(st: SlClockBindState): boolean | undefined {
    return st.getChangeColorState();
  }

  private getMethodBackgroundColor(st: SlClockBindState): ResourceColor | undefined {
    return st.getBackgroundColor();
  }

  private getMethodBrightness(st: SlClockBindState): BrightnessOptions | undefined {
    return st.getBrightness();
  }

  private getMethodHasFormCard(st: SlClockBindState): boolean | undefined {
    return st.hasAddedFormCard();
  }

  private getMethodClockLayout(st: SlClockBindState): ClockLayout | undefined {
    return st.getClockLayout();
  }

  private getMethodPosterShadow(st: SlClockBindState): boolean | undefined {
    return st.getPosterShadow();
  }

  protected initGetMethods(): void {
    this.getMethods.set(ClockBindStateType.BACKGROUND_COLOR, this.getMethodBackgroundColor);
    this.getMethods.set(ClockBindStateType.BRIGHTNESS, this.getMethodBrightness);
    this.getMethods.set(ClockBindStateType.HAS_FORM_CARD, this.getMethodHasFormCard);
    this.getMethods.set(ClockBindStateType.IS_CHANGE_COLOR, this.getMethodChangeColorState);
    this.getMethods.set(ClockBindStateType.CLOCK_LAYOUT, this.getMethodClockLayout);
    this.getMethods.set(ClockBindStateType.IS_POSTER_SHADOW, this.getMethodPosterShadow);
  }

  public setBatteryLayout(displayModel: BatteryLayout): SlClockBindState {
    return this;
  }

  public setBackgroundColor(color: ResourceColor): SlClockBindState {
    if (this.backgroundColor !== color) {
      this.backgroundColor = color;
      this.notifyStateChange(ClockBindStateType.BACKGROUND_COLOR);
    }
    return this;
  }

  public setBrightness(options?: BrightnessOptions): SlClockBindState {
    if (this.brightnessOptions !== options) {
      this.brightnessOptions = options;
      this.notifyStateChange(ClockBindStateType.BRIGHTNESS);
    }
    return this;
  }

  public setChangeColorState(isChangeColor: boolean): SlClockBindState {
    if (isChangeColor === undefined) {
      return this;
    }
    if (this.isChangeColor !== isChangeColor) {
      this.isChangeColor = isChangeColor;
    }
    return this;
  }

  public getChangeColorState(): boolean | undefined {
    return this.isChangeColor;
  }


  public getBackgroundColor(): ResourceColor | undefined {
    return this.backgroundColor;
  }

  public getBrightness(): BrightnessOptions | undefined {
    return this.brightnessOptions;
  }

  public setHasFormCard(hasFormCard?: boolean): void {
    if (this.hasFormCard !== hasFormCard) {
      this.hasFormCard = hasFormCard;
      this.notifyStateChange(ClockBindStateType.HAS_FORM_CARD);
    }
  }

  public hasAddedFormCard(): boolean { // 服务卡片是否已添加
    return this.hasFormCard ?? false;
  }

  public setClockAodToDesktop(isClockAodToDesktop: boolean): SlClockBindState {
    if (this.isClockAodToDesktop !== isClockAodToDesktop) {
      this.isClockAodToDesktop = isClockAodToDesktop;
    }
    return this;
  }

  public getClockAodToDesktop(): boolean {
    return this.isClockAodToDesktop ?? false;
  }

  public setClockDesktopToAod(isClockDesktopToAod: boolean): SlClockBindState {
    if (this.isClockDesktopToAod !== isClockDesktopToAod) {
      this.isClockDesktopToAod = isClockDesktopToAod;
    }
    return this;
  }

  public getClockDesktopToAod(): boolean {
    return this.isClockDesktopToAod ?? false;
  }

  public getCurrentAnimScene(): string | undefined {
    return this.currentAnimScene;
  }

  public setCurrentAnimScene(scene: string | undefined): SlClockBindState {
    if (this.currentAnimScene !== scene) {
      this.currentAnimScene = scene;
    }
    return this;
  }

  public isInDesktopAndAodClockOneShot(): boolean {
    return this.getClockDesktopToAod() || this.getClockAodToDesktop();
  }

  public setRemoveBrightness(isRemove: boolean): SlClockBindState {
    if (this.removeBrightness !== isRemove) {
      this.removeBrightness = isRemove;
      this.notifyStateChange(ClockBindStateType.REMOVE_BRIGHTNESS);
    }
    return this;
  }

  public getRemoveBrightness(): boolean {
    return this.removeBrightness;
  }

  public setClearTextBlurEffect(clearEffect: boolean): SlClockBindState {
    if (this.clearTextBlurEffect !== clearEffect) {
      this.clearTextBlurEffect = clearEffect;
    }
    return this;
  }

  public getClearTextBlurEffect(): boolean {
    return this.clearTextBlurEffect;
  }

  public setTextColorOfDesktopClock(color: string): SlClockBindState {
    if (this.textColorOfDesktopClock !== color) {
      this.textColorOfDesktopClock = color;
    }
    return this;
  }

  public getTextColorOfDesktopClock(): string {
    return this.textColorOfDesktopClock;
  }

  public setBatteryVisibility(visibility: Visibility): SlClockBindState {
    if (this.batteryVisibility !== visibility) {
      this.batteryVisibility = visibility;
    }
    return this;
  }

  public getBatteryVisibility(): Visibility {
    return this.batteryVisibility;
  }

  public setShadowSwitch(switcherStatus: boolean): SlClockBindState {
    if (this.enableShadowSwitch !== switcherStatus) {
      this.enableShadowSwitch = switcherStatus;
    }
    return this;
  }

  public getShadowSwitch(): boolean {
    return this.enableShadowSwitch;
  }

  public setTextShadow(textShadow: boolean): SlClockBindState {
    if (this.textShadow !== textShadow) {
      this.textShadow = textShadow;
    }
    return this;
  }

  public getTextShadow(): boolean {
    return this.textShadow;
  }

  public setTextBlurEffect(textBlurEffect: boolean): SlClockBindState {
    if (this.textBlurEffect !== textBlurEffect) {
      this.textBlurEffect = textBlurEffect;
    }
    return this;
  }

  public getTextBlurEffect(): boolean {
    return this.textBlurEffect;
  }

  public setEnableBright(enableBright: boolean): SlClockBindState {
    if (this.enableBright !== enableBright) {
      this.enableBright = enableBright;
    }
    return this;
  }

  public getEnableBright(): boolean {
    return this.enableBright;
  }

  public setIsSmallOuter(isSmallOuter: boolean): SlClockBindState {
    if (this.isSmallOuter !== isSmallOuter) {
      this.isSmallOuter = isSmallOuter;
    }
    return this;
  }

  public getIsSmallOuter(): boolean {
    return this.isSmallOuter;
  }

  public setIsNotificationVisible(isNotificationVisible: boolean): SlClockBindState {
    if (this.isNotificationVisible !== isNotificationVisible) {
      this.isNotificationVisible = isNotificationVisible;
    }
    return this;
  }

  public getIsNotificationVisible(): boolean {
    return this.isNotificationVisible;
  }

  public setTextColor(value: string | undefined): void {
    if (value && this._textColor !== value) {
      this._textColor = value;
      this.notifyStateChange(ClockBindStateType.TEXT_COLOR);
    }
  }

  public getTextColor(): string {
    return this._textColor;
  }

  public setPositionX(value: number | undefined): void {
    if (this._positionX !== value) {
      this._positionX = value;
      this.notifyStateChange(ClockBindStateType.POSITION_X);
    }
  }

  public getPositionX(): number | undefined {
    return this._positionX;
  }

  public setPositionY(value: number | undefined): void {
    if (this._positionY !== value) {
      this._positionY = value;
      this.notifyStateChange(ClockBindStateType.POSITION_Y);
    }
  }

  public getPositionY(): number | undefined {
    return this._positionY;
  }

  public setClockLayout(value: ClockLayout | undefined): void {
    if (value && this._clockLayout !== value) {
      this._clockLayout = value;
      this.notifyStateChange(ClockBindStateType.CLOCK_LAYOUT);
    }
  }

  public getClockLayout(): ClockLayout {
    return this._clockLayout;
  }

  public setSignatureVisible(value: boolean): void {
    if (this._signatureVisible !== value) {
      this._signatureVisible = value;
      this.notifyStateChange(ClockBindStateType.SIGNATURE_VISIBLE);
    }
  }

  public getSignatureVisible(): boolean {
    return this._signatureVisible ?? false;
  }

  public setFontFamily(value: string | undefined): void {
    if (value && this._fontFamily !== value) {
      this._fontFamily = value;
      this.notifyStateChange(ClockBindStateType.FONT_FAMILY);
    }
  }

  public getFontFamily(): string {
    return this._fontFamily;
  }

  public setSignatureText(value: string): void {
    if (this._signatureText !== value) {
      this._signatureText = value;
      this.notifyStateChange(ClockBindStateType.SIGNATURE_TEXT);
    }
  }

  public getSignatureText(): string {
    return this._signatureText;
  }

  public setTextAlign(value: ClockTextAlign | undefined): void {
    if (this._textAlign !== value) {
      this._textAlign = value;
      this.notifyStateChange(ClockBindStateType.TEXT_ALIGN);
    }
  }

  public geTextAlign(): ClockTextAlign | undefined {
    return this._textAlign;
  }

  public setClockStrokeColor(value: string): void {
    if (this._clockStrokeColor !== value) {
      this._clockStrokeColor = value;
      this.notifyStateChange(ClockBindStateType.STROKE_COLOR);
    }
  }

  public getClockStrokeColor(): string {
    return this._clockStrokeColor;
  }

  public setClockDegree(value: number): void {
    if (this._clockDegree !== value) {
      this._clockDegree = value;
    }
  }

  public getClockDegree(): number {
    return this._clockDegree;
  }

  public setClockWidgetLeftMargin(margin: number): SlClockBindState {
    if (this.clockWidgetLeftMargin !== margin) {
      this.clockWidgetLeftMargin = margin;
      log.showInfo(TAG, `clockWidgetLeftMargin is ${margin}`);
    }
    return this;
  }

  public getClockWidgetLeftMargin(): number {
    return this.clockWidgetLeftMargin;
  }

  public setClockWidgetTopMargin(margin: number): SlClockBindState {
    if (this.clockWidgetTopMargin !== margin) {
      this.clockWidgetTopMargin = margin;
    }
    return this;
  }

  public getClockWidgetTopMargin(): number {
    return this.clockWidgetTopMargin;
  }

  public setClockBorderLeftMargin(margin: number): SlClockBindState {
    if (this.clockBorderLeftMargin !== margin) {
      this.clockBorderLeftMargin = margin;
    }
    return this;
  }

  public getClockBorderLeftMargin(): number {
    return this.clockBorderLeftMargin;
  }

  public setClockBorderTopMargin(margin: number): SlClockBindState {
    if (this.clockBorderTopMargin !== margin) {
      this.clockBorderTopMargin = margin;
    }
    return this;
  }

  public getClockBorderTopMargin(): number {
    return this.clockBorderTopMargin;
  }

  public getLeftDynamicMargin(): number {
    return this.leftDynamicMargin;
  }

  public setLeftDynamicMargin(margin: number): SlClockBindState {
    if (this.leftDynamicMargin !== margin) {
      this.leftDynamicMargin = margin;
    }
    return this;
  }

  public getTopDynamicMargin(): number {
    return this.topDynamicMargin;
  }

  public setTopDynamicMargin(margin: number): SlClockBindState {
    if (this.topDynamicMargin !== margin) {
      this.topDynamicMargin = margin;
    }
    return this;
  }

  public getTopExpandDynamicMargin(): number {
    return this.topExpandDynamicMargin;
  }

  public setTopExpandDynamicMargin(margin: number): SlClockBindState {
    if (this.topExpandDynamicMargin !== margin) {
      this.topExpandDynamicMargin = margin;
    }
    return this;
  }

  public setClockViewOffset(offset: Position): SlClockBindState {
    if (this.clockViewOffset !== offset) {
      this.clockViewOffset = offset
    }
    return this;
  }

  public getClockViewOffset(): Position {
    return this.clockViewOffset;
  }

  public getClockExpandOnAodAnim():boolean {
    return this.isClockExpandOnAodAnimEnd;
  }

  public setClockExpandOnAodAnim(value: boolean): SlClockBindState {
    if (this.isClockExpandOnAodAnimEnd !== value) {
      this.isClockExpandOnAodAnimEnd = value;
    }
    return this;
  }

  public setClockBoardArea(clockBoardArea: Area): SlClockBindState {
    if (this.clockBoardArea !== clockBoardArea) {
      this.clockBoardArea = clockBoardArea;
      this.notifyStateChange(ClockBindStateType.CLOCK_BOARD_AREA);
    }
    return this;
  }

  public getClockBoardArea(): Area | undefined {
    return this.clockBoardArea;
  }

  public setIsClockVisible(isClockVisible: boolean): void {
    if (this.isClockVisible !== isClockVisible) {
      this.isClockVisible = isClockVisible;
    }
  }

  public getIsClockVisible(): boolean {
    return this.isClockVisible;
  }

  public setPosterShadow(isPosterShadow: boolean): SlClockBindState {
    if (this.isPosterShadow !== isPosterShadow) {
      this.isPosterShadow = isPosterShadow;
      this.notifyStateChange(ClockBindStateType.IS_POSTER_SHADOW);
    }
    return this;
  }

  public getPosterShadow(): boolean | undefined {
    return this.isPosterShadow;
  }
}