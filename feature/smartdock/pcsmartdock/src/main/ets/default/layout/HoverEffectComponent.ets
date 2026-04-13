/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import image from '@ohos.multimedia.image';
import drawableDescriptor from '@ohos.arkui.drawableDescriptor';

import {
  BadgeListener,
  BadgeManager,
  CommonConstants,
  DockItemInfo,
  StyleConstants
} from '@ohos/launchercommon';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { BadgeItemInfo } from '@ohos/launchercommon';
import HoverEffectConstants from '../common/constants/HoverEffectConstants';
import SmartDockConstants from '@ohos/smartdock/src/main/ets/default/common/constants/SmartDockConstants';

import { PCDockUtils } from '../utils/PCDockUtils';

const TAG = 'HoverEffectComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

@Component
export default struct HoverEffectComponent {
  private icon: string | image.PixelMap = '';
  private backgroundDescriptor: drawableDescriptor.DrawableDescriptor | null = null;
  private foregroundDescriptor: drawableDescriptor.DrawableDescriptor | null = null;
  private iconSize: number = 0;
  private appInfo: DockItemInfo = new DockItemInfo();
  private isAdaptiveIcon: boolean = false;
  private shadowPixelmap: image.PixelMap | null = null;
  private mBaseBorderRadius: number = 12;
  private mBaseShadowTranslateOffset: number = 3;
  private badgeFontSize: number = StyleConstants.PC_BADGE_FONT_SIZE;
  private mBadgeSize: number = StyleConstants.PC_BADGE_SIZE;
  private mBadgeScale: number = 1;
  private badgeManager: BadgeManager = BadgeManager.getInstance();
  @Consume hoverVisibility: Visibility;
  @Consume rotateX: number;
  @Consume rotateY: number;
  @Consume backgroundRotateAngle: number;
  @Consume foregroundRotateAngle: number;
  @Consume foregroundTranslateX: number;
  @Consume foregroundTranslateY: number;
  @Consume highlightingTranslateX: number;
  @Consume highlightingTranslateY: number;
  @Consume shadowTranslateX: number;
  @Consume shadowTranslateY: number;
  @Consume baseScale: number;
  @Consume shadowScale: number;
  @Consume foregroundScale: number;
  @Consume shadowOpacity: number;
  @Consume adapterScale: number;
  @State updateIconReady: boolean = false;
  @State badgeNumber: number = 0;

  getPresetBackground(): Resource | string | null {
    let backgroundResource: Resource | string | null = null;
    switch (this.appInfo.abilityName) {
      case CommonConstants.APPCENTER_ABILITY:
        backgroundResource = $r('app.media.adaptive_appcenter_background');
        break;
      case CommonConstants.RECENT_ABILITY:
        backgroundResource = $r('app.media.adaptive_multitask_background');
        break;
      case CommonConstants.RECYCLE_BIN_ABILITY:
        backgroundResource = StyleConstants.DEFAULT_RECYCLE_BIN_BACKGROUND_IMAGE;
        break;
      default:
        break;
    }
    return backgroundResource;
  }

  getPresetForeground(): Resource | string | null {
    let foregroundResource: Resource | string | null = null;
    switch (this.appInfo.abilityName) {
      case CommonConstants.APPCENTER_ABILITY:
        foregroundResource = $r('app.media.adaptive_appcenter_foreground');
        break;
      case CommonConstants.RECENT_ABILITY:
        foregroundResource = $r('app.media.adaptive_multitask_foreground');
        break;
      case CommonConstants.RECYCLE_BIN_ABILITY:
        foregroundResource = StyleConstants.DEFAULT_RECYCLE_BIN_FOREGROUND_IMAGE;
        break;
      default:
        break;
    }
    return foregroundResource;
  }

  private badgeListener: BadgeListener = {
    onUpdate: (badgeInfo: BadgeItemInfo) => {
      log.showDebug(`update badge.badgeNumber=${badgeInfo?.badgeNumber}, badge.isShow=${badgeInfo?.isShow}`);
      this.badgeManager.getBadgeDisplayNumberByBundle(this.appInfo, (num: number) => this.badgeNumber = num);
    }
  };

  private isPcResidentAbility(): boolean {
    return this.appInfo.abilityName === CommonConstants.APPCENTER_ABILITY ||
      this.appInfo.abilityName === CommonConstants.RECENT_ABILITY ||
      this.appInfo.abilityName === CommonConstants.RECYCLE_BIN_ABILITY;
  }

  aboutToAppear() {
    log.showInfo(`HoverEffectComponent aboutToAppear ${this.appInfo.bundleName}`);
    this.badgeManager.getBadgeDisplayNumberByBundle(this.appInfo, (num: number) => this.badgeNumber = num);
    if (this.appInfo != null && this.appInfo.bundleName != CommonConstants.LAUNCHER_BUNDLE) {
      log.showInfo(`HoverEffectComponent aboutToAppear isAdaptiveIcon ${this.isAdaptiveIcon}`);
      if (this.isAdaptiveIcon) {
        if (this.foregroundDescriptor) {
          this.shadowPixelmap = ResourceManager.getInstance().getCachedEffectKit(this.appInfo?.appIconId,
            this.appInfo?.abilityName);
        }
      } else {
        if (this.appInfo.bundleName && this.appInfo.moduleName) {
          ResourceManager.getInstance().getAppIconWithCache(this.appInfo.appIconId, this.appInfo.bundleName,
            this.appInfo.moduleName, (value: string | PixelMap) => {
              this.icon = value;
              this.updateIconReady = true;
            }, this.icon);
        }
      }
    } else if (this.appInfo != null && this.isPcResidentAbility()) {
      log.showInfo(`HoverEffectComponent aboutToAppear resident ${this.appInfo.abilityName}`);
      this.isAdaptiveIcon = true;
      this.shadowPixelmap = ResourceManager.getInstance().getCachedEffectKit(this.appInfo?.appIconId,
        this.appInfo?.abilityName);
    }
    this.badgeManager.registerBadgeListener(this.appInfo, this.badgeListener);
    log.showInfo(`HoverEffectComponent aboutToAppear end ${this.appInfo.bundleName}`);
  }

