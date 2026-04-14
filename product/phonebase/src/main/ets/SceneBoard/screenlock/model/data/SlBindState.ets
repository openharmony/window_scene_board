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

import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  SlBindStateType,
  SlMainStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { BlurFreezeScene, ISlState, SlObject } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import Constants from '@ohos/screenlockcomponent/src/main/ets/common/Constants';
import { SlAnimScene } from '@ohos/screenlockcomponent/src/main/ets/common/anim/SlAnimConstants';

const TAG = 'SlBindState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const DEFAULT_FREEZE_SCENE = 'default_freeze_scene';
const FREEZE_TIME_OUT: number = 3000;
const DEFAULT_TIME_OUT: number = -1;

/**
 * 锁屏面板UI绑定状态变量管理
 */
@Observed
export class SlBindState implements ISlState {
  public slStateChangeListener?: ISlStateChangeListener | undefined; // 复写ISlState
  @Track private setMethods: Map<SlBindStateType, Function> = new Map(); // 状态赋值函数
  @Track private getMethods: Map<SlBindStateType, Function> = new Map(); // 状态取值函数
  @Track private isSlShowing: boolean = false; // 锁屏面板可见性
  @Track private osAccountUnlockState: boolean = false; // 账号是否已认证解锁
  @Track private bgBlurFreezeScene: Set<string> = new Set(); // 背景模糊冻结场景
  @Track private isBgBlurFreeze: boolean = false; // 当前是否背景模糊冻结
  @Track private isUsingImmersiveWallPaper: boolean = false; // 是否正在使用沉浸态壁纸
  @Track private disableClockShadow: boolean = false; // 当前是否关闭时钟阴影
  /**
   * 是否展示沉浸态，用于三方主题场景锁屏时钟与主题时钟切换、锁屏壁纸与主题壁纸切换
   */
  @Track private isImmersiveShowing: boolean = false;
  @Track private slGreetShowState: boolean = false;

  @Track private rootScale: number = 1.0;

  /**
   * 锁屏显影状态
   */
  @Track private slVisibility: Visibility = Visibility.Visible;
  /**
   * 主页透明度
   */
  @Track private opacity: number = 0;
  /**
   * 跟手滑动时主题缩放
   */
  @Track private zoomRatio: number = 0;
  /**
   * 壁纸纵向偏移
   */
  @Track private wallpaperTranslate: number = 0;
  /**
   * 是否是静态布局
   */
  @Track private isStaticTheme: boolean = false;
  /**
   * 网格区域宽度
   */
  @Track private gridWidth: number = 0;
  /**
   * 小工具是否在使用
   */
  @Track private isToolsUsing: boolean = false;
  /**
   * 无障碍模式下根组件是否禁止聚焦，默认不禁止
   */
  @Track private isFocusDisabled: boolean = false;
  /**
   * 锁屏面板前景内容模糊
   */
  @Track private homeContentBlur: number = Constants.DEFAULT_BLUR_RADIUS;
  /**
   * 锁屏小工具滑动过程中主界面的缩放
   */
  @Track private scaleByCameraTool: number = Constants.DEFAULT_SCALE;
  /**
   * 快捷小工具可见性
   */
  @Track private isQuickToolVisible: boolean = true;
  /**
   * 锁屏相机可见性
   */
  @Track private isCameraVisible: boolean = true;

  /**
   * 是否需要开启特效
   */
  @Track private needUseEffect: boolean = false;
  /**
   * 是否拖拽卡片未松手
   */
  @Track private isFormDragNotDrop: boolean = false;
  /**
   * 跟手滑动时主题缩放
   */
  @Track private slideRatio: number = 0;
  /**
   * 当前锁屏状态是否在假AOD状态
   */
  @Track private isFakeAodState: boolean = false;

  /**
   * 深浅壁纸
   */
  @Track private isLightWallpaper: boolean = false;

  /**
   * 底部小工具距离屏幕边缘间距
   */
  @Track private bottomViewMargin: number = 0;

  /**
   * 编辑界面缩放比例
   */
  @Track private editClockUpScale: number = 1.0;

  /**
   * 当前锁屏壁纸是否为浅色壁纸
   */
  @Track private _isSlWallpaperLight: boolean = false;

  /**
   * 上一次的模糊冻结定时器
   */
  @Track private preFreezeTimeout: number = DEFAULT_TIME_OUT;

