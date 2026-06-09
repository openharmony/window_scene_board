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

import type { BusinessError } from '@ohos.base';
import bundle from '@ohos.bundle.bundleManager';
import type common from '@ohos.app.ability.common';
import type resourceManager from '@ohos.resourceManager';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'ExternalMenuManager';
const EXTERNAL_MENU_ACTION_V1 = 'action.external.menu.v1';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

/**
 * 外部菜单数据类
 */
export class ExternalMenu {
  public bundleName: string = '';
  public abilityName: string = '';
  public key: string = '';
  public menuType: string = '';
  public showCondition: string = '';
  public titleResource: string = '';
  public title: string = '';
  public state: string = '';
  public iconResource: string = '';
  public icon: string = '';
  public summaryResource: string = '';
  public summary: string = '';
  public stateDbKey: string = '';
  public stateDefault: string = '';
  public switchDbKey: string = '';
  public switchDefault: string = '';
  public accessTokenId?: number;

  constructor(menu: ExternalMenu) {
    if (!menu) {
      return;
    }

    this.key = menu.key;
    this.menuType = menu.menuType;
    this.showCondition = menu.showCondition;
    this.titleResource = menu.titleResource;
    this.iconResource = menu.iconResource;
    this.summaryResource = menu.summaryResource;
    this.stateDbKey = menu.stateDbKey;
    this.stateDefault = menu.stateDefault;
    this.switchDbKey = menu.switchDbKey;
    this.switchDefault = menu.switchDefault;
  }

  /**
   * 加载标题资源
   * @param resourceManager 当前的resourceManager
   * @returns title名称
   */
  loadTitleResource(resourceManager: resourceManager.ResourceManager | null): string {
    log.info(`${TAG} loadTitleResource: ${this.titleResource}`);
    if (!this.titleResource || this.titleResource === '' || !resourceManager) {
      return '';
    }

    try {
      this.title = resourceManager.getStringByNameSync(this.titleResource);
    } catch (err) {
      log.error(`${TAG} get title failed ${err?.message}`);
    }

    return this.title;
  }

  /**
   * 加载标题资源
   * @param 当前的resourceManager
   * @returns title名称
   */
  loadTitleResourceNew(resourceManager: resourceManager.ResourceManager | null): string {
    log.info(`${TAG} loadTitleResource: ${this.titleResource}`);
    if (!this.titleResource || !resourceManager) {
      return '';
    }

    try {
      this.title = resourceManager.getStringByNameSync(this.titleResource);
    } catch (err) {
      log.error(`${TAG} get title failed ${err.message}`);
    }

    return this.title;
  }

  /**
   * 加载辅助文本资源
   * @param resourceManager
   * @returns 返回summary
   */
  loadSummaryResourceNew(resourceManager: resourceManager.ResourceManager | null): string {
    log.info(`${TAG} loadSummaryResource: ${this.summaryResource}`);
    if (!this.summaryResource || this.summaryResource === '' || !resourceManager) {
      return '';
    }

    try {
      this.summary = resourceManager.getStringByNameSync(this.summaryResource);
    } catch (err) {
      log.error(`${TAG} get summary failed ${err?.message}`);
    }

    return this.summary;
  }

  /**
   * 加载辅助文本资源
   * @param resourceManager
   * @returns summary
   */
  loadSummaryResource(resourceManager: resourceManager.ResourceManager | null): string {
    log.info(`${TAG} loadSummaryResource: ${this.summaryResource}`);
    if (!this.summaryResource || this.summaryResource === '' || !resourceManager) {
      return '';
    }

    try {
      this.summary = resourceManager.getStringByNameSync(this.summaryResource);
    } catch (err) {
      log.error(`${TAG} get summary failed ${err?.message}`);
    }

    return this.summary;
  }

