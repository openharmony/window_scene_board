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

import { RectInfo } from '@ohos/basicutils';
import { ClockStaticStateType, SlMainStateType,
  WidgetStaticStateType, ClockDeskTop2AodAnimType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { CcmOption, SlAreaType, SlPositionType, SlVisualControl } from '@ohos/screenlockcommon';
import { BaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { WidgetStaticState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { slStateHelper } from '../../../common/utils/SlStateHelper';
import sMultiSceneThemeManager from '../../../common/theme/MultiSceneThemeManager';
import { BatteryLayout } from '../../../common/WidgetParam';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { ThemeScene } from '@ohos/screenlockcommon/src/main/ets/constants/ThemeEditAndScreenLockConstants';

const TAG = 'SlClockStaticState';

const COMPONENT_ID_DIGITAL_VIEW = 'Text_Digital';
const COMPONENT_ID_DIGITAL_TEXT_VIEW = 'Text_Digital_Text';
const AOD_SIGN_MAX_WITH = vp2px(112);
const AOD_BATTERY_OFFSET = vp2px(-45);

/**
 * 锁屏时钟区域存储类
 */
class ClockInfoRect {
  /**
   * 屏幕类型ThemeScene 锁屏时钟区域
   */
  private clockSceneMap: Map<string, RectInfo> = new Map<string, RectInfo>();

  setRectInfo(info: RectInfo) {
    const qualifier: string = this.getQualifier();
    this.clockSceneMap.set(qualifier, info);
  }

  getRectInfo(): RectInfo | undefined {
    const qualifier: string = this.getQualifier();
    return this.clockSceneMap.get(qualifier)
  }

  clearRectInfo(): void {
    this.clockSceneMap.clear();
  }

  private getQualifier(): string {
    return sMultiSceneThemeManager.getCurrentThemeQualifier();
  }
}

/**
 * 锁屏时钟非UI状态变量管理
 */
export class SlClockStaticState extends WidgetStaticState<ClockStaticStateType> {
  private slClockAnimCtrl: WidgetAnimState = BaseState.wrap(WidgetAnimState, TAG);
  private clockViewAnimSt: WidgetAnimState = BaseState.wrap(WidgetAnimState, TAG);
  private clockBackground?: ResourceColor; // 背景颜色，用于提亮色的混合
  private isChangeColor?: boolean = false; // 时钟是否赋色
  private brightness: number = 1; // 时钟是否需要提亮
  private aodClockColor?: ResourceColor; // AOD时钟颜色
  private isClockVisible: boolean = true;
  private clockExpandRectInfo: ClockInfoRect = new ClockInfoRect(); // 竖排时钟位置
  private clockCollapseRectInfo: ClockInfoRect = new ClockInfoRect(); // 横排时钟位置
  /**
   * 时钟组件初始化是否强制设置锁屏时钟展开状态
   * undefined不强制设置展开非展开状态， true强制设置为展开状态， false强制设置非展开态
   */
  private isClockForceCollapseState?: boolean = undefined;
  /**
   * 是否正在退出锁屏
   */
  private isExitingKg: boolean = false;
  /**
   * 是否播放灭屏时钟一镜到底动效
   */
  private desktop2AodAnimType: ClockDeskTop2AodAnimType = ClockDeskTop2AodAnimType.NONE;
  /**
   * aod显示电量图标开关是否打开
   */
  private batterySwitchOpenMap: Map<BatteryLayout, boolean> = new Map([
    [BatteryLayout.FULL_AOD_LAYOUT, false],
    [BatteryLayout.PART_AOD_LAYOUT, false],
    [BatteryLayout.FULL_ART_SIGN_LAYOUT, false],
  ]);
  /**
   * 是否展开显示
   */
  private isClockExpand: boolean = true;

  /**
   * 时钟组件整体偏移
   */
  private clockMoveDistance: number = 0;

  private enableSolid: boolean = SlVisualControl.getInstance().getEnable(CcmOption.SOLID, SlAreaType.CLOCK);

  private enableBright: boolean = SlVisualControl.getInstance().getEnable(CcmOption.BRIGHT, SlAreaType.CLOCK);
  /**
   * 是否需要刷新时钟样式
   */
  private isNeedRefreshClockLayout: boolean = false;
  /**
   * 是否有通知联动动效
   */
  private hasNtfRelatedAnimation: boolean = false;
  /**
   * 显示AOD电池图标
   */
  private showAodBattery: boolean = false;
  /**
   * 是否展示外屏时钟
   */
  private isSubScreen: boolean = false;
  /**
   * 仅当isSubScreen为true时，才应用此GridWidth
   */
  private subScreenGridWidth: number = 0;
  /**
   * 是否为AOD预览页面
   */
  private isPreviewPage: boolean = false;
  /**
   * AOD隔离逻辑使用，后续统一整改为UseScene
   */
  private clockViewId: string = COMPONENT_ID_DIGITAL_VIEW;
  /**
   * AOD组件截图使用，后续统一整改为UseScene
   */
  private textViewIdPrefix: string = COMPONENT_ID_DIGITAL_TEXT_VIEW;
  /**
   * 是否显示日期
   */
  private _dateVisible: boolean = true;
  /**
   * 是否显示农历
   */
  private _lunarVisible: boolean = true;
  /**
   * AOD签名最大宽度
   */
  private aodSignMaxWith: number = AOD_SIGN_MAX_WITH;
  /**
   * AOD电量偏移
   */
  private aodBatteryOffset: number = AOD_BATTERY_OFFSET;

  // 艺术签名文本长度
  private artSignTextLength: number = 0;

  // 标记是否英文文本
  private isTextBlock: boolean = false;

  // 艺术签名海报是否时镜像布局
  private isMirrorLayout: boolean = false;

  // 所有组件都显示样式配置的字体
  private allShowConfigFont: boolean = false;

  // 时钟在AOD态展开
  private isClockExpandOnAod: boolean = false;

  // 时钟布局左边距
  private clockWidgetLeftMargin: number = 0;
  // 时钟布局上边距
  private clockWidgetTopMargin: number = 0;

  // 标识时钟位置更新是否需要触发动效，在开机时，默认值为false不会触发动效
  private isClockMarginNeedAnim: boolean = false;

  constructor() {
    super(SlMainStateType.SL_CLOCK_WG_STATIC_STATE);
  }

  protected initSetMethods(): void { // 复写 WidgetStaticState
    super.initSetMethods();
    this.setMethods.set(ClockStaticStateType.BACKGROUND_COLOR, this.setMethodBackgroundColor);
    this.setMethods.set(ClockStaticStateType.IS_CHANGE_COLOR, this.setMethodChangeColorState);
    this.setMethods.set(ClockStaticStateType.BRIGHTNESS, this.setMethodBrightness);
    this.setMethods.set(ClockStaticStateType.AOD_CLOCK_COLOR, this.setMethodAodClockColor);
    this.setMethods.set(ClockStaticStateType.IS_EXITING_KG, this.setMethodIsExitingKg);
    this.setMethods.set(ClockStaticStateType.IS_CLOCK_FORCE_COLLAPSE_STATE, this.setMethodIsClockForceCollapseState);
    this.setMethods.set(ClockStaticStateType.DESKTOP_TO_AOD_ANIM_TYPE, this.setMethodDesktopToAodAniType);
    this.setMethods.set(ClockStaticStateType.IS_CLOCK_EXPAND_STATE, this.setMethodSetIsExpand);
    this.setMethods.set(ClockStaticStateType.CLOCK_MOVE_DISTANCE, this.setMethodClockMoveDistance);
    this.setMethods.set(ClockStaticStateType.CLOCK_DIGITAL_RECT_EXPAND, this.setMethodClockExpandRectInfo);
    this.setMethods.set(ClockStaticStateType.CLOCK_DIGITAL_RECT_COLLAPSE, this.setMethodClockCollapseRectInfo);
    this.setMethods.set(ClockStaticStateType.IS_AOD_CLOCK_EXPAND, this.setMethodClockExpandOnAod);
  }

  private setMethodClockExpandRectInfo(st: SlClockStaticState, value: Area): void {
    st.setClockExpandRectInfo(value);
  }

  private setMethodClockCollapseRectInfo(st: SlClockStaticState, value: Area): void {
    st.setClockCollapseRectInfo(value);
  }

  private setMethodClockMoveDistance(st: SlClockStaticState, value: number): void {
    st.setClockMoveDistance(value);
  }

  private setMethodIsExitingKg(st: SlClockStaticState, value: boolean): void {
    st.setIsExitingKg(value);
  }

  private setMethodBackgroundColor(st: SlClockStaticState, value: ResourceColor): void {
    st.setBackgroundColor(value);
  }

  private setMethodChangeColorState(st: SlClockStaticState, value: boolean): void {
    st.setChangeColorState(value);
  }

  private setMethodBrightness(st: SlClockStaticState, value: number): void {
    st.setBrightness(value);
  }

  private setMethodAodClockColor(st: SlClockStaticState, value: ResourceColor): void {
    st.setAodClockColor(value);
  }

  private setMethodIsClockForceCollapseState(st: SlClockStaticState, value: boolean): void {
    st.setClockForceCollapseState(value);
  }

  private setMethodDesktopToAodAniType(st: SlClockStaticState, value: ClockDeskTop2AodAnimType): void {
    st.setDesktopToAodAniType(value);
  }

  private setMethodClockExpandOnAod(st: SlClockStaticState, value:boolean):void {
    st.setClockExpandOnAod(value);
  }

  private getMethodClockExpandOnAod(st: SlClockStaticState): boolean {
    return st.getClockExpandOnAod();
  }

  private getMethodClockExpandRectInfo(st: SlClockStaticState): RectInfo | undefined {
    return st.getExpandClockRectInfo();
  }

  private getMethodClockCollapseRectInfo(st: SlClockStaticState): RectInfo | undefined {
    return st.getCollapseClockRectInfo();
  }

  private getMethodClockMoveDistance(st: SlClockStaticState): number {
    return st.getClockMoveDistance();
  }

  private getMethodSlClockAnimCtrl(st: SlClockStaticState): WidgetAnimState {
    return st.getSlClockAnimCtrl();
  }

  private getMethodClockViewAnimSt(st: SlClockStaticState): WidgetAnimState {
    return st.getClockViewAnimSt();
  }

  private getMethodBackgroundColor(st: SlClockStaticState): ResourceColor | undefined {
    return st.getBackgroundColor();
  }

  private getMethodChangeColorState(st: SlClockStaticState): boolean | undefined {
    return st.getChangeColorState();
  }

  private getMethodBrightness(st: SlClockStaticState): number {
    return st.getBrightness();
  }

  private getMethodAodClockColor(st: SlClockStaticState): ResourceColor | undefined {
    return st.getAodClockColor();
  }

  private getMethodIsExitingKg(st: SlClockStaticState): boolean | undefined {
    return st.getIsExitingKg();
  }

  private getMethodIsClockForceCollapseState(st: SlClockStaticState): boolean | undefined {
    return st.getIsClockForceCollapseState();
  }

  private getMethodIsClockVisibleState(st: SlClockStaticState): boolean | undefined {
    return st.getIsClockVisible();
  }

  private getMethodDesktopToAodAniType(st: SlClockStaticState): ClockDeskTop2AodAnimType {
    return st.getDesktopToAodAniType();
  }

  private getMethodIsExpand(st: SlClockStaticState): boolean {
    return st.getIsExpand();
  }

  private setMethodSetIsExpand(st: SlClockStaticState, isExpand: boolean): void {
    st.setIsExpand(isExpand);
  }

  protected initGetMethods(): void { // 复写 WidgetStaticState
    super.initGetMethods();
    this.getMethods.set(WidgetStaticStateType.WIDGET_ANIM_CTRL, this.getMethodSlClockAnimCtrl);
    this.getMethods.set(ClockStaticStateType.CLOCK_VIEW_ANIM, this.getMethodClockViewAnimSt);
    this.getMethods.set(ClockStaticStateType.BACKGROUND_COLOR, this.getMethodBackgroundColor);
    this.getMethods.set(ClockStaticStateType.IS_CHANGE_COLOR, this.getMethodChangeColorState);
    this.getMethods.set(ClockStaticStateType.BRIGHTNESS, this.getMethodBrightness);
    this.getMethods.set(ClockStaticStateType.AOD_CLOCK_COLOR, this.getMethodAodClockColor);
    this.getMethods.set(ClockStaticStateType.IS_EXITING_KG, this.getMethodIsExitingKg);
    this.getMethods.set(ClockStaticStateType.IS_CLOCK_FORCE_COLLAPSE_STATE, this.getMethodIsClockForceCollapseState);
    this.getMethods.set(ClockStaticStateType.DESKTOP_TO_AOD_ANIM_TYPE, this.getMethodDesktopToAodAniType);
    this.getMethods.set(ClockStaticStateType.IS_CLOCK_EXPAND_STATE, this.getMethodIsExpand);
    this.getMethods.set(ClockStaticStateType.CLOCK_MOVE_DISTANCE, this.getMethodClockMoveDistance);
    this.getMethods.set(ClockStaticStateType.CLOCK_DIGITAL_RECT_COLLAPSE, this.getMethodClockCollapseRectInfo);
    this.getMethods.set(ClockStaticStateType.CLOCK_DIGITAL_RECT_EXPAND, this.getMethodClockExpandRectInfo);
    this.getMethods.set(ClockStaticStateType.IS_AOD_CLOCK_EXPAND, this.getMethodClockExpandOnAod);
    this.getMethods.set(ClockStaticStateType.CLOCK_VISIBLE_STATE, this.getMethodIsClockVisibleState);
  }

  public getClockExpandOnAod(): boolean {
    return this.isClockExpandOnAod;
  }

  public setClockExpandRectInfo(value: Area): SlClockStaticState {
    let left = (value?.globalPosition?.x ?? 0) as number;
    let top = (value?.globalPosition?.y ?? 0) as number;
    let width = (value?.width ?? 0) as number;
    let height = (value?.height ?? 0) as number;
    this.clockExpandRectInfo.setRectInfo(new RectInfo(left, top, width, height));
    return this;
  }

  public setClockCollapseRectInfo(value: Area): SlClockStaticState {
    let left = (value?.globalPosition?.x ?? 0) as number;
    let top = (value?.globalPosition?.y ?? 0) as number;
    let width = (value?.width ?? 0) as number;
    let height = (value?.height ?? 0) as number;
    this.clockCollapseRectInfo.setRectInfo(new RectInfo(left, top, width, height));
    return this;
  }

  public clearClockRectInfo(): void {
    this.clockCollapseRectInfo.clearRectInfo();
    this.clockExpandRectInfo.clearRectInfo();
  }

  public getExpandClockRectInfo(): RectInfo | undefined {
    return this.clockExpandRectInfo.getRectInfo();
  }

  public getCollapseClockRectInfo(): RectInfo | undefined {
    return this.clockCollapseRectInfo.getRectInfo();
  }

  public setClockMoveDistance(value: number): SlClockStaticState {
    let result = value ?? 0;
    if (this.clockMoveDistance !== result) {
      this.clockMoveDistance = result;
      this.notifyStateChange(ClockStaticStateType.CLOCK_MOVE_DISTANCE);
    }
    return this;
  }

  public getClockMoveDistance(): number {
    return this.clockMoveDistance;
  }

  public setBackgroundColor(color: ResourceColor): SlClockStaticState {
    if (this.clockBackground !== color) {
      this.clockBackground = color;
    }
    return this;
  }

  public getBackgroundColor(): ResourceColor | undefined {
    return this.isChangeColor ? this.clockBackground : this.getDefaultBackgroundColor();
  }

  private getDefaultBackgroundColor(): ResourceColor | undefined {
    if (this.enableSolid) {
      return SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_CLOCK_WIDGET)?.getSolidColor();
    } else if (!this.enableBright) {
      return SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_CLOCK_WIDGET)?.getBrightnessColor(
        slStateHelper.getSlClockBindState()?.getLightWallpaperState());
    }
    return this.clockBackground;
  }


  public setAodClockColor(color?: ResourceColor): SlClockStaticState {
    if (this.aodClockColor !== color) {
      this.aodClockColor = color;
    }
    return this;
  }

  public getAodClockColor(): ResourceColor | undefined {
    return this.aodClockColor;
  }

  public setClockForceCollapseState(expand: boolean | undefined): SlClockStaticState {
    if (this.isClockForceCollapseState !== expand) {
      this.isClockForceCollapseState = expand;
    }
    return this;
  }

  public setDesktopToAodAniType(animType: ClockDeskTop2AodAnimType): SlClockStaticState {
    if (this.desktop2AodAnimType !== animType) {
      this.desktop2AodAnimType = animType;
      this.notifyStateChange(ClockStaticStateType.DESKTOP_TO_AOD_ANIM_TYPE);
    }
    return this;
  }

  public setClockExpandOnAod(value: boolean): SlClockStaticState {
    if (this.isClockExpandOnAod !== value) {
      this.isClockExpandOnAod = value;
      this.notifyStateChange(ClockStaticStateType.IS_AOD_CLOCK_EXPAND);
    }
    return this;
  }

  public setBrightness(brightness: number): void {
    if (this.brightness !== brightness) {
      this.brightness = brightness;
      this.notifyStateChange(ClockStaticStateType.BRIGHTNESS);
    }
  }

  public getBrightness(): number {
    return this.brightness;
  };

  public setChangeColorState(isChangeColor: boolean): SlClockStaticState {
    if (isChangeColor === undefined) {
      return this;
    }
    if (this.isChangeColor !== isChangeColor) {
      this.isChangeColor = isChangeColor;
      this.notifyStateChange(ClockStaticStateType.IS_CHANGE_COLOR);
    }
    return this;
  }

  public getChangeColorState(): boolean | undefined {
    return this.isChangeColor;
  }

  public getSlClockAnimCtrl(): WidgetAnimState { // 获取锁屏时钟动效管理
    return this.slClockAnimCtrl;
  };

  public getClockViewAnimSt(): WidgetAnimState {
    return this.clockViewAnimSt;
  }

  public setIsClockVisible(isClockVisible: boolean): void {
    if (this.isClockVisible !== isClockVisible) {
      this.isClockVisible = isClockVisible;
      this.notifyStateChange(ClockStaticStateType.CLOCK_VISIBLE_STATE);
    }
  }

  public getIsClockVisible(): boolean {
    return this.isClockVisible;
  }

  public setIsExitingKg(isExitingKg: boolean): void {
    this.isExitingKg = isExitingKg;
  }

  public getIsExitingKg(): boolean {
    return this.isExitingKg;
  }

  public getIsClockForceCollapseState(): boolean | undefined {
    return this.isClockForceCollapseState;
  }

  public getDesktopToAodAniType(): ClockDeskTop2AodAnimType {
    return this.desktop2AodAnimType;
  }

  public setBatterySwitchState(isSwitchOpen: boolean, layout?: BatteryLayout): void {
    if (layout === undefined) {
      return;
    }
    const switchOpen: boolean | undefined = this.batterySwitchOpenMap.get(layout);
    if (switchOpen !== isSwitchOpen) {
      this.batterySwitchOpenMap.set(layout, isSwitchOpen);
      this.notifyStateChange(ClockStaticStateType.BATTERY_SWITCH_STATE);
    }
  }

  public getBatterySwitchState(layout: BatteryLayout): boolean {
    return this.batterySwitchOpenMap.get(layout) ?? false;
  }

  public setIsExpand(isClockExpand: boolean): void {
    if (this.isClockExpand !== isClockExpand) {
      this.isClockExpand = isClockExpand;
      this.notifyStateChange(ClockStaticStateType.IS_CLOCK_EXPAND_STATE);
    }
  }

  public getIsExpand(): boolean {
    return this.isClockExpand;
  }

  public setIsNeedRefreshClockLayout(isNeedRefreshClockLayout: boolean): void {
    if (this.isNeedRefreshClockLayout !== isNeedRefreshClockLayout) {
      this.isNeedRefreshClockLayout = isNeedRefreshClockLayout;
      this.notifyStateChange(ClockStaticStateType.IS_NEED_REFRESH_CLOCK_LAYOUT);
    }
  }

  public getIsNeedRefreshClockLayout(): boolean {
    return this.isNeedRefreshClockLayout;
  }

  public setHasNtfRelatedAnimation(hasNtfRelatedAnimation: boolean): void {
    if (this.hasNtfRelatedAnimation !== hasNtfRelatedAnimation) {
      this.hasNtfRelatedAnimation = hasNtfRelatedAnimation;
      this.notifyStateChange(ClockStaticStateType.HAS_NTF_RELATED_ANIMATION);
    }
  }

  public getHasNtfRelatedAnimation(): boolean {
    return this.hasNtfRelatedAnimation;
  }

  public setShowAodBattery(showAodBattery: boolean): void {
    if (this.showAodBattery !== showAodBattery) {
      this.showAodBattery = showAodBattery;
      this.notifyStateChange(ClockStaticStateType.SHOW_AOD_BATTERY);
    }
  }

  public getShowAodBattery(): boolean {
    return this.showAodBattery;
  }

  public setIsSubScreen(isSubScreen: boolean): void {
    if (this.isSubScreen !== isSubScreen) {
      this.isSubScreen = isSubScreen;
      this.notifyStateChange(ClockStaticStateType.IS_SUB_SCREEN);
    }
  }

  public getIsSubScreen(): boolean {
    return this.isSubScreen;
  }

  public setSubScreenGridWidth(subScreenGridWidth: number): void {
    if (this.subScreenGridWidth !== subScreenGridWidth) {
      this.subScreenGridWidth = subScreenGridWidth;
      this.notifyStateChange(ClockStaticStateType.BRIGHTNESS);
    }
  }

  public getSubScreenGridWidth(): number {
    return this.subScreenGridWidth;
  }

  public setIsPreviewPage(isPreviewPage: boolean): void {
    if (this.isPreviewPage !== isPreviewPage) {
      this.isPreviewPage = isPreviewPage;
      this.notifyStateChange(ClockStaticStateType.IS_SUB_SCREEN);
    }
  }

  public getIsPreviewPage(): boolean {
    return this.isPreviewPage;
  }

  public setClockViewId(clockViewId: string): void {
    if (this.clockViewId !== clockViewId) {
      this.clockViewId = clockViewId;
      this.notifyStateChange(ClockStaticStateType.BRIGHTNESS);
    }
  }

  public getClockViewId(): string {
    return this.clockViewId;
  }

  public setTextViewIdPrefix(textViewIdPrefix: string): void {
    if (this.textViewIdPrefix !== textViewIdPrefix) {
      this.textViewIdPrefix = textViewIdPrefix;
      this.notifyStateChange(ClockStaticStateType.BRIGHTNESS);
    }
  }

  public getTextViewIdPrefix(): string {
    return this.textViewIdPrefix;
  }

  public setDateVisible(value: boolean) {
    if (this._dateVisible != value) {
      this._dateVisible = value;
    }
  }

  public getDateVisible(): boolean {
    return this._dateVisible;
  }

  public setLunarVisible(value: boolean) {
    if (this._lunarVisible != value) {
      this._lunarVisible = value;
    }
  }

  public getLunarVisible(): boolean {
    return this._lunarVisible;
  }

  public setAodSignMaxWidth(value: number): void {
    if (this.aodSignMaxWith !== value) {
      this.aodSignMaxWith = value;
    }
  }

  public getAodSignMaxWidth(): number {
    return this.aodSignMaxWith;
  }

  public setAodBatteryOffset(value: number): void {
    if (this.aodBatteryOffset !== value) {
      this.aodBatteryOffset = value;
    }
  }

  public getAodBatteryOffset(): number {
    return this.aodBatteryOffset;
  }

  public setArtSignTextLength(length: number): void {
    if (this.artSignTextLength !== length) {
      this.artSignTextLength = length;
    }
  }

  public getArtSignTextLength(): number {
    return this.artSignTextLength;
  }

  public setTextBlock(isTextBlock: boolean): void {
    if (this.isTextBlock !== isTextBlock) {
      this.isTextBlock = isTextBlock;
    }
  }

  public getTextBlock(): boolean {
    return this.isTextBlock;
  }

  /**
   * 设置当前是否需要使用镜像布局
   *
   * @param isMirrorLayout true表示使用镜像布局
   */
  public setMirrorLayout(isMirrorLayout: boolean): void {
    if (isMirrorLayout !== this.isMirrorLayout) {
      this.isMirrorLayout = isMirrorLayout;
      return;
    }
  }

  /**
   * 当前是否使用镜像布局
   * @returns true表示当前使用镜像布局
   */
  public isUsingMirrorLayout(): boolean {
    return this.isMirrorLayout;
  }

  public setAllShowConfigFont(allShowConfigFont: boolean): void {
    if (this.allShowConfigFont !== allShowConfigFont) {
      this.allShowConfigFont = allShowConfigFont;
    }
  }

  public getAllShowConfigFont(): boolean {
    return this.allShowConfigFont;
  }

  public setClockWidgetTopMargin(clockWidgetTopMargin: number): void {
    this.clockWidgetTopMargin = clockWidgetTopMargin;
  }

  public getClockWidgetTopMargin(): number {
    return this.clockWidgetTopMargin;
  }

  public setClockWidgetLeftMargin(clockWidgetLeftMargin: number): void {
    this.clockWidgetLeftMargin = clockWidgetLeftMargin;
  }

  public getClockWidgetLeftMargin(): number {
    return this.clockWidgetLeftMargin;
  }

  public setIsClockMarginNeedAnim(isClockMarginNeedAnim: boolean): void {
    this.isClockMarginNeedAnim = isClockMarginNeedAnim;
  }

  public getIsClockMarginNeedAnim(): boolean {
    return this.isClockMarginNeedAnim;
  }
}