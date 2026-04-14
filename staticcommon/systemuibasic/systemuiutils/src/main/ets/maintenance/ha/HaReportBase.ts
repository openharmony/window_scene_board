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

import { LogDomain, LogHelper } from '@ohos/basicutils';
// import hiAnalytics from '@hms.core.hiAnalytics';
import { SingletonHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/utils/GlobalContext';
import CommonEventManager from '@ohos.commonEventManager';
import dataPreferences from '@ohos.data.preferences';
import { util } from '@kit.ArkTS';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'HaReportBase');

export enum REPORT_TYPE {
  /* 运营 */
  OPERATION = 0,
  /* 运维 */
  MAINTENANCE = 1
}

/**
 * ha打点上报基础功能
 */
export class HaReportBase {
  public static get = SingletonHelper.createFactory(() => new HaReportBase());

  private static readonly APP_ID = 'SystemUI';

  private static readonly INSTANCE_TAG = 'SYSTEM_UI';

  private static readonly HA_REPORT_INFO = 'SYSTEM_UI_HA_REPORT_INFO';

  private static readonly HA_REPORT_URL = 'SYSTEM_UI_HA_REPORT_URL';

  private static readonly HA_REPORT_REGION = 'SYSTEM_UI_HA_REPORT_REGION';

  private static readonly HA_CONFIG_PATH = 'ha_config/ha_report_config.json';

  /* 中国区 */
  private static readonly REGION_CN = 1;

  // push更新 -> 本地持久化 -> 默认url
  private reportUrl?: string;

  private reportRegion?: number;

  private defaultUrl?: string;

  private initialized: boolean = false;

  private canInit: boolean = false;

  private constructor() {
  }

  /* 仅在通知监听初始化的线程里面可以初始化 */
  public async init(initFlag: boolean = false): Promise<void> {
    try {
      if (initFlag) {
        log.showInfo(`canInit change to ${initFlag}`);
        this.canInit = initFlag;
      }
      if (!this.canInit) {
        return;
      }
      log.showInfo('start init Ha');
      await this.getDefaultConfig();
      // 尝试恢复内存
      this.getReportConfigFromStorage();
      await this.initHaConfig();
    } catch (e) {
      log.showError(`init ha fail, error :${e?.code}, msg:${e?.message}`);
    }
  }

  public isInit(): boolean {
    return this.initialized;
  }

  private async getDefaultConfig(): Promise<void> {
    try {
      // 读取默认HA配置
      const rawFile = await GlobalContext.getContext()?.resourceManager?.getRawFileContent(HaReportBase.HA_CONFIG_PATH);
      const rawStirng = util.TextDecoder.create('utf-8', { ignoreBOM: true }).decodeWithStream(rawFile);
      const haConfig: HaConfig = JSON.parse(rawStirng);
      this.defaultUrl = haConfig.defaultUrl;
    } catch (e) {
      log.showError(`get default url failed, error :${e?.code}, msg:${e?.message}`);
    }
  }

  public async urlUpdateProcess(data: CommonEventManager.CommonEventData): Promise<void> {
    if (!data || data.code !== 0) {
      log.showWarn(`Data invalid!`);
      return;
    }
    log.showInfo(`receive url from push, belongId ${data.parameters?.belongId}`);
    this.reportUrl = data.parameters?.reportUrl;
    this.reportRegion = data.parameters?.belongId ?? HaReportBase.REGION_CN;
    if (!this.reportUrl) {
      log.showWarn('url is invalid');
      return;
    }
    this.saveReportConfig();
    // url更新，更新HA配置
    await this.initHaConfig();
  };

  private saveReportConfig(): void {
    log.showInfo('storageReportInfo start');
    try {
      const preferences =
        dataPreferences.getPreferencesSync(GlobalContext.getContext(), { name: HaReportBase.HA_REPORT_INFO });
      preferences.putSync(HaReportBase.HA_REPORT_URL, this.reportUrl);
      preferences.putSync(HaReportBase.HA_REPORT_REGION, this.reportRegion);
      preferences.flush();
    } catch (e) {
      log.showError(`save config failed, error :${e?.code}, msg:${e?.message}`);
    }
  }

  private getReportConfigFromStorage(): void {
    // 内存有值，不用取
    if (this.reportUrl && this.reportRegion) {
      return;
    }
    try {
      const preferences =
        dataPreferences.getPreferencesSync(GlobalContext.getContext(), { name: HaReportBase.HA_REPORT_INFO });
      const reportUrl = preferences.getSync(HaReportBase.HA_REPORT_URL, undefined);
      const reportRegion = preferences.getSync(HaReportBase.HA_REPORT_REGION, undefined);
      log.showInfo(`getReportInfoFromStorage, url valid: ${Boolean(reportUrl)}, region ${reportRegion}`);
      if (reportUrl && reportRegion) {
        this.reportUrl = reportUrl as string;
        this.reportRegion = reportRegion as number;
      }
    } catch (e) {
      log.showError(`get config failed, error :${e?.code}, msg:${e?.message}`);
    }
  }

  private async initHaConfig(): Promise<void> {
    try {
      log.showInfo(`init config, url valid ${Boolean(this.reportUrl)}, region: ${this.reportRegion}`);
      // const config: hiAnalytics.InstanceParams = {
      //   instanceTag: HaReportBase.INSTANCE_TAG,
      //   appId: HaReportBase.APP_ID,
      //   operationConfig: {
      //     presetProperties: ['uuid'],
      //     collectUrl: this.reportUrl ?? this.defaultUrl ?? ''
      //   },
      //   maintenanceConfig: {
      //     presetProperties: ['uuid'],
      //     collectUrl: this.reportUrl ?? this.defaultUrl ?? ''
      //   }
      // };
      // await hiAnalytics.setConfigOptions(config);
      this.initialized = true;
      log.showInfo('init success');
    } catch (e) {
      this.initialized = false;
      log.showError(`init failed, error :${e?.code}, msg:${e?.message}`);
    }
  }

  /**
   * 上报HA打点
   * @param eventId 事件id
   * @param type 上报类型 0:运营 1:运维
   * @param params 上报参数
   * @returns
   */
  public async reportHa(eventId: string, type: REPORT_TYPE[], params: Record<string, string>): Promise<void> {
    // 非中国区不上报
    if (this.reportRegion && Number(this.reportRegion) !== HaReportBase.REGION_CN) {
      return;
    }
    log.showInfo(`start report ${eventId}, params ${JSON.stringify(params)}`);
    // for (const eventType of type) {
    //   hiAnalytics.onEvent(HaReportBase.INSTANCE_TAG, eventType, eventId, params).then(() => {
    //     log.showInfo(`ha report success, type ${eventType}`);
    //   }).catch(() => {
    //     log.showInfo(`ha report failed, type ${eventType}`);
    //     // 尝试重新init
    //     this.init();
    //   });
    // }
  }
}

class HaConfig {
  defaultUrl?: string
}