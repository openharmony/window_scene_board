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

import resourceManager from '@ohos.resourceManager';
import { image } from '@kit.ImageKit';
// import lazy { hdsDrawable } from '@kit.UIDesignKit';
import bundleResourceManager from '@ohos.bundle.bundleResourceManager';
import { DrawableDescriptor, LayeredDrawableDescriptor } from '@kit.ArkUI';
import { DeviceHelper } from '../../base/DeviceHelper';
import taskpool from '@ohos.taskpool';
import type ctx from '@ohos.app.ability.common';
import { IconCacheFwkInterface } from '../IconCacheFwkInterface';
import IconInfo, { IconPicType } from '../IconInfo';
import { LogDomain, Logger, CheckEmptyUtils, CommonUtils, PixelMapUtil } from '@ohos/basicutils';
import { GraphicUtils } from '../GraphicsUtils';
import { Constants } from '@ohos/commonconstants';
import { GlobalContext } from '../../utils/GlobalContext';

import { AppIconIdLoader } from '../AppIconIdLoader';
import { BundleResourceInfo } from '@ohos/windowsceneinterfaces';
import { LauncherAbilityResourceInfo } from '@ohos/windowsceneinterfaces';
import commonBundleManager from '../../manager/CommonBundleManager';
import { IconExtendParam } from '../IconExtendParam';
import { TaskInfo } from '../TaskInfo';
import { IconResourceUtils } from '../IconResourceUtils';

const TAG = 'BundleManagerFwk';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);
const INVALID_ICON_ID: number = 0;

export class BundleManagerFwk implements IconCacheFwkInterface {
  private static sInstance: BundleManagerFwk | null = null;
  private iconSizeOfGrid: number = px2vp(Constants.APP_ICON_STANDARD_WIDTH);
  private maskImage: image.PixelMap | undefined = undefined;
  private appIconIdLoader: AppIconIdLoader | undefined = undefined;

  public static getInstance(): BundleManagerFwk {
    if (BundleManagerFwk.sInstance === null) {
      BundleManagerFwk.sInstance = new BundleManagerFwk();
      // 只对手机\平板\pc\qxs设置editable属性，watch设备不支持hds
      if (DeviceHelper.isPhoneOrPad() || DeviceHelper.isPC() || DeviceHelper.is2In1DevicePadType() ||
        DeviceHelper.is2In1DevicePcType()) {
        try {
          // pixelMap editable属性设置为false 避免横竖屏旋转场景卡顿
          // hdsDrawable.setHdsDrawableEditable(false);
        } catch (e) {
          log.showError(TAG, `set hds drawable editable fail, error: ${e}`);
        }
      }
    }
    return BundleManagerFwk.sInstance;
  }

  /**
   * 初始化图标大小, 对应为当前机型的默认标准图标大小
   *
   * @param iconSizeOfGrid 图标大小, 单位vp
   */
  public initIconSizeOfGrid(iconSizeOfGrid: number): void {
    if (iconSizeOfGrid === undefined || iconSizeOfGrid <= 0) {
      log.showError(TAG, `invalid iconSize, use default iconSizeOfGrid`);
      return;
    }
    log.showWarn(TAG, `set Iconsize: ${iconSizeOfGrid}`);
    this.iconSizeOfGrid = iconSizeOfGrid;
  }

  public getMaskImage(): image.PixelMap {
    if (CheckEmptyUtils.isEmptyPixelMap(this.maskImage)) {
      log.showWarn(TAG, 'maskImage is empty, refreshMaskImage');
      this.refreshMaskImage();
    }
    // 无法获取mask时需要正常返回, hds支持传入空参数, 其内部使用默认的mask处理
    return this.maskImage;
  }

  public getIconSizeOfGrid(): number {
    return this.iconSizeOfGrid;
  }

  public getHdsIcon(bundleName: string, imagePixelMap: image.PixelMap): image.PixelMap {
    return GraphicUtils.getHdsIcon(bundleName, this.iconSizeOfGrid, imagePixelMap, this.getMaskImage());
  }

  public refreshMaskImage(): void {
    log.showInfo(TAG, `refreshMaskImage start`);
    let oldMaskImage: image.PixelMap = this.maskImage;
    try {
      let resManager: resourceManager.ResourceManager = GlobalContext.getContext()?.resourceManager;
      let layeredDrawableDescriptor =
        (resManager?.getDrawableDescriptor($r('app.media.drawable').id)) as LayeredDrawableDescriptor;
      this.maskImage = layeredDrawableDescriptor?.getMask().getPixelMap();
      PixelMapUtil.addName(this.maskImage, 'refreshMaskImage');
    } catch (err) {
      log.showError(TAG, `refreshMaskImage error: ${err}`);
      return;
    }
    oldMaskImage?.release();
    log.showInfo(TAG, `refreshMaskImage end`);
  }

