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

import { bundleResourceManager } from '@kit.AbilityKit';
import { DrawableDescriptor, LayeredDrawableDescriptor } from '@kit.ArkUI';
// import { hdsDrawable } from '@kit.UIDesignKit';
import { CheckEmptyUtils, LogDomain, Logger, PixelMapUtil } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';
import { IconExtendParam } from '../IconExtendParam';
import { IconDatabaseColumn, IconPicType } from '../IconInfo';
import { image } from '@kit.ImageKit';
import IconInfo from '../IconInfo';
import bundleManager from '@ohos.bundle.bundleManager';
import commonBundleManager from '../../manager/CommonBundleManager';
import { GraphicUtils } from '../GraphicsUtils';
import rdb from '@ohos.data.relationalStore';

const TAG = 'DataAndRefreshUtils';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);
const CONTACT_ABILITY_NAME: string = 'com.ohos.contacts.EntryAbility';
const BACK_PICTURE_INDEX: number = 0;
const FORE_PICTURE_INDEX: number = 1;

/**
 * 资源获取或缓存存储子线程操作工具类,防止子线程出现超大方法,相关子线程内的公共操作可抽离至此类
 */
export class DataAndRefreshUtils {
  public static EVENT_STRATEGY_CANCEL_FINISH: string = 'strategy_cancel_finish';

  /**
   * 释放bms处获取到的资源中的图标,用于子线程被打断场景
   *
   * @param bmsRes bms处获取到的资源
   */
  public static releaseBmsInoRes(bmsRes: bundleResourceManager.LauncherAbilityResourceInfo[]): void {
    bmsRes.forEach((resInfo: bundleResourceManager.LauncherAbilityResourceInfo) => {
      let drawableDes: DrawableDescriptor = resInfo.drawableDescriptor;
      if (drawableDes instanceof LayeredDrawableDescriptor) {
        let layeredDrawable: LayeredDrawableDescriptor = drawableDes as LayeredDrawableDescriptor;
        layeredDrawable.getForeground().getPixelMap().release();
        layeredDrawable.getBackground().getPixelMap().release();
      } else {
        drawableDes.getPixelMap().release();
      }
    });
  }

  /**
   * 将从bms获取的资源按单双层图标区分为两个数组,用于分别向hds进行资源处理
   *
   * @param bmsRes 图标bms资源集合
   * @param icons 图标存放最终处理资源集合
   * @param layeredIcons 需要给hds处理的双层图标集合
   * @param iconInfos 需要给hds处理的单层图标集合
   * @param deliverAppIconInfosMap dh应用列表
   */
  public static handleLayeredIconAndIcon(bmsRes: bundleResourceManager.LauncherAbilityResourceInfo[],
    icons: Icon[] , iconInfos: IconInfo[],
    deliverAppIconInfosMap: Map<string, IconInfo>): void {
    if (CheckEmptyUtils.isEmptyArr(bmsRes)) {
      log.showError(TAG, 'bmsRes is empty in handleIcon');
      return;
    }
    for (let resourceInfo of bmsRes) {
      if (resourceInfo.abilityName === CONTACT_ABILITY_NAME) {
        // 当前联系人实现为快捷方式,快捷方式当前未接入三级缓存,避免联系人和电话的资源混淆所以将联系人的资源跳过，此判断在6.1接入单应用多图标时需删除
        let drawable: LayeredDrawableDescriptor = resourceInfo.drawableDescriptor as LayeredDrawableDescriptor;
        drawable.getForeground().getPixelMap().release();
        drawable.getBackground().getPixelMap().release();
        continue;
      }
      let iconInfo: IconInfo = new IconInfo();
      iconInfo.bundleName = resourceInfo.bundleName;
      iconInfo.moduleName = resourceInfo.moduleName;
      iconInfo.abilityName = resourceInfo.abilityName;
      let param: IconExtendParam = new IconExtendParam();
      param.bundleName =
        deliverAppIconInfosMap.has(resourceInfo.bundleName) ?
          resourceInfo.bundleName + SCBConstants.BUNDLENAME_APPEND_TEMPLATE :
        resourceInfo.bundleName;
      iconInfo.hdsBundleName = param.bundleName;
      iconInfo.param = param;

      // if (resourceInfo.drawableDescriptor instanceof LayeredDrawableDescriptor) {
      //   iconInfo.iconType = IconPicType.ADAPTIVE;
      //   layeredIcons.push(...[{
      //     bundleName: param.bundleName,
      //     layeredDrawableDescriptor: resourceInfo.drawableDescriptor
      //   }]);
      // } else {
      iconInfo.iconType = IconPicType.NORMAL;
      icons.push(...[{ bundleName: param.bundleName, pixelMap: resourceInfo.drawableDescriptor.getPixelMap() }]);
      // }
      iconInfos.push(iconInfo);
    }
  }

