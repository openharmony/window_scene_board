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

import Want from '@ohos.app.ability.Want';
import bundleManager from '@ohos.bundle.bundleManager';
import rpc from '@ohos.rpc';
import { BusinessError } from '@ohos.base';
import LinkedList from '@ohos.util.LinkedList';
import buffer from '@ohos.buffer';
import util from '@ohos.util';
import type abilityCommon from '@ohos.app.ability.common';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ConfigParseUtil } from '../TsIndex';
import { ServiceType } from '../utils/ConfigParseUtil';

const TAG: string = 'AppFoundationServiceExtensionManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
//第二位非空，表示找到了映射的商用上架鸿蒙应用
const APP_HARMONY_ON_SHELF = 1 << 1;
// 第四位非空，表示该应用在应用的分发清单内
const APP_IN_APP_LIST = 1 << 3;
// 第五位非空，表示该应用在克隆应用的分发清单内
const APP_IN_DELIVER_TONG_LIST = 1 << 4;
// 第六位非空，表示该应用不在分发清单，但是兜底允许
const APP_NOT_IN_LIST = 1 << 5;

/**
 * 获取应用市场鸿蒙化应用映射类
 *
 * @since 2024-09-20
 */
export class AppFoundationServiceExtensionManager {
  private static instance: AppFoundationServiceExtensionManager | null = null;
  private readonly APP_FOUNDATION_EXTENSION_ABILITY: string = 'AppFoundationService';
  private readonly APP_GALLERY_BUNDLE_NAME: string = 'com.ohos.appgallery';
  private readonly METHOD_CODE: number = 10;
  private readonly MAX_SUPPORT_APP_NUM: number = 500;
  private readonly NOT_VERIFY_SIGN: number = 1;
  private readonly VERIFY_SIGN: number = 0;
  private readonly QUERY_REQUEST_TIME_OUT: number = 3000;
  private context: abilityCommon.ServiceExtensionContext | null = null;
  private dualApps: DualApp[] = [];
  private dualAppsQueue: LinkedList<DualApp[]> = new LinkedList();
  private connectionId: number = -1;
  private inputParamString: string = '';
  private ohosAppMap: Map<string, string[]> = new Map();
  private ohosAppMappingInfoMap: Map<string, MappingInfo> = new Map();
  private deliverBundleNamesMap: Map<string, number> = new Map();
  private queryResult: boolean = false;
  private proxy: rpc.IRemoteObject | null = null;
  private intefaceToken: string = '';
  private want: Want = {
    bundleName: this.APP_GALLERY_BUNDLE_NAME,
    abilityName: this.APP_FOUNDATION_EXTENSION_ABILITY,
  };

  private constructor() {
    this.context = GlobalContext.getContext();
  }

  /**
   * 获取AppFoundationServiceExtensionManager实例
   *
   * @returns AppFoundationServiceExtensionManager实例
   */
  public static getInstance(): AppFoundationServiceExtensionManager {
    if (AppFoundationServiceExtensionManager.instance === null) {
      AppFoundationServiceExtensionManager.instance = new AppFoundationServiceExtensionManager();
    }
    return AppFoundationServiceExtensionManager.instance;
  }

  /**
   * 查询鸿蒙化应用映射
   *
   * @param packageList 包名列表
   * @param context 上下文
   */
  public async queryAppMappingInfo(packageList: string[]): Promise<void> {
    if (this.context === null || CheckEmptyUtils.isEmptyArr(packageList)) {
      log.showError('packageList or context is null');
      return;
    }
    this.init(packageList);
    if (!(this.dualAppsQueue?.length > 0) || CheckEmptyUtils.isEmpty(this.context)) {
      log.showError('invalid parameter, context or dualAppsQueue is null');
      return;
    }
    log.showInfo('start queryAppMappingInfo');
    let result: boolean = await this.connectServiceExtensionAbility();
    log.showInfo('connect result = %{public}s', result);

    // 建联失败，直接返回
    if (!result) {
      log.showError('connect AppFoundationServiceExtension failed');
      return;
    }

    // 循环查询
    while (this.dualAppsQueue.length > 0) {
      let dualAppBatch: DualApp[] = this.dualAppsQueue.removeFirst();
      let inputParam: InputParam = {
        apps: dualAppBatch,
        verify: this.NOT_VERIFY_SIGN,
      };
      this.inputParamString = JSON.stringify(inputParam);
      try {
        await this.sendQueryRequestTimeout().catch(() => {
          log.showError('sendQueryRequestTimeout failed.');
        });
      } catch (error) {
        log.showError('sendQueryRequestTimeout exception.');
      }
    }
    // 断开连接
    this.disconnectServiceExtensionAbility();
  }