  /**
   * 获取应用图标接口
   *
   * @param bundleName 包名
   * @param moduleName 模块名
   * @param abilityName 应用abilityName
   * @returns IconInfo
   */
  public async getAppIconResourceInner(param: IconExtendParam, bundleName: string, moduleName: string,
    abilityName: string): Promise<IconInfo> {
    let iconInfo: IconInfo = new IconInfo();
    try {
      let iconId = await this.getIconId(bundleName, moduleName, abilityName);
      let resMgr: resourceManager.ResourceManager = (GlobalContext.getInstance().getObject('desktopContext') as
      ctx.ServiceExtensionContext).createModuleResourceManager(bundleName, moduleName);
      let imageDescriptor: DrawableDescriptor = (resMgr.getDrawableDescriptor(Number(iconId), undefined, 1));
      // MemoryUtils.removeNapiWrap(resMgr, false);
      if (CheckEmptyUtils.isEmpty(imageDescriptor)) {
        log.showWarn(TAG, `bundleName: ${bundleName}, imageDescriptor is empty: ${imageDescriptor == null}`);
        return iconInfo;
      }
      let imagePixelMap = await GraphicUtils.getCombinePixelMap(param.bundleName, this.iconSizeOfGrid,
        imageDescriptor, this.getMaskImage(), param);
      PixelMapUtil.addName(imagePixelMap, 'BundleMgr_getCombine');
      if (imageDescriptor instanceof LayeredDrawableDescriptor) {
        log.showInfo(TAG, `getAppIconResourceInner LayeredDrawableDescriptor`);
        let layerImageDescriptor: LayeredDrawableDescriptor = imageDescriptor as LayeredDrawableDescriptor;
        let backGround = layerImageDescriptor.getBackground().getPixelMap();
        PixelMapUtil.addName(backGround, 'BundleMgr_backGround');
        let foreGround = layerImageDescriptor.getForeground().getPixelMap();
        PixelMapUtil.addName(foreGround, 'BundleMgr_foreGround');
        if (backGround !== null && foreGround !== null) {
          let fore = await GraphicUtils.changePixelToBase64(foreGround);
          let back = await GraphicUtils.changePixelToBase64(backGround);
          iconInfo.adaptivePic = [back, fore];
          iconInfo.iconType = IconPicType.ADAPTIVE;
          await backGround.release();
          await foreGround.release();
        }
      } else {
        log.showInfo(TAG, `getAppIconResourceInner normal`);
        iconInfo.iconType = IconPicType.NORMAL;
      }
      iconInfo.combinePicSrc = imagePixelMap;
      iconInfo.combinePic = await GraphicUtils.changePixelToBase64(imagePixelMap);
      PixelMapUtil.addName(imagePixelMap, 'BundleMgr_getAppIconResourceInner');
      await IconResourceUtils.replaceTransparentPixelMap(iconInfo, param, 'getAppIconResourceInner');
    } catch (error) {
      log.showError(TAG, `getAppIconResourceInner error ${error}`);
    }
    return iconInfo;
  }

  /**
   * 通过包管理获取到iconId
   *
   * @param bundleName 包名
   * @param moduleName 模块名
   * @param abilityName 应用abilityName
   * @returns iconId
   */
  private async getIconId(bundleName: string, moduleName: string, abilityName: string): Promise<number> {
    if (!CheckEmptyUtils.isEmpty(abilityName)) {
      let iconId = this.appIconIdLoader?.getAppItemIconId(bundleName, moduleName, abilityName);
      if (!iconId) {
        return INVALID_ICON_ID;
      }
      if (iconId !== INVALID_ICON_ID) {
        log.showWarn(TAG, `bundleName: ${bundleName}, load iconId is invalid`);
        return iconId;
      }
      log.showWarn(TAG, `bundleName: ${bundleName}, iconId from BMS by abilityName`);
      let abilityInfo = await commonBundleManager.getAbilityInfoByAbilityName(bundleName, abilityName);
      if (!abilityInfo) {
        return INVALID_ICON_ID;
      }
      return abilityInfo?.iconId === 0 ? abilityInfo.applicationInfo.iconId : abilityInfo?.iconId;
    }
    log.showWarn(TAG, `bundleName: ${bundleName}, iconId from BMS by bundleName`);
    let bundleInfo = await commonBundleManager.getBundleInfoByBundleName(bundleName);
    let hapModulesInfo = bundleInfo?.hapModulesInfo?.filter(moduleInfo => moduleInfo.name === moduleName);
    if (CommonUtils.containerIsEmpty(hapModulesInfo)) {
      log.warn(TAG, `bundleName: ${bundleName}, moduleName: ${moduleName} moduleInfo empty`);
      return bundleInfo?.appInfo?.iconId as number;
    }
    return hapModulesInfo?.[0].iconId as number;
  }


