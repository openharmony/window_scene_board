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

import { AppDataWrapper, CommonConstants, StyleConstants } from '../../TsIndex';
import { AppIconExternCb } from '../interface/AppIconExternCb';

export class AppIconConfig {
  // 是否使用overlay方式创建图标, 仅支持图标、按压蒙层
  private _enableOverlayIcon: boolean = false;
  // 合成文件夹背板是否支持
  private _enableBackplane: boolean = true;
  // 禁用蒙层是否支持
  private _enableDisableMask: boolean = true;
  // 按压蒙层是否支持
  private _enableTouchMask: boolean = true;
  // 下载蒙层是否支持
  private _enableInstallAnimate: boolean = true;
  // 应用名称是否支持
  private _enableName: boolean = true;
  // 应用名称是否支持右键菜单
  private _enableRightMenuFromName: boolean = false;
  // 右上角标是否支持: 通知角标、自定义角标
  private _enableBadge: boolean = true;
  // 堆叠角标是否支持
  private _enableSuperPoseBadge: boolean = false;
  // 右下角标是否支持: 分身角标
  private _enableCloneBadge: boolean = true;
  // 多选框是否支持
  private _enableMultiSelect: boolean = true;

  // 弹出菜单是否支持
  private _enableMenu: boolean = true;
  // 鼠标长按弹出菜单是否支持
  private _enableMenuWithMouse: boolean = false;
  // 拖拽是否支持
  private _enableDrag: boolean = true;
  // Hover态是否支持
  private _enableHoverAnimation: boolean = false;
  // 应用图标的反馈效果
  private _enableEffectFlag: number = CommonConstants.DEFAULT_ENABLE_EFFECT_FLAG;
  // 应用名称转场动效是否支持
  private _enableAppNameTransactionAnimate: boolean = true;
  // 应用名称是否支持显隐动效
  private _enableNameAnim: boolean = true;
  // 长按弹菜单是否支持图标显隐
  private _enableLongPressIconVisibility: boolean = true;
  // 长按菜单预览图是否支持
  private _enableLongPressMenuPreview: boolean = true;
  // 鼠标右键菜单是否跟随图标
  private _enableRightClickMenuFollowIcon: boolean = true;

  // 自适应布局是否支持
  private _isAdaptiveLayout: boolean = false;
  // 是否显示小角标: 大文件夹角标
  private _isBadgeSmaller: boolean = false;
  // 壁纸字体颜色是否支持
  private _enableWallpaperFontColor: boolean = true;
  // 阴影是否支持
  private _enableShadow: boolean = true;
  // 热区扩展是否支持
  private _enableExtendResponseRegion: boolean = true;
  // 是否支持动态图标阴影显示
  private _enableDynamicIconShadow: boolean = false;
  // 图标容器大小
  private _iconContainerSize: Length = StyleConstants.PERCENTAGE_100;
  // 图标背板扩展大小: PC图标选中背板、文件夹合成背板
  private _iconBackPlaneSize: number = 0;
  // 图标的上外边距
  private _iconMarginTop: number = 0;
  // 相对布局设置
  private _alignRuleOption?: AlignRuleOption;
  // 是否支持检测与修复
  private _enableSupportCheckAndFix: boolean = false;
  // 是否使能container透明度变化事件
  private _enableContainerOpacityChange: boolean = true;
  // 是否是桌面Item
  private _isDesktopItem: boolean = true;
  // 是否复用appIconConfig and iconEvent
  private _isReuseIconConfigAndEvent: boolean = false;
  // 是否是外屏桌面
  private _isOuterDesktop: boolean = false;
  // 是否可显示阴影
  private _enableNameShadow: boolean = true;
  // 是否任何场景均设置圆角
  private _enableRadiusAll: boolean = false;
  // 是否是应用中心Item
  private _isAppCenterItem: boolean = false;
  // 图标的唯一性标识，需要业务侧创建
  private _appDataOfTransitionController?: AppDataWrapper;
  // 业务侧回调
  private _externCb?: AppIconExternCb;
  // 文件夹是否展开
  private _isOpenFolder?: boolean;
  // 是否保持菜单顺序
  // 仅dock区图标使用: dock区图标快捷方式顺序固定, 无需反向, 后续dock+宫格区菜单项归一后此属性可去除
  private _keepMenuOrder: boolean = false;
  private _enableContainerClickEvent: boolean = true;