  private async sendQueryRequestTimeout(): Promise<void> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let timerId = setTimeout(() => {
        log.showError('sendQueryRequestTimeout timed out.');
        reject();
      }, this.QUERY_REQUEST_TIME_OUT);

      await this.sendQueryRequest();
      clearTimeout(timerId);
      resolve();
    });
  }

  /**
   * 校验证书是否正确
   *
   * @param dualApp 包信息(含签名证书)
   * @param context 上下文
   * @param bundleName 包名
   */
  public async validSignature(dualApp: DualApp, bundleName: string): Promise<boolean> {
    if (this.context === null || CheckEmptyUtils.isEmpty(dualApp?.pkgName) || CheckEmptyUtils.isEmpty(dualApp?.sign) ||
    CheckEmptyUtils.isEmpty(bundleName)) {
      log.showError('packageList or context is null');
      return false;
    }
    this.ohosAppMap.clear();
    this.ohosAppMappingInfoMap.clear();
    log.showInfo('start validSignature, pkgName: %{public}s sign: %{public}s', dualApp.pkgName, dualApp.sign);
    let result: boolean = await this.connectServiceExtensionAbility();
    log.showInfo('connect result =', result);

    // 建联失败，直接返回false
    if (!result) {
      log.showError('connect AppFoundationServiceExtension failed');
      return false;
    }

    // 查询包名+证书映射
    let inputParam: InputParam = {
      apps: [dualApp],
      verify: this.VERIFY_SIGN,
    };
    this.inputParamString = JSON.stringify(inputParam);
    await this.sendQueryRequest();

    // 若使用包名+证书查询为空，则说明AG无映射关系或者验证不一致
    if (this.ohosAppMap.size === 0 || !this.ohosAppMap.has(dualApp.pkgName)) {
      log.showInfo('AG not has package mappinginfo, packageName: %{public}s', dualApp.pkgName);
      return false;
    }

    let bundleNameWithSign: string = this.ohosAppMap.get(dualApp.pkgName)?.[0] ?? '';
    this.ohosAppMap.clear();

    return !CheckEmptyUtils.isEmpty(bundleNameWithSign) && bundleNameWithSign === bundleName;
  }

  /**
   * 获取查询到的鸿蒙化应用列表
   *
   * @returns 鸿蒙化应用列表
   */
  public getohosAppMap(): Map<string, string[]> {
    return this.ohosAppMap;
  }

  /**
   * 获取查询到的鸿蒙化应用列表
   *
   * @returns 鸿蒙化应用列表
   */
  public getohosAppMappingInfoMap(): Map<string, MappingInfo> {
    return this.ohosAppMappingInfoMap;
  }

  /**
   * 获取查询到的可应用列表
   *
   * @returns 可出列表
   */
  public getDeliverBundleNamesMap(): Map<string, number> {
    return this.deliverBundleNamesMap;
  }

  /**
   * 获取请求是否成功
   *
   * @returns 请求结果
   */
  public queryMappingResult(): boolean {
    return this.queryResult;
  }


  /**
   * 初始化数据
   *
   * @param packageList 待查询的包名列表
   * @param context 上下文
   */
  private init(packageList: string[]): void {
    this.ohosAppMap.clear();
    this.ohosAppMappingInfoMap.clear();
    this.deliverBundleNamesMap.clear();
    this.queryResult = false;
    // 将包名转换成DualApp数据结构
    this.stringToDualApp(packageList);
    log.showInfo('dualApps size: %{public}d', this.dualApps.length);

    // 将数组切分， 500长度一组
    this.sliceDualApps();
    log.showInfo('dualAppsQueue size: %{public}d', this.dualAppsQueue.length);
  }

  /**
   * 建立连接
   *
   * @returns true：成功, false：失败
   */
  private connectServiceExtensionAbility(): Promise<boolean> {
    return new Promise<boolean>((resolve, reject) => {
      if (CheckEmptyUtils.isEmpty(this.context)) {
        log.showError('the context is null');
        resolve(false);
        return;
      }

      // 如果已经建立了连接，无需重新建联
      if (this.proxy !== null) {
        log.showError('already connect AG');
        resolve(true);
        return;
      }
      try {
        this.connectionId = this.context?.connectServiceExtensionAbility(this.want, {
          onConnect: (elementName: bundleManager.ElementName, remote: rpc.IRemoteObject) => {
            log.showInfo('onConnect... name: %{public}s', elementName.bundleName);
            this.proxy = remote;
            resolve(true);
          },
          onDisconnect: (elementName: bundleManager.ElementName) => {
            log.showError('onDisconnect... name: %{public}s', elementName.bundleName);
            this.proxy = null;
            resolve(false);
          },

          onFailed: (code: number) => {
            log.showError('onFailed... code: %{public}d', code);
            resolve(false);
          }
        }) ?? -1;
      } catch (error) {
        log.showError('connect AppFoundationServiceExtension exception %{public}s', error?.message);
        reject(false);
      }
    });
  }

  /**
   * 断开AG连接
   */
  public disconnectServiceExtensionAbility(): void {
    log.showInfo('disconnectServiceExtensionAbility, connectId = %{public}d', this.connectionId);
    if (CheckEmptyUtils.isEmpty(this.context) || this.proxy === null) {
      log.showError('the context is null or already disconnect');
      return;
    }
    try {
      this.context?.disconnectServiceExtensionAbility(this.connectionId);

      // 断连时释放资源
      this.proxy = null;
      this.dualApps = [];
      this.dualAppsQueue.clear();
    } catch (error) {
      log.showError('disconnect AppFoundationServiceExtension exception %{public}s', error?.message);
    }
  }

  private async sendQueryRequest(): Promise<void> {
    // 如果proxy为空，则建联失败
    if (this.proxy === null || this.proxy === undefined) {
      log.showError('connectServiceExtensionAbility failed');
      return;
    }
    let option: rpc.MessageOption = new rpc.MessageOption();
    let data: rpc.MessageSequence = new rpc.MessageSequence();
    let reply: rpc.MessageSequence = new rpc.MessageSequence();
    try {
      data.writeInterfaceToken(this.getInterFaceToken());
      let contentArray: number[] = Array.from(this.stringToUint8Array(this.inputParamString));
      data.writeInt(contentArray.length);
      data.writeRawData(contentArray, contentArray.length);
      await this.proxy.sendMessageRequest(this.METHOD_CODE, data, reply, option).then((result: rpc.RequestResult) => {
        if (result.errCode !== 0) {
          log.showError('sendMessageRequest failed: %{public}d', result.errCode);
          return;
        }
        let len: number = reply.readInt();
        let resultArray: number[] = reply.readRawData(len);
        let mappingJson: string = this.uint8ArrayToString(new Uint8Array(resultArray));
        log.showInfo('sendMessageRequest success');
        this.parseohosAppList(mappingJson);
      }).catch((error: BusinessError) => {
        log.showError('sendMessageRequest error. %{public}d', error.code);
      });
    } catch (error) {
      log.showError('sendMessageRequest exception. %{public}s', error?.message);
    } finally {
      data.reclaim();
      reply.reclaim();
    }
  }

  private getInterFaceToken(): string {
    if (CheckEmptyUtils.isEmpty(this.intefaceToken)) {
      this.intefaceToken = ConfigParseUtil.getInterfaceToken(ServiceType.APP_FOUNDATION);
    }
    return this.intefaceToken;
  }

  private stringToDualApp(packageNames: string[]): void {
    if (CheckEmptyUtils.isEmptyArr(packageNames)) {
      log.showError('Invalid parameter, packageNames is empty');
      return;
    }
    this.dualApps = packageNames.map((packageName: string) => {
      let dualApp: DualApp = { pkgName: packageName, sign: '' };
      return dualApp;
    });
  }

  private sliceDualApps(): void {
    if (CheckEmptyUtils.isEmptyArr(this.dualApps)) {
      return;
    }
    while (this.dualApps.length > this.MAX_SUPPORT_APP_NUM) {
      this.dualAppsQueue.add(this.dualApps.splice(0, this.MAX_SUPPORT_APP_NUM));
    }

    if (this.dualApps.length > 0) {
      this.dualAppsQueue.add(this.dualApps);
    }
  }

  private parseohosAppList(mappingJson: string): void {
    log.showInfo('the mappingJson is %{public}s', mappingJson);
    if (CheckEmptyUtils.isEmpty(mappingJson)) {
      log.showError('the mappingJson is empty');
      return;
    }
    let outputParam: OutPutParam;
    try {
      outputParam = JSON.parse(mappingJson) as OutPutParam;
    } catch (error) {
      log.showError('parse mappingJson failed %{public}s', error?.message);
      return;
    }
    if (outputParam.result !== 0) {
      log.showError('query mappingInfos failed, %{public}d', outputParam.result);
    }
    if (CheckEmptyUtils.isEmptyArr(outputParam.mappingInfos)) {
      log.showError('the mappingInfos is empty');
      return;
    }
    this.queryResult = true;
    outputParam.mappingInfos.forEach((mappingInfo: MappingInfo) => {
      let type: number = mappingInfo.type;
      if (((type & APP_IN_DELIVER_TONG_LIST) || (type & APP_IN_APP_LIST) || (type & APP_NOT_IN_LIST)) &&
        !CheckEmptyUtils.isEmpty(mappingInfo.pkgName)) {
        this.deliverBundleNamesMap.set(mappingInfo.pkgName, type);
      }
      if (!(mappingInfo?.harmonyInfos?.length > 0) || CheckEmptyUtils.isEmpty(mappingInfo.pkgName)) {
        log.showDebug('the mappingInfo is empty');
        return;
      }
      if (!this.isFindohosMapping(mappingInfo.type)) {
        log.showDebug('find app mapping failed, %{public}s', mappingInfo.pkgName);
        return;
      }
      let bundleNames: string[] = mappingInfo.harmonyInfos.map((info: HarmonyAppInfo) => {
        return info.bundleName;
      });
      this.ohosAppMap.set(mappingInfo.pkgName, bundleNames);
      this.ohosAppMappingInfoMap.set(mappingInfo.pkgName, mappingInfo);
    });
  }

  /*
   * 0--不在架(com.openharmony.shortcutsmenu4)
   * 1--在架，无关系（com.openharmony.CMSupgrade）
   * 第二位非空--在架，有关系（tv.danmaku.bili）
   */
  private isFindohosMapping(mappingType: number): boolean {
    return (mappingType & APP_HARMONY_ON_SHELF) > 0;
  }

  private stringToUint8Array(str: String): Uint8Array {
    try {
      return new Uint8Array(buffer.from(str, 'utf-8').buffer);
    } catch (error) {
      log.showError('stringToUint8Array fail  %{public}s', error?.message);
      return new Uint8Array(0);
    }
  }

  private uint8ArrayToString(fileData: Uint8Array): string {
    try {
      return util.TextDecoder.create('utf-8', { ignoreBOM: true }).decodeWithStream(fileData, { stream: false });
    } catch (error) {
      log.showError('uint8ArrayToString fail %{public}s', error?.message);
      return '';
    }
  }
}

interface InputParam {
  apps: DualApp[];
  verify: number;
}

interface OutPutParam {
  result: number;
  mappingInfos: MappingInfo[];
}

export interface DualApp {
  pkgName: string;
  sign: string;
}

export interface MappingInfo {
  pkgName: string;
  harmonyInfos: HarmonyAppInfo[];
  type: number;
}

interface HarmonyAppInfo {
  bundleName: string;
  iconUri: string;
  name: string;
  size: number;
}