  public setAppIconIdLoader(appIconIdLoader: AppIconIdLoader): void {
    this.appIconIdLoader = appIconIdLoader;
  }

  async getIconResourceFromFwk(param: IconExtendParam, bundleName: string, moduleName?: string, abilityName?: string,
    size?: number): Promise<IconInfo> {
    let iconInfo: IconInfo = new IconInfo();
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showError(TAG, `getIconResourceFromFwk bundleName is null`);
      return iconInfo;
    }
    try {
      log.showWarn(TAG, `getIconResourceFromFwk for ${bundleName} ${moduleName} ${abilityName} ` +
        `${param.appIndex} ${param.hasBorder} ${size} ${param.isTransparentBorder} begin`);
      let task =
        new taskpool.Task('getIconResourceFromFwk', getIconResource, bundleName, moduleName ?? '', abilityName ?? '',
          param, size ?? this.iconSizeOfGrid, this.getMaskImage());
      iconInfo = await taskpool.execute(task) as IconInfo;
      log.showWarn(TAG, `getIconResourceFromFwk for ${bundleName} ${moduleName} ${abilityName} ` +
        ` ${param.appIndex} ${param.hasBorder}  ${size} ${param.isTransparentBorder} end`);
    } catch (error) {
      log.showError(TAG, `getIconResourceFromFwk error ${error}`);
    }
    return iconInfo;
  }

  async getIconResourceFromFwkBatch(taskInfos: TaskInfo[]): Promise<IconInfo[]> {
    let iconInfos: IconInfo[] = [];
    try {
      log.showWarn(TAG, `getIconResourceFromFwkBatch begin`);
      let task = new taskpool.Task('getIconResourceFromFwkBatch', getIconResourceBatch, taskInfos, this.iconSizeOfGrid,
        this.getMaskImage());
      iconInfos = await taskpool.execute(task) as IconInfo[];
      log.showWarn(TAG, `getIconResourceFromFwkBatch end`);
    } catch (error) {
      log.showError(TAG, `getIconResourceFromFwkBatch error ${error}`);
    }
    return iconInfos;
  }
}

async function getIconResourceBatch(taskInfos: TaskInfo[], iconSizeOfGrid: number,
  maskImage: image.PixelMap): Promise<IconInfo[]> {
  'use concurrent';
  let iconInfos: IconInfo[] = [];
  const TAG = 'BundleManagerFwk';
  const log: Logger = Logger.getLogHelper(LogDomain.SCB);

  let size = px2vp(Constants.APP_ICON_SYSTEMUI_WIDTH);

  if (CheckEmptyUtils.isEmptyArr(taskInfos)) {
    log.showWarn(TAG, 'taskInfos is empty');
    return iconInfos;
  }

  for (let taskInfo of taskInfos) {
    let imageDescriptor: DrawableDescriptor | undefined = undefined;
    let bundleName = taskInfo.bundleName;
    let param = taskInfo.param;
    let iconInfo: IconInfo = new IconInfo();
    iconInfo.bundleName = taskInfo.bundleName;
    iconInfo.moduleName = taskInfo.moduleName;
    iconInfo.abilityName = taskInfo.abilityName;
    iconInfo.hdsBundleName = param.bundleName;
    iconInfo.param = taskInfo.param;
    try {
      let resourceInfo: BundleResourceInfo | LauncherAbilityResourceInfo | undefined;
      resourceInfo = IconResourceUtils.getResourceInfo(bundleName, taskInfo.moduleName, taskInfo.abilityName, param.appIndex);
      imageDescriptor = resourceInfo?.drawableDescriptor;
      // 分身图标直接取icon数据
      if (resourceInfo) {
        iconInfo.combinePic = resourceInfo.icon;
      }
    } catch (error) {
      log.showError(TAG, `getResourceInfo error ${error}`);
    }
    if (CheckEmptyUtils.isEmpty(imageDescriptor)) {
      log.showWarn(TAG, `getIconResourceBatch imageDescriptor is null, bundleName:${bundleName},moduleName:${taskInfo.moduleName},abilityName:${taskInfo.abilityName}`);
      iconInfos.push(iconInfo);
      continue;
    }
    let imagePixelMap = await GraphicUtils.getCombinePixelMap(param.bundleName,
      param.hasBorder ? size : iconSizeOfGrid, imageDescriptor, maskImage, param);
    iconInfo.combinePicSrc = imagePixelMap;
    iconInfo.combinePic = await GraphicUtils.changePixelToBase64(imagePixelMap);
    if (imageDescriptor instanceof LayeredDrawableDescriptor && !param.hasBorder) {
      let adaptivePic = await GraphicUtils.getForeGroundBackGroundBase64(bundleName, iconSizeOfGrid, imageDescriptor,
        maskImage);
      if (!CommonUtils.containerIsEmpty(adaptivePic)) {
        iconInfo.adaptivePic = adaptivePic;
        iconInfo.iconType = IconPicType.ADAPTIVE;
      }
    } else {
      iconInfo.iconType = IconPicType.NORMAL;
    }
    PixelMapUtil.addName(iconInfo.combinePicSrc, 'BundleMgr_getIconResourceBatch');
    await IconResourceUtils.replaceTransparentPixelMap(iconInfo, iconInfo.param, 'getIconResourceBatch');
    iconInfo.combinePicSrc?.setTransferDetached(true);
    iconInfos.push(iconInfo);
  }
  return iconInfos;
}

