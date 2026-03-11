/*
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
import { DividerStyleConstants } from '@ohos/commonconstants';
import { IconResourceManager } from '@ohos/frameworkwrapper';
import { LogHelper, LogDomain} from '@ohos/basicutils';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { RecentsStyleConstants } from '../../recent/constants/RecentsStyleConstants';
import { SCBDividerParam, SceneParam } from '../../scene/session/SCBDividerParam';
import { SCBSceneContainerSession } from '../../scene/session/SCBSceneContainerSession';
import { SCBScreenProperty } from '../../screen/session/SCBScreenSession';
import { SCBSceneSession } from './SCBSceneSession';
import { DrawableDescriptor } from '@kit.ArkUI';

const TAG = `SCBAppIconParam`;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

type ImageSource = PixelMap | ResourceStr | DrawableDescriptor;

/**
 * Controls how app icon is displayed
 */
@Observed
export class SCBAppIconParam {
  static readonly SPLIT_APP_ICON_SIZE = 64;
  @Track public show: boolean = false;
  @Track public x: Length = 0;
  @Track public y: Length = 0;
  @Track public size: number = SCBAppIconParam.SPLIT_APP_ICON_SIZE;
  @Track public translateX: number = 0;
  @Track public translateY: number = 0;
  @Track public scale: number = 1;
  @Track public touchScale: number = 1;
  @Track public floatScaleX = 1;
  @Track public floatScaleY = 1;
  @Track public opacity: number = 0;
  @Track public zIndex = 1;
  @Track public rotateAngle = 0;
  @Track public anchorX: Length = 0;
  @Track public anchorY: Length = 0;
  @Track public radius?: Length;

  @Track public primIconTip: ResourceStr = '';
  @Track public primIconTipOpacity: number = 0;
  @Track public primIconTipScale: number = 1.2;
  @Track public needPrimIconTip: boolean = false;
  @Track public secIconTip: ResourceStr = '';
  @Track public secIconTipOpacity: number = 0;
  @Track public secIconTipScale: number = 1.2;
  @Track public needSecIconTip: boolean = false;
  @Track public maxTipWidth: number = Infinity;
  /**
   * whether is need to skip hide tip
   */
  @Track public needSkipHideTip: boolean = false;
  /**
   * whether is in the animation of hiding tip, controls Text Component get down the tree after animation
   */
  @Track public isHideTipAnimating: boolean = false;

  private updateIcon: ((icon: ImageSource) => void) | undefined;
  private sceneSession: () => SCBSceneSession | null;

  constructor(sceneSession: () => SCBSceneSession | null) {
    this.sceneSession = sceneSession;
  }

  public getUpdateIconCallback(): ((icon: ImageSource) => void) | undefined {
    return this.updateIcon;
  }

  public set icon(icon: ImageSource) {
    this.updateIcon?.(icon);
  }

  public getScaleX(): number {
    return this.scale * this.touchScale * this.floatScaleX;
  }

  public getScaleY(): number {
    return this.scale * this.touchScale * this.floatScaleY;
  }

  /**
   * Callback to update icon info
   * @param callback transfer undefined to clear callback
   */
  public updateIconUpdateCallback(callback?: ((icon: ImageSource) => void)): void {
    this.updateIcon = callback;
  }

  /**
   * Refresh the display application icon.
   */
  public async refreshIcon(): Promise<void> {
    let session = this.sceneSession();
    if (session === null || session === undefined) {
      log.showWarn('refreshIcon sceneSession is invalid');
      this.show = false;
      return;
    }
    this.show = true;
    let bundleName: string = session.sceneInfo.bundleName;
    let moduleName: string = session.sceneInfo.moduleName;
    let abilityName: string = session.sceneInfo.abilityName;
    if (ResourceManager.getInstance().isSCBInnerModule(bundleName, moduleName)) {
      log.showInfo(`refreshIcon for scb module ${bundleName}/${moduleName}`);
      let defaultIcon = RecentsStyleConstants.DEFAULT_APP_ICON_IMAGE;
      ResourceManager.getInstance().getSCBInnerIcon(moduleName, (icon: ImageSource) => this.icon = icon, defaultIcon);
      return;
    }
    log.showInfo(`refreshIcon for ${bundleName}/${moduleName}/${abilityName}`);
    let image = await IconResourceManager.getInstance().getCombIcon(bundleName, moduleName, abilityName, undefined,
    'CombIcon_AppIconParam');
    this.icon = image;
  }

