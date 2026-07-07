/**
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import {
  TraceUtil,
  DomainName,
  RectInfo,
  PixelMapUtil,
} from '@ohos/basicutils';
import {
  IconResourceManager,
  IntelligentCache,
  GlobalContext,
  ResourceManager,
  DeviceHelper,
} from '@ohos/frameworkwrapper';
import { RotationConstants } from '@ohos/commonconstants';
import { ItemUtils, } from '@ohos/componenthelper';
import {
  SCBScreenSessionManager,
  NeedRenderBorderRadius,
  SCBScreenProperty,
  SCBSceneContainerSession,
  SCBSceneContainerState,
  IconInfoFromScreenLock,
  ResUtils,
  SCBWindowRotateController,
  SCBSceneSessionManager,
  SCBEventId,
  SceneInfoAdapterUtil
} from '@ohos/windowscene';
import { LogDomain, LogHelper, CheckEmptyUtils, StartType, CompanionIconInfo, } from '@ohos/basicutils';
import { DrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import { StyleConstants } from '../constants/StyleConstants';
import { CommonConstants } from '../constants/CommonConstants';
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import image from '@ohos.multimedia.image'
import { CloseAppManager } from '../manager/CloseAppManager';
import { GrayAppListManager } from '../manager/GrayAppListManager';
import { AppIconModel } from '../../ets/launchericon/common/AppIconModel';
import {
  AppItemInfo,
  DeliverUtil,
  FolderDataModelManager,
  LauncherLayoutCacheUtil
} from '../TsIndex';
import { ShortcutViewModel } from '../launchericon/viewmodel/ShortcutViewModel';
import { AiSuggestionCache } from '../aisuggestion/AiSuggestionCache';

const TAG = 'CompanionIcon';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

const ADAPTIVE_ICON_FACTOR = 1.5;
const LAYOUT_PERCENTAGE: string = '100%';

@Component
export struct CompanionIcon {
  @ObjectLink @Watch('updateIcon') screenProperty: SCBScreenProperty;
  @ObjectLink @Watch('sceneContainerSessionChange') sceneContainerSession: SCBSceneContainerSession;
  @State appIcon: string | image.PixelMap | undefined = undefined;
  @State isAdaptiveIcon: boolean = false;
  // 是否对单层图标优化
  @State isOptimized: boolean = true;
  private bgImage: DrawableDescriptor | string | Resource | image.PixelMap = '';
  private foreground: DrawableDescriptor | string | image.PixelMap = '';
  @State shortWidth: number = 0;
  @State formIcon: image.PixelMap | undefined = undefined;
  @State isGrayIcon: boolean = false;
  private iconRectInfo?: RectInfo;
  private lastCompanionIconInfo: CompanionIconInfo | null = null;
  private cardWidth: number = 0;
  private cardHeight: number = 0;
  private isRelativeVerticalScreen: boolean = true;
  private baseRatio: number = 1;
  @State startType: StartType = StartType.APP;
  @State isSameLocation: boolean = false;
  @State iconInfoFromScreenLock: IconInfoFromScreenLock = new IconInfoFromScreenLock();
  nonAdaptiveIconRadius: NeedRenderBorderRadius = new NeedRenderBorderRadius();
  private smallFolderId?: string = undefined;
  private needResize: boolean = false;
  private isDynamicIcon: boolean = false;
  private backEventCallback: () => void = (): void => {
    this.backEvent();
  }

  private onStartTypeChange: (startType: StartType) => void = (startType: StartType) => {
    log.showInfo(`onStartTypeChange: this.startType: ${this.startType}, recv start type: ${startType}`);
    if (this.startType !== startType) {
      this.updateIcon();
    }
  }

  private backEvent(): void {
    if (CloseAppManager.getInstance().isWidthChangeCard(this.sceneContainerSession?.companionIconInfo?.iconId)) {
      this.updateIcon();
    }
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    this.updateIcon();
    this.refreshScreenLockIcon();
    this.addIntelligentListener();
    log.showInfo(`aboutToAppear moduleName: ${this.sceneContainerSession?.companionIconInfo?.moduleName}, ` +
      `bundleName: ${this.sceneContainerSession?.companionIconInfo?.bundleName}, ` +
      `startAppType: ${this.sceneContainerSession?.companionIconInfo?.startAppType}`);
    GlobalContext.getContext()?.eventHub.on(CommonConstants.EVENTHUB_UPDATE_START_APP_TYPE, this.onStartTypeChange);

    // 对于负一屏服务卡片，侧滑退出会走中断退出
    SCBSceneSessionManager.getInstance()
      .on(SCBEventId.TERMINATE_SCENE, this.screenProperty.screenId, this.backEventCallback);

    // 对于负一屏的卡片和资讯，侧滑退出走的最小化退出
    SCBSceneSessionManager.getInstance()
      .on(SCBEventId.MINIMIZE_SCENE, this.screenProperty.screenId, this.backEventCallback);
  }

  /**
   * 负一屏添加图标id变化获取图标icon的监听事件
   */
  private addIntelligentListener(): void {
    let companionIconInfo = this.sceneContainerSession?.companionIconInfo;
    if (IntelligentCache.isIntelligentIconId(companionIconInfo?.iconId)) {
      log.showInfo(`addIntelligentListener， ${companionIconInfo?.iconId}`);
      IntelligentCache.getInstance().addIconListener(companionIconInfo.iconId, (): void => {
        log.showInfo('updateIntelligentListener');
        this.formIcon = IntelligentCache.getInstance().getIconCache(companionIconInfo.iconId);
      })
    }
  }

  /**
   * 删除负一屏的事件监听
   */
  private deleteIntelligentListener(): void {
    let companionIconInfo = this.sceneContainerSession?.companionIconInfo;
    if (IntelligentCache.isIntelligentIconId(companionIconInfo?.iconId)) {
      log.showInfo('deleteIntelligentListener');
      IntelligentCache.getInstance().deleteIconListener(companionIconInfo.iconId)
    }
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.deleteIntelligentListener();
    GlobalContext.getContext()?.eventHub.off(CommonConstants.EVENTHUB_UPDATE_START_APP_TYPE, this.onStartTypeChange);
    SCBSceneSessionManager.getInstance()
      .off(SCBEventId.TERMINATE_SCENE, this.screenProperty.screenId, this.backEventCallback);
    SCBSceneSessionManager.getInstance()
      .off(SCBEventId.MINIMIZE_SCENE, this.screenProperty.screenId, this.backEventCallback);
  }

  /**
   * 获取图标资源
   * @param cacheKey 缓存的key值
   * @param cacheType 缓存的类型
   * @returns 图标资源字典
   */
  getAppResourceCache(cacheKey: string, cacheType: string): Map<string, object> {
    return ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as Map<string, object>;
  }

  /**
   * 更新图标
   */
  private updateIcon(): void {
    let companionIconInfo = this.sceneContainerSession?.companionIconInfo;
    this.lastCompanionIconInfo = companionIconInfo;
    if (companionIconInfo) {
      this.isSameLocation = companionIconInfo.isSameLocation ?? false;
      this.smallFolderId = companionIconInfo.smallFolderId;
      this.startType = companionIconInfo.startAppType;
    } else {
      this.startType = CloseAppManager.getInstance().getStartAppType();
    }
    log.showWarn(`updateIcon startType: ${this.startType}`);
    if (this.startType === StartType.CARD) {
      this.loadCardSnapshotWithCache();
      return;
    }
    if (IntelligentCache.isIntelligentPageOrIcon(companionIconInfo?.iconId, companionIconInfo?.bundleName)) {
      this.appIcon = IntelligentCache.getInstance().getIconCache(companionIconInfo?.iconId);
      this.setShortWidth();
      return;
    }

    if (!CheckEmptyUtils.isEmpty(companionIconInfo?.bundleName) &&
      !CheckEmptyUtils.isEmpty(companionIconInfo?.moduleName)) {
      this.isGrayIcon = GrayAppListManager.getInstance().isGrayAppIcon(
        this.sceneContainerSession?.companionIconInfo);
      if (this.startType === StartType.SHORTCUT_APP) {
        this.loadShortcutIconWithCache();
      } else {
        this.loadIconWithCache();
      }
    }
    this.setShortWidth();
  }

  /**
   * 设置图标宽度
   */
  private setShortWidth(): void {
    this.shortWidth = px2vp(Math.min(this.screenProperty.width, this.screenProperty.height));
    if (this.sceneContainerSession?.getState() === SCBSceneContainerState.SPLIT &&
      !this.sceneContainerSession?.dividerParam.isUpDownSplit()) {
      this.shortWidth = px2vp(Math.min(this.screenProperty.width / 2, this.screenProperty.height));
    }
  }

  private sceneContainerSessionChange(): void {
    this.refreshScreenLockIcon();

    this.smallFolderId = this.sceneContainerSession?.companionIconInfo?.smallFolderId;
    if (!this.isNeedUpdateIcon()) {
      return;
    }
    this.appIcon = undefined;
    this.isAdaptiveIcon = false;
    this.updateIcon();
    log.showInfo(`sceneContainerSessionChange this.isAdaptiveIcon ${this.isAdaptiveIcon}`);
  }

  /**
   * 是否需要更新图标
   *
   * @returns boolean 是否需要更新的结果
   */
  private isNeedUpdateIcon(): boolean {
    let newBundleName = this.sceneContainerSession?.companionIconInfo?.bundleName;
    let newModuleName = this.sceneContainerSession?.companionIconInfo?.moduleName;
    let newAbilityName = this.sceneContainerSession?.companionIconInfo?.abilityName;
    let newIconNumber = this.sceneContainerSession?.companionIconInfo?.iconNumber;
    if (CheckEmptyUtils.isEmpty(newBundleName) || CheckEmptyUtils.isEmpty(newModuleName) ||
      CheckEmptyUtils.isEmpty(newAbilityName)) {
      log.showWarn('isNeedUpdateIcon name is Empty, return false');
      return false;
    }
    if (newBundleName === this.lastCompanionIconInfo?.bundleName &&
      newModuleName === this.lastCompanionIconInfo?.moduleName &&
      newAbilityName === this.lastCompanionIconInfo?.abilityName &&
      newIconNumber === this.lastCompanionIconInfo?.iconNumber) {
        return false;
    }
    log.showInfo('isNeedUpdateIcon need update icon, newBundleName: %{public}s, newModuleName: %{public}s, newAbilityName:%{public}s',
      newBundleName, newModuleName, newAbilityName);
    return true;
  }

  /**
   * 加载图标的缓存
   * @returns
   */
  private async loadIconWithCache(): Promise<void> {
    let companionIconInfo = this.sceneContainerSession?.companionIconInfo;
    if (!companionIconInfo) {
      log.showError(`companionIconInfo is empty`);
      return;
    }

    // 动态图标
    this.isDynamicIcon = AppIconModel.getInstance().isDynamicIcon({
      bundleName: companionIconInfo.bundleName,
      moduleName: companionIconInfo.moduleName
    });

    if (this.startType === StartType.AI_SUGGESTION_APP) {
      this.appIcon =
        AiSuggestionCache.getInstance().getIconCache(companionIconInfo?.bundleName + companionIconInfo?.extraId);
      log.showInfo(`loadIconWithCache cacheKey: ${companionIconInfo?.bundleName +
        companionIconInfo?.extraId} appIcon: ${this.appIcon?.length}`);
      if (this.appIcon) {
        this.singleIconOptimize(companionIconInfo.iconId);
        return;
      }
    }
    if (!this.appIcon) {
      // 先获取融合图标资源，避免分层图标获取超时动效透明的问题
      IconResourceManager.getInstance().getCombIcon(companionIconInfo.bundleName,
        companionIconInfo.moduleName, companionIconInfo.abilityName, companionIconInfo.appIndex, TAG,
      DeliverUtil.isSupportAppType(companionIconInfo.bundleName)).then((image: PixelMap) => {
        this.appIcon = image;
      });
    }

    if (this.checkIsAdaptiveIcon()) {
      const adaptiveIcon: image.PixelMap[] =
        await CloseAppManager.getInstance().getAdaptiveIcon(companionIconInfo.bundleName,
          companionIconInfo.moduleName, companionIconInfo.abilityName, companionIconInfo.iconNumber);
      if (adaptiveIcon && adaptiveIcon[0] && adaptiveIcon[1]) {
        this.foreground = adaptiveIcon[1];
        this.bgImage = adaptiveIcon[0];
        this.isAdaptiveIcon = true;
        const imageSize = this.foreground.getImageInfoSync().size.height;
        // 288*288的图标资源有效范围只有192大小，需要做放大1.5倍后裁减
        this.needResize = imageSize === 288;
        log.showWarn(`adaptive icon, needResize: ${this.needResize} image size: ${imageSize}`);
        return;
      }
    }
    this.singleIconOptimize(companionIconInfo.iconId);
  }

  /**
   * 获取快捷菜单启动的图标
   * @returns
   */
  private async loadShortcutIconWithCache(): Promise<void> {
    const companionIconInfo: CompanionIconInfo = this.sceneContainerSession?.companionIconInfo;
    if (!companionIconInfo) {
      log.showError(`companionIconInfo is empty`);
      return;
    }
    this.appIcon = await ShortcutViewModel.getInstance().getShortcutImageAsync(
      {
        appIconId: companionIconInfo.iconNumber,
        moduleName: companionIconInfo.moduleName,
        bundleName: companionIconInfo.bundleName,
        shortcutId: companionIconInfo.shortcutId,
        appIndex: companionIconInfo.appIndex
      } as AppItemInfo
    );
    this.singleIconOptimize(companionIconInfo.iconId);
  }

  /**
   * 设置卡片image
   * @param cardComponentId 卡片组件id
   */
  private setFormIcon(cardComponentId: string): void {
    if (IntelligentCache.isIntelligentCardPage(cardComponentId)) {
      this.formIcon = IntelligentCache.getInstance().getIconCache(cardComponentId);
    } else {
      this.formIcon = CloseAppManager.getInstance().getCardStartSnapshot(cardComponentId);
    }
  }

  /**
   * 加载卡片截图
   */
  private loadCardSnapshotWithCache(): void {
    const cardComponentId = this.sceneContainerSession?.companionIconInfo?.iconId;
    if (typeof cardComponentId !== 'string') {
      log.showError('cardComponentId is not of type string.');
      return;
    }
    log.showInfo(`aboutToAppear card companionIconInfo.iconId=${cardComponentId}`);
    this.setFormIcon(cardComponentId);
    log.showWarn(`card companionIconInfo.iconId=${cardComponentId}, formIcon is null=${!this.formIcon}`);
    if (!this.formIcon) {
      try {
        TraceUtil.startTrace(DomainName.HOME, `CompanionIconSnapshotFromId:${cardComponentId}`);
        componentSnapshot.get(cardComponentId)?.then((pixmap: image.PixelMap) => {
          log.showInfo('card pixmap load completed');
          TraceUtil.endTrace(DomainName.HOME, `CompanionIconSnapshotFromId:${cardComponentId}`);
          if (IntelligentCache.isIntelligentCardPage(cardComponentId)) {
            PixelMapUtil.addName(pixmap, `Intelligent_card_snapshot_${cardComponentId}`);
            IntelligentCache.getInstance().setIconCache(cardComponentId, pixmap);
          } else {
            PixelMapUtil.addName(pixmap, `Desktop_card_snapshot_${cardComponentId}`);
            CloseAppManager.getInstance().setCardStartSnapshot(cardComponentId, pixmap);
            pixmap.release();
          }
          this.setFormIcon(cardComponentId);
        }).catch((error: Error) => {
          log.error('componentSnapshot error', error);
        });
      } catch (error) {
        log.error('loadCardSnapshotWithCache componentSnapshot error', error);
      }
    }
    this.calcAnimParams(cardComponentId);
  }

  /**
   * 单层图标优化
   * @param componentId 组件ID
   */
  private singleIconOptimize(componentId: string): void {
    this.isAdaptiveIcon = false;
    log.showWarn(`non adaptive icon, comIcon is null: ${!this.appIcon}`);
    if (this.checkIsAdaptiveIcon()) {
      log.showWarn('check is adaptive, but icon is really not adaptive');
      this.isOptimized = false;
      return;
    }
    this.isOptimized = true;
    this.calcAnimParams(componentId);
  }

  /**
   * 计算动效参数
   * @param componentId 组件ID
   */
  private calcAnimParams(componentId: string): void {
    log.showWarn(`start calcCardAnimParams componentId: ${componentId}`);
    if (CheckEmptyUtils.isEmpty(componentId)) {
      log.showError('calcCardAnimParams: cardComponentId is null');
      return;
    }
    this.iconRectInfo = this.sceneContainerSession?.companionIconInfo?.iconRect;
    if (!this.iconRectInfo) {
      log.showWarn('companionIconInfo.iconRect is null');
      this.iconRectInfo = ItemUtils.getRectById(componentId);
    }
    log.showInfo(`get iconRect: ${this.iconRectInfo.toString()}`);
    this.cardWidth = this.iconRectInfo.right - this.iconRectInfo.left;
    this.cardHeight = this.iconRectInfo.bottom - this.iconRectInfo.top;
    if (this.cardHeight === 0 || this.cardWidth === 0) {
      log.showError('The width or height of card is zero');
      return;
    }
    let windowWidth = px2vp(this.screenProperty.width);
    let windowHeight = px2vp(this.screenProperty.height);
    if (DeviceHelper.isPad()) {
      //如果是平板，用该方式直接获取平板是横屏还是竖屏状态
      this.isRelativeVerticalScreen = LauncherLayoutCacheUtil.getIsPadPortrait();
    } else {
      this.isRelativeVerticalScreen = windowHeight / this.cardHeight >= windowWidth / this.cardWidth;
    }
    log.showInfo(`calcCardAnimParams this.isRelativeVerticalScreen: ${this.isRelativeVerticalScreen}, isNeedRotateIcon:
      ${this.isNeedRotateIcon()}`);
    if (!this.isRelativeVerticalScreen || this.isNeedRotateIcon()) {
      this.baseRatio = DeviceHelper.isPhone() && !this.isBigFoldPhoneExpandStatus() ?
        windowWidth / this.cardHeight : windowWidth / this.cardWidth;
    } else {
      this.baseRatio = windowHeight / this.cardHeight;
    }
    log.showInfo('finish calcCardAnimParams');
  }

  /**
   * 是否大折叠展开
   * @returns
   */
  private isBigFoldPhoneExpandStatus(): boolean {
    return SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
  }

  /**
   * 是否需要旋转图标
   * @returns
   */
  private isNeedRotateIcon(): boolean {
    if (this.isBigFoldPhoneExpandStatus()) {
      return false;
    }
    if (DeviceHelper.isPad()) {
      return this.screenProperty.rotation !== RotationConstants.ROTATION_0 &&
        this.screenProperty.rotation !== RotationConstants.ROTATION_180;
    }
    return this.screenProperty.rotation !== RotationConstants.ROTATION_0;
  }

  /**
   * 设备是否是竖直方向
   * @returns
   */
  private isVertical(): boolean {
    if (this.screenProperty === undefined) {
      log.showError('screenProperty is undefined, keep vertical.');
      return true;
    }

    let screenRotation = this.screenProperty.rotation;
    if (this.screenProperty.defaultScreenOrientation === 0) {
      return screenRotation === RotationConstants.ROTATION_0 || screenRotation === RotationConstants.ROTATION_180;
    } else {
      return screenRotation === RotationConstants.ROTATION_90 || screenRotation === RotationConstants.ROTATION_270;
    }
  }

  private getAdaptiveBgHeight(): Length {
    if (this.needResize) {
      return this.sceneContainerSession.needRenderClip.clipHeight.getVp() * ADAPTIVE_ICON_FACTOR;
    }
    return LAYOUT_PERCENTAGE;
  }

  private getAdaptiveBgWidth(): Length {
    if (this.needResize) {
      return ADAPTIVE_ICON_FACTOR * this.sceneContainerSession.needRenderClip.clipWidth.getVp();
    }
    return LAYOUT_PERCENTAGE;
  }

  private getPosition(): Position {
    if (this.needResize) {
      return {
        x: -this.shortWidth / 4,
        y: -this.shortWidth / 4,
      };
    }
    return { x: 0, y: 0 };
  }

  private getAdaptiveShortWidth(): number {
    if (this.needResize) {
      return this.shortWidth * ADAPTIVE_ICON_FACTOR;
    }
    return this.shortWidth;
  }

  private getIconRotation(): number {
    if (SCBWindowRotateController.getInstance().isFullScreenRotatePolicy()) {
      if (!SCBWindowRotateController.getInstance().isLandscapeStartInterrupt()) {
        return RotationConstants.ROTATION_0;
      } else {
        return (SCBWindowRotateController.getInstance().getLandscapeStartRotation() -
          SCBWindowRotateController.getInstance().getLandscapeStartDesktopRotation() +
          RotationConstants.ROTATION_360) % RotationConstants.ROTATION_360;
      }
    }
    if (this.screenProperty) {
      return this.screenProperty.rotation;
    }
    return 0;
  }

  private getCardPosition(): Position {
    if (this.screenProperty === undefined) {
      return {
        x: 0,
        y: 0
      };
    }
    if (!this.isRelativeVerticalScreen) {
      if (DeviceHelper.isThreeFoldProduct() && (DeviceHelper.isMState() || DeviceHelper.isGState())) {
        return {
          x: 0,
          y: px2vp(this.screenProperty.height) / 2 - this.cardHeight * this.baseRatio / 2
        }
      }
      if (DeviceHelper.isPad() || DeviceHelper.isFoldExpanded()) {
        return {
          x: 0,
          y: px2vp(this.screenProperty.height) / 2 - this.cardHeight * this.baseRatio / 2
        }
      }
    }
    if (this.getIconRotation() === 0) {
      return {
        x: px2vp(this.screenProperty.width) / 2 - this.cardWidth * this.baseRatio / 2,
        y: 0
      }
    }
    return {
      x: px2vp(this.screenProperty.width) / 2 - this.cardWidth * this.baseRatio / 2,
      y: px2vp(this.screenProperty.height) / 2 - this.cardHeight * this.baseRatio / 2
    };
  }

  private getBorderRadius(): BorderRadiuses {
    return {
      topLeft: this.nonAdaptiveIconRadius.topLeft,
      topRight: this.nonAdaptiveIconRadius.topRight,
      bottomLeft: this.nonAdaptiveIconRadius.bottomLeft,
      bottomRight: this.nonAdaptiveIconRadius.bottomRight
    };
  }

  private getNormalWidth(shortWidth: number, intelligentScene: number): Length {
    if (IntelligentCache.isIntelligentMyPage(this.sceneContainerSession?.companionIconInfo?.iconId) &&
      intelligentScene == 1) {
      return LAYOUT_PERCENTAGE;
    }
    return shortWidth;
  }

  @Styles
  cardBasicStyles() {
    .size({ width: this.cardWidth * this.baseRatio, height: this.cardHeight * this.baseRatio })
    .scale({
      x: this.sceneContainerSession?.cardScale,
      y: this.sceneContainerSession?.cardScale
    })
    .opacity(this.sceneContainerSession?.iconAlpha)
    .rotate({ angle: this.getIconRotation() })
  }

  @Styles
  normalIconBasicStyles() {
    .width(this.getNormalWidth(this.shortWidth, this.sceneContainerSession?.intelligentScene))
    .height(this.getNormalWidth(this.shortWidth, this.sceneContainerSession?.intelligentScene))
    .position({
      x: 0,
      y: 0
    })
    .opacity(this.sceneContainerSession?.iconAlpha)
    .rotate({ angle: this.getIconRotation() })
    .borderRadius(this.getBorderRadius())
    .clip(this.nonAdaptiveIconRadius.hasBorderRadius())
  }

  @Styles
  AdaptiveIconBasicStyles() {
    .draggable(false)
    .opacity(this.sceneContainerSession?.iconAlpha)
    .rotate({ angle: this.getIconRotation() })
  }

  @Builder
  GrayIconBuilder() {
    Column()
      .width(this.shortWidth)
      .height(px2vp(this.screenProperty?.height as number))
      .backgroundColor(StyleConstants.APP_ICON_GRAY_COLOR)
      .visibility(this.isGrayIcon ? Visibility.Visible : Visibility.Hidden)
      .opacity(this.sceneContainerSession?.iconAlpha)
      .id(`${TAG}_Column_grayIconArea`)
  }

  private getScreenLockBgWidth(): number {
    if (this.isVertical()) {
      return this.shortWidth * ADAPTIVE_ICON_FACTOR;
    }
    return ADAPTIVE_ICON_FACTOR * this.sceneContainerSession?.needRenderClip.clipWidth.getVp();
  }

  @Builder
  iconFromScreenLock() {
    EffectComponent() {
      if (this.iconInfoFromScreenLock.isBackgroundEffect) {
        Column() {
        }
        .width(LAYOUT_PERCENTAGE)
        .height(LAYOUT_PERCENTAGE)
        .useEffect(true)
        .backgroundStyle()
      }

      Column() {
      }
      .backgroundColor(this.iconInfoFromScreenLock.backgroundColor)
      .backgroundBrightnessInternal(this.iconInfoFromScreenLock.backgroundBrightness)
      .backgroundStyle()
      .pointLight(this.iconInfoFromScreenLock.pointLight)

      Column() {
        if (!this.iconInfoFromScreenLock.isHit) {
          Stack() {
            this.screenLockImage(this.iconInfoFromScreenLock.iconBackgroundBrightness);
            if (this.iconInfoFromScreenLock.isAddBrightness) {
              this.screenLockImage(this.iconInfoFromScreenLock.iconAddBackgroundBrightness);
            }
          }
          .width(LAYOUT_PERCENTAGE)
          .height(LAYOUT_PERCENTAGE)
        } else {
          this.screenLockImage(undefined)
        }
      }
      .width(this.getScreenLockBgWidth())
      .height(this.getScreenLockBgWidth())
      .position({
        x: -this.shortWidth / 4,
        y: -this.shortWidth / 4,
      })
      .borderRadius(this.iconInfoFromScreenLock.borderRadius)
      .opacity(this.iconInfoFromScreenLock.opacity * this.sceneContainerSession?.iconAlpha)
      .rotate({ angle: this.getIconRotation() })
      .scale({
        x: this.iconInfoFromScreenLock.iconScale * this.iconInfoFromScreenLock.imgWidth /
        this.iconInfoFromScreenLock.bgWidth / ADAPTIVE_ICON_FACTOR,
        y: this.iconInfoFromScreenLock.iconScale * this.iconInfoFromScreenLock.imgHeight /
        this.iconInfoFromScreenLock.bgHeight / ADAPTIVE_ICON_FACTOR
      })
    }
    .backgroundEffect(this.iconInfoFromScreenLock.backgroundEffect, { disableSystemAdaptation: true })
    .width(LAYOUT_PERCENTAGE)
    .height(LAYOUT_PERCENTAGE)

    this.GrayIconBuilder()
  }

  @Styles
  backgroundStyle() {
    .width(this.getScreenLockBgWidth())
    .height(this.sceneContainerSession?.needRenderClip.clipHeight.getVp() * ADAPTIVE_ICON_FACTOR)
    .position({
      x: -this.shortWidth / 4,
      y: -this.shortWidth / 4,
    })
    .borderRadius(this.iconInfoFromScreenLock.borderRadius)
    .opacity(this.iconInfoFromScreenLock.backplaneOpacity * this.sceneContainerSession?.iconAlpha)
  }

  @Builder
  screenLockImage(brightnessOptions: BrightnessOptions | undefined) {
    SymbolGlyph(this.iconInfoFromScreenLock.image)
      .draggable(false)
      .width(LAYOUT_PERCENTAGE)
      .height(LAYOUT_PERCENTAGE)
      .fontSize(this.getScreenLockBgWidth() + 'vp')
      .fontColor([this.iconInfoFromScreenLock.fillColor])
      .renderingStrategy(SymbolRenderingStrategy.SINGLE)
      .foregroundBrightness(brightnessOptions)
  }

  @Builder
  cardBuilder() {
    Image(this.formIcon as image.PixelMap)
      .draggable(false)
      .syncLoad(true)
      .objectFit(ImageFit.Fill)
      .autoResize(false)
      .interpolation(ImageInterpolation.Medium)
      .cardBasicStyles()
  }

  @Builder
  normalIconBuilder() {
    if (this.appIcon) {
      Image(this.appIcon)
        .draggable(false)
        .syncLoad(true)
        .autoResize(false)
        .interpolation(ImageInterpolation.Medium)
        .backgroundImage(ShortcutViewModel.getInstance().getShortcutBackgroundImage({
          startType: this.startType,
          bundleName: this.sceneContainerSession?.companionIconInfo?.bundleName
        }))
        .backgroundImageSize(ImageSize.Cover)
        .backgroundImagePosition(Alignment.Center)
        .normalIconBasicStyles()
      this.GrayIconBuilder()
    }
  }

  @Builder
  normalIconOptimizedBuilder() {
    if (this.appIcon) {
      Image(this.appIcon)
        .draggable(false)
        .syncLoad(true)
        .objectFit(ImageFit.Fill)
        .autoResize(false)
        .interpolation(ImageInterpolation.Medium)
        .cardBasicStyles()
        .backgroundImage(ShortcutViewModel.getInstance().getShortcutBackgroundImage({
          startType: this.startType,
          bundleName: this.sceneContainerSession?.companionIconInfo?.bundleName
        }))
        .backgroundImageSize(ImageSize.Cover)
        .backgroundImagePosition(Alignment.Center)
      this.GrayIconBuilder()
    }
  }

  @Builder
  adaptiveIconBuilder() {
    Image(this.bgImage)
      .syncLoad(true)
      .width(this.getAdaptiveBgWidth())
      .height(this.getAdaptiveBgHeight())
      .objectFit(ImageFit.Fill)
      .position(this.getPosition())
      .AdaptiveIconBasicStyles()

    if (!this.isDynamicIcon) {
      Image(this.foreground)
        .syncLoad(true)
        .width(this.getAdaptiveShortWidth())
        .height(this.getAdaptiveShortWidth())
        .objectFit(ImageFit.Fill)
        .position(this.getPosition())
        .AdaptiveIconBasicStyles()
        .interpolation(ImageInterpolation.Medium)
    }
    this.GrayIconBuilder()
  }

  private getScreenLockIcon(): IconInfoFromScreenLock | undefined {
    let primarySession = this.sceneContainerSession.primarySession;
    if (primarySession) {
      let re = primarySession.isTemporarilyShowWhenLocked;
      let info = SceneInfoAdapterUtil.getScreenLockInfo(this.sceneContainerSession);
      if (re && info) {
        return info.originIconInfo;
      }
    }
    return undefined;
  }

  private refreshScreenLockIcon() {
    let info = this.getScreenLockIcon();
    if (info) {
      this.iconInfoFromScreenLock = info;
    }
  }

  private checkIsAdaptiveIcon(): boolean {
    let companionIconInfo = this.sceneContainerSession?.companionIconInfo;
    let isAdaptive = IconResourceManager.getInstance().isAdaptiveIcon(companionIconInfo);
    log.showWarn(`checkIsAdaptiveIcon, bundleName:${companionIconInfo?.bundleName}, isAdaptive:${isAdaptive}`);
    return isAdaptive;
  }

  @Builder
  private backAppOfSmallFolder(){
    Stack({alignContent: Alignment.Top}) {
      Column() {
      }
      .size({
        width: LAYOUT_PERCENTAGE,
        height: LAYOUT_PERCENTAGE,
      })
      .backgroundColor($r('app.color.back_plane_bg_color'))
      .brightness(FolderDataModelManager.getInstance().getBackgroundBrightness())
      .saturate(ResUtils.getNumber($r('app.float.ohos_id_blur_style_thin_saturation')))

      Image(ResourceManager.getInstance()
        .getCachedSmallFolderIcon(this.smallFolderId))
        .objectFit(ImageFit.Fill)
        .syncLoad(true)
        .draggable(false)
        .AdaptiveIconBasicStyles()
        .size({
          width: LAYOUT_PERCENTAGE
        })
    }
    .size({
      width: LAYOUT_PERCENTAGE,
      height: LAYOUT_PERCENTAGE,
    })
  }

  build() {
    if (this.isSameLocation) {
      this.backAppOfSmallFolder();
    } else {
      Stack() {
        if (this.startType === StartType.CARD && this.screenProperty !== undefined) {
          this.cardBuilder();
        } else {
          if (this.getScreenLockIcon()) {
            if (this.sceneContainerSession.isScreenLockIconShow) {
              this.iconFromScreenLock();
            }
          } else if (this.isAdaptiveIcon) {
            this.adaptiveIconBuilder();
          } else if (this.isOptimized) {
            this.normalIconOptimizedBuilder();
          } else {
            this.normalIconBuilder();
          }
        }
      }
      .size({
        width: LAYOUT_PERCENTAGE,
        height: LAYOUT_PERCENTAGE
      })
    }
  }

  private getTranslateX(): string | number | undefined {
    if (this.sceneContainerSession.needRenderTranslateIcon.translateOobeIconX !== 0) {
      return this.sceneContainerSession.needRenderTranslateIcon.translateOobeIconX;
    }
    return this.sceneContainerSession.needRenderTranslateIcon.translateIconX;
  }

  private getTranslateY(): string | number | undefined {
    if (this.sceneContainerSession.needRenderTranslateIcon.translateOobeIconY !== 0) {
      return this.sceneContainerSession.needRenderTranslateIcon.translateOobeIconY;
    }
    return this.sceneContainerSession.needRenderTranslateIcon.translateIconY;
  }
}