async function getIconResource(bundleName: string, moduleName: string, abilityName: string,
  param: IconExtendParam, iconSizeOfGrid: number, maskImage: image.PixelMap): Promise<IconInfo> {
  'use concurrent';
  let iconInfo: IconInfo = new IconInfo();
  let imageDescriptor: DrawableDescriptor | undefined = undefined;
  const TAG = 'BundleManagerFwk';
  const log: Logger = Logger.getLogHelper(LogDomain.SCB);
  let size = px2vp(Constants.APP_ICON_SYSTEMUI_WIDTH);

  let resourceFlag = bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_DRAWABLE_DESCRIPTOR;
  try {
    let resourceInfo: BundleResourceInfo | LauncherAbilityResourceInfo | undefined;
    if (!CheckEmptyUtils.isEmpty(moduleName) && !CheckEmptyUtils.isEmpty(abilityName)) {
      log.showWarn(TAG, `getIconResource from bms getLauncherAbilityResourceInfo for ${bundleName} ${param.appIndex}`);
      resourceInfo = bundleResourceManager.getLauncherAbilityResourceInfo(bundleName, resourceFlag, param.appIndex)
        .find((curInfo) => curInfo.bundleName === bundleName && curInfo.moduleName === moduleName &&
          curInfo.abilityName === abilityName);
    } else {
      log.showWarn(TAG, `getIconResource from bms getBundleResourceInfo for ${bundleName} ${param.appIndex}`);
      resourceInfo = bundleResourceManager.getBundleResourceInfo(bundleName, resourceFlag, param.appIndex);
    }
    imageDescriptor = resourceInfo?.drawableDescriptor;
  } catch (error) {
    log.showError(TAG, `error ${error}`);
  }
  if (CheckEmptyUtils.isEmpty(imageDescriptor)) {
    log.showWarn(TAG, `getIconResource imageDescriptor is null`);
    return iconInfo;
  }

  let imagePixelMap = await GraphicUtils.getCombinePixelMap(param.bundleName,
    param.hasBorder ? size : iconSizeOfGrid, imageDescriptor, maskImage, param);
  iconInfo.combinePicSrc = imagePixelMap;
  iconInfo.combinePic = await GraphicUtils.changePixelToBase64(imagePixelMap);
  if (imageDescriptor instanceof LayeredDrawableDescriptor && !param.hasBorder) {
    let adaptivePic = await GraphicUtils.getForeGroundBackGroundBase64(bundleName, iconSizeOfGrid, imageDescriptor,
      maskImage);
    if (!CommonUtils.containerIsEmpty(adaptivePic)) {
      iconInfo.adaptivePic = adaptivePic;
      iconInfo.iconType = IconPicType.ADAPTIVE;
    }
  } else {
    iconInfo.iconType = IconPicType.NORMAL;
  }
  PixelMapUtil.addName(iconInfo.combinePicSrc, 'BundleMgr_getIconResource');
  await IconResourceUtils.replaceTransparentPixelMap(iconInfo, param, 'getIconResource');
  iconInfo.combinePicSrc?.setTransferDetached(true);
  return iconInfo;
}

export const bundleManagerFwk = BundleManagerFwk.getInstance();