  /**
   * 时钟是否拖拽中
   */
  @Track private isClockDragging: boolean = false;

  /**
   * 是否折叠屏展开态
   */
  @Track private _isFoldExpand: boolean = false;

  /**
   * 黑屏展示
   */
  @Track private blankScreen: boolean = false;

  constructor() {
    this.initSetMethods();
    this.initGetMethods();
  }

  private initSetMethods(): void { // 赋值函数统一管理
    this.setMethods.set(SlBindStateType.SL_SHOWING_STATE,
      (state: SlBindState, isShowing: boolean) => state?.setSlShowing(isShowing));
    this.setMethods.set(SlBindStateType.OS_ACCOUNT_UNLOCK_STATE,
      (state: SlBindState, isUnlocked: boolean) => state?.setOsAccountUnlocked(isUnlocked));
    this.setMethods.set(SlBindStateType.BG_BLUR_FREEZE,
      (st: SlBindState, value?: BlurFreezeScene) => st.setBgBlurFreeze(value));
    this.setMethods.set(SlBindStateType.IS_USING_IMMERSIVE_WALL_PAPER,
      (st: SlBindState, value: boolean) => st.setImmersiveWallPaperUsing(value));
    this.setMethods.set(SlBindStateType.SL_WALLPAPER_LIGHT,
      (st: SlBindState, value: boolean) => st.setSlWallPaperLight(value));
    this.setMethods.set(SlBindStateType.DISABLE_CLOCK_SHADOW,
      (state: SlBindState, disableClockShadow: boolean) => state?.setDisableClockShadow(disableClockShadow));
    this.setMethods.set(SlBindStateType.IMMERSIVE_SHOWING_STATE,
      (state: SlBindState, isImmersiveShowing: boolean) => state?.setIsImmersiveShowing(isImmersiveShowing));
    this.setMethods.set(SlBindStateType.SL_GREET_SHOWING_STATE,
      (state: SlBindState, slGreetShowState: boolean) => state?.setSlGreetShowState(slGreetShowState));
    this.setMethods.set(SlBindStateType.SL_ROOT_SCALE,
      (state: SlBindState, rootScale: number) => state?.setRootScale(rootScale));
    this.setMethods.set(SlBindStateType.SL_VISIBILITY,
      (state: SlBindState, visibility: Visibility) => state?.setSlVisibility(visibility));
    this.setMethods.set(SlBindStateType.SL_OPACITY,
      (state: SlBindState, opacity: number) => state?.setOpacity(opacity));
    this.setMethods.set(SlBindStateType.SL_ZOOM_RATIO,
      (state: SlBindState, ration: number) => state?.setZoomRatio(ration));
    this.setMethods.set(SlBindStateType.SL_WALLPAPER_TRANSLATE,
      (state: SlBindState, translate: number) => state?.setWallpaperTranslate(translate));
    this.setMethods.set(SlBindStateType.SL_THEME_STATIC,
      (state: SlBindState, isStatic: boolean) => state?.setIsStaticTheme(isStatic));
    this.setMethods.set(SlBindStateType.SL_GRID_WIDTH,
      (state: SlBindState, width: number) => state?.setGridWidth(width));
    this.setMethods.set(SlBindStateType.SL_HOME_BLUR,
      (state: SlBindState, blur: number) => state?.setHomeContentBlur(blur));
    this.setMethods.set(SlBindStateType.SL_HOME_SCALE,
      (state: SlBindState, scale: number) => state?.setScaleByCameraTool(scale));
    this.setMethods.set(SlBindStateType.IS_USING_TOOLS,
      (state: SlBindState, isUsing: boolean) => state?.setIsToolsUsing(isUsing));
    this.setMethods.set(SlBindStateType.IS_CAMERA_VISIBLE,
      (state: SlBindState, isVisible: boolean) => state?.setIsCameraVisible(isVisible));
    this.setMethods.set(SlBindStateType.IS_QUICK_TOOLS_VISIBLE,
      (state: SlBindState, isVisible: boolean) => state?.setIsQuickToolVisible(isVisible));
    this.setMethods.set(SlBindStateType.IS_FOCUS_DISABLED,
      (state: SlBindState, isDisabled: boolean) => state?.setFocusDisabled(isDisabled));
    this.setMethods.set(SlBindStateType.SL_NEED_USE_EFFECT,
      (state: SlBindState, useEffect: boolean) => state?.setNeedUseEffect(useEffect));
    this.setMethods.set(SlBindStateType.IS_FORM_DRAG_NOT_DROP,
      (state: SlBindState, isNotDrop: boolean) => state?.setIsFormDragNotDrop(isNotDrop));
    this.setMethods.set(SlBindStateType.IS_FAKE_AOD_STATE,
      (state: SlBindState, isFakeAodState: boolean) => state?.setIsFakeAodState(isFakeAodState));
    this.setMethods.set(SlBindStateType.SL_BOTTOM_VIEW_MARGIN,
      (state: SlBindState, margin: number) => state?.setBottomViewMargin(margin));
    this.setMethods.set(SlBindStateType.SL_EDIT_CLOCK_UP_SCALE,
      (state: SlBindState, scale: number) => state?.setEditClockUpScale(scale));
    this.setMethods.set(SlBindStateType.SL_CLOCK_DRAG_STATE,
      (state: SlBindState, isClockDragging: boolean) => state?.setClockDragState(isClockDragging));
    this.setMethods.set(SlBindStateType.SL_FOLD_EXPAND_STATE,
      (state: SlBindState, value: boolean) => state?.setFoldExpandState(value));
  }

