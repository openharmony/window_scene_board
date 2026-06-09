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
import bundleManager from '@ohos.bundle.bundleManager';
import { LogDomain, LogHelper, CheckEmptyUtils, CommonUtils } from '@ohos/basicutils';
import { IconCacheFwkInterface } from '../IconCacheFwkInterface';
import IconInfo, { IconPicType } from '../IconInfo';
import resourceManager from '@ohos.resourceManager';
import { GraphicUtils } from '../GraphicsUtils';
import image from '@ohos.multimedia.image';
import { DrawableDescriptor, LayeredDrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import { GlobalContext } from '../../utils/GlobalContext';
import type ctx from '@ohos.app.ability.common';
import commonBundleManager from '../../manager/CommonBundleManager';
import { AppIconIdLoader } from '../AppIconIdLoader';
import { BundleManagerFwk } from './BundleManagerFwk';
import { IconExtendParam } from '../IconExtendParam';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'ResourceManagerFwk';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const RETRY_INTERVAL: number = 100;
const DEFAULT_MODULE_NAME: string = 'entry';
const INVALID_ICON_ID: number = 0;

/**
 * getDrawableDescriptor接口中传入1，表示获取主题资源包中应用的分层图标资源
 */
const TYPE_GET_DESCRIPTOR_THEME = 1;

/**
 * getDrawableDescriptor接口中传入0，表示获取应用自身图标资源
 */
const TYPE_GET_DESCRIPTOR_APP = 0;

export class ResourceManagerFwk implements IconCacheFwkInterface {
  private appIconIdLoader: AppIconIdLoader | undefined = undefined;
  private static sInstance: ResourceManagerFwk;
  static getInstance(): ResourceManagerFwk {
    if (!ResourceManagerFwk.sInstance) {
      ResourceManagerFwk.sInstance = new ResourceManagerFwk();
    }
    return ResourceManagerFwk.sInstance;
  }

  refreshMaskImage(): void {
  }

  public setAppIconIdLoader(appIconIdLoader: AppIconIdLoader): void {
    this.appIconIdLoader = appIconIdLoader;
  }

  async getIconResourceFromFwk(param: IconExtendParam, bundleName: string, moduleName: string, abilityName: string):
      Promise<IconInfo> {
    log.showInfo(`getIconResourceFromFwk for ${bundleName} ${moduleName} ${abilityName} begin`);
    let iconInfo: IconInfo = new IconInfo();
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      log.showInfo(`bundleName empty`);
      return iconInfo;
    }

    iconInfo = await this.getIconResourceFromFwkInner(param, bundleName, moduleName, abilityName, true);
    log.showInfo(`getIconResourceFromFwk for ${bundleName} ${moduleName} ${abilityName} end`);
    return iconInfo;
  }

  async getIconResourceFromFwkNoDynamic(bundleName: string, moduleName: string,
    abilityName: string): Promise<IconInfo> {
    log.showInfo(`getIconResourceFromFwkNoDynamic for ${bundleName} ${moduleName} ${abilityName} begin`);
    let iconInfo: IconInfo =
      await this.getIconResourceFromFwkInner(new IconExtendParam(), bundleName, moduleName, abilityName, false);
    log.showInfo(`getIconResourceFromFwkNoDynamic for ${bundleName} ${moduleName} ${abilityName} end`);
    return iconInfo;
  }

  async getIconResourceFromFwkInner(param: IconExtendParam, bundleName: string, moduleName: string, abilityName: string,
     isCheckDynamic: boolean): Promise<IconInfo> {
    log.showInfo(`getIconResourceFromFwkInner for ${bundleName}`);
    let iconInfo: IconInfo = new IconInfo();
    if (isCheckDynamic) {
      let dynamicModuleName: string = await this.getDynamicIcon(bundleName);
      if (!CheckEmptyUtils.isEmpty(dynamicModuleName)) {
        return await BundleManagerFwk.getInstance().getIconResourceFromFwk(param, bundleName, moduleName, abilityName);
      }
    }
    let iconId: number = await this.getIconId(bundleName, moduleName, abilityName);
    try {
      if (CheckEmptyUtils.isEmpty(moduleName)) {
        moduleName = DEFAULT_MODULE_NAME;
      }
      let resMgr: resourceManager.ResourceManager = (GlobalContext.getInstance().getObject('desktopContext') as
      ctx.ServiceExtensionContext).createModuleResourceManager(bundleName, moduleName);
      await this.getAccountSAState();
      let imageDescriptor: DrawableDescriptor = (resMgr.getDrawableDescriptor(Number(iconId), undefined,
          param.isNeedAbilityIcon ? TYPE_GET_DESCRIPTOR_APP : TYPE_GET_DESCRIPTOR_THEME));
      // MemoryUtils.removeNapiWrap(resMgr, false);
      if (CheckEmptyUtils.isEmpty(imageDescriptor)) {
        return iconInfo;
      }
      let value: image.PixelMap = imageDescriptor.getPixelMap();
      iconInfo.combinePicSrc = value;
      iconInfo.combinePic = await GraphicUtils.changePixelToBase64Child(value);
      if (imageDescriptor instanceof LayeredDrawableDescriptor) {
        log.showInfo(`getAppInfoFromResource LayeredDrawableDescriptor`);
        let layerImageDescriptor: LayeredDrawableDescriptor = imageDescriptor as LayeredDrawableDescriptor;
        let Background = layerImageDescriptor.getBackground().getPixelMap();
        let Foreground = layerImageDescriptor.getForeground().getPixelMap();
        if (Background !== null && Foreground !== null) {
          let fore: string = await GraphicUtils.changePixelToBase64Child(Foreground);
          let back: string = await GraphicUtils.changePixelToBase64Child(Background);
          iconInfo.adaptivePic = [back, fore];
          iconInfo.iconType = IconPicType.ADAPTIVE;
          await Background.release();
          await Foreground.release();
        }
      } else {
        iconInfo.iconType = IconPicType.NORMAL;
      }
    } catch (error) {
      log.showError(`error ${error}`);
    }
    return iconInfo;
  }

  /*
  通过包管理获取到iconid；
   */
  private async getIconId(bundleName: string, moduleName: string, abilityName: string): Promise<number> {
    if (!CheckEmptyUtils.isEmpty(abilityName)) {
      if (this.appIconIdLoader) {
        let iconId = this.appIconIdLoader.getAppItemIconId(bundleName, moduleName, abilityName);
        if (iconId !== INVALID_ICON_ID) {
          return iconId;
        } else {
          log.showInfo(`bundleName: ${bundleName}, appIconIdLoader iconId invalid`);
        }
      }
      log.showInfo(`bundleName: ${bundleName}, iconId from BMS`);
      let abilityInfo: bundleManager.AbilityInfo =
        await commonBundleManager.getAbilityInfoByAbilityName(bundleName, abilityName);
      return abilityInfo?.iconId === 0 ? abilityInfo.applicationInfo.iconId as number : abilityInfo?.iconId as number;
    }
    let bundleInfo: bundleManager.BundleInfo | undefined =
      await commonBundleManager.getBundleInfoByBundleName(bundleName);
    let hapModulesInfo = bundleInfo?.hapModulesInfo?.filter(moduleInfo => moduleInfo.name === moduleName);
    if (CommonUtils.containerIsEmpty(hapModulesInfo)) {
      log.showInfo(`bundleName: ${bundleName}, moduleName: ${moduleName} moduleInfo empty`);
      return bundleInfo?.appInfo?.iconId as number;
    }
    return hapModulesInfo === undefined ? INVALID_ICON_ID : hapModulesInfo[0]?.iconId as number;
  }

  /*
  查看是否是备份图标
  */
  async getDynamicIcon(bundleName: string): Promise<string> {
    let dynamicModuleName: string = '';
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      log.showInfo(`bundleName empty`);
      return dynamicModuleName;
    }
    try {
      await bundleManager.getDynamicIcon(bundleName).then((moduleName: string) => {
        log.showDebug(`getDynamicIcon moduleName: ${moduleName}`);
        dynamicModuleName = moduleName;
      })
        .catch((err: BusinessError) => {
          log.showError(`getDynamicIcon failed with error message: ${err.message} error code: ${err.code}`);
        });
    } catch (error) {
      log.error('getDynamicIcon failed try error:', error);
    }
    return dynamicModuleName;
  }

  async getAccountSAState(): Promise<boolean> {
    return new Promise((resolve) => {
      if (AppStorage.get('accountSAReady')) {
        resolve(true);
        return;
      }
      let timer: number = setInterval(() => {
        log.showInfo('getAccountSAState');
        if (AppStorage.get('accountSAReady')) {
          clearInterval(timer);
          resolve(true);
        }
      }, RETRY_INTERVAL);
    });
  }
}

export const resourceManagerFwk = ResourceManagerFwk.getInstance();