  /**
   * 加载图标资源
   * @param bundleName
   * @returns Base64字符串
   */
  loadIconResource(bundleName: string): string | null {
    log.info(`${TAG} loadIconResource: ${this.iconResource}`);
    if (!this.iconResource || this.iconResource === '') {
      return null;
    }

    let resourceManager = this.getBundleResourceManager(bundleName);
    if (!resourceManager) {
      return '';
    }

    try {
      this.icon = resourceManager.getMediaBase64ByNameSync(this.iconResource);
    } catch (err) {
      log.error(`${TAG} get icon failed ${err?.message}`);
    }
    return this.icon;
  }

  /**
   * 获取bundleResourceManager
   * @param bundleName bundleName信息
   * @returns bundleResourceManager
   */
  getBundleResourceManager(bundleName: string): resourceManager.ResourceManager | null {
    let resManager: resourceManager.ResourceManager | null = null;
    try {
      let context: common.UIAbilityContext =
        AppStorage.get<common.UIAbilityContext>('pageContext') as common.UIAbilityContext;
      let bundleContext: Context = context?.createBundleContext(bundleName);
      resManager = bundleContext ? bundleContext.resourceManager : null;
    } catch (err) {
      log.error(`${TAG} get resource manager failed: ${err?.message}`);
    }

    return resManager;
  }
}

/**
 * 外部菜单数据变更监听接口
 */
export interface ExternalMenuChangeListener {
  /**
   * 获取 listener name
   * @returns listener name
   */
  getListenerName(): string;

  /**
   * 外部菜单数据变更回调
   */
  onExternalMenuChange(bundleName: string): void;

  /**
   * 外部菜单数据加载完成回调
   */
  onExternalMenuLoadFinish(): void;
}

/**
 * 语言变化时回调接口
 */
export interface LangChangeListener {
  /**
   * 语言变化回调事件
   */
  onLangChange(newLang: string): void;

  /**
   * 获取 listener name
   * @returns listener name
   */
  getListenerName(): string;
}

/**
 * 外部菜单数据管理类
 */
export class ExternalMenuManager {
  public listenerKey: string = 'external_menu_manager';
  public externalMenus: Map<string, Array<ExternalMenu>> = new Map();
  public grantExternalMenus: Map<string, ExternalMenu> = new Map();
  public bundleMenuKeys: Map<string, Array<string>> = new Map();
  public listeners: ExternalMenuChangeListener[] = [];
  public grantStatusMap: Map<string, boolean> = new Map();
  public queryFlag: number = bundle.AbilityFlag.GET_ABILITY_INFO_WITH_METADATA |
    bundle.AbilityFlag.GET_ABILITY_INFO_WITH_APPLICATION;
  public langChangeListeners: LangChangeListener[] = [];

  registerLangChangeListener(listener: LangChangeListener): void {
    if (!listener) {
      log.error(`${TAG} registerLangChangeListener invalid`);
      return;
    }

    for (const langChangeListener of this.langChangeListeners) {
      if (langChangeListener.getListenerName() === listener.getListenerName()) {
        log.info(`${TAG} registerLangChangeListener listener already register`);
        return;
      }
    }

    this.langChangeListeners.push(listener);
    log.info(`${TAG} push: ${listener.getListenerName()} size: ${this.langChangeListeners.length}`);
  }

  unregisterLangChangeListener(listener: LangChangeListener): void {
    if (!listener) {
      log.error(`${TAG} unregisterLangChangeListener invalid`);
      return;
    }

    for (let index = 0; index < this.langChangeListeners.length; index++) {
      if (this.langChangeListeners[index].getListenerName() === listener.getListenerName()) {
        log.info(`${TAG} unregisterLangChangeListener success: ${listener.getListenerName()}`);
        this.langChangeListeners.splice(index, 1);
        return;
      }
    }
  }

  /**
   * 语言变化时的回调，触发外部菜单的文本资源刷新
   *
   * @param newLang 新的语言
   * */
  public dispatchLangChangeEvent(newLang: string): void {
    log.info(`${TAG} dispatchLangChangeEvent`);
    for (let listener of this.langChangeListeners) {
      listener?.onLangChange(newLang);
    }
  }

  /**
   * 根据Key获取外部菜单数据
   * @param key
   * @returns ExternalMenu
   */
  async getExternalMenu(key: string): Promise<ExternalMenu | null | undefined> {
    log.info(`${TAG} getExternalMenu`);
    let menu = this.grantExternalMenus.get(key);
    return menu ?? this.updateGrantMenuList(this.externalMenus.get(key));
  }

