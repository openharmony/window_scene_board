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

import ResourceManager from '@ohos.resourceManager';
import Common from '@ohos.app.ability.common';
import BundleMgr from '@ohos.bundle';
import { SingletonHelper } from '@ohos/basicutils';
import { CommonUtils } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EvtBus } from '@ohos/frameworkwrapper';
import { AccountMgr } from '@ohos/frameworkwrapper';
import { ConfigurationEvent } from '@ohos/frameworkwrapper';
import type { DrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import { SCBConstants } from '@ohos/commonconstants';
import { DisplayMgr } from './DisplayManager';
import { IResProxyIf, ResUtilProxy } from '@ohos/frameworkwrapper/src/main/ets/utils/ResUtilProxy';

const TAG = 'ResourceUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 默认DPI值
 */
const DEFAULT_DPI = 160;

/**
 * 栅格空隙，vp
 */
const GRID_ROW_GUTTER = 12;

/**
 * context等待类型
 */
type ContextResolve = (context: Common.Context | PromiseLike<Common.Context>) => void;

/**
 * 获取资源信息工具
 *
 * @since 2022-10-31
 */
class ResourceUtils implements IResProxyIf {
  /**
   * 环境
   */
  private appContext: Common.Context;

  /**
   * 模块context集
   */
  private moduleContexts: Map<string, Common.Context> = new Map();

  /**
   * 包context集
   */
  private bundleContexts: Map<string, Common.Context> = new Map();

  /**
   * context等待集
   */
  private contextResolves: Set<ContextResolve> = new Set();

  /**
   * 默认屏幕宽度和实际屏幕宽度比值
   */
  private rate: number = 1;

  /**
   * 系统语言
   */
  private systemLanguage: string = '';

  constructor() {
    ResUtilProxy.setInstance(this);
  }

  /**
   * 初始化
   *
   * @param context 环境
   */
  init(context: Common.Context): void {
    this.appContext = context;
    EvtBus.on(ConfigurationEvent, event => {
      this.onConfigurationEvent(event);
    });
  }

  /**
   * 横屏时获取6个栅格的宽度
   *
   * @param landScreenWidth 屏幕宽度
   * @return 6个栅格宽度， px
   */
  getLandGridRowWidth(landScreenWidth: number): number {
    let gutter = this.vp2px(GRID_ROW_GUTTER);
    // 总共8个栅格
    let aveWidth = (landScreenWidth - gutter * 9) / 8;
    // 取6个栅格，有5个空隙
    return aveWidth * 6 + gutter * 5;
  }

  /**
   * 横屏时获取4个栅格的宽度(横屏弹框宽度)
   *
   * @param landScreenWidth 屏幕宽度(未去margin)
   * @return 4个栅格宽度，单位：px
   */
  getLandBoxGridRowWidth(landScreenWidth: number): number {
    let gutter = this.vp2px(GRID_ROW_GUTTER);
    // 总共8个栅格
    let aveWidth = (landScreenWidth - gutter * 9) / 8;
    // 取4个栅格，有3个空隙
    return aveWidth * 4 + gutter * 3;
  }

  /**
   * 横屏时获取8个栅格的宽度(总共12个栅格)
   *
   * @param landScreenWidth 屏幕宽度
   * @return 8个栅格宽度， px
   */
  getLandPadGridRowWidth(landScreenWidth: number): number {
    let gutter = this.vp2px(GRID_ROW_GUTTER);
    // 总共12个栅格
    let aveWidth = (landScreenWidth - gutter * 13) / 12;
    // 取8个栅格，有7个空隙
    return aveWidth * 8 + gutter * 7;
  }

  /**
   * 横屏时时间日期在开始方向布局获取5个栅格的宽度(总共8个栅格)
   *
   * @param landScreenWidth 屏幕宽度
   * @return 5个栅格宽度， px
   */
  getTimeStartWidthByLandScreenWidth(landScreenWidth: number): number {
    let aveWidth = landScreenWidth / 8;
    // 取5个栅格
    return aveWidth * 5;
  }

  /**
   * 横屏时获取4个栅格的宽度(总共4个栅格)
   *
   * @param landScreenWidth 屏幕宽度
   * @return 4个栅格宽度， px
   */
  getLandPhoneGridRowWidth(landScreenWidth: number): number {
    let gutter = this.vp2px(GRID_ROW_GUTTER);
    // 总共4个栅格
    let aveWidth = (landScreenWidth - gutter * 5) / 4;
    // 取4个栅格，有3个空隙
    return aveWidth * 4 + gutter * 3;
  }

  /**
   * 根据屏幕宽度获取对应栅格化宽度
   * @param landScreenWidth 屏幕宽度
   * @returns 栅格化宽度，px
   */
  getWidthByLandScreenWidth(landScreenWidth: number): number {
    if (this.px2vp(landScreenWidth) >= 840) {
      // 12栅格 宽度：8
      return this.getLandPadGridRowWidth(landScreenWidth);
    } else if (this.px2vp(landScreenWidth) >= 520) {
      // 8栅格 宽度：6
      return this.getLandGridRowWidth(landScreenWidth);
    } else {
      // 4栅格 宽度：4
      return this.getLandPhoneGridRowWidth(landScreenWidth);
    }
  }

  /**
   * 获取ScreenDensity
   *
   * @param
  * @return Promise<number>
   */
  async getDeviceScreenDensity(): Promise<number> {
    return (await this.appContext.resourceManager.getDeviceCapability()).screenDensity;
  }

  /**
   * 应用内字串获取
   *
   * @param resource 资源信息
   * @return 字串
   */
  getInnerString(resource: ResourceManager.Resource): string {
    if (CommonUtils.isInvalid(resource)) {
      return null;
    }
    let result: string = '';
    try {
      result = this.getModuleContext(resource.moduleName)?.resourceManager?.getStringSync(resource.id);
    } catch (err) {
      log.showError(`getInnerString failed,bundleName:${resource.bundleName},moduleName:${resource.moduleName},error:`, err);
    }
    return result;
  }

  /**
   * 应用内含有变量的非复数字串获取
   *
   * @param resource 资源信息
   * @param count 变量
   * @return 字串
   */
  async getInnerStringNum(resource: ResourceManager.Resource, count: number | string): Promise<string> {
    if (CommonUtils.isInvalid(resource) || CommonUtils.isInvalid(count)) {
      return '';
    }
    return this.getModuleContext(resource.moduleName)?.resourceManager?.getStringSync(resource.id, count);
  }

  /**
   * 应用内含有变量的非复数字串同步获取
   *
   * @param resource 资源信息
   * @param count 变量
   * @return 字串
   */
  getInnerStringNumS(resource: ResourceManager.Resource, ...count: (string | number)[]): string {
    if (CommonUtils.isInvalid(resource)) {
      return null;
    }
    for (let i = 0; i < count.length; i++) {
      if (CommonUtils.isInvalid(count[i])) {
        return null;
      }
    }
    let outString: string = null;
    try {
      outString = this.getModuleContext(resource.moduleName)?.resourceManager?.getStringSync(resource.id, ...count);
    } catch (err) {
      log.showError('getInnerStringNumS error', err);
    }
    return outString;
  }

  /**
   * 获取三方应用字串
   *
   * @param res 三方资源信息
   * @return 字串
   */
  getOutString(res: ResourceManager.Resource): string {
    if (CommonUtils.isInvalid(res)) {
      return null;
    }
    let outString: string = null;
    try {
      outString = this.appContext?.resourceManager?.getStringSync(res);
    } catch (err) {
      log.error('getOutString error:', err);
    }
    return outString;
  }

  /**
   * 通过labelId获取应用名称字串
   *
   * @param res 三方资源信息
   * @return 应用字串
   */
  async getDeliverOutStringById(labelId: number, bundleName: string): Promise<string> {
    if (CommonUtils.isInvalid(labelId)) {
      return null;
    }
    let outString: string = null;
    try {
      const resMgr = await this.getResMgr(bundleName);
      outString = resMgr.getStringSync(labelId);
    } catch (error) {
      log.showError('Get deliver getDeliverOutString for [%{public}s] error by [%{public}s]', bundleName, error.message);
      return null;
    }
    return outString;
  }

  /**
   * 应用内字串获取通过资源名
   *
   * @param resName 资源名
   * @return 字串
   */
  getInnerStringByName(resName: string): string {
    if (CommonUtils.isInvalid(resName)) {
      return null;
    }
    try {
      return this.appContext?.resourceManager?.getStringByNameSync(resName);
    } catch (e) {
      log.showError(`getInnerStringByName error, code: ${e?.code}, msg: ${e?.message}`);
      return null;
  }
  }

  /**
   * 获取三方应用字串通过资源名
   *
   * @param resName 资源名
   * @param bundleName 包名
   * @return 字串
   */
  async getOutStringByName(resName: string, bundleName?: string): Promise<string> {
    if (CommonUtils.isEmpty(resName)) {
      return null;
    }
    return new Promise((resolve) => {
      this.getResMgr(bundleName).then((resMgr) => {
        resolve(this.getResStringByName(resMgr, resName));
      });
    });
  }

  private getResStringByName(resMgr: ResourceManager.ResourceManager, resName: string): string {
    let str: string = '';
    try {
      str = resMgr.getStringByNameSync(resName);
    } catch (e) {
      log.showError(`getStringByNameSync error, resName: ${resName}, code: ${(e as Error)?.message}`);
    }
    return str;
  }

  /**
   * 应用内获取复数字串
   *
   * @param resource 资源
   * @param count 复数值
   * @return 字串
   */
  async getInnerPlural(resource: ResourceManager.Resource, count: number): Promise<string> {
    if (CommonUtils.isInvalid(resource) || CommonUtils.isInvalid(count)) {
      return null;
    }
    let moduleName: string = resource.moduleName;
    return this.getModuleContext(moduleName)?.resourceManager?.getPluralStringValue(
      resource.id, count);
  }

  /**
   * get Inner Plural By Resource
   *
   * @param resource inner plural string
   * @param count count
   * @return string value
   */
  getInnerPluralByResource(resource: ResourceManager.Resource, count: number): string {
    if (CommonUtils.isInvalid(resource) || CommonUtils.isInvalid(count)) {
      return null;
    }
    let moduleName: string = resource.moduleName;
    return this.getModuleContext(moduleName)?.resourceManager?.getPluralStringValueSync(resource.id, count);
  }

  /**
   * vp转换px
   *
   * @param value vp值
   * @return px值
   */
  vp2px(value: number): number {
    let dis = DisplayMgr.getCacheDisplay();
    if (CommonUtils.isInvalid(dis)) {
      return value;
    }
    return value * (DEFAULT_DPI);
  }

  /**
   * px转换vp
   *
   * @param value px值
   * @return vp值
   */
  px2vp(value: number): number {
    let dis = DisplayMgr.getCacheDisplay();
    if (CommonUtils.isInvalid(dis)) {
      return value;
    }
    return value / (DEFAULT_DPI);
  }

  /**
   * mm转换vp
   *
   * @param value mm值
   * @return vp值
   */
  mm2vp(value: number): number {
    let dis = DisplayMgr.getCacheDisplay();
    if (CommonUtils.isInvalid(dis)) {
      return value;
    }

    return value / 25.4 * DEFAULT_DPI;
  }

  /**
   * 获取应用内资源数字
   *
   * @param resource 资源信息
   * @return 数字，单位px
   */
  getNumber(resource: ResourceManager.Resource): number {
    if (CommonUtils.isInvalid(resource)) {
      return 0;
    }
    if (CommonUtils.isInvalid(this.appContext)) {
      return 0;
    }
    if (CommonUtils.isEmpty(resource.bundleName) || CommonUtils.isEmpty(resource.moduleName)) {
      log.showWarn('getNumber bundleName or moduleName is invalid.');
      return 0;
    }
    let context = this.getModuleContext(resource.moduleName as string);
    if (context == null) {
      log.showWarn('getNumber getModuleContext is invalid.');
      return 0;
    }
    try {
      return context.resourceManager.getNumber(resource.id) as number;
    } catch (err) {
      log.showError(`getNumber failed,bundleName:${resource.bundleName},moduleName:${resource.moduleName},error:`, err);
      return 0;
    }
  }

  /**
   * 获取三方应用资源数字
   *
   * @param res 资源信息
   * @return 数字
   */
  getOutNumber(res: ResourceManager.Resource): number {
    if (CommonUtils.isInvalid(res)) {
      return 0;
    }
    return this.appContext?.resourceManager?.getNumber(res) ?? 0;
  }

  /**
   * 获取资源数字
   * 统一用vp，number默认按vp算
   *
   * @param value 资源信息
   * @return 数字，单位vp
   */
  getNumberFromLength(value: Length): number {
    if (CommonUtils.isInvalid(value)) {
      return 0;
    }
    // number按vp算
    if (CommonUtils.isNumber(value)) {
      return value as number;
    }
    if (CommonUtils.isString(value)) {
      let oriStr = value as string;
      // vp直接返回数字
      if (oriStr.endsWith('vp')) {
        let strPadding = oriStr.replace('vp', '');
        return Number.parseFloat(strPadding);
      }
      // px转vp返回
      if (oriStr.endsWith('px')) {
        let strPadding = oriStr.replace('px', '');
        return this.px2vp(Number.parseFloat(strPadding));
      }
      // 无单位，按vp算
      return Number.parseFloat(oriStr);
    }
    // 获取vp资源
    return this.getNumber(value as ResourceManager.Resource);
  }

  /**
   * 获取资源数字,px直接返回
   * 统一用vp，number默认按vp算
   *
   * @param value 资源信息
   * @return 数字，单位vp
   */
  getNumberFromLengthExceptPx(value: Length): number {
    if (CommonUtils.isInvalid(value)) {
      return 0;
    }
    // number按vp算
    if (CommonUtils.isNumber(value)) {
      return value as number;
    }
    if (CommonUtils.isString(value)) {
      let oriStr = value as string;
      // vp直接返回数字
      if (oriStr.endsWith('vp') || oriStr.endsWith('fp')) {
        let strPadding = oriStr.replace('vp', '');
        return Number.parseFloat(strPadding);
      }
      // 无单位，按vp算
      return Number.parseFloat(oriStr);
    }
    // 获取vp资源
    return this.getNumber(value as ResourceManager.Resource);
  }

  /**
   * 获取转化后的资源数字
   * 统一用vp，number默认按vp算
   *
   * @param value 资源信息
   * @return 数字，单位vp
   */
  getConvertNumber(value: Length): number {
    if (CommonUtils.isInvalid(value)) {
      return 0;
    }
    return this.getNumberFromLength(value) * this.rate;
  }

  /**
   * 清除模块Contexts
   */
  clearModuleContexts(): void {
    log.showInfo('clear module contexts!');
    for (let cxt of this.moduleContexts.values()) {
      // MemoryUtils.removeNapiWrap(cxt, false);
    }
    this.moduleContexts.clear();

    for (let cxt of this.bundleContexts.values()) {
      // MemoryUtils.removeNapiWrap(cxt, false);
    }
    this.bundleContexts.clear();
  }


  /**
   * 获取应用内资源颜色
   *
   * @param resource 资源信息
   * @return 十进制颜色
   */
  getColor(resource: ResourceManager.Resource): number {
    if (CommonUtils.isInvalid(resource)) {
      return -1;
    }
    if (CommonUtils.isInvalid(this.appContext)) {
      return -1;
    }
    if (CommonUtils.isEmpty(resource.bundleName) || CommonUtils.isEmpty(resource.moduleName)) {
      log.showWarn('getColor bundleName or moduleName is invalid.');
      return -1;
    }
    let context = this.getModuleContext(resource.moduleName as string);
    if (context == null) {
      log.showWarn('getColor getModuleContext is invalid.');
      return -1;
    }
    try {
      return context.resourceManager.getColorSync(resource.id);
    } catch (err) {
      log.error(`getColor failed,bundleName:${resource.bundleName},bundleName:${resource.moduleName},error:`, err);
      return -1;
    }
  }

  /**
   * 应用内获取图片资源
   *
   * @param resource 资源信息
   * @return base64字串
   */
  async getInnerMediaBase64(resource: ResourceManager.Resource): Promise<string> {
    if (CommonUtils.isInvalid(resource)) {
      return null;
    }
    return await this.getModuleContext(resource.moduleName)?.resourceManager?.getMediaContentBase64({
      bundleName: resource.bundleName,
      moduleName: resource.moduleName,
      id: resource.id
    });
  }

  async getAccountSAState(): Promise<boolean> {
    return new Promise((resolve) => {
      if (AppStorage.get('accountSAReady')) {
        resolve(true);
        return;
      }
      let timer = setInterval(() => {
        if (AppStorage.get('accountSAReady')) {
          clearInterval(timer);
          resolve(true);
        }
      }, 100);
    });
  }

  /**
   * 获取三方应用图片资源
   *
   * @param res 资源信息
   * @return base64字串
   */
  async getOutMediaBase64(res: ResourceManager.Resource): Promise<string> {
    if (CommonUtils.isInvalid(res)) {
      return null;
    }
    await this.getAccountSAState();
    return await this.appContext?.resourceManager?.getMediaContentBase64(res);
  }

  /**
   * 获取三方应用DrawableDescriptor
   *
   * @param res 资源信息
   * @return DrawableDescriptor
   */
  async getDrawableDescriptor(res: ResourceManager.Resource): Promise<DrawableDescriptor> {
    if (CommonUtils.isInvalid(res)) {
      return null;
    }
    return await this.appContext?.resourceManager?.getDrawableDescriptor(res);
  }

  /**
   * 获取三方应用DrawableDescriptor
   *
   * @param res 资源
   * @returns DrawableDescriptor
   */
  async getOutDrawableDescriptor(res: ResourceManager.Resource, deliverIconId?: number,
    deliverBundleName?: string): Promise<DrawableDescriptor | null> {
    if (CommonUtils.isInvalid(res) && CommonUtils.isInvalid(deliverIconId)) {
      log.showWarn('Get drawableDescriptor error for invalid resource');
      return null;
    }
    let bundleName: string = null;
    let iconId: number = null;
    if (!CommonUtils.isInvalid(res)) {
      bundleName = res.bundleName;
      iconId = res.id;
    } else {
      bundleName = deliverBundleName;
      iconId = deliverIconId;
    }
    try {
      const resMgr = await this.getResMgr(bundleName);
      return resMgr.getDrawableDescriptor(iconId, 0, 1);
    } catch (error) {
      log.showError('Get drawableDescriptor for [%{public}s] error by [%{public}s]', bundleName, error.message);
      return null;
    }
  }

  /**
   * 获取三方应用DrawableDescriptor
   *
   * @param res 资源
   * @returns DrawableDescriptor
   */
  async getOutDrawableDescriptorWidthDensity(deliverIconId: number,
    deliverBundleName: string, density: number): Promise<DrawableDescriptor | null> {
    try {
      const resMgr = await this.getResMgr(deliverBundleName);
      return resMgr.getDrawableDescriptor(deliverIconId, density, 1);
    } catch (error) {
      log.showError('Get drawableDescriptor for [%{public}s] error by [%{public}s]', deliverBundleName, error.message);
      return null;
    }
  }

  async getBundleInfo(tag: string, bundleName: string, getInfo?: any, requestId?: number) {
    getInfo = getInfo ?? BundleMgr.BundleFlag.GET_BUNDLE_DEFAULT;
    let userInfo = {
      userId: requestId ?? await AccountMgr.getCurrentAccountId(),
    };
    log.showDebug(`getBundleInfo from: ${tag}`);
    return await BundleMgr.getBundleInfo(bundleName, getInfo, userInfo);
  }

  /**
   * 获取module context
   *
   * @param moduleName 模块名
   */
  private getModuleContext(moduleName: string): Common.Context {
    let moduleContext = this.moduleContexts.get(moduleName);
    if (!CommonUtils.isInvalid(moduleContext)) {
      return moduleContext;
    }
    try {
      moduleContext = this.appContext.createModuleContext(moduleName);
      this.moduleContexts.set(moduleName, moduleContext);
    } catch (error) {
      log.showError(`createModuleContext failed, error msg: ${error.message}`);
    }
    return moduleContext;
  }

  /**
   * 获取context
   *
   * return context
   */
  private async getContext(): Promise<Common.Context> {
    // 已存在
    if (!CommonUtils.isInvalid(this.appContext)) {
      return this.appContext;
    }
    // 等待
    return new Promise((resolve) => {
      this.contextResolves.add(resolve);
    });
  }

  /**
   * 获取资源管理器
   *
   * @param bundleName 包名
   * return resMgr
   */
  private async getResMgr(bundleName?: string): Promise<ResourceManager.ResourceManager> {
    // 包名不为SystemUI，则创建对应应用资源管理器
    if (!CommonUtils.isEmpty(bundleName) && bundleName !== SCBConstants.SCENE_BOARD_PKG) {
      let cachedContext = this.bundleContexts.get(bundleName!);
      if (cachedContext) {
        return cachedContext.resourceManager;
      }
      return new Promise((resolve) => {
        this.getContext().then((context) => {
          let tarContext = context.createBundleContext(bundleName);
          this.bundleContexts.set(bundleName!, tarContext);
          resolve(tarContext.resourceManager);
        });
      });
    }
    // 默认SystemUI资源管理器
    return new Promise((resolve) => {
      this.getContext().then((context) => {
        resolve(context.resourceManager);
      });
    });
  }

  /**
   * 语言变化，清理moduleContexts
   *
   * @param event 事件
   */
  private onConfigurationEvent(event: ConfigurationEvent): void {
    let language = event.config?.language;
    if (!CommonUtils.isInvalid(language) && this.systemLanguage !== language) {
      log.showInfo(`system language changed, oldLanguage: ${this.systemLanguage}, newLanguage: ${language}`);
      this.systemLanguage = language;
      this.clearModuleContexts();
    }
  }
}

// 单例
export let ResUtils = SingletonHelper.getInstance(ResourceUtils, TAG);