  private initGetMethods(): void { // 取值函数统一管理
    this.getMethods.set(SlBindStateType.SL_SHOWING_STATE, (state: SlBindState): boolean => state.isPanelShowing());
    this.getMethods.set(SlBindStateType.OS_ACCOUNT_UNLOCK_STATE,
      (state: SlBindState): boolean => state.isOsAccountUnlocked());
    this.getMethods.set(SlBindStateType.BG_BLUR_FREEZE,
      (st: SlBindState, scene?: string): boolean => st.isBgBlurSceneFreeze(scene));
    this.getMethods.set(SlBindStateType.IS_USING_IMMERSIVE_WALL_PAPER,
      (st: SlBindState): boolean => st.getImmersiveWallPaperUsing());
    this.getMethods.set(SlBindStateType.SL_WALLPAPER_LIGHT,
      (st: SlBindState): boolean => st.isSlWallpaperLight());
    this.getMethods.set(SlBindStateType.DISABLE_CLOCK_SHADOW,
      (state: SlBindState): boolean => state.isDisableClockShadow());
    this.getMethods.set(SlBindStateType.IMMERSIVE_SHOWING_STATE,
      (state: SlBindState): boolean => state.getIsImmersiveShowing());
    this.getMethods.set(SlBindStateType.SL_GREET_SHOWING_STATE,
      (state: SlBindState): boolean => state.getSlGreetShowState());
    this.getMethods.set(SlBindStateType.SL_ROOT_SCALE,
      (state: SlBindState): number => state.getRootScale());
    this.getMethods.set(SlBindStateType.SL_VISIBILITY,
      (state: SlBindState): Visibility => state.getSlVisibility());
    this.getMethods.set(SlBindStateType.SL_OPACITY,
      (state: SlBindState): number => state.getOpacity());
    this.getMethods.set(SlBindStateType.SL_ZOOM_RATIO,
      (state: SlBindState): number => state.getZoomRatio());
    this.getMethods.set(SlBindStateType.SL_WALLPAPER_TRANSLATE,
      (state: SlBindState): number => state.getWallpaperTranslate());
    this.getMethods.set(SlBindStateType.SL_THEME_STATIC,
      (state: SlBindState): boolean => state.getIsStaticTheme());
    this.getMethods.set(SlBindStateType.SL_GRID_WIDTH,
      (state: SlBindState): number => state.getGridWidth());
    this.getMethods.set(SlBindStateType.SL_HOME_BLUR,
      (state: SlBindState): number => state.getHomeContentBlur());
    this.getMethods.set(SlBindStateType.SL_HOME_SCALE,
      (state: SlBindState): number => state.getScaleByCameraTool());
    this.getMethods.set(SlBindStateType.IS_USING_TOOLS,
      (state: SlBindState): boolean => state.getIsToolsUsing());
    this.getMethods.set(SlBindStateType.IS_CAMERA_VISIBLE,
      (state: SlBindState): boolean => state.getIsCameraVisible());
    this.getMethods.set(SlBindStateType.IS_QUICK_TOOLS_VISIBLE,
      (state: SlBindState): boolean => state.getIsQuickToolVisible());
    this.getMethods.set(SlBindStateType.IS_FOCUS_DISABLED,
      (state: SlBindState): boolean => state.getFocusDisabled());
    this.getMethods.set(SlBindStateType.SL_NEED_USE_EFFECT,
      (state: SlBindState): boolean => state.getNeedUseEffect());
    this.getMethods.set(SlBindStateType.IS_FORM_DRAG_NOT_DROP,
      (state: SlBindState): boolean => state.getIsFormDragNotDrop());
    this.getMethods.set(SlBindStateType.IS_FAKE_AOD_STATE,
      (state: SlBindState, isFakeAodState: boolean) => state?.setIsFakeAodState(isFakeAodState));
    this.getMethods.set(SlBindStateType.SL_BOTTOM_VIEW_MARGIN,
      (state: SlBindState): number => state.getBottomViewMargin());
    this.getMethods.set(SlBindStateType.SL_EDIT_CLOCK_UP_SCALE,
      (state: SlBindState): number => state.getEditClockUpScale());
    this.getMethods.set(SlBindStateType.SL_CLOCK_DRAG_STATE,
      (state: SlBindState): boolean => state.getClockDragState());
    this.getMethods.set(SlBindStateType.SL_FOLD_EXPAND_STATE,
      (state: SlBindState): boolean => state.isFoldExpand());
  }