  public setKeepMenuOrder(value: boolean): AppIconConfig {
    this._keepMenuOrder = value;
    return this;
  }

  public get keepMenuOrder(): boolean {
    return this._keepMenuOrder;
  }

  public get isOpenFolder(): boolean {
    return this._isOpenFolder ?? false;
  }

  public setIsOpenFolder(isOpenFolder: boolean): AppIconConfig {
    this._isOpenFolder = isOpenFolder;
    return this;
  }

  // 是否支持鼠标长按震动
  private _enableMouseLongPressVibration = true;

  // 是否支持获焦
  private _enableFocus = true;

  public get enableName(): boolean {
    return this._enableName;
  }

  public get enableBadge(): boolean {
    return this._enableBadge;
  }

  public get enableRightMenuFromName(): boolean {
    return this._enableRightMenuFromName;
  }

  public get enableSuperPoseBadge(): boolean {
    return this._enableSuperPoseBadge;
  }

  public get enableCloneBadge(): boolean {
    return this._enableCloneBadge;
  }

  public get enableMenu(): boolean {
    return this._enableMenu;
  }

  public get enableMenuWithMouse(): boolean {
    return this._enableMenuWithMouse;
  }

  public get enableDrag(): boolean {
    return this._enableDrag;
  }

  public get isAdaptiveLayout(): boolean {
    return this._isAdaptiveLayout;
  }

  public get isBadgeSmaller(): boolean {
    return this._isBadgeSmaller;
  }

  public get enableBackplane(): boolean {
    return this._enableBackplane;
  }

  public get enableInstallAnimate(): boolean {
    return this._enableInstallAnimate;
  }

  public get enableTouchMask(): boolean {
    return this._enableTouchMask;
  }

  public get enableDisableMask(): boolean {
    return this._enableDisableMask;
  }

  public get enableMultiSelect(): boolean {
    return this._enableMultiSelect;
  }

  public get enableWallpaperFontColor(): boolean {
    return this._enableWallpaperFontColor;
  }

  public get enableShadow(): boolean {
    return this._enableShadow;
  }

  public get enableEffectFlag(): number {
    return this._enableEffectFlag;
  }

  public get iconContainerSize(): Length {
    return this._iconContainerSize;
  }

  public get appDataOfTransitionController(): AppDataWrapper | undefined {
    return this._appDataOfTransitionController;
  }

  public get enableExtendResponseRegion(): boolean {
    return this._enableExtendResponseRegion;
  }

  public get enableHoverAnimation(): boolean {
    return this._enableHoverAnimation;
  }

  public get enableAppNameTransactionAnimate(): boolean {
    return this._enableAppNameTransactionAnimate;
  }

  public get enableNameAnim(): boolean {
    return this._enableNameAnim;
  }

  public get enableLongPressIconVisibility(): boolean {
    return this._enableLongPressIconVisibility;
  }

  public get enableLongPressMenuPreview(): boolean {
    return this._enableLongPressMenuPreview;
  }

  public get enableRightClickMenuFollowIcon(): boolean {
    return this._enableRightClickMenuFollowIcon;
  }

  public get isDesktopItem(): boolean {
    return this._isDesktopItem;
  }

  public get isReuseIconConfigAndEvent(): boolean {
    return this._isReuseIconConfigAndEvent;
  }

  public get isOuterDesktop(): boolean {
    return this._isOuterDesktop;
  }

  public get enableDynamicIconShadow(): boolean {
    return this._enableDynamicIconShadow;
  }

  public get externCb(): AppIconExternCb | undefined {
    return this._externCb;
  }

  public get iconBackPlaneSize(): number {
    return this._iconBackPlaneSize;
  }

  public get iconMarginTop(): number {
    return this._iconMarginTop;
  }

  public get alignRuleOption(): AlignRuleOption | undefined {
    return this._alignRuleOption;
  }

  public get enableOverlayIcon(): boolean {
    return this._enableOverlayIcon;
  }

