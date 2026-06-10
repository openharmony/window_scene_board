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

import {
  ImmersiveShowType,
  LiveButtonArray,
  LiveExtendType,
  LiveOtherExtendData,
  LivePickUpTemplate,
  LiveScoreTemplate,
  LiveSystemTemplate,
  LiveType, OtherBaseTemplate, SysTypeCode } from '@ohos/systemuicommon';
import type image from '@ohos.multimedia.image';
import { transResToPicHelper } from '@ohos/systemuicommon';
import { LiveViewData } from '@ohos/systemuicommon';
import type { IUpdatable } from '@ohos/systemuicommon';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import Want from '@ohos.app.ability.Want';
import { DrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import { ImmInvertColorMgr } from '@ohos/screenlockcommon/Index';
import { LiveProgressTemplate } from '@ohos/systemuicommon/src/main/ets/liveview/data/template/LiveProgressTemplate';
import { LiveFlightTemplate } from '@ohos/systemuicommon/src/main/ets/liveview/data/template/LiveFlightTemplate';
import {
  LiveNavigationTemplate
} from '@ohos/systemuicommon/src/main/ets/liveview/data/template/LiveNavigationTemplate';
import { immersiveDefaultCardDataHelper } from './ImmersiveDefaultCardDataHelper';
import { ImmersiveCardAuthLevel, ImmersiveConstants } from '../../common/ImmersiveConstants';
import { OnBodyStateResponse } from '@kit.SensorServiceKit';

const SHOW_TYPE: Set<ImmersiveShowType> = new Set([
  ImmersiveShowType.NOT_SHOW,
  ImmersiveShowType.SHOW_CAPSULE,
  ImmersiveShowType.SHOW_CARD
]);
const TAG = 'ImmersiveCardData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const IMAGE_LIMIT = 4 * 1024 * 1024;

/**
 * 沉浸式锁屏卡片数据模型
 */
@Observed
export class ImmersiveCardData implements IUpdatable {
  /**
   * 实况卡片模板类型
   */
  public liveType?: LiveType = LiveType.TYPE_SYSTEM;

  /**
   * 实况通知数据
   */
  public liveView?: LiveViewData;

  /**
   * 沉浸卡片实况数据，深拷贝原实况数据
   */
  public cardLiveView?: LiveViewData;

  /**
   * 沉浸式卡片大图
   */
  public bigIcon?: image.PixelMap;

  /**
   * 沉浸式卡片大图资源路径
   */
  public bigIconRes?: string;

  /**
   * 用于通过UIExtensionComponent拉起应用小窗的参数
   */
  public immersiveWant?: Want;

  /**
   * 沉浸式实况锁屏背景图片
   */
  private backgroundIcon?: image.PixelMap;

  /**
   * 左上角应用名称
   */
  public appName?: string;

  /**
   * 左上角应用小图标
   */
  private appIcon?: image.PixelMap | string | DrawableDescriptor;

  /**
   * 位置信息错误码
   */
  public locationErrorCode: number = Infinity;

  /**
   * 设置扩展组件是否支持交互操作
   */
  public isSupportInteraction?: boolean;

  /**
   * 沉浸实况权益
   */
  private immersiveCardAuthLevel?: number;

  /**
   * 沉浸态常亮开关，默认关闭
   */
  private _isKeepScreenOnEnable: boolean = false;

  /**
   * 获取沉浸实况类型
   * @returns
   */
  getLiveType(): LiveType | undefined {
    return this.liveType;
  }

  /**
   * 数据可显示类型
   * 默认可以在胶囊和卡片中显示
   */
  private showType: ImmersiveShowType = ImmersiveShowType.SHOW_CAPSULE;

  /**
   * 显示类型切换监听
   */
  private showTypeListener?: (showType: ImmersiveShowType) => void;

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    if (!(other instanceof ImmersiveCardData)) {
      return;
    }
    let otherImmersiveData = other as ImmersiveCardData;
    this.setLiveType(otherImmersiveData.liveType);
    this.setBigIcon(otherImmersiveData.bigIcon);
    this.setBigIconRes(otherImmersiveData.bigIconRes);
    this.setWantInfo(otherImmersiveData.immersiveWant);
    this.setBackgroundIcon(otherImmersiveData.backgroundIcon);
    this.setAppName(otherImmersiveData.appName);
    this.setAppIcon(otherImmersiveData.appIcon);
    this.setIsSupportInteraction(otherImmersiveData.isSupportInteraction);
    this.setImmersiveCardAuthLevel(otherImmersiveData.immersiveCardAuthLevel);
  }

  /**
   * 导航类型
   *
   * @returns true导航类型
   */
  isNavigationType(): boolean {
    return this.liveType === LiveType.NAVIGATION;
  }

  /**
   * 播控类型
   *
   * @returns true播控类型
   */
  isMediaCenter(): boolean {
    return this.isMediaImmersiveSupported();
  }

  /**
   * 设置沉浸态支持常亮开关
   *
   * @param isEnable
   */
  setKeepScreenOnEnable(isEnable: boolean): void {
    let result = isEnable ?? false;
    if (this._isKeepScreenOnEnable !== result) {
      this._isKeepScreenOnEnable = result;
    }
  }

  /**
   * 是否开启常亮开关
   *
   * @returns true开启常亮
   */
  isKeepScreenOnEnable(): boolean {
    return this._isKeepScreenOnEnable;
  }

  /**
   * 设置实况卡片模板类型
   *
   * @param LiveType 实况卡片模板类型
   * @param forceRefresh 是否强制刷新
   */
  setLiveType(liveType?: LiveType, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(liveType)) {
      this.liveType = liveType;
    }
  }

  /**
   * 设置显示类型切换监听
   *
   * @param listener 监听器
   */
  setShowTypeListener(listener?: (showType: ImmersiveShowType) => void): void {
    this.showTypeListener = listener;
    listener?.(this.showType);
  }

  /**
   * 设置实况通知数据
   *
   * @param liveViewData 实况通知数据
   * @param forceRefresh 是否强制刷新
   */
  setLiveView(liveViewData?: LiveViewData, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(liveViewData)) {
      this.liveView = liveViewData;
      this.updateCardShowState();
    }
  }

  /**
   * 设置沉浸式卡片大图
   *
   * @param bigIcon 沉浸式卡片大图
   * @param forceRefresh 是否强制刷新
   */
  setBigIcon(bigIcon?: image.PixelMap, forceRefresh?: boolean): void {
    if ((forceRefresh || !CommonUtils.isInvalid(bigIcon)) && this.checkBigIcon(bigIcon)) {
      this.bigIcon?.release();
      this.bigIcon = bigIcon;
      this.updateCardShowState();
      if (this.isShowImmersiveCard()) {
        // 沉浸大图异步加载后刷新一下是否有可以进沉浸态通知状态
        if (this.liveView?.hashCode) {
          immersiveDefaultCardDataHelper.addImmersiveNtfDataToShow(this.liveView?.hashCode);
        }
      }
    }
  }

  /**
   * 设置沉浸式卡片大图资源路径
   *
   * @param bigIconRes 沉浸式卡片大图资源路径
   * @param forceRefresh 是否强制刷新
   */
  setBigIconRes(bigIconRes?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(bigIconRes)) {
      this.bigIconRes = bigIconRes;
      transResToPicHelper.getPicFromRes(this.bigIconRes).then((result) => this.setBigIcon(result)); // 刷新大图
    }
  }

  /**
   * 设置沉浸式UIExtension参数
   *
   * @param immersiveWant 设置沉浸式UIExtension的want参数
   * @param forceRefresh 是否强制刷新
   */
  setWantInfo(want?: Want, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(want)) {
      this.immersiveWant = want;
      this.updateCardShowState();
    }
  }

  /**
   * 设置沉浸式实况锁屏背景图片
   *
   * @param backgroundIcon 沉浸式实况锁屏背景图片
   * @param forceRefresh 是否强制刷新
   */
  setBackgroundIcon(backgroundIcon?: image.PixelMap, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(backgroundIcon)) {
      this.backgroundIcon = backgroundIcon;
    }
  }

  /**
   * 设置左上角应用名称
   *
   * @param appName 左上角应用名称
   * @param forceRefresh 是否强制刷新
   */
  setAppName(appName?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(appName)) {
      this.appName = appName;
    }
  }

  /**
   * 设置左上角应用小图标
   *
   * @param appIcon 左上角应用小图标
   * @param forceRefresh 是否强制刷新
   */
  setAppIcon(appIcon?: image.PixelMap | string | DrawableDescriptor, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(appIcon)) {
      this.appIcon = appIcon;
    }
  }

  /**
   * 设置扩展组件是否支持交互操作
   *
   * @param isSupportInteraction 是否支持交互
   * @param forceRefresh 是否强制刷新
   */
  setIsSupportInteraction(isSupportInteraction?: boolean, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(isSupportInteraction)) {
      this.isSupportInteraction = isSupportInteraction;
    }
  }

  /**
   * 设置实况权益级别
   *
   * @param immersiveCardAuthLevel 权益级别
   * @param forceRefresh 是否强制刷新
   */
  setImmersiveCardAuthLevel(immersiveCardAuthLevel?: number, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(immersiveCardAuthLevel)) {
      this.immersiveCardAuthLevel = immersiveCardAuthLevel;
      this.updateCardShowState();
    }
  }

  /**
   * 是否显示沉浸卡片
   *
   * @returns boolean
   */
  shouldShowInImmersiveCard(): boolean {
    return (this.showType & ImmersiveShowType.SHOW_CARD) !== 0;
  }

  isUiExtensionCard(): boolean {
    return this.immersiveWant ? true : false;
  }

  /**
   * 删除显示场景
   *
   * @param showType 场景
   */
  deleteShowType(showType: ImmersiveShowType): void {
    if (!SHOW_TYPE.has(showType)) {
      return;
    }
    this.showType &= (~Number(showType));
    this.showTypeListener?.(this.showType);
  }

  /**
   * 是否显示锁屏胶囊
   *
   * @returns boolean
   */
  shouldShowInCapsule(): boolean {
    return (this.showType & ImmersiveShowType.SHOW_CAPSULE) !== 0;
  }

  /**
   * 新增显示场景
   *
   * @param showType 场景
   */
  addShowType(showType: ImmersiveShowType): void {
    if (!SHOW_TYPE.has(showType)) {
      return;
    }
    this.showType |= showType;
    this.showTypeListener?.(this.showType);
  }

  /**
   * 设置沉浸卡片实况数据
   *
   * @param liveViewData 实况数据
   * @param forceRefresh 是否强制刷新
   */
  setCardLiveView(liveViewData?: LiveViewData, forceRefresh?: boolean): void {
    if (CommonUtils.isInvalid(liveViewData)) {
      log.showError('liveViewData is invalid.');
      return;
    }
    if (forceRefresh) {
      this.cardLiveView = liveViewData;
      return;
    }
    let newData: LiveViewData = new LiveViewData();
    newData.setLiveType(liveViewData?.liveType);
    let template:OtherBaseTemplate = new OtherBaseTemplate();
    switch (newData.liveType) {
      case LiveType.PROGRESS:
        template = new LiveProgressTemplate();
        let button: LiveButtonArray = new LiveButtonArray();
        (template as LiveProgressTemplate).nodeIcons = button;
        break;
      case LiveType.PICK_UP:
        template = new LivePickUpTemplate();
        break;
      case LiveType.FLIGHT:
        template = new LiveFlightTemplate();
        break;
      case LiveType.SCORE:
        template = new LiveScoreTemplate();
        break;
      case LiveType.NAVIGATION:
        template = new LiveNavigationTemplate();
        break;
      case LiveType.TYPE_SYSTEM:
        this.createSystemLiveViewData(liveViewData, newData);
        return;
      default:
        break;
    }
    let extendData: LiveOtherExtendData = new LiveOtherExtendData();
    template.setExtendData(LiveExtendType.TYPE_OTHER_EXTEND, extendData);
    template.setLiveTimer(liveViewData?.getTemplateTimer());
    template.isTimeTemplate = (liveViewData?.template as OtherBaseTemplate)?.isTimeTemplate;
    newData.setTemplate(template);
    newData.update(liveViewData);
    this.cardLiveView = newData;
  }

  toString(): string {
    return `appName: ${this.appName}, type: ${this.liveType}, showType: ${this.showType}`;
  }

  /**
   * 创建系统实况模板
   */
  private createSystemLiveViewData(liveViewData?: LiveViewData, newData?: LiveViewData): void {
    let sysTemplate = new LiveSystemTemplate();
    let oriTemplate = liveViewData?.template as LiveSystemTemplate;
    newData?.setTemplate(sysTemplate);
    newData?.update(liveViewData);
    sysTemplate.setTitle(this.immersiveWant?.parameters?.immersiveTitle as string);
    sysTemplate.setContent(this.immersiveWant?.parameters?.immersiveContent as string);
    sysTemplate.setOverlayIcon(oriTemplate.overlayIcon);
    this.cardLiveView = newData;
  }

  /**
   * 更新沉浸态支持状态
   */
  private updateCardShowState(): void {
    if (this.isShowImmersiveCard()) {
      this.addShowType(ImmersiveShowType.SHOW_CARD);
      // 支持沉浸态，缓存壁纸反色（非播控、UIExtension）
      if (Boolean(this.bigIcon) && !Boolean(this.immersiveWant) && !this.isMediaImmersiveSupported()) {
        ImmInvertColorMgr.getInstance().cacheInvertColor(this.liveView?.hashCode, this.bigIcon);
      }
      // UIExtension时，开启状态栏背景色渐变
      ImmInvertColorMgr.getInstance().cacheSbBgGradientState(this.liveView?.hashCode, Boolean(this.immersiveWant));
      return;
    }
    // 其他场景不支持沉浸态
    this.deleteShowType(ImmersiveShowType.SHOW_CARD);
    // 清除壁纸反色
    ImmInvertColorMgr.getInstance().deleteCacheByHash(this.liveView?.hashCode);
  }

  /**
   * 1、播控类直接放行
   * 2、有实况权益数据，使用实况权益数据校验
   * 3、无实况权益数据，校验是否在白名单
   *
   * @returns 是否展示沉浸卡片
   */
  private isShowImmersiveCard(): boolean {
    if (this.isMediaImmersiveSupported()) {
      return true;
    }
    if (this.immersiveWant || this.bigIcon) {
      if (this.immersiveCardAuthLevel !== ImmersiveCardAuthLevel.INVALID_AUTH) {
        return this.isHasImmersiveRight();
      }
      if (this.isInWhitelist()) {
        return true;
      }
    }
    return false;
  }

  private isInWhitelist(): boolean {
    if (this.immersiveWant && ImmersiveConstants.isValidUiExtensionWant(this.immersiveWant.bundleName,
      this.immersiveWant.abilityName)) {
      return true;
    }
    return false;
  }

  private isHasImmersiveRight(): boolean {
    return this.immersiveCardAuthLevel === ImmersiveCardAuthLevel.STATIC_IMAGE_RIGHT || this.immersiveCardAuthLevel ===
      ImmersiveCardAuthLevel.DYNAMIC_IMAGE_RIGHT_WITH_INTERACTION;
  }

  /**
   * 是播控且支持沉浸态的场景
   *
   * @returns boolean
   */
  private isMediaImmersiveSupported(): boolean {
    return this.liveView?.isSysTypeCode(SysTypeCode.BROADCASTING_CENTER) ?? false;
  }

  private checkBigIcon(bigIcon?: image.PixelMap): boolean {
    let pixelBytesNumber: number | undefined = bigIcon?.getPixelBytesNumber();
    if (pixelBytesNumber === undefined || pixelBytesNumber > IMAGE_LIMIT) {
      log.showError('checkBigIcon false.');
      return false;
    }
    return true;
  }
}