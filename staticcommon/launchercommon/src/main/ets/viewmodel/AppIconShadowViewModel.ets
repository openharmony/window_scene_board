/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper, Trace, CheckEmptyUtils } from '@ohos/basicutils';
import { GlobalContext, IconResourceManager } from '@ohos/frameworkwrapper';
import curves from '@ohos.curves';
import { CommonConstants } from '../constants/CommonConstants';
import { AppIconShadowData } from '../bean/AppIconShadowData';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { DockContinuableInfo } from '../bean/DockContinuableInfo';
import { IconPicType } from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/IconInfo';
import { AppItemInfo } from '../bean/AppItemInfo';


const TAG = 'AppIconShadowViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class AppIconShadowViewModel {
  private mouseX: number = 0;
  private mouseY: number = 0;
  private curve1: curves.ICurve = curves.cubicBezierCurve(0.2, 0.0, 0.2, 1.0);
  private currentForegroundMaxTranslate: number = 0;
  private currentShadowMaxTranslate: number = 0;
  private is2DVersion: boolean = false;
  private iconSize: number = 0;
  private appIconShadowData: AppIconShadowData;
  private isContinueItem: boolean = false;
  private onAppIconUpdate: Function = (data: DockContinuableInfo): Promise<void> => this.appEventIconUpdate(data);
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private iconLoadCallback?: Function;

  public constructor(appIconShadowData: AppIconShadowData) {
    this.appIconShadowData = appIconShadowData;
  }

  public init(is2DVersion: boolean, iconSize: number, isContinueItem: boolean, iconLoadCallback: Function): void {
    this.is2DVersion = is2DVersion;
    this.iconSize = iconSize;
    this.isContinueItem = isContinueItem;
    this.iconLoadCallback = iconLoadCallback;
    if (this.isContinueItem) {
      this.desktopContext?.eventHub.on('continueItemChange', this.onAppIconUpdate);
    }
    log.showInfo(`init, ${this.is2DVersion},${this.iconSize},${this.isContinueItem}`);
  }

  public destroy(): void {
    if (this.isContinueItem) {
      this.desktopContext?.eventHub.off('continueItemChange', this.onAppIconUpdate);
    }
    log.showInfo(`destroy, ${this.isContinueItem}`);
  }

  public getAppIconShadowData(): AppIconShadowData {
    return this.appIconShadowData;
  }

  private async appEventIconUpdate(appInfo: DockContinuableInfo): Promise<void> {
    if (CheckEmptyUtils.isEmpty(appInfo) || CheckEmptyUtils.isEmpty(appInfo.bundleName) ||
    CheckEmptyUtils.isEmpty(appInfo.moduleName) || !this.iconLoadCallback) {
      return;
    }
    log.showInfo(`update bundleName, ${appInfo.bundleName} moduleName, ${appInfo.moduleName} abilityName, ${appInfo.abilityName} iconSize: ${this.iconSize}`);
    let icon = await IconResourceManager.getInstance().getIconResourceBySize(appInfo.bundleName, appInfo.moduleName,
      appInfo.abilityName, this.iconSize);
    const isAdaptiveIcon: boolean = icon.iconType === IconPicType.ADAPTIVE ? true : false;
    if (isAdaptiveIcon) {
      this.iconLoadCallback(icon, isAdaptiveIcon, appInfo);
    } else {
      this.iconLoadCallback(icon.combinePic, isAdaptiveIcon, appInfo);
    }
  }


  public onHoverIconHandler(isHover: boolean): void {
    if (this.is2DVersion) {
      return;
    }
    log.showInfo(`handleHoverState ${isHover}`);
    if (isHover) {
      this.onHoverIconInAnimation();
    } else {
      this.onHoverIconOutAnimation();
    }
  }

  private onHoverIconInAnimation() {
    log.showInfo('onHoverIconInAnimation');
    let x = this.mouseX;
    let y = this.mouseY;
    const size = this.iconSize;
    const halfSize = size / 2;
    let expectAngleX = (y / halfSize - 1) * CommonConstants.BACKGROUND_ROTATE_ANGLE_X;
    let expectAngleY = (x / halfSize - 1) * CommonConstants.BACKGROUND_ROTATE_ANGLE_Y;
    let angle = Math.sqrt(Math.pow(expectAngleX, 2) + Math.pow(expectAngleY, 2))
    let maxDis = Math.sqrt(Math.pow(halfSize, 2) + Math.pow(halfSize, 2));
    let curDis = Math.sqrt(Math.pow(x - halfSize, 2) + Math.pow(y - halfSize, 2));

    let currentForegroundTranslate = CommonConstants.FOREGROUND_BASE_TRANSLATE *
    this.curve1.interpolate((maxDis - curDis) / (maxDis));
    this.currentForegroundMaxTranslate = Math.max(this.currentForegroundMaxTranslate, currentForegroundTranslate);
    let currentShadowTranslate = CommonConstants.SHADOW_BASE_TRANSLATE *
    this.curve1.interpolate((maxDis - curDis) / (maxDis));
    this.currentShadowMaxTranslate = Math.max(this.currentShadowMaxTranslate, currentShadowTranslate);
    animateTo({
      curve: curves.springCurve(0, 1, 322, 30),
    }, () => {
      this.appIconShadowData.shadowRotateX = expectAngleX;
      this.appIconShadowData.shadowRotateY = expectAngleY;
      this.appIconShadowData.shadowRotateAngle = angle * CommonConstants.FOREGROUND_ROTATE_ANGLE_MULTIPLE;
      this.appIconShadowData.shadowTranslateX = -(x - halfSize) / halfSize * this.currentShadowMaxTranslate;
      this.appIconShadowData.shadowTranslateY = -(y - halfSize) / halfSize * this.currentShadowMaxTranslate;
      this.appIconShadowData.shadowScale = CommonConstants.FIXED_SHADOW_SCALE;
      this.appIconShadowData.shadowOpacity = CommonConstants.SHADOW_OPACITY;
    });
  }

  private onHoverIconOutAnimation(): void {
    log.showInfo('onHoverIconOutAnimation');
    animateTo({
      curve: curves.responsiveSpringMotion(0.35, 0.86, 0.25),
      onFinish: () => {
      }
    }, () => {
      this.appIconShadowData.shadowRotateX = 0;
      this.appIconShadowData.shadowRotateY = 0;
      this.appIconShadowData.shadowRotateAngle = 0;
      this.appIconShadowData.shadowTranslateX = 0;
      this.appIconShadowData.shadowTranslateY = 0;
      this.appIconShadowData.shadowScale = 1.0;
      this.appIconShadowData.shadowOpacity = 0;
    });
  }

  public onMouseIconHandler(event: MouseEvent): void {
    if (this.is2DVersion) {
      return;
    }
    Trace.start('onMouseIconHandler');
    let x = event.x;
    let y = event.y;
    const size = this.iconSize;
    const halfSize = size / 2;
    let expectAngleX = (y / halfSize - 1) * CommonConstants.BACKGROUND_ROTATE_ANGLE_X;
    let expectAngleY = (x / halfSize - 1) * CommonConstants.BACKGROUND_ROTATE_ANGLE_Y;
    let angle = Math.sqrt(Math.pow(expectAngleX, 2) + Math.pow(expectAngleY, 2))
    let maxDis = Math.sqrt(Math.pow(halfSize, 2) + Math.pow(halfSize, 2));
    let curDis = Math.sqrt(Math.pow(x - halfSize, 2) + Math.pow(y - halfSize, 2));
    let currentForegroundTranslate = CommonConstants.FIXED_FOREGROUND_BASE_TRANSLATE *
    this.curve1.interpolate((maxDis - curDis) / (maxDis));
    this.currentForegroundMaxTranslate = Math.max(this.currentForegroundMaxTranslate, currentForegroundTranslate);
    let currentShadowTranslate = CommonConstants.FIXED_SHADOW_BASE_TRANSLATE *
    this.curve1.interpolate((maxDis - curDis) / (maxDis));
    this.currentShadowMaxTranslate = Math.max(this.currentShadowMaxTranslate, currentShadowTranslate);

    animateTo({
      curve: curves.springCurve(0, 1, 322, 30),
    }, () => {
      this.appIconShadowData.shadowRotateX = expectAngleX;
      this.appIconShadowData.shadowRotateY = expectAngleY;
      this.appIconShadowData.shadowRotateAngle = angle * CommonConstants.FOREGROUND_ROTATE_ANGLE_MULTIPLE;
      this.appIconShadowData.shadowTranslateX = -(x - halfSize) / halfSize * this.currentShadowMaxTranslate;
      this.appIconShadowData.shadowTranslateY = -(y - halfSize) / halfSize * this.currentShadowMaxTranslate;
    });
    Trace.end('onMouseIconHandler');
  }

  public onIconShadowAnimateInForPc(event: MouseEvent): void {
    if (this.is2DVersion) {
      return;
    }
    if (this.appIconShadowData.shadowScale !== CommonConstants.FIXED_SHADOW_SCALE &&
        this.appIconShadowData.shadowOpacity !== CommonConstants.PC_SHADOW_OPACITY) {
      animateTo({
        curve: curves.springCurve(0, 1, 322, 30),
      }, () => {
        this.appIconShadowData.shadowScale = CommonConstants.FIXED_SHADOW_SCALE;
        this.appIconShadowData.shadowOpacity = CommonConstants.PC_SHADOW_OPACITY;
      });
    }
    this.onMouseIconHandler(event);
  }

  public onIconShadowAnimateOutForPc(): void {
    this.onHoverIconOutAnimation();
  }

  public getPcResidentIconName(item: AppItemInfo) {
    let iconName: string = '';
    switch (item.abilityName) {
      case CommonConstants.APPCENTER_ABILITY:
        iconName = 'adaptive_appcenter_foreground';
        break;
      case CommonConstants.RECENT_ABILITY:
        iconName = 'adaptive_multitask_foreground';
        break;
      case CommonConstants.RECYCLE_BIN_ABILITY:
        iconName = 'adaptive_recycle_bin_foreground';
        break;
      default:
        break;
    }
    return iconName;
  }

}