  public setIsFakeAodState(isFakeAodState: boolean): void {
    this.isFakeAodState = isFakeAodState;
  }

  public getIsFakeAodState(): boolean {
    return this.isFakeAodState;
  }

  public setRootScale(rootScale: number): void {
    this.rootScale = rootScale;
  }

  public getRootScale(): number {
    return this.rootScale;
  }

  private notifyStateChange(subType: SlBindStateType): void { // 通知状态切换
    this.slStateChangeListener?.onSlStateChange?.(SlMainStateType.SL_BIND_STATE, subType);
  }

  public getSlStateType(): SlMainStateType { // 复写ISlState
    return SlMainStateType.SL_BIND_STATE;
  }

  public setSlState(subType: SlBindStateType, value: SlObject): SlBindState { // 复写ISlState
    this.setMethods.get(subType)?.(this, value);
    return this;
  }

  public getSlState(subType: SlBindStateType, scene?: SlObject): SlObject { // 复写ISlState
    return this.getMethods.get(subType)?.(this, scene);
  }

  public setSlShowing(isShowing: boolean): void { // 设置锁屏面板可见性
    if (this.isSlShowing !== isShowing) {
      this.isSlShowing = isShowing;
      this.notifyStateChange(SlBindStateType.SL_SHOWING_STATE);
    }
  }

  public isPanelShowing(): boolean { // 锁屏面板是否可见
    return this.isSlShowing;
  };

  public setOsAccountUnlocked(isUnlocked: boolean): void { // 设置账号认证解锁状态
    if (this.osAccountUnlockState !== isUnlocked) {
      this.osAccountUnlockState = isUnlocked;
      this.notifyStateChange(SlBindStateType.OS_ACCOUNT_UNLOCK_STATE);
    }
  }

  public isOsAccountUnlocked(): boolean { // 账号认证解锁
    return this.osAccountUnlockState;
  };

  public setBgBlurFreeze(freeze?: BlurFreezeScene): SlBindState { // 设置模糊冻结状态
    let isFreeze = freeze?.isFreeze ?? false;
    let scene = freeze?.scene ?? DEFAULT_FREEZE_SCENE;
    log.showInfo(`setBgBlurFreeze freeze:${isFreeze} scene:${scene} curScenes:${Array.from(this.bgBlurFreezeScene).toString()}`);
    if (isFreeze) {
      this.bgBlurFreezeScene.add(scene);
    } else {
      this.bgBlurFreezeScene.delete(scene);
    }
    let isCurFreeze = !ArrayUtils.isEmpty(this.bgBlurFreezeScene);
    if (this.isBgBlurFreeze !== isCurFreeze) {
      this.isBgBlurFreeze = isCurFreeze;
      log.showInfo(`setBgBlurFreeze ${this.isBgBlurFreeze}`);
      this.notifyStateChange(SlBindStateType.BG_BLUR_FREEZE);
    }
    this.handleFreezeTimeout();
    return this;
  }

