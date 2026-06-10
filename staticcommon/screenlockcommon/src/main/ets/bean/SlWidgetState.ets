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

import { SlMainStateType, SlSubStateType, WidgetBindStateType, WidgetStaticStateType } from '../constants/SlStateType';
import { ISlState, SlObject, WidgetArea, WidgetPivot } from '../interface/ISlState';
import { ISlStateChangeListener } from '../interface/ISlStateChangeListener';

// 锁屏首页组件静态状态管理
export class WidgetStaticState<T extends SlSubStateType> implements ISlState {
  public slStateChangeListener?: ISlStateChangeListener; // 状态切换监听器
  public widgetStateChangeListener?: ISlStateChangeListener; // 适配时钟组件化状态切换监听器
  protected readonly mainType: SlMainStateType; // 状态类型
  protected readonly setMethods: Map<WidgetStaticStateType | T, Function> = new Map(); // 状态赋值函数
  protected readonly getMethods: Map<WidgetStaticStateType | T, Function> = new Map(); // 状态取值函数
  private readonly widgetArea: WidgetArea = { globalX: 0, globalY: 0, width: 0, height: 0 }; // 组件显示区域
  private readonly widgetScreenPivot: WidgetPivot = {}; // 组件相对全屏缩放中心点

  constructor(mainType: SlMainStateType) {
    this.mainType = mainType;
    this.initSetMethods();
    this.initGetMethods();
  }

  protected initSetMethods(): void { // 赋值函数统一管理
    this.setMethods.set(WidgetStaticStateType.WIDGET_AREA, this.setMethodWidgetArea);
    this.setMethods.set(WidgetStaticStateType.WIDGET_SCREEN_PIVOT, this.setMethodWidgetScreenPivot);
  }

  private setMethodWidgetArea(st: WidgetStaticState<T>, area?: WidgetArea): void {
    st.setWidgetArea(area);
  }

  private setMethodWidgetScreenPivot(st: WidgetStaticState<T>, pivot?: WidgetPivot): void {
    st.setWidgetScreenPivot(pivot);
  }

  private getMethodWidgetArea(st: WidgetStaticState<T>): WidgetArea {
    return st.getWidgetArea();
  }

  private getMethodWidgetScreenPivot(st: WidgetStaticState<T>): WidgetPivot {
    return st.getWidgetScreenPivot();
  }

  protected initGetMethods(): void { // 取值函数统一管理
    this.getMethods.set(WidgetStaticStateType.WIDGET_AREA, this.getMethodWidgetArea);
    this.getMethods.set(WidgetStaticStateType.WIDGET_SCREEN_PIVOT, this.getMethodWidgetScreenPivot);
  }

  protected notifyStateChange(subType: WidgetStaticStateType | T): void { // 通知状态切换
    this.slStateChangeListener?.onSlStateChange?.(this.mainType, subType);
    this.widgetStateChangeListener?.onSlStateChange?.(this.mainType, subType);
  }

  public getSlStateType(): SlMainStateType { // 复写ISlState，状态主类型
    return this.mainType;
  }

  public setSlState(subType: WidgetStaticStateType | T, value: SlObject): WidgetStaticState<T> { // 复写ISlState
    this.setMethods.get(subType)?.(this, value);
    return this;
  }

  public getSlState(subType: WidgetStaticStateType | T, scene?: SlObject): SlObject { // 复写ISlState，取值场景区分
    return this.getMethods.get(subType)?.(this, scene);
  }

  public setWidgetArea(area?: WidgetArea): void { // 记录组件显示区域
    let globalX = area?.globalX ?? 0;
    let globalY = area?.globalY ?? 0;
    let width = area?.width ?? 0;
    let height = area?.height ?? 0;
    if (this.widgetArea.globalX !== globalX || this.widgetArea.globalY !== globalY ||
      this.widgetArea.width !== width || this.widgetArea.height !== height) {
      this.widgetArea.globalX = globalX;
      this.widgetArea.globalY = globalY;
      this.widgetArea.width = width;
      this.widgetArea.height = height;
      this.notifyStateChange(WidgetStaticStateType.WIDGET_AREA);
    }
  }

  public getWidgetArea(): WidgetArea { // 获取组件显示区域
    return this.widgetArea;
  }

  public setWidgetScreenPivot(pivot?: WidgetPivot): void { // 记录组件相对全屏缩放中心点
    let centerX = pivot?.centerX;
    let centerY = pivot?.centerY;
    let centerZ = pivot?.centerZ;
    if (this.widgetScreenPivot.centerX !== centerX || this.widgetScreenPivot.centerY !== centerY ||
      this.widgetScreenPivot.centerZ !== centerZ) {
      this.widgetScreenPivot.centerX = centerX;
      this.widgetScreenPivot.centerY = centerY;
      this.widgetScreenPivot.centerZ = centerZ;
      this.notifyStateChange(WidgetStaticStateType.WIDGET_SCREEN_PIVOT);
    }
  }

  public getWidgetScreenPivot(): WidgetPivot { // 获取组件相对全屏缩放中心点
    return this.widgetScreenPivot;
  }
}

// 锁屏首页组件UI绑定状态管理
@Observed
export class WidgetBindState<T extends SlSubStateType> implements ISlState {
  public slStateChangeListener?: ISlStateChangeListener; // 状态切换监听器
  public widgetStateChangeListener?: ISlStateChangeListener; // 适配时钟组件化状态切换监听器
  protected readonly mainType: SlMainStateType; // 状态类型
  protected readonly setMethods: Map<WidgetBindStateType | T, Function> = new Map(); // 状态赋值函数
  @Track protected readonly getMethods: Map<WidgetBindStateType | T, Function> = new Map(); // 状态取值函数
  @Track private width: string | number = ''; // 布局宽度
  @Track private height: string | number = ''; // 布局高度
  @Track private visibility: Visibility = Visibility.Visible; // 布局可见性
  @Track private layoutScale: number = 1; // 布局缩放比例 0 - 1
  @Track private layoutOpacity: number = 1; // 布局透明度 0 - 1
  @Track private isLightWallpaper: boolean = false; // 是否亮色壁纸

