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

import { DrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import {
  LogDomain,
  LogHelper,
  StartType,
  CompanionIconInfo,
  CheckEmptyUtils,
  SingleContext
} from '@ohos/basicutils';
import {
  GlobalContext,
  ResourceManager,
  IconResourceManager,
  memoryCache,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import { SCBSceneResourceManager, SCBScreenProperty, } from '@ohos/windowscene';
import {
  CommonConstants,
  StyleConstants,
  layoutConfigManager,
  BadgeManager,
  BadgeListener,
  LayoutViewModel,
  AppItemInfo,
  ShortcutViewModel,
  GrayAppListManager,
  AppGridStyleConfig
} from '@ohos/launchercommon';
import effectKit from '@ohos.effectKit';
import image from '@ohos.multimedia.image';
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import { BadgeItemInfo } from '@ohos/launchercommon';
import { AppIconShadowData } from '@ohos/launchercommon/src/main/ets/bean/AppIconShadowData';
import HoverEffectConstants
  from '@ohos/pcsmartdock/src/main/ets/default/common/constants/HoverEffectConstants';
import HashMap from '@ohos.util.HashMap';
import { PCUtils } from '../../common/utils/PCUtils';
import { FileIconUtils } from '@ohos/desktopfilefolder/src/main/ets/default/utils/FileIconUtils';
import common from '@ohos.app.ability.common';
import { PcStatusBarDragMgr } from '@ohos/statusbarcomponent/src/main/ets/pc/manager/PcStatusBarDragMgr';
import { DefineBadgePostion } from '@ohos/launchercommon/src/main/ets/manager/BadgeManager';
import { PcDockIndepentIconMgr } from '@ohos/pcsmartdock/src/main/ets/default/manager/PcDockIndependentIconMgr';
import IconInfo, { IconPicType } from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/IconInfo';
import { PcDockAnimationMgr } from '@ohos/pcsmartdock/src/main/ets/default/manager/PcDockAnimationMgr';
import { AppIconData } from '@ohos/launchercommon/Index';

const TAG = 'CompanionIconForPC';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const ADAPTIVE_ICON = 'adaptiveicon';
const BORDER_RADIUS_OF_CARD: number = 16;
const LOW_RESOLUTION: number = 288;
const CONTACTS_BUNDLE_NAME = 'com.ohos.contacts';

@Observed
export class CompanionIconViewModel {
  public companionIconInfo: CompanionIconInfo | null = null;
  public iconWidth: number = 0;
  public iconHeight: number = 0;
  public iconPosX: number = 0;
  public iconPosY: number = 0;
  public iconTranX: number = 0;
  public iconTranY: number = 0;
  public iconScaleX: number = 1.0;
  public iconScaleY: number = 1.0;
  public iconAlpha: number = 1.0;
  public iconRadius: number = 0;
  public iconVisible: boolean = false;
  // minimize animation finish-shake fix size
  public iconFixSize: number = 0;
  public animCount: number = 0;
  public persistentId: string = '';
  public appIndex: number = 0;
  public iconTypeId: number = 0;
  public iconResource: string = '';
  public startType: StartType = StartType.APP;

  public setInitState() {
    this.iconTranX = 0;
    this.iconTranY = 0;
    this.iconScaleX = 1.0;
    this.iconScaleY = 1.0;
    this.iconAlpha = 1.0;
    this.iconRadius = this.getRadius();
    this.iconVisible = false;
    this.iconFixSize = 0;
  }

  public setEndState(tranX: number, tranY: number) {
    this.setTran(tranX, tranY);
    this.iconVisible = true;
  }

  public setTran(tranX: number, tranY: number): void {
    this.iconTranX = tranX;
    this.iconTranY = tranY;
  }

  public getRadius(): number {
    return CommonConstants.DEFAULT_ICON_RADIUS * this.iconWidth /
      (layoutConfigManager.getStyleConfig(CommonConstants.APP_GRID_STYLE_CONFIG,
        CommonConstants.PAGE_DESKTOP_FEATURE_NAME) as AppGridStyleConfig)?.mIconSize ?? this.iconWidth;
  }
}

@Observed
export class CompanionIconViewList extends Array<CompanionIconViewModel> {
}

@Component
export struct CompanionIconForPC {
  @ObjectLink iconView: CompanionIconViewModel;
  @ObjectLink iconData: AppIconData;
  @Link screenProp: SCBScreenProperty;
  @Prop singleContext?: SingleContext;
  @State isIconUpdateReady: boolean = false;
  @State isAdaptiveIcon: boolean = false;
  private appIcon?: string | DrawableDescriptor | image.PixelMap;
  private bgImage: DrawableDescriptor | string = '';
  private foreground: DrawableDescriptor | string = '';
  @State formIcon: image.PixelMap | undefined = undefined;
  private badgeFontSize: number = StyleConstants.PC_BADGE_FONT_SIZE;
  private mBadgeSize: number = StyleConstants.PC_BADGE_SIZE;
  private mBadgeScale: number = 1;
  private badgeManager: BadgeManager = BadgeManager.getInstance();
  private dockHeight: number = 0;
  private readonly DEFULT_LIGHT_POSITION_Z: number = 150;
  @State badgeNumber: number = 0;
  @StorageLink('dockHoverConfig') @Watch('onDockHoverConfigChange') dockHoverConfig:
    HashMap<string, Object> = new HashMap();
  @State appIconShadowData: AppIconShadowData = new AppIconShadowData();
  @State shadowPixelmap: image.PixelMap | null = null;
  private mDesktopContext = GlobalContext.getInstance().getObject('desktopContext') as common.Context;
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private disableMaskContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private item: AppItemInfo = new AppItemInfo();
  private grayAppListManager: GrayAppListManager = GrayAppListManager.getInstance();
  private isGrayApp: boolean = false;
  private iconNeedScale: boolean = false;

  private badgeListener: BadgeListener = {
    onUpdate: (badgeInfo: BadgeItemInfo) => {
      log.showDebug(`update badge.badgeNumber=${badgeInfo?.badgeNumber}, badge.isShow=${badgeInfo?.isShow}`);
      this.badgeManager.getBadgeDisplayNumberByBundle(this.iconView.companionIconInfo,
        (num: number) => this.badgeNumber = num);
    }
  };


  getAppResourceCache(cacheKey: string, cacheType: string): Map<string, object> {
    return ResourceManager.getInstance().getAppResourceCache(cacheKey, cacheType) as Map<string, object>;
  }

  // Get the double-layer icon of adaptiveicon through cache, determine whether to use adaptiveicon
  private checkIsAdaptiveIconWithCache(): boolean {
    const companionIconInfo = this.iconView.companionIconInfo;
    const bundleName = companionIconInfo?.bundleName;
    const moduleName = companionIconInfo?.moduleName;
    const abilityName = companionIconInfo?.abilityName;

    const size: number = PcDockAnimationMgr.getInstance(this.screenProp.screenId)?.getDockIconSize();
    const appInfo = memoryCache.getIconResourceBySize(bundleName, moduleName, abilityName, size);
    if (!appInfo || !appInfo.adaptivePic[0] || !appInfo.adaptivePic[1]) {
      return false;
    } else {
      this.bgImage = appInfo.adaptivePic[0];
      this.foreground = appInfo.adaptivePic[1];
      log.showInfo(`isAdaptiveIcon bundleName=${bundleName}, moduleName=${moduleName}, size=${size}`);
      return true;
    }
  }

  private async loadIconWithCache(): Promise<void> {
    let companionIconInfo = this.iconView.companionIconInfo;
    this.isAdaptiveIcon = this.checkIsAdaptiveIconWithCache();
    if (!this.isAdaptiveIcon) {
      this.appIcon = await IconResourceManager.getInstance().getCombIcon(companionIconInfo?.bundleName,
        companionIconInfo?.moduleName, companionIconInfo?.abilityName);
      log.showInfo(`loadIconWithCache appIcon is null ? ${CheckEmptyUtils.isEmpty(this.appIcon)}`);
    }
    this.isIconUpdateReady = true;
  }

  private updateIcon(): void {
    let companionIconInfo = this.iconView.companionIconInfo;
    if (companionIconInfo?.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
      if (DeviceHelper.is2In1DevicePcType()) {
        this.getIconResource(companionIconInfo);
      } else {
        // recycle bin use 72x72 png
        this.setRecycleBinIcon();
      }
      return;
    }

    if (companionIconInfo?.startAppType === StartType.FILE_FOLDER) {
      this.isIconUpdateReady = true;
      let iconImage: image.PixelMap | undefined =
        FileIconUtils.getPixMapFromResourceId(companionIconInfo?.iconNumber, this.mDesktopContext);
      log.showInfo(`updateIcon iconimage: ${!iconImage}, appcionid: ${companionIconInfo?.iconNumber}`);
      if (iconImage) {
        this.appIcon = iconImage;
      }
      return;
    }

    if (companionIconInfo?.startAppType === StartType.STATUS_BAR_TRAY) {
      this.isIconUpdateReady = true;
      let iconImage: image.PixelMap | undefined = PcStatusBarDragMgr.getInstance().getSnapshot();
      log.showInfo(`STATUS_BAR_TRAY updateIcon iconimage: ${!iconImage}, appcionid: ${companionIconInfo?.iconNumber}`);
      if (iconImage) {
        this.appIcon = iconImage;
      }
      return;
    }
    if (PcDockIndepentIconMgr.getInstance().isIndependentIconAbility(companionIconInfo?.bundleName ?? '',
      this.iconView?.persistentId)) {
      this.isIconUpdateReady = true;
      const iconImage = SCBSceneResourceManager.getInstance().getSessionIconCache(this.iconView?.persistentId);
      log.showInfo(`independentIconAbility updateIcon iconimage: ${!iconImage},` +
        `persistentId: ${this.iconView?.persistentId}`);
      if (iconImage) {
        this.appIcon = iconImage;
      }
      return;
    }

    if (companionIconInfo?.bundleName === CommonConstants.CALENDAR_BUNDLE) {
      this.isIconUpdateReady = true;
      this.isAdaptiveIcon = false;
      if (DeviceHelper.is2In1DevicePcType()) {
        this.getIconResource(companionIconInfo);
      }
      return;
    }

    if (!!companionIconInfo?.shortcutId && this.iconView.iconTypeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      log.showInfo(`updateIcon shortcut, bundleName: ${companionIconInfo?.bundleName}, shortcutId: ${companionIconInfo?.shortcutId}`);
      let item = new AppItemInfo();
      item.iconResource = this.iconView.iconResource;
      item.appIconId = companionIconInfo?.iconNumber;
      item.bundleName = companionIconInfo?.bundleName;
      item.moduleName = companionIconInfo?.moduleName;
      const iconImage: string | image.PixelMap = ShortcutViewModel.getInstance().getShortcutImageSync(item);
      if (this.isValidIcon(iconImage)) {
        this.appIcon = iconImage;
      } else {
        this.appIcon = StyleConstants.DEFAULT_ICON;
      }
      this.isIconUpdateReady = true;
      return;
    }

    if (DeviceHelper.is2In1DevicePcType()) {
      this.getIconResource(companionIconInfo);
    } else {
      this.loadIconWithCache();
    }
  }

  private isValidIcon(iconSrc: string | image.PixelMap): boolean {
    if (typeof iconSrc === 'string') {
      return !CheckEmptyUtils.checkStrIsEmpty(iconSrc);
    } else {
      return !CheckEmptyUtils.isEmptyPixelMap(iconSrc);
    }
  }

  private setRecycleBinIcon(): void {
    this.isIconUpdateReady = true;
    this.isAdaptiveIcon = true;
    this.bgImage = StyleConstants.DEFAULT_RECYCLE_BIN_BACKGROUND_IMAGE;
    const isRecycleBinEmpty = AppStorage.get<boolean>('isDockRecycleBinEmpty');
    this.foreground = isRecycleBinEmpty ? StyleConstants.DEFAULT_RECYCLE_BIN_FOREGROUND_IMAGE :
    StyleConstants.DEFAULT_RECYCLE_BIN_FULL_FOREGROUND_IMAGE;
  }

  private getIconResource(companionIconInfo: CompanionIconInfo | null): void {
    let iconId = Number(companionIconInfo?.iconNumber);
    let bundleName = companionIconInfo?.bundleName ?? '';
    let moduleName = companionIconInfo?.moduleName ?? '';
    let abilityName = companionIconInfo?.abilityName ?? '';
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      return;
    }
    log.showInfo(`getIconResource bundleName: ${companionIconInfo?.bundleName},` +
      `moduleName: ${companionIconInfo?.moduleName}, abilityName: ${companionIconInfo?.abilityName}, ` +
      `appIndex: ${companionIconInfo?.appIndex}, startType: ${this.iconView.startType}`);
    if (this.iconView.startType === StartType.DOCK_APP) {
      let resultInfo: IconInfo = new IconInfo();
      let size: number = PcDockAnimationMgr.getInstance(this.screenProp.screenId)?.getDockIconSize();
      resultInfo = memoryCache.getIconResourceBySize(bundleName, moduleName, abilityName, size);
      if (resultInfo === undefined || resultInfo === null || resultInfo.iconType === IconPicType.NONE) {
        log.showError(`getIconResource DOCK_APP fail, use defalut icon, iconType: ${resultInfo?.iconType}, ` +
          `size: ${size}`);
        if (abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
          this.setRecycleBinIcon();
          return;
        } else {
          this.loadIconWithCache();
        }
        return;
      }
      if (resultInfo.iconType === IconPicType.ADAPTIVE) {
        this.isIconUpdateReady = true;
        this.isAdaptiveIcon = true;
        this.bgImage = resultInfo?.adaptivePic[0];
        this.foreground = resultInfo?.adaptivePic[1];
      } else {
        this.isIconUpdateReady = true;
        this.appIcon = resultInfo?.combinePic;
      }
      this.iconNeedScale = true;
    } else {
      let iconImage: image.PixelMap | undefined =
        memoryCache.getCombIconSync(bundleName, moduleName, abilityName, companionIconInfo?.appIndex);
      if (iconImage) {
        this.isIconUpdateReady = true;
        this.appIcon = iconImage;
      } else {
        log.showError('getIconResource APP fail, use defalut icon');
        this.loadIconWithCache();
      }
    }
  }

  private onDockHoverConfigChange(): void {
    const isHover = this.dockHoverConfig.get('isHover') as boolean;
    const screenId = this.dockHoverConfig.get('screenId') as number;
    if (isHover && screenId === this.screenProp.screenId) {
      this.appIconShadowData = this.dockHoverConfig.get('appIconShadowData') as AppIconShadowData;
    } else {
      this.appIconShadowData = new AppIconShadowData();
    }
  }

  private createShadowPixelMap(pixelStr: string): void {
    setTimeout(async () => {
      let imageSource: image.ImageSource | null = null;
      let foregroundPixelMap: image.PixelMap | null = null;
      let effectPixelMap: image.PixelMap | null = null;
      try {
        imageSource = image.createImageSource(pixelStr);
        foregroundPixelMap = await imageSource.createPixelMap();
        const filter = effectKit.createEffect(foregroundPixelMap)?.blur(this.iconView.iconRadius);
        effectPixelMap = await filter.getEffectPixelMap();
        if (effectPixelMap) {
          this.shadowPixelmap = await effectPixelMap?.createAlphaPixelmap();
          ResourceManager.getInstance().setEffectKitCache(
            this.iconView.companionIconInfo?.iconNumber, this.iconView.companionIconInfo?.abilityName,
            this.shadowPixelmap);
          log.showInfo(`createShadowPixelMap set shadowPixelmap,  ${this.iconView.companionIconInfo?.bundleName}`);
          effectPixelMap?.release();
        }
      } catch (e) {
        log.showError(`createShadowPixelMap error`, e);
      } finally {
        imageSource?.release();
        foregroundPixelMap?.release();
        effectPixelMap?.release();
      }
    }, 100);
  }

  private scaled(): boolean {
    if (this.foreground === StyleConstants.DEFAULT_RECYCLE_BIN_FOREGROUND_IMAGE ||
      this.foreground === StyleConstants.DEFAULT_RECYCLE_BIN_FULL_FOREGROUND_IMAGE) {
      return false;
    }
    if (DeviceHelper.is2In1DevicePcType() && this.iconNeedScale) {
      return true;
    }
    if (this.foreground && typeof this.foreground === 'string') {
      return true;
    }
    let isScaled: boolean = false;
    try {
      let image = this.foreground as DrawableDescriptor;
      let size = image.getPixelMap().getImageInfoSync().size;
      if (size.height !== LOW_RESOLUTION && size.width !== LOW_RESOLUTION) {
        isScaled = true;
      } else {
        isScaled = false;
      }
    } catch (error) {
      log.showError('typeError', error)
    }
    return isScaled;
  }

  private getBadgePostion(): DefineBadgePostion {
    let temp = this.badgeManager.getBadgePostion(this.badgeNumber, 
      this.badgeFontSize * this.mBadgeScale, this.iconView.iconWidth);
    return temp;
  }

  aboutToAppear(): void {
    if (!this.iconView.companionIconInfo) {
      return;
    }
    this.dockHoverConfig = AppStorage.get('dockHoverConfig') as HashMap<string, Object>;
    this.onDockHoverConfigChange();
    this.dockHeight = AppStorage.get('dockHeight') as number;
    if (this.dockHeight === 0) {
      this.dockHeight = LayoutViewModel.getInstance(this.singleContext).getDockHeight();
    }
    this.updateIcon();
    if (this.isAdaptiveIcon) {
      this.shadowPixelmap = ResourceManager.getInstance().getCachedEffectKit(
        this.iconView.companionIconInfo?.iconNumber, this.iconView.companionIconInfo?.abilityName);
      if (!this.shadowPixelmap && this.foreground && typeof this.foreground === 'string') {
        this.createShadowPixelMap(this.foreground as string);
      }
    }
    log.showInfo('aboutToAppear this.isAdaptiveIcon=%{public}s,companionIconInfo.iconId=%{public}d, ' +
      'companionIconInfo.bundleName=%{public}s', this.isAdaptiveIcon, this.iconView.companionIconInfo.iconId, this.iconView.companionIconInfo.bundleName);
    this.badgeManager.getBadgeDisplayNumberByBundle(this.iconView.companionIconInfo,
      (num: number) => this.badgeNumber = num);
    this.badgeManager.registerBadgeListener(this.iconView.companionIconInfo, this.badgeListener);
    log.showInfo(`aboutToAppear ${this.badgeNumber}`);
    if (this.iconView.companionIconInfo) {
      this.item.bundleName = this.iconView.companionIconInfo.bundleName;
      this.item.appIndex = this.iconView.appIndex;
    }
    this.isGrayApp = this.grayAppListManager.isGrayAppIcon(this.item);
    log.showInfo(`aboutToAppear isGrayApp: ${this.isGrayApp}`);
  }

  aboutToDisappear(): void {
    this.badgeManager.unRegisterBadgeListener(this.iconView.companionIconInfo, this.badgeListener);
    log.showInfo('aboutToDisappear');
  }

  @Styles
  FormIconUse() {
    .size({ width: this.iconView.iconWidth - 2 * this.iconView.iconFixSize,
      height: this.iconView.iconHeight - 2 * this.iconView.iconFixSize })
    .position({ x: this.iconView.iconPosX + this.iconView.iconFixSize,
      y: this.iconView.iconPosY + this.iconView.iconFixSize })
    .translate({ x: this.iconView.iconTranX, y: this.iconView.iconTranY })
    .scale({ x: this.iconView.iconScaleX, y: this.iconView.iconScaleY })
    .opacity(this.iconView.iconAlpha)
    .borderRadius(this.iconView.iconRadius)
    .clip(true)
  }

  @Styles
  StackUse() {
    .size({ width: this.iconView.iconWidth - 2 * this.iconView.iconFixSize,
      height: this.iconView.iconHeight - 2 * this.iconView.iconFixSize })
    .borderRadius(this.iconView.iconRadius)
    .clip(true)
  }

  @Styles
  BadgeUse() {
    .position({ x: this.iconView.iconPosX + this.iconView.iconFixSize,
      y: this.iconView.iconPosY + this.iconView.iconFixSize })
    .translate({ x: this.iconView.iconTranX, y: this.iconView.iconTranY })
    .scale({ x: this.iconView.iconScaleX * this.iconData.containerScale,
      y: this.iconView.iconScaleY * this.iconData.containerScale })
    .opacity(this.iconView.iconAlpha)
  }

  @Styles
  pixelRoundUse() {
    .pixelRound({
      start: PixelRoundCalcPolicy.NO_FORCE_ROUND,
      end: PixelRoundCalcPolicy.NO_FORCE_ROUND,
      top: PixelRoundCalcPolicy.NO_FORCE_ROUND,
      bottom: PixelRoundCalcPolicy.NO_FORCE_ROUND
    })
  }

  private drawMask(context: CanvasRenderingContext2D, fillStyle: string): void {
    let iconWidth: number = this.iconView.iconWidth + px2vp(10);
    let iconHeight: number = this.iconView.iconHeight + px2vp(10);
    let image: PixelMap = this.appIcon as PixelMap;
    let tempItem = new AppItemInfo();
    tempItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
    // 空图标、动态图标(日历、时钟)和快捷图标的蒙层基于快捷图标背景图绘制
    image = ShortcutViewModel.getInstance().getShortcutBackgroundImage(tempItem) as PixelMap;
    context.drawImage(image, -10, -10, iconWidth + 20, iconHeight + 20);
    context.globalCompositeOperation = 'source-in';
    context.fillStyle = fillStyle;
    context.fillRect(0, 0, iconWidth, iconHeight);
  }

  @Builder
  DisableMask() {
    Canvas(this.disableMaskContext)
      .onReady(() => {
        this.drawMask(this.disableMaskContext, StyleConstants.APP_ICON_GRAY_COLOR);
      })
      .width(StyleConstants.PERCENTAGE_100)
      .height(StyleConstants.PERCENTAGE_100)
  }

  @Builder
  IconBuilder() {
    Stack({ alignContent: Alignment.Center }) {
      if (!this.isAdaptiveIcon) {
        if (this.appIcon) {
          Image(this.appIcon).draggable(false)
            .width(this.iconView.iconWidth)
            .height(this.iconView.iconHeight)
            .position({ x: -this.iconView.iconFixSize, y: -this.iconView.iconFixSize })
            .pointLight({
              illuminated: PCUtils.is2D() ? 0 : 2,
            })
            .pixelRoundUse()
            .syncLoad(true)
            .interpolation(ImageInterpolation.Medium)
        }
      } else {
        Stack({ alignContent: Alignment.Center }) {
          this.adaptiveIconBackgroundImage();
          this.adaptiveIconShadowImage();
          this.adaptiveIconForegroundImage();
        }
        .pixelRoundUse()
        .pointLight({
          illuminated: PCUtils.is2D() ? 0 : 2,
        })
      }
      if (this.isGrayApp) {
        this.DisableMask();
      }
    }
    .id('companionIconForPC_' + this.iconView.companionIconInfo?.bundleName)
    .StackUse()

  }

  @Builder
  adaptiveIconBackgroundImage() {
    Image(this.bgImage)
      .draggable(false)
      .width(this.scaled() ? this.iconView.iconWidth : this.iconView.iconWidth * HoverEffectConstants.ADAPTIVE_SCALE)
      .height(this.scaled() ? this.iconView.iconHeight : this.iconView.iconHeight * HoverEffectConstants.ADAPTIVE_SCALE)
      .interpolation(ImageInterpolation.Low)
      .syncLoad(true)
      .pixelRoundUse()
  }

  @Builder
  adaptiveIconShadowImage() {
    Image(this.shadowPixelmap)
      .draggable(false)
      .width(this.scaled() ? this.iconView.iconWidth : this.iconView.iconWidth * HoverEffectConstants.ADAPTIVE_SCALE)
      .height(this.scaled() ? this.iconView.iconHeight : this.iconView.iconHeight * HoverEffectConstants.ADAPTIVE_SCALE)
      .interpolation(ImageInterpolation.Low)
      .syncLoad(true)
      .scale({ x: this.appIconShadowData.shadowScale, y: this.appIconShadowData.shadowScale })
      .opacity(this.appIconShadowData.shadowOpacity)
      .translate({
        x: this.appIconShadowData.shadowTranslateX,
        y: this.appIconShadowData.shadowTranslateY,
      })
      .rotate({
        x: this.appIconShadowData.shadowRotateX,
        y: this.appIconShadowData.shadowRotateY,
        z: 0,
        centerX: '50%',
        centerY: '50%',
        perspective: -1.5,
        angle: this.appIconShadowData.shadowRotateAngle
      })
      .pixelRoundUse()
  }

  @Builder
  adaptiveIconForegroundImage() {
    Image(this.foreground)
      .draggable(false)
      .width(this.scaled() ? this.iconView.iconWidth : this.iconView.iconWidth * HoverEffectConstants.ADAPTIVE_SCALE)
      .height(this.scaled() ? this.iconView.iconHeight : this.iconView.iconHeight * HoverEffectConstants.ADAPTIVE_SCALE)
      .objectFit(ImageFit.Contain)
      .interpolation(ImageInterpolation.Medium)
      .autoResize(false)
      .syncLoad(true)
      .pixelRoundUse()
  }

  private isNeedBadge(): boolean {
    return this.iconView.companionIconInfo?.needBadge === undefined || this.iconView.companionIconInfo?.needBadge;
  }

  build() {
    if (this.isIconUpdateReady) {
      Badge({
        count: this.badgeNumber,
        maxCount: StyleConstants.MAX_BADGE_COUNT,
        style: {
          color: StyleConstants.DEFAULT_FONT_COLOR,
          fontSize: this.badgeFontSize * this.mBadgeScale,
          badgeSize: (this.badgeNumber > 0 && this.isNeedBadge() ? this.mBadgeSize * this.mBadgeScale : 0),
          badgeColor: $r('sys.color.ohos_id_color_badge_red'),
          borderWidth: 0
        },
        position: this.getBadgePostion()
      }) {
        this.IconBuilder()
      }
      .BadgeUse()
    }
  }
}