  /**
   * 监听应用变更
   * @param listener 监听者
   */
  registerListener(listener: ExternalMenuChangeListener): void {
    if (!listener) {
      log.error(`${TAG} registerListener listener invalid`);
      return;
    }

    for (let index = 0; index < this.listeners.length; index++) {
      if (this.listeners[index].getListenerName() === listener.getListenerName()) {
        log.info(`${TAG} registerListener listener already register`);
        return;
      }
    }

    this.listeners.push(listener);
    log.info(`${TAG} listeners size: ${this.listeners.length}`);
  }

  /**
   * 取消监听应用变更
   * @param listener 监听者
   */
  unRegisterListener(listener: ExternalMenuChangeListener): void {
    if (!listener) {
      log.error(`${TAG} unRegisterListener listener invalid`);
      return;
    }

    for (let index = 0; index < this.listeners.length; index++) {
      if (this.listeners[index].getListenerName() === listener.getListenerName()) {
        this.listeners.splice(index, 1);
        return;
      }
    }
  }

  /**
   * 开始加载外部应用菜单数据
   */
  async startLoad(errCallBack?: (err: BusinessError) => void): Promise<void> {
    log.info(`${TAG} startLoad`);
    try {
      await bundle.queryAbilityInfo({
        action: EXTERNAL_MENU_ACTION_V1
      }, this.queryFlag).then((infos: Array<bundle.AbilityInfo>) => {
        log.info(`${TAG} queryAbilityInfo in`);
        this.updateAbilityInfos(infos).then(() => {
          log.info(`${TAG} updateGrantStatus`);
          this.updateGrantStatus();
          this.dispatchExternalMenuLoadFinish();
        });
      });
    } catch (err) {
      log.showError(`startLoad err: ${err?.message}`);
    }
  }

  private dispatchExternalMenuLoadFinish(): void {
    log.info(`${TAG} dispatchExternalMenuLoadFinish`);
    for (let listener of this.listeners) {
      listener?.onExternalMenuLoadFinish();
    }
  }

  private clearCache(): void {
    this.externalMenus.clear();
    this.grantExternalMenus.clear();
    this.grantStatusMap.clear();
    this.bundleMenuKeys.clear();
  }

  private async updateAbilityInfos(infos: Array<bundle.AbilityInfo>): Promise<void> {
    if (!infos) {
      log.info(`${TAG} updateAbilityInfos infos invalid`);
      this.clearCache();
      return;
    }
  }

  private addMapMenu(menus: Map<string, Array<ExternalMenu>>, menu: ExternalMenu): void {
    let keyMenus: Array<ExternalMenu> | undefined = menus.get(menu.key);
    if (!keyMenus) {
      keyMenus = [];
    }

    keyMenus.push(menu);
    menus.set(menu.key, keyMenus);
  }

  private addBundleMenuKey(menu: ExternalMenu): void {
    let keys: Array<string> | undefined = this.bundleMenuKeys.get(menu.bundleName);
    if (!keys) {
      keys = [];
      this.bundleMenuKeys.set(menu.bundleName, keys);
    }
    keys.push(menu.key);
  }

  private async updateGrantStatus(): Promise<void> {
    for (let value of this.externalMenus.values()) {
      let grantExternalMenus = this.grantExternalMenus;
      this.updateGrantMenuList(value)?.then((grantMenu) => {
        if (grantMenu) {
          grantExternalMenus.set(grantMenu.key, grantMenu);
        }
      });
    }
  }

  private async updateGrantMenuList(list: Array<ExternalMenu> | undefined): Promise<ExternalMenu | null | undefined> {
    if (!list || CheckEmptyUtils.isEmptyArr(list)) {
      log.error(`${TAG} updateGrantMenuList invalid`);
      return null;
    }

    for (let menu of list) {
      let isGrant = true;
      if (isGrant) {
        return menu;
      }
    }

    return null;
  }
}