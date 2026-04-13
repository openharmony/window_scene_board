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

import taskpool from '@ohos.taskpool';
import BundleMgr from '@ohos.bundle.bundleManager';
import type Want from '@ohos.app.ability.Want';
import {
  JsonUtils,
  CommonUtils,
  ArrayUtils,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import {
  DeviceHelper,
  PluginSlot,
  PluginParseInfo
} from '@ohos/frameworkwrapper';

const TAG = 'Plugin-ParseConfigUtils';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

// 查询ability的默认flag
const DEFAULT_BUNDLE_FLAG =
  BundleMgr.AbilityFlag.GET_ABILITY_INFO_WITH_METADATA | BundleMgr.AbilityFlag.GET_ABILITY_INFO_WITH_PERMISSION;

/**
 * 请求接口
 */
export interface Request {
  /**
   * 请求plugin资源json
   *
   * @param resName 资源名称
   * @param bundleName 包名
   */
  requestPluginJson(resName: string, bundleName: string): Promise<string>;
}

/**
 * ability参数
 */
interface AbilityParam {
  /**
   * 资源集
   */
  abilityInfos: Array<BundleMgr.AbilityInfo | BundleMgr.ExtensionAbilityInfo>;

  /**
   * plugin action
   */
  action: string;

  /**
   * 目标metadata名
   */
  metadataName: string;

  /**
   * 解析结果集
   */
  resultInfos: Array<PluginParseInfo>;

  /**
   * json请求
   */
  request: Request;
}

/**
 * metadata参数
 */
interface MetadataParam {
  /**
   * metadata
   */
  metadata: Array<BundleMgr.Metadata>;

  /**
   * 目标metadata名
   */
  metadataName: string;

  /**
   * plugin action
   */
  action: string;

  /**
   * 应用包名
   */
  bundleName: string;

  /**
   * 应用模块名
   */
  moduleName: string;

  /**
   * plugin ability
   */
  abilityName: string;

  /**
   * 解析结果集
   */
  resultInfos: Array<PluginParseInfo>;

  /**
   * json请求
   */
  request: Request;
}

/**
 * 解析三方APP配置信息，一般子线程使用
 *
 * @since 2022-10-06
 */
export class ParseConfigUtils {
  /**
   * 获取APP配置信息
   *
   * @param bundleName 应用包名
   * @param userId 应用所属用户
   * @return APP信息
   */
  static async getBundleInfo(bundleName: string, userId: number): Promise<BundleMgr.BundleInfo | undefined> {
    try {
      return await BundleMgr.getBundleInfo(bundleName, BundleMgr.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION, userId);
    } catch (error) {
      log.error('getBundleInfo error code:' + error?.code + ', message:' + error?.message);
    }
    return undefined;
  }

  /**
   * 获取APP配置信息，含ability信息
   *
   * @param bundleName 应用包名
   * @param userId 应用所属用户
   * @return APP信息
   */
  static async getBundleInfoWithAbility(bundleName: string, userId: number, uid: number): Promise<BundleMgr.BundleInfo | undefined> {
    let flag = (BundleMgr.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
    BundleMgr.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
    BundleMgr.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY |
    BundleMgr.BundleFlag.GET_BUNDLE_INFO_WITH_EXTENSION_ABILITY);

    let appIndex = 0;
    try {
      let appIdentity = await BundleMgr.getAppCloneIdentity(uid);
      appIndex = appIdentity?.appIndex;
    } catch (error) {
      log.error('getAppCloneIdentity error code:' + error?.code + ', message:' + error?.message);
    }

    try {
      if (appIndex > 0) {
        return await BundleMgr.getAppCloneBundleInfo(bundleName, appIndex, flag, userId);
      } else {
        return await BundleMgr.getBundleInfo(bundleName, flag, userId);
      }
    } catch (error) {
      log.error('getBundleInfoWithAbility error', error);
    }
    return undefined;
  }

  /**
   * 获取所有已安装应用信息
   *
   * @param userId 当前用户
   * @return APP信息集
   */
  static async getAllBundleInfo(userId: number, flag: number): Promise<Array<BundleMgr.BundleInfo>> {
    try {
      const infos = await taskpool.execute(getAllBundleInfoTask, flag, userId) as BundleMgr.BundleInfo[];
      return infos;
    } catch (error) {
      log.showError('execute getAllBundleInfoTask error code:' + error?.code + ', message:' + error?.message);
      return [];
    }
  }

  /**
   * 查询三方APP特定action的ability信息，解析封装PluginInfo
   *
   * @param action 特定action
   * @param userId 多用户id
   * @param metaDataName 过滤metadata名称
   * @param bundleName 应用包名
   * @param request 请求json
   * @return plugin信息集
   */
  static async parsePluginInfo(action: string, userId: number, metaDataName: string, bundleName: string, request: Request):
  Promise<Array<PluginParseInfo>> {
    log.showInfo('parsePluginInfo action: ' + action + ', userId:' + userId + ', bundleName: ' + bundleName);
    let result: Array<PluginParseInfo> = new Array();
    let queryWant: Want = !CommonUtils.isEmpty(bundleName) ? { action: action, bundleName: bundleName } : {
      action: action
    };
    try {
      // 兼容AbilityInfo
      log.showInfo('queryAbilityInfo');
      let abilityInfos: Array<BundleMgr.AbilityInfo> = await BundleMgr.queryAbilityInfo(queryWant, DEFAULT_BUNDLE_FLAG, userId);
      await ParseConfigUtils.getPluginByAbility({
        abilityInfos: abilityInfos,
        action: action,
        metadataName: metaDataName,
        resultInfos: result,
        request: request
      });
    } catch (err) {
      log.showError('queryAbilityInfo query ability err. action: ' + action +
        'code:' + err?.code + ', message:' + err?.message);
    }
    try {
      // 新API ExtensionAbilityInfo
      log.showInfo('queryExtensionAbilityInfo');
      let extensionAbilityInfos: Array<BundleMgr.ExtensionAbilityInfo> = await BundleMgr.queryExtensionAbilityInfo(queryWant,
        BundleMgr.ExtensionAbilityType.UNSPECIFIED, DEFAULT_BUNDLE_FLAG, userId);
      await ParseConfigUtils.getPluginByAbility({
        abilityInfos: extensionAbilityInfos,
        action: action,
        metadataName: metaDataName,
        resultInfos: result,
        request: request
      });
    } catch (err) {
      log.showError('queryAbilityInfo query extension ability err. action: ' + action +
        'code:' + err?.code + ', message:' + err?.message);
    }
    return result;
  }

  /**
   * 获取plugin信息从Ability里
   *
   * @param param 解析参数
   */
  private static async getPluginByAbility(param: AbilityParam): Promise<void> {
    if (ArrayUtils.isEmpty(param.abilityInfos)) {
      return;
    }
    for (let info of param.abilityInfos) {
      await ParseConfigUtils.getPluginByMetadata({
        metadata: info?.metadata,
        metadataName: param.metadataName,
        action: param.action,
        bundleName: info?.bundleName,
        moduleName: info?.moduleName,
        abilityName: info?.name,
        resultInfos: param.resultInfos,
        request: param.request
      });
      log.showInfo('getPluginByAbility: ' + info?.metadata.length);
    }
  }

  /**
   * 获取plugin信息从metadata里
   *
   * @param param 参数
   * @param result 结果搜集
   */
  private static async getPluginByMetadata(param: MetadataParam): Promise<void> {
    if (ArrayUtils.isEmpty(param.metadata)) {
      return;
    }
    for (let data of param.metadata) {
      if (data?.name !== param.metadataName) {
        log.showDebug('getPluginByMetadata metadata invalid, current: ' + data?.name +
          ', target: ' + param.metadataName);
        return;
      }
      // 获取json串
      let pluginJson = await ParseConfigUtils.getPluginJson(data, param.bundleName, param.request);
      if (CommonUtils.isEmpty(pluginJson)) {
        log.showWarn('getPluginByMetadata plugin json is empty');
        return;
      }
      log.showInfo('getPluginByMetadata pluginJson: ' + pluginJson);
      let pluginInfo: PluginParseInfo = JsonUtils.parse(() => new PluginParseInfo(), pluginJson);
      if (CommonUtils.isInvalid(pluginInfo)) {
        log.showDebug('getPluginByMetadata parse json err, bundleName: ' + param.bundleName +
          ', metadata: ' + param.metadataName);
        return;
      }
      pluginInfo.bundleName = param.bundleName;
      pluginInfo.moduleName = param.moduleName;
      pluginInfo.action = param.action;
      // 未设置组件ability时，默认当前ability
      if (CommonUtils.isInvalid(pluginInfo.pluginAbilityName)) {
        pluginInfo.pluginAbilityName = param.abilityName;
      }
      // 校正默认值
      pluginInfo.checkParams();
      // 校验解析数据有效性
      if (ParseConfigUtils.checkPluginValid(pluginInfo)) {
        param.resultInfos.push(pluginInfo);
      } else {
        log.showWarn('getPluginByMetadata parse plugin fail. bundle: ' + param.bundleName +
          ', template: ' + pluginInfo.pluginTemplateName);
      }
    }
  }

  /**
   * 获取plugin的json传
   *
   * @param metadata metadata信息
   * @param bundleName 包名
   * @return json串
   */
  private static async getPluginJson(metadata: BundleMgr.Metadata, bundleName: string, request: Request): Promise<string> {
    if (CommonUtils.isInvalid(metadata) || CommonUtils.isEmpty(metadata.value)) {
      return '';
    }
    log.showInfo(`requestPluginJson value ${metadata.value} bundleName ${bundleName}`);
    return request?.requestPluginJson(metadata.value, bundleName);
  }

  /**
   * 校验有效性
   *
   * @param pluginInfo 组件信息
   * @return true有效
   */
  private static checkPluginValid(pluginInfo: PluginParseInfo): boolean {
    if (CommonUtils.isInvalid(pluginInfo)) {
      return false;
    }
    log.showDebug(`checkPluginValid plugin: ${pluginInfo?.isLocalPlugin}--${pluginInfo?.bundleName}--${pluginInfo?.moduleName}--${pluginInfo?.action}`);
    // 组件模板名称、组件ability
    if (CommonUtils.isInvalid(pluginInfo.pluginTemplateName) || CommonUtils.isInvalid(pluginInfo.pluginAbilityName)) {
      log.showWarn('checkPluginValid template fail: ' + pluginInfo.action + ', ' + pluginInfo.pluginSlot);
      return false;
    }
    if (!CommonUtils.isInvalid(pluginInfo.clickInfo) && CommonUtils.isInvalid(pluginInfo.clickInfo.abilityName)) {
      log.showWarn('checkPluginValid click fail: ' + pluginInfo.action + ', ' + pluginInfo.pluginSlot);
      return false;
    }
    if (!CommonUtils.isInvalid(pluginInfo.subPageClickInfo) &&
      CommonUtils.isInvalid(pluginInfo.subPageClickInfo.abilityName)) {
      log.showWarn('checkPluginValid sub click fail: ' + pluginInfo.action + ', ' + pluginInfo.pluginSlot);
      return false;
    }
    // 组件设备类型匹配
    let defaultDeviceType = PluginSlot.getDefaultDeviceType(pluginInfo.action, pluginInfo.pluginSlot);
    if (!CommonUtils.isEmpty(defaultDeviceType)) {
      pluginInfo.pluginDeviceType = defaultDeviceType;
    } else {
      // 兼容处理，接入方tablet按PC处理
      if (CommonUtils.equals(pluginInfo.pluginDeviceType, DeviceHelper.TYPE_TABLET)) {
        pluginInfo.pluginDeviceType = DeviceHelper.TYPE_2IN1;
      }
    }
    let isMatch = DeviceHelper.isMatchDevice(pluginInfo.pluginDeviceType);
    if (!isMatch) {
      log.showWarn('checkPluginValid device match fail: ' + pluginInfo.action + ', ' +
        pluginInfo.pluginSlot + ', ' + pluginInfo.pluginDeviceType);
    }
    return isMatch;
  }
}

async function getAllBundleInfoTask(flag: number, userId: number) : Promise<BundleMgr.BundleInfo[]> {
  'use concurrent';
  const infos = await BundleMgr.getAllBundleInfo(flag, userId) as BundleMgr.BundleInfo[];
  return infos;
}