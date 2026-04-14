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

import PCM from '@ohos.pluginComponent';
import Want from '@ohos.application.Want';
import type { PluginParseInfo } from '@ohos/frameworkwrapper';
import type { PluginComponentInfo } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper, CommonUtils, ArrayUtils, SingletonHelper } from '@ohos/basicutils';

const TAG = "Plugin-PluginComponentManager";
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * PluginInfo数据构造类型
 */
type PluginType<T extends PluginComponentInfo> = new (...args: any[]) => T;

/**
 * plugin组件模板
 */
interface PluginComponentTemplate {
  source: string; // 组件模板名
  ability: string; // 组件ability名
}

/**
 * plugin组件push事件监听器
 */
export interface PluginPushListener<T extends PluginComponentInfo> {
  parseInfo: PluginParseInfo | undefined; // plugin配置信息
  pluginClassCreater: () => T; // plugin对象创建器
  onPush(pluginInfo: T): void; // 事件结果回调
}

/**
 * pluginComponent管理
 *
 * @since 2022-10-12
 */
class PluginComponentManager {
  /**
   * 远程plugin组件push回调监听集
   * bundleName => templateName => listener
   */
  private mPluginPushListeners: Map<string, Map<string, Set<PluginPushListener<any>>>>;

  /**
   * 标记是否已经初始化
   */
  private hasInit: boolean = false;

  /**
   * 初始化
   */
  init(): void {
    if (this.hasInit) {
      return;
    }
    // 监听plugin组件push事件
    // TODO 当前不允许在Ability onCreate等生命周期调用，会crash
    PCM.on('push', this.handlePluginPushEvent.bind(this));
    this.hasInit = true;
  }

  /**
   * PluginComponent组件使用，主动请求组件刷新
   *
   * @param pluginClassCreater plugin对象创建器
   * @param parseInfo plugin配置信息
   * @param data 额外信息
   */
  async requestPlugin<T extends PluginComponentInfo>(pluginClassCreater: () => T, parseInfo: PluginParseInfo, data?: PCM.KVObject):
    Promise<T> {
    return new Promise((resolve) => {
      PCM.request({
        want: { bundleName: parseInfo?.bundleName, abilityName: parseInfo?.pluginAbilityName },
        name: parseInfo?.pluginTemplateName,
        data: data ?? {}
      }, (err, data) => {
        if (err) {
          log.showError('requestPlugin err.');
        }
        if (!CommonUtils.isInvalid(data)) {
          let resultInfo = this.createPluginInfo(pluginClassCreater, parseInfo, data.componentTemplate, data.data, data.extraData);
          // 回调结果
          resolve(resultInfo);
        }
      });
    });
  }

  /**
   * 注册远程plugin组件push事件
   *
   * @param listener 监听器
   */
  registerPushListener<T extends PluginComponentInfo>(listener: PluginPushListener<T>): void {
    // TODO 初始化监听
    this.init();
    let bundleName = listener?.parseInfo?.bundleName;
    let templateName = listener?.parseInfo?.pluginTemplateName;
    log.showDebug('registerPushListener bundle: ' + bundleName + ', template: ' + templateName);
    if (CommonUtils.isInvalid(bundleName) || CommonUtils.isInvalid(templateName)) {
      log.showInfo('registerPushListener listener is invalid');
      return;
    }
    if (CommonUtils.isInvalid(this.mPluginPushListeners)) {
      this.mPluginPushListeners = new Map();
    }
    // 按应用包名分类
    let bundleMap = this.mPluginPushListeners.get(bundleName);
    if (CommonUtils.isInvalid(bundleMap)) {
      bundleMap = new Map();
      this.mPluginPushListeners.set(bundleName, bundleMap);
    }
    // 按模板名分类
    let templateSet = bundleMap.get(templateName);
    if (CommonUtils.isInvalid(templateSet)) {
      templateSet = new Set();
      bundleMap.set(templateName, templateSet);
    }
    // 添加监听器
    templateSet.add(listener);
  }