  /**
   * 将hds处理好的图标放入准备返回给主线程的图标资源集合中
   *
   * @param iconInfos 返回给主线程的图标资源集合
   * @param bmsRes bms图标资源信息
   * @param res hds图标资源信息
   */
  public static handleInfos(iconInfos: IconInfo[], bmsRes: bundleResourceManager.LauncherAbilityResourceInfo[]): void {
    if (CheckEmptyUtils.isEmptyArr(iconInfos)) {
      log.showError(TAG, 'iconInfos is empty in handleInfos');
      return;
    }
    // iconInfos.forEach((info: IconInfo) => {
    //   let tmp: hdsDrawable.ProcessedIcon = res.find((hdsIcon: hdsDrawable.ProcessedIcon) => {
    //     // dh应用在hds中处理需要添加后缀,所以此处比对时需要使用处理后的bundleName
    //     return hdsIcon.bundleName === info.param.bundleName;
    //   });
    //   PixelMapUtil.addName(tmp.pixelMap, 'getHdsIcon_'.concat(info.bundleName));
    //   info.combinePicSrc = tmp.pixelMap;
    // });
    // iconInfos.filter((info: IconInfo) => {
    //   return info.iconType === IconPicType.ADAPTIVE;
    // }).forEach((info: IconInfo) => {
    //   let bmsInfo = bmsRes.find(resourceInfo => {
    //     return info.bundleName === resourceInfo.bundleName && resourceInfo.abilityName !== CONTACT_ABILITY_NAME;
    //   });
    //   if (!bmsInfo) {
    //     log.showWarn(TAG, 'handleInfos not find info in bmsRes, bundleName: %{public}s, abilityName: %{public}s',
    //       info.bundleName, info.abilityName);
    //     return;
    //   }
    //   // 子线程返回主线程时需将自身与底层的链接断开,避免主线程中release掉资源不会及时释放内存
    //   let layerImageDescriptor: LayeredDrawableDescriptor = bmsInfo.drawableDescriptor as LayeredDrawableDescriptor;
    //   let back: image.PixelMap = layerImageDescriptor.getBackground().getPixelMap();
    //   let fore: image.PixelMap = layerImageDescriptor.getForeground().getPixelMap();
    //   back.setTransferDetached(true);
    //   fore.setTransferDetached(true);
    //   PixelMapUtil.addName(back, 'BmsIcon_back_'.concat(info.bundleName));
    //   PixelMapUtil.addName(fore, 'BmsIcon_fore_'.concat(info.bundleName));
    //   info.adaptivePicSrc = [back, fore];
    // });
  }

  public static async handleInsertIconInfos(insertIconInfos: rdb.ValuesBucket[],
    childTaskInfos: IconInfo[]): Promise<void> {
    if (CheckEmptyUtils.isEmptyArr(childTaskInfos)) {
      log.showError(TAG, 'childTaskInfos is empty in handleInsertIconInfos');
      return;
    }
    for (let iconInfo of childTaskInfos) {
      let bundleInfo: bundleManager.BundleInfo =
        await commonBundleManager.getBundleInfoByBundleName(iconInfo.bundleName);
      let appVersion = bundleInfo?.versionName;
      let combinePic: string = await GraphicUtils.changePixelToBase64(iconInfo.combinePicSrc);
      let backPic: string = iconInfo.iconType === IconPicType.ADAPTIVE ?
        await GraphicUtils.changePixelToBase64(iconInfo.adaptivePicSrc[BACK_PICTURE_INDEX]) : '';
      iconInfo.adaptivePicSrc[BACK_PICTURE_INDEX]?.release();
      let forePic: string = iconInfo.iconType === IconPicType.ADAPTIVE ?
        await GraphicUtils.changePixelToBase64(iconInfo.adaptivePicSrc[FORE_PICTURE_INDEX]) : '';
      iconInfo.adaptivePicSrc[FORE_PICTURE_INDEX]?.release();
      let insertIconInfo: rdb.ValuesBucket = {
        [IconDatabaseColumn.BUNDLE_NAME]: iconInfo.bundleName,
        [IconDatabaseColumn.MODULE_NAME]: iconInfo.moduleName ?? '',
        [IconDatabaseColumn.ABILITY_NAME]: iconInfo.abilityName ?? '',
        [IconDatabaseColumn.ICON_TYPE]: iconInfo.iconType,
        [IconDatabaseColumn.FORE_PIC]: forePic ?? '',
        [IconDatabaseColumn.BACK_PIC]: backPic ?? '',
        [IconDatabaseColumn.COMBINE_PIC]: combinePic ?? '',
        [IconDatabaseColumn.APP_VERSION]: appVersion ?? '',
      };
      insertIconInfos.push(insertIconInfo);
    }
  }
}

export interface Icon {
  /**
   * Indicates the bundle name of the application.
   *
   * @type { string }
   * @syscap SystemCapability.UIDesign.Core
   * @atomicservice
   * @since 5.0.0(12)
   */
  bundleName: string;
  /**
   * Icon pixelMap.
   *
   * @type { image.PixelMap }
   * @syscap SystemCapability.UIDesign.Core
   * @atomicservice
   * @since 5.0.0(12)
   */
  pixelMap: image.PixelMap;
}