  public get enableNameShadow(): boolean {
    return this._enableNameShadow;
  }

  public get enableRadiusAll(): boolean {
    return this._enableRadiusAll;
  }

  public get isAppCenterItem(): boolean {
    return this._isAppCenterItem;
  }

  public get enableMouseLongPressVibration(): boolean {
    return this._enableMouseLongPressVibration;
  }

  public get enableContainerClickEvent(): boolean {
    return this._enableContainerClickEvent;
  }

  public get enableSupportCheckAndFix(): boolean {
    return this._enableSupportCheckAndFix;
  }

  public get enableContainerOpacityChange(): boolean {
    return this._enableContainerOpacityChange;
  }

  public get enableFocus(): boolean {
    return this._enableFocus;
  }

  public setEnableName(enableName: boolean): AppIconConfig {
    this._enableName = enableName;
    return this;
  }

  public setEnableBadge(enableBadge: boolean): AppIconConfig {
    this._enableBadge = enableBadge;
    return this;
  }

  public setEnableRightMenuFromName(enableRightMenuFromName: boolean): AppIconConfig {
    this._enableRightMenuFromName = enableRightMenuFromName;
    return this;
  }

  public setEnableSuperPoseBadge(enableSuperPoseBadge: boolean): AppIconConfig {
    this._enableSuperPoseBadge = enableSuperPoseBadge;
    return this;
  }

  public setEnableCloneBadge(enableCloneBadge: boolean): AppIconConfig {
    this._enableCloneBadge = enableCloneBadge;
    return this;
  }

  public setEnableMenu(enableMenu: boolean): AppIconConfig {
    this._enableMenu = enableMenu;
    return this;
  }

  public setEnableMenuWithMouse(enableMenuWithMouse: boolean): AppIconConfig {
    this._enableMenuWithMouse = enableMenuWithMouse;
    return this;
  }

  public setEnableDrag(enableDrag: boolean): AppIconConfig {
    this._enableDrag = enableDrag;
    return this;
  }

  public setEnableExtendResponseRegion(enableExtendResponseRegion: boolean): AppIconConfig {
    this._enableExtendResponseRegion = enableExtendResponseRegion;
    return this;
  }

  public setEnableDynamicIconShadow(enableDynamicIconShadow: boolean): AppIconConfig {
    this._enableDynamicIconShadow = enableDynamicIconShadow;
    return this;
  }

  public setEnableHoverAnimation(enableHoverAnimation: boolean): AppIconConfig {
    this._enableHoverAnimation = enableHoverAnimation;
    return this;
  }

  public setIsDesktopItem(isDesktopItem: boolean): AppIconConfig {
    this._isDesktopItem = isDesktopItem;
    return this;
  }

  public setIsReuseIconConfigAndEvent(isReuseIconConfigAndEvent: boolean): AppIconConfig {
    this._isReuseIconConfigAndEvent = isReuseIconConfigAndEvent;
    return this;
  }

  public setIsOuterDesktop(isOuterDesktop: boolean): AppIconConfig {
    this._isOuterDesktop = isOuterDesktop;
    return this;
  }

  public setEnableBackplane(enableBackplane: boolean): AppIconConfig {
    this._enableBackplane = enableBackplane;
    return this;
  }

  public setEnableInstallAnimate(enableInstallAnimate: boolean): AppIconConfig {
    this._enableInstallAnimate = enableInstallAnimate;
    return this;
  }

  public setEnableTouchMask(enableTouchMask: boolean): AppIconConfig {
    this._enableTouchMask = enableTouchMask;
    return this;
  }

  public setEnableDisableMask(enableDisableMask: boolean): AppIconConfig {
    this._enableDisableMask = enableDisableMask;
    return this;
  }

  public setEnableMultiSelect(enableMultiSelect: boolean): AppIconConfig {
    this._enableMultiSelect = enableMultiSelect;
    return this;
  }

  public setEnableWallpaperFontColor(enableWallpaperFontColor: boolean): AppIconConfig {
    this._enableWallpaperFontColor = enableWallpaperFontColor;
    return this;
  }