  private handleFreezeTimeout(): void {
    if (this.preFreezeTimeout !== DEFAULT_TIME_OUT) {
      clearTimeout(this.preFreezeTimeout);
    }
    this.preFreezeTimeout = setTimeout(() => {
      let restScene: string = '';
      this.bgBlurFreezeScene.forEach((scene: string) => {
        if (scene) {
          restScene += (' ' + scene);
        }
      })
      if (restScene) {
        log.showInfo(`handleFreezeTimeout rest: ${restScene}`);
      }
      this.preFreezeTimeout = DEFAULT_TIME_OUT;
    }, FREEZE_TIME_OUT);
  }

  public isBgBlurSceneFreeze(scene?: string): boolean { // 当前模糊冻结状态
    if (scene) {
      log.showInfo(`isBgBlurFreeze ${scene} ${this.bgBlurFreezeScene.has(scene)}`);
      return this.bgBlurFreezeScene.has(scene);
    }
    log.showInfo(`isBgBlurFreeze ${this.isBgBlurFreeze}`);
    return this.isBgBlurFreeze; // 无场景，表示全场景检验
  }

  public getImmersiveWallPaperUsing(): boolean { // 复写ISlState
    return this.isUsingImmersiveWallPaper;
  }

  public setImmersiveWallPaperUsing(isUsingImmersiveWallPaper: boolean): void {
    if (this.isUsingImmersiveWallPaper !== isUsingImmersiveWallPaper) {
      this.isUsingImmersiveWallPaper = isUsingImmersiveWallPaper;
      this.notifyStateChange(SlBindStateType.IS_USING_IMMERSIVE_WALL_PAPER);
    }
  }

  public setSlWallPaperLight(isLight: boolean): void {
    if (this._isSlWallpaperLight !== isLight) {
      this._isSlWallpaperLight = isLight;
      this.notifyStateChange(SlBindStateType.SL_WALLPAPER_LIGHT);
    }
  }

  public isSlWallpaperLight(): boolean {
    return this._isSlWallpaperLight ?? false;
  }

  public getIsImmersiveShowing(): boolean {
    return this.isImmersiveShowing;
  }

  public setSlGreetShowState(value: boolean): void {
    this.slGreetShowState = value;
  }

  public getSlGreetShowState(): boolean {
    return this.slGreetShowState;
  }

  public setIsImmersiveShowing(isImmersiveShowing: boolean): void {
    if (this.isImmersiveShowing !== isImmersiveShowing) {
      this.isImmersiveShowing = isImmersiveShowing;
    }
  }

  public setDisableClockShadow(disableClockShadow: boolean): SlBindState {
    if (disableClockShadow !== this.disableClockShadow) {
      this.disableClockShadow = disableClockShadow;
      this.notifyStateChange(SlBindStateType.DISABLE_CLOCK_SHADOW);
    }
    return this;
  }

  public isDisableClockShadow(): boolean {
    return this.disableClockShadow;
  }

  public setSlVisibility(visibility: Visibility): SlBindState {
    this.slVisibility = visibility;
    return this;
  }

  public getSlVisibility(): Visibility {
    return this.slVisibility;
  }

  public setOpacity(opacity: number): SlBindState {
    this.opacity = opacity;
    return this;
  }

  public getOpacity(): number {
    return this.opacity;
  }

  public setZoomRatio(ratio: number): SlBindState {
    this.zoomRatio = ratio;
    return this;
  }

  public getZoomRatio(): number {
    return this.zoomRatio;
  }

  public setWallpaperTranslate(translate: number): SlBindState {
    this.wallpaperTranslate = translate;
    return this;
  }

  public getWallpaperTranslate(): number {
    return this.wallpaperTranslate;
  }

  public setIsStaticTheme(isStatic: boolean): SlBindState {
    this.isStaticTheme = isStatic;
    return this;
  }

  public getIsStaticTheme(): boolean {
    return this.isStaticTheme;
  }

  public setGridWidth(width: number): SlBindState {
    this.gridWidth = width;
    return this;
  }

  public getGridWidth(): number {
    return this.gridWidth;
  }

  public setHomeContentBlur(blur: number): SlBindState {
    this.homeContentBlur = blur;
    return this;
  }