  public initAppIconPosition(x: number, y: number, isVertical: boolean): void {
    if (isVertical) {
      this.x = x;
      this.y = y;
    } else {
      this.y = x;
      this.x = y;
    }
  }

  public doAppIconTranslate(translate: number, isVertical: boolean): void {
    if (isVertical) {
      this.translateX = 0;
      this.translateY = translate;
    } else {
      this.translateX = translate;
      this.translateY = 0;
    }
  }

  /**
   * update App icon position on midscene
   *
   * @param sceneParam
   * @param screenProperty
   */
  public updateAppIconPositionOnMidScene(sceneParam: SceneParam, screenProperty: SCBScreenProperty): void {
    if (!sceneParam || sceneParam === undefined) {
      return;
    }
    let sceneW = parseFloat(sceneParam.width) * screenProperty.width / DividerStyleConstants.PERCENT;
    let sceneH = parseFloat(sceneParam.height) * screenProperty.height / DividerStyleConstants.PERCENT;
    this.x = (px2vp(sceneW) - this.size) / 2;
    this.y = (px2vp(sceneH) - this.size) / 2;
  }

  /**
   * only used for update App icon position when midScene adjust window
   *
   * @param sceneW scene width (unit: px)
   * @param sceneH scene height (unit: px)
   * @param offsetX offset x (unit: px)
   * @param offsetY offset y (unit: px)
   */
  public updateAppIconPosOnMidSceneAdjustWindow(sceneW: number, sceneH: number, offsetX: number,
    offsetY: number): void {
    this.x = px2vp(offsetX) + (px2vp(sceneW) - this.size) / 2;
    this.y = px2vp(offsetY) + (px2vp(sceneH) - this.size) / 2;
  }

  public setCenterPosition(container: SCBSceneContainerSession, divider: SCBDividerParam,
    screenProperty: SCBScreenProperty, primary: boolean = true): void {
    if (container.isFloat) {
      this.x = container.needRenderClip.clipWidth.getVp() / 2 - this.size / 2;
      this.y = container.needRenderClip.clipHeight.getVp() / 2 - this.size / 2;
    } else {
      let screenW = px2vp(screenProperty.width);
      let screenH = px2vp(screenProperty.height);
      let sceneW = divider.getSceneWidth(primary, screenW);
      let sceneH = divider.getSceneHeight(primary, screenH);
      let scenePosX = divider.getScenePositionX(primary, screenW);
      let scenePosY = divider.getScenePositionY(primary, screenH);
      this.x = scenePosX + sceneW / 2 - this.size / 2;
      this.y = scenePosY + sceneH / 2 - this.size / 2;
    }
    this.translateX = 0;
    this.translateY = 0;
  }

  /**
   * Reset the params for the tip
   */
  public resetDraggingTip(): void {
    this.needPrimIconTip = false;
    this.needSecIconTip = false;
    this.primIconTip = '';
    this.secIconTip = '';
    this.primIconTipOpacity = 0;
    this.secIconTipOpacity = 0;
    this.primIconTipScale = 1.2;
    this.secIconTipScale = 1.2;
  }

  /*
 * Set the max width for tip
 */
  public setMaxTipWidth(newMaxTipWidth: number): void {
    this.maxTipWidth = newMaxTipWidth;
  }

  public setSize(value: number): void {
    this.size = value;
  }

  public getSize(): number {
    return this.size;
  }

  public setScale(value: number): void {
    this.scale = value;
  }

  public getScale(): number {
    return this.scale;
  }

  public setTouchScale(value: number): void {
    this.touchScale = value;
  }

  public getTouchScale(): number {
    return this.touchScale;
  }

  public setFloatScaleX(value: number): void {
    this.floatScaleX = value;
  }

  public getFloatScaleX(): number {
    return this.floatScaleX;
  }

  public setFloatScaleY(value: number): void {
    this.floatScaleY = value;
  }

  public getFloatScaleY(): number {
    return this.floatScaleY;
  }
}