  /**
   * 注销远程plugin组件push事件
   *
   * @param listener 监听器
   */
  unregisterPushListener<T extends PluginComponentInfo>(listener: PluginPushListener<T>): void {
    let bundleName = listener?.parseInfo?.bundleName;
    let templateName = listener?.parseInfo?.pluginTemplateName;
    log.showDebug('unregisterPushListener bundle: ' + bundleName + ', template: ' + templateName);
    let bundleMap = this.mPluginPushListeners?.get(bundleName);
    if (CommonUtils.isInvalid(bundleMap)) {
      return;
    }
    let templateSet = bundleMap.get(templateName);
    if (CommonUtils.isInvalid(templateSet)) {
      return;
    }
    // 删除成功，校验集合为空则删除集合
    if (templateSet.delete(listener)) {
      ArrayUtils.checkDeleteIfEmpty(bundleMap, templateName);
      ArrayUtils.checkDeleteIfEmpty(this.mPluginPushListeners, bundleName);
    }
  }

  /**
   * 处理远程plugin主动push事件
   *
   * @param source plugin组件提供方ability信息
   * @param template plugin组件模板
   * @param data 组件模板数据
   * @param extraData 额外携带数据
   */
  private handlePluginPushEvent(source: Want, template: PluginComponentTemplate, data: PCM.KVObject, extraData: PCM.KVObject): void {
    log.showDebug('handlePluginPushEvent bundle: ' + source?.bundleName + ', template: ' + template?.source + ',' + template?.ability);
    // 查找对应push监听器
    this.mPluginPushListeners?.get(source?.bundleName)?.get(template?.source)?.forEach((listener) => {
      listener.onPush(this.createPluginInfo(listener.pluginClassCreater, listener.parseInfo, template, data, extraData));
    });
  }

  /**
   * 构建plugin组件数据信息
   *
   * @param pluginClassCreater plugin对象创建器
   * @param parseInfo plugin配置信息
   * @param template plugin模板信息
   * @param data plugin模板数据
   * @param extraData 附加数据
   */
  private createPluginInfo<T extends PluginComponentInfo>(pluginClassCreater: () => T, parseInfo: PluginParseInfo,
                                                          template: PluginComponentTemplate, data: PCM.KVObject, extraData: PCM.KVObject): T {
    let resultInfo = pluginClassCreater();
    resultInfo.pluginParseInfo = parseInfo;
    resultInfo.templateAbility = template?.ability;
    resultInfo.templateSource = template?.source;
    resultInfo.pluginData = data;
    // 附加值，请求icon布局宽度
    let requestWidth = extraData?.requestWidth;
    if (CommonUtils.isNumber(requestWidth)) {
      resultInfo.requestWidth = requestWidth as number;
    }
    // 附加值，请求图标可见性
    let requestVisible = extraData?.requestVisible;
    if (CommonUtils.isBoolean(requestVisible)) {
      resultInfo.requestVisible = requestVisible as boolean;
    }
    // 附加值，请求关闭弹窗
    let requestCloseWindow = extraData?.requestCloseWindow;
    if (CommonUtils.isBoolean(requestCloseWindow)) {
      resultInfo.requestCloseWindow = requestCloseWindow as boolean;
    }
    // 附加值，请求销毁窗口
    let requestDestroyWindow = extraData?.requestDestroyWindow;
    if (CommonUtils.isBoolean(requestDestroyWindow)) {
      resultInfo.requestDestroyWindow = requestDestroyWindow as boolean;
    }
    // 附加值，请求弹窗高度
    let requestWindowHeight = extraData?.requestWindowHeight;
    if (CommonUtils.isNumber(requestWindowHeight)) {
      resultInfo.requestWindowHeight = requestWindowHeight as number;
    }
    // 附加值，request pid
    let requestPid = extraData?.requestPid;
    if (CommonUtils.isNumber(requestPid)) {
      resultInfo.requestPid = requestPid as number;
    }
    // 附加值，request userId
    let requestUserId = extraData?.requestUserId;
    if (CommonUtils.isNumber(requestUserId)) {
      resultInfo.requestUserId = requestUserId as number;
    }
    // 附加值，请求打开弹窗
    let requestOpenWindow = extraData?.requestOpenWindow;
    if (CommonUtils.isBoolean(requestOpenWindow)) {
      resultInfo.requestOpenWindow = requestOpenWindow as boolean;
    }
    return resultInfo;
  }
}

// 单例
export let PluginComponentMgr = SingletonHelper.getInstance(PluginComponentManager, TAG);