  public setEnableShadow(enableShadow: boolean): AppIconConfig {
    this._enableShadow = enableShadow;
    return this;
  }

  public setEnableEffectFlag(enableEffectFlag: number): AppIconConfig {
    this._enableEffectFlag = enableEffectFlag;
    return this;
  }

  public setEnableAppNameTransactionAnimate(enableAppNameTransactionAnimate: boolean): AppIconConfig {
    this._enableAppNameTransactionAnimate = enableAppNameTransactionAnimate;
    return this;
  }

  public setEnableNameAnim(enableNameAnim: boolean): AppIconConfig {
    this._enableNameAnim = enableNameAnim;
    return this;
  }

  public setEnableLongPressIconVisibility(enableLongPressIconVisibility: boolean): AppIconConfig {
    this._enableLongPressIconVisibility = enableLongPressIconVisibility;
    return this;
  }

  public setEnableLongPressMenuPreview(enableLongPressMenuPreview: boolean): AppIconConfig {
    this._enableLongPressMenuPreview = enableLongPressMenuPreview;
    return this;
  }

  public setEnableRightClickMenuFollowIcon(enableRightClickMenuFollowIcon: boolean): AppIconConfig {
    this._enableRightClickMenuFollowIcon = enableRightClickMenuFollowIcon;
    return this;
  }

  public setIsAdaptiveLayout(isAdaptiveLayout: boolean): AppIconConfig {
    this._isAdaptiveLayout = isAdaptiveLayout;
    return this;
  }

  public setAppDataOfTransactionController(appData: AppDataWrapper): AppIconConfig {
    this._appDataOfTransitionController = appData;
    return this;
  }

  public setIsBadgeSmaller(isBadgeSmaller: boolean): AppIconConfig {
    this._isBadgeSmaller = isBadgeSmaller;
    return this;
  }

  public setIconContainerSize(iconContainerSize: Length): AppIconConfig {
    this._iconContainerSize = iconContainerSize;
    return this;
  }

  public setIconBackPlaneSize(iconBackPlaneSize: number): AppIconConfig {
    this._iconBackPlaneSize = iconBackPlaneSize;
    return this;
  }

  public setIconMarginTop(iconMarginTop: number): AppIconConfig {
    this._iconMarginTop = iconMarginTop;
    return this;
  }

  public setAlignRuleOption(alignRuleOption: AlignRuleOption): AppIconConfig {
    this._alignRuleOption = alignRuleOption;
    return this;
  }

  public setExternCb(externCb: AppIconExternCb): AppIconConfig {
    this._externCb = externCb;
    return this;
  }

  public setEnableOverlayIcon(enableOverlayIcon: boolean): AppIconConfig {
    this._enableOverlayIcon = enableOverlayIcon;
    return this;
  }

  public setEnableNameShadow(enableNameShadow: boolean): AppIconConfig {
    this._enableNameShadow = enableNameShadow;
    return this;
  }

  public setEnableRadiusAll(enableRadiusAll: boolean): AppIconConfig {
    this._enableRadiusAll = enableRadiusAll;
    return this;
  }

  public setIsAppCenterItem(isAppCenterItem: boolean): AppIconConfig {
    this._isAppCenterItem = isAppCenterItem;
    return this;
  }

  public setEnableMouseLongPressVibration(enableMouseLongPressVibration: boolean): AppIconConfig {
    this._enableMouseLongPressVibration = enableMouseLongPressVibration;
    return this;
  }

  public setEnableContainerClickEvent(enableContainerClickEvent: boolean): AppIconConfig {
    this._enableContainerClickEvent = enableContainerClickEvent;
    return this;
  }

  public setEnableSupportCheckAndFix(enableSupportCheckAndFix: boolean): AppIconConfig {
    this._enableSupportCheckAndFix = enableSupportCheckAndFix;
    return this;
  }

  public setEnableContainerOpacityChange(enableContainerOpacityChange: boolean): AppIconConfig {
    this._enableContainerOpacityChange = enableContainerOpacityChange;
    return this;
  }

  public setEnableFocus(enableFocus: boolean): AppIconConfig {
    this._enableFocus = enableFocus;
    return this;
  }
}