  public getHomeContentBlur(): number {
    return this.homeContentBlur;
  }

  public setScaleByCameraTool(scale: number): SlBindState {
    this.scaleByCameraTool = scale;
    return this;
  }

  public getScaleByCameraTool(): number {
    return this.scaleByCameraTool;
  }

  public setIsToolsUsing(isUsing: boolean): SlBindState {
    this.isToolsUsing = isUsing;
    return this;
  }

  public getIsToolsUsing(): boolean {
    return this.isToolsUsing;
  }

  /**
   * 设置根组件是否禁止聚焦
   *
   * @param isFocusDisabled 根组件是否禁止聚焦
   */
  public setFocusDisabled(isFocusDisabled: boolean): SlBindState {
    if (this.isFocusDisabled !== isFocusDisabled) {
      this.isFocusDisabled = isFocusDisabled;
    }
    return this;
  }

  /**
   * 获取根组件是否禁止聚焦
   *
   * @returns 根组件是否禁止聚焦
   */
  public getFocusDisabled(): boolean {
    return this.isFocusDisabled;
  }

  public setIsQuickToolVisible(isVisible: boolean): SlBindState {
    this.isQuickToolVisible = isVisible;
    return this;
  }

  public getIsQuickToolVisible(): boolean {
    return this.isQuickToolVisible;
  }

  public setIsCameraVisible(isVisible: boolean): SlBindState {
    this.isCameraVisible = isVisible;
    return this;
  }

  public getIsCameraVisible(): boolean {
    return this.isCameraVisible;
  }

  public setNeedUseEffect(useEffect: boolean): SlBindState {
    this.needUseEffect = useEffect;
    return this;
  }

  public getNeedUseEffect(): boolean {
    return this.needUseEffect;
  }

  public setIsFormDragNotDrop(isNotDrop: boolean): SlBindState {
    this.isFormDragNotDrop = isNotDrop;
    return this;
  }

  public getIsFormDragNotDrop(): boolean {
    return this.isFormDragNotDrop;
  }

  public getSlideScale(): number {
    return this.slideRatio;
  }

  public setSlideScale(scale: number): SlBindState {
    this.slideRatio = scale;
    return this;
  }

  public getisLightWallpaper(): boolean {
    return this.isLightWallpaper;
  }

  public setisLightWallpaper(isLightWallpaper: boolean): void {
    this.isLightWallpaper = isLightWallpaper;
  }

  /**
   * 更新底部小工具距离屏幕边缘间距
   * @param margin 新的布局间距
   */
  public setBottomViewMargin(margin: number): void {
    this.bottomViewMargin = margin;
  }

  /**
   * 获取底部小工具距离屏幕边缘间距
   * @returns 当前布局底部小工具距离屏幕边缘间距
   */
  public getBottomViewMargin(): number {
    return this.bottomViewMargin;
  }

  /**
   * 更新编辑界面缩放比例
   * @param scale 新的缩放比例
   */
  public setEditClockUpScale(scale: number): void {
    this.editClockUpScale = scale;
  }

  /**
   * 获取编辑界面缩放比例
   * @returns 当前编辑界面缩放比例
   */
  public getEditClockUpScale(): number {
    return this.editClockUpScale;
  }

  /**
   * 设置时钟拖拽状态
   * @param isClockDragging 时钟是否拖拽中
   */
  public setClockDragState(isClockDragging: boolean): void {
    if (this.isClockDragging !== isClockDragging) {
      this.isClockDragging = isClockDragging;
      this.notifyStateChange(SlBindStateType.SL_CLOCK_DRAG_STATE);
    }
  }

  /**
   * 获取时钟拖拽状态
   * @returns 时钟是否拖拽中
   */
  public getClockDragState(): boolean {
    return this.isClockDragging;
  }

  public setFoldExpandState(isFoldExpand: boolean): void {
    if (this._isFoldExpand !== isFoldExpand) {
      this._isFoldExpand = isFoldExpand;
      this.notifyStateChange(SlBindStateType.SL_FOLD_EXPAND_STATE);
    }
  }

  public getBlankScreen(): boolean {
    return this.blankScreen;
  }

  public setBlankScreen(blankScreen: boolean): void {
    this.blankScreen = blankScreen;
  }

  public isFoldExpand(): boolean {
    return this._isFoldExpand ?? false;
  }
}