  aboutToDisappear() {
    this.badgeManager.unRegisterBadgeListener(this.appInfo, this.badgeListener);
  }

  build() {
    Badge({
      count: this.badgeNumber,
      maxCount: StyleConstants.MAX_BADGE_COUNT,
      style: {
        color: StyleConstants.DEFAULT_FONT_COLOR,
        fontSize: this.badgeFontSize * this.mBadgeScale,
        badgeSize: (this.badgeNumber > 0 ? this.mBadgeSize * this.mBadgeScale : 0),
        badgeColor: Color.Red
      },
      position: this.badgeManager.getBadgePostion(this.badgeNumber, this.badgeFontSize * this.mBadgeScale,
        this.iconSize)
    }) {
      Flex() {
        Stack({ alignContent: Alignment.Center }) {
          if (this.isAdaptiveIcon) {
            Stack({ alignContent: Alignment.Center }) {
              Image(this.isPcResidentAbility() ? this.getPresetBackground() : this.backgroundDescriptor)
                .draggable(false)
                .height(this.iconSize * HoverEffectConstants.ADAPTIVE_SCALE)
                .width(this.iconSize * HoverEffectConstants.ADAPTIVE_SCALE)
                .interpolation(ImageInterpolation.Medium)
                .autoResize(false)
                .syncLoad(true)
            }
            .height(this.iconSize)
            .width(this.iconSize)
            .clip(true)
            .borderRadius(this.mBaseBorderRadius)

            Image(this.shadowPixelmap)
              .draggable(false)
              .height(this.iconSize * HoverEffectConstants.ADAPTIVE_SCALE)
              .width(this.iconSize * HoverEffectConstants.ADAPTIVE_SCALE)
              .objectFit(ImageFit.Contain)
              .interpolation(ImageInterpolation.Medium)
              .autoResize(false)
              .scale({ x: this.shadowScale, y: this.shadowScale })
              .opacity(this.shadowOpacity)
              .syncLoad(true)
              .translate({
                x: this.shadowTranslateX + this.mBaseShadowTranslateOffset,
                y: this.shadowTranslateY + this.mBaseShadowTranslateOffset,
              })
              .rotate({
                x: this.rotateX,
                y: this.rotateY,
                z: 0,
                centerX: '50%',
                centerY: '50%',
                perspective: HoverEffectConstants.CAMERA_DISTANCE,
                angle: this.foregroundRotateAngle
              })

            Image(this.isPcResidentAbility() ? this.getPresetForeground() : this.foregroundDescriptor)
              .draggable(false)
              .height(this.iconSize * HoverEffectConstants.ADAPTIVE_SCALE)
              .width(this.iconSize * HoverEffectConstants.ADAPTIVE_SCALE)
              .objectFit(ImageFit.Contain)
              .interpolation(ImageInterpolation.Medium)
              .autoResize(false)
              .syncLoad(true)
              .scale({ x: this.foregroundScale, y: this.foregroundScale })
              .translate({
                x: this.foregroundTranslateX,
                y: this.foregroundTranslateY,
              })
              .rotate({
                x: this.rotateX,
                y: this.rotateY,
                z: 0,
                centerX: '50%',
                centerY: '50%',
                perspective: HoverEffectConstants.CAMERA_DISTANCE,
                angle: this.foregroundRotateAngle
              })
          } else {
            Stack({ alignContent: Alignment.Center }) {
              if (this.updateIconReady) {
                Image(this.icon).draggable(false)
                  .interpolation(ImageInterpolation.Medium)
                  .autoResize(false)
                  .syncLoad(true)
              }
            }
            .height(this.iconSize)
            .width(this.iconSize)
            .clip(true)
            .borderRadius(this.mBaseBorderRadius)
            .rotate({
              x: this.rotateX,
              y: this.rotateY,
              z: 0,
              centerX: '50%',
              centerY: '50%',
              perspective: HoverEffectConstants.CAMERA_DISTANCE,
              angle: this.backgroundRotateAngle
            })
          }
        }
      }
      .clip(true)
      .borderRadius(this.mBaseBorderRadius)
      .enabled(false)
      .shadow({
        radius: SmartDockConstants.DOCK_ITEM_HOVER_SHADOW_RADIUS,
        color: SmartDockConstants.DOCK_ITEM_HOVER_SHADOW_COLOR,
        offsetY: SmartDockConstants.DOCK_ITEM_HOVER_SHADOW_OFFSETY_ONE,
        offsetX: SmartDockConstants.DOCK_ITEM_HOVER_SHADOW_OFFSETX_ONE
      })
    }
    .visibility(this.hoverVisibility)
    .scale({ x: this.baseScale, y: this.baseScale })
    .enabled(false)
    .height(this.iconSize)
    .width(this.iconSize)
  }
}