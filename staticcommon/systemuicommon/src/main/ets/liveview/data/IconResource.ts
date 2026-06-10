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
import { image } from '@kit.ImageKit';
// import { CommonUtils, LogDomain, LogHelper, MemoryUtils } from '@ohos/basicutils';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import type { Context } from '@kit.AbilityKit';

import { resourceManager } from '@kit.LocalizationKit';
import { taskpool } from '@kit.ArkTS';
import { parseIconRes } from './IconResourceParse';
import application from '@ohos.app.ability.application';
import { baseStateMgr, DarkModeState, IState, StateType } from '@ohos/systemuiutils';

const ICON_RES_BUNDLE_SEPARATOR = '#';

const TAG = 'IconResourceParser';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class BaseIconResource {
  /**
   * 图标对应resource
   */
  iconResource: Resource;

  /**
   * 图标对应pixelMap
   */
  icon?: image.PixelMap;

  constructor(iconResource: Resource) {
    this.iconResource = iconResource;
  }
}

/**
 * 图标资源类
 */
export class IconResource extends BaseIconResource {
  /**
   * 所有图标资源实例，bundleName#资源id: 图标资源类实例
   */
  static iconResMap: Map<string, IconResource> = new Map();

  /**
   * 实况卡片按钮资源更新器，深浅色切换后强制刷新卡片按钮数据 key值：hashcode#useScene value: 更新函数
   */
  static buttonDataUpdaters: Map<string, () => void> = new Map();

  /**
   * 单个资源实例绑定的更新器， hashCode:更新函数
   */
  updater: Map<string, (icon?: image.PixelMap) => void> = new Map();

  public static init(): void {
    baseStateMgr.registerStateChangeListener(StateType.TYPE_DARK_MODE, {
      onStateChange: (state: IState) => {
        if (state instanceof DarkModeState) {
          log.showInfo(`DarkModeStateChange = ${state.isDarkMode}`);
          this.reParseIcon();
        }
      }
    });
  }

  /**
   * 获取图标资源实例
   *
   * @param iconResource 资源
   * @param hashCode 卡片hashCode
   * @param updater 更新器
   * @returns 资源实例
   */
  public static get(iconResource: Resource, hashCode: string): IconResource {
    const key: string = iconResource.bundleName + ICON_RES_BUNDLE_SEPARATOR + iconResource.id;
    let instance: IconResource = IconResource.iconResMap.get(key);
    log.showInfo(`getInstance: ${key}, hash: ${hashCode} instance: ${CommonUtils.isInvalid(instance)}`);
    if (!instance) {
      instance = new IconResource(iconResource);
      IconResource.iconResMap.set(key, instance);
    }
    return instance;
  }

  /**
   * 删除卡片所有的图标更新器绑定
   *
   * @param hashCode 卡片hashCode
   */
  public static delete(hashCode: string): void {
    log.showInfo(`delete iconResource for ${hashCode}`);
    const needDeleteList: string[] = [];
    IconResource.iconResMap.forEach((iconRes, key) => {
      iconRes.updater.delete(hashCode);
      if (iconRes.updater.size === 0) {
        iconRes.icon?.release();
        needDeleteList.push(key);
      }
    });
    needDeleteList.forEach(key => {
      IconResource.iconResMap.delete(key);
    });
  }

  /**
   * 解析图标资源
   *
   * @param contextOrResMgr 上下文或resMgr
   * @param iconResInstances 资源实例
   * @returns 处理后的实例
   */
  public static async parse(contextOrResMgr: Context | resourceManager.ResourceManager,
    iconResInstances: BaseIconResource[]): Promise<BaseIconResource[]> {
    if (iconResInstances.length <= 0) {
      return iconResInstances;
    }
    let needParseMap: Map<string, BaseIconResource[]> = new Map();
    iconResInstances.forEach(ins => {
      let iconRes = needParseMap.get(ins.iconResource.bundleName);
      if (!iconRes) {
        iconRes = [];
        needParseMap.set(ins.iconResource.bundleName, iconRes);
      }
      iconRes.push(ins);
    });
    const parsePromise = [];
    needParseMap.forEach((iconResource, bundleName) => {
      parsePromise.push(this.parseIcons(contextOrResMgr, iconResource, bundleName));
    });
    await Promise.all(parsePromise);
    log.showInfo(`parseIconRes end`);
    return iconResInstances;
  }

  /**
   * 处理解析结果，回填图标资源实例
   *
   * @param iconParseResult 图标解析结果
   * @returns
   */
  public static async handleResult(iconParseResult: BaseIconResource[]): Promise<void> {
    log.showInfo(`handleResult begin, length: ${iconParseResult?.length}`);
    iconParseResult.forEach(iconResult => {
      if (!iconResult.icon) {
        log.showInfo(`iconResult.icon null, id: ${iconResult.iconResource.id}`);
        return;
      }
      const key: string = iconResult.iconResource.bundleName + ICON_RES_BUNDLE_SEPARATOR + iconResult.iconResource.id;
      const instance = IconResource.iconResMap.get(key);
      if (!instance) {
        log.showInfo(`IconResource.iconResMap.get result is  null, key: ${key}`);
        return;
      }
      instance.icon?.release();
      instance.icon = iconResult.icon;
      log.showInfo(`instance.icon bytesNumber: ${instance.icon.getPixelBytesNumber()}`);
      instance.updater.forEach((updater) => {
        updater(iconResult.icon);
      });
    });
    this.buttonDataUpdaters?.forEach((updater: () => void) => {
      updater?.();
    });
  }

  private static async parseIcons(contextOrResMgr: Context | resourceManager.ResourceManager,
    iconResInstances: BaseIconResource[], bundleName: string): Promise<void> {
    let needFree: boolean = false;
    let resManager: resourceManager.ResourceManager;
    try {
      if (Reflect.has(contextOrResMgr, 'createBundleContext')) {
        let bundleContext = await application.createBundleContext(contextOrResMgr as Context, bundleName);
        resManager = bundleContext?.resourceManager;
        needFree = true;
      } else {
        resManager = contextOrResMgr as resourceManager.ResourceManager;
      }
      for (let instance of iconResInstances) {
        try {
          let drawable = resManager.getDrawableDescriptor(instance.iconResource.id);
          instance.icon = drawable?.getPixelMap();
          log.showInfo(`parseOneResIcon id: ${instance.iconResource.id} bytesNumber: ${instance.icon.getPixelBytesNumber()}`);
        } catch (e) {
          log.error(`parseOneResIcon id: ${instance.iconResource.id} failed: ${e?.message}`);
        }
      }
    } catch (err) {
      log.showError(`parseIcon for ${bundleName} failed, err: ${err?.message}`);
    }
    if (needFree && resManager) {
      try {
        log.showInfo(`removeNapiWrap`);
        // MemoryUtils.removeNapiWrap(resManager, false);
      } catch (err) {
        log.error(`removeNapiWrap resManager failed: ${err?.message}`);
      }
    }
  }

  private static async reParseIcon(): Promise<void> {
    log.showInfo(`handleIconResourceParse`);
    const context = GlobalContext.getContext();
    let result: BaseIconResource[] = [];
    IconResource.iconResMap.forEach((res) => {
      result.push(new BaseIconResource(res.iconResource));
    });
    const iconParseResult =
      await taskpool.execute(parseIconRes, context,
        result) as BaseIconResource[];
    IconResource.handleResult(iconParseResult);
  }
}