  constructor(mainType: SlMainStateType) {
    this.mainType = mainType;
    this.initSetMethods();
    this.initGetMethods();
  }

  protected initSetMethods(): void { // 赋值函数统一管理
    this.setMethods.set(WidgetBindStateType.LAYOUT_SCALE, this.setMethodLayoutScale);
    this.setMethods.set(WidgetBindStateType.LAYOUT_OPACITY, this.setMethodLayoutOpacity);
    this.setMethods.set(WidgetBindStateType.IS_LIGHT_WALLPAPER, this.setMethodLightWallpaperState);
    this.setMethods.set(WidgetBindStateType.LAYOUT_WIDTH, this.setMethodLayoutWidth);
    this.setMethods.set(WidgetBindStateType.LAYOUT_HEIGHT, this.setMethodLayoutHeight);
    this.setMethods.set(WidgetBindStateType.LAYOUT_VISIBILITY, this.setMethodVisibility);
  }

  private setMethodLayoutScale(st: WidgetBindState<T>, scale: number): void {
    st.setLayoutScale(scale);
  }

  private setMethodLayoutOpacity(st: WidgetBindState<T>, opacity: number): void {
    st.setLayoutOpacity(opacity);
  }

  private setMethodLightWallpaperState(st: WidgetBindState<T>, isLightWallpaper: boolean): void {
    st.setLightWallpaperState(isLightWallpaper);
  }

  private setMethodLayoutWidth(st: WidgetBindState<T>, width: number | string): void {
    st.setLayoutWidth(width);
  }

  private setMethodLayoutHeight(st: WidgetBindState<T>, height: number | string): void {
    st.setLayoutHeight(height);
  }

  private setMethodVisibility(st: WidgetBindState<T>, visibility: Visibility): void {
    st.setVisibility(visibility);
  }
  private getMethodLayoutScale(st: WidgetBindState<T>): number {
    return st.getLayoutScale();
  }

  private getMethodLayoutOpacity(st: WidgetBindState<T>): number {
    return st.getLayoutOpacity();
  }

  private getMethodLightWallpaperState(st: WidgetBindState<T>): boolean {
    return st.getLightWallpaperState();
  }

  private getMethodLayoutWidth(st: WidgetBindState<T>): number | string {
    return st.getLayoutWidth();
  }

  private getMethodLayoutHeight(st: WidgetBindState<T>): number | string {
    return st.getLayoutHeight();
  }

  private getMethodVisibility(st: WidgetBindState<T>): Visibility {
    return st.getVisibility();
  }
  protected initGetMethods(): void { // 取值函数统一管理
    this.getMethods.set(WidgetBindStateType.LAYOUT_SCALE, this.getMethodLayoutScale);
    this.getMethods.set(WidgetBindStateType.LAYOUT_OPACITY, this.getMethodLayoutOpacity);
    this.getMethods.set(WidgetBindStateType.IS_LIGHT_WALLPAPER, this.getMethodLightWallpaperState);
    this.getMethods.set(WidgetBindStateType.LAYOUT_WIDTH, this.getMethodLayoutWidth);
    this.getMethods.set(WidgetBindStateType.LAYOUT_HEIGHT, this.getMethodLayoutHeight);
    this.getMethods.set(WidgetBindStateType.LAYOUT_VISIBILITY, this.getMethodVisibility);
  }

  protected notifyStateChange(subType: WidgetBindStateType | T): void { // 通知状态切换
    this.slStateChangeListener?.onSlStateChange?.(this.mainType, subType);
    this.widgetStateChangeListener?.onSlStateChange?.(this.mainType, subType);
  }

  public getSlStateType(): SlMainStateType { // 复写ISlState
    return this.mainType;
  }

  public setSlState(subType: WidgetBindStateType | T, value: SlObject): WidgetBindState<T> { // 复写ISlState
    this.setMethods.get(subType)?.(this, value);
    return this;
  }

  public getSlState(subType: WidgetBindStateType | T, scene?: SlObject): SlObject { // 复写ISlState，取值场景区分
    return this.getMethods.get(subType)?.(this, scene);
  }

  public getLayoutWidth(): number | string {
    return this.width;
  }

  public setLayoutWidth(width: number | string): void {
    this.width = width;
  }

  public getLayoutHeight(): number | string {
    return this.height;
  }

  public setLayoutHeight(height: number | string): void {
    this.height = height;
  }

  public getLayoutScale(): number {
    return this.layoutScale;
  }

  public setLayoutScale(scale: number): void {
    this.layoutScale = scale;
  }

  public getLayoutOpacity(): number {
    return this.layoutOpacity;
  }

  public setLayoutOpacity(opacity: number): void {
    this.layoutOpacity = opacity;
  }

  public getLightWallpaperState(): boolean {
    return this.isLightWallpaper;
  }

  public setLightWallpaperState(isLightWallpaper: boolean): void {
    if (this.isLightWallpaper !== isLightWallpaper) {
      this.isLightWallpaper = isLightWallpaper;
      this.notifyStateChange(WidgetBindStateType.IS_LIGHT_WALLPAPER);
    }
  }

  public getVisibility(): Visibility {
    return this.visibility;
  }

  public setVisibility(visibility: Visibility): void {
    this.visibility = visibility;
  }
}