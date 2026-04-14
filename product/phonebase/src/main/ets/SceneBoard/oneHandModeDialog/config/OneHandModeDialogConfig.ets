/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { convertxml } from '@kit.ArkTS';
import { fileIo } from '@kit.CoreFileKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { OneHandCloudPushConfigManager } from './OneHandCloudPushConfigManager';
import { OneHandDialogConstants } from './OneHandModeDialogConstants';

const TAG: string = 'OneHandModeDialogConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

interface XmlClass {
  head: XmlHead;
  children: XmlConfig[];
}

interface XmlHead {
  values: Record<string, string>;
}

interface XmlConfig {
  type: string;
  name: string;
  children?: XmlConfig[];
  value?: string;
  values?: Record<string, string>;
}

export interface OneHandModeDialogConfigInfo {
  enable: boolean;
  inOneHandThreshold: number;
  // <name：应用包名  popupThreshold：交互引导窗允许弹出的最大次数>
  normalAppMap: Map<string, number>;
}

export class OneHandModeDialogConfig {
  private static instance?: OneHandModeDialogConfig;
  private configInfo: OneHandModeDialogConfigInfo = {
    enable: false,
    inOneHandThreshold: 0,
    normalAppMap: new Map()
  };
  private isInit: boolean = false;

  private constructor() {}

  private toNumber(value?: string): number {
    let num: number = Number(value);
    if (isNaN(num)) {
      return 0;
    }
    return num;
  }

  private processAppWhitelist(isNormal: boolean, xmlConfig?: XmlConfig): void {
    if (xmlConfig?.name !== 'app-whitelist') {
      return;
    }
    xmlConfig.children?.forEach((item) => {
      if (item.name !== 'pkg') {
        return;
      }
      let value = item.values;
      if (value && value.name && value.popupThreshold) {
        if (isNormal) {
          this.configInfo.normalAppMap.set(value.name, this.toNumber(value.popupThreshold));
        }
      }
    });
  }

  private processXmlClass(xmlClass: XmlClass): void {
    if (!xmlClass) {
      log.showError('xmlClass is null');
      return;
    }
    let xmlVersion: string = xmlClass.head.values['version'];
    log.showInfo(`processXmlVersion: ${xmlVersion}`);
    let guideConfig = xmlClass.children?.[0]?.children;
    guideConfig?.forEach((item) => {
      switch (item.name) {
        case 'enable':
          this.configInfo.enable = item.children?.[0].value === 'true';
          break;
        case 'inOneHandThreshold':
          this.configInfo.inOneHandThreshold = this.toNumber(item.children?.[0].value);
          break;
        case 'normal':
          this.processAppWhitelist(true, item.children?.[0]);
          break;
        default:
          break;
      }
    });

    log.showInfo('processXmlClass ok');
  }

  private initConfigInfo(): void {
    let options: convertxml.ConvertOptions = {
      trim: true,
      ignoreComment: true,
      declarationKey: 'head',
      instructionKey: 'instruction',
      attributesKey: 'values',
      textKey: 'value',
      cdataKey: 'unknown',
      doctypeKey: 'doctype',
      commentKey: 'comment',
      parentKey: 'parent',
      typeKey: 'type',
      nameKey: 'name',
      elementsKey: 'children'
    };

    try {
      let xml = OneHandCloudPushConfigManager.getInstance().loadAppTruncateConfig();
      if (xml === undefined) {
        xml = fileIo.readTextSync(OneHandDialogConstants.CONFIG_PATH);
      }
      let conv: convertxml.ConvertXML = new convertxml.ConvertXML();
      let xmlClass: XmlClass = conv.convertToJSObject(xml, options) as XmlClass;
      this.processXmlClass(xmlClass);
    } catch (err) {
      log.showError(`Load product config failed, error: ${err?.code}`);
    }
    // 仅初始化一次，初始化失败后不重试
    this.isInit = true;
  }

  public getConfig(): OneHandModeDialogConfigInfo {
    if (!this.isInit) {
      this.initConfigInfo();
    }
    return this.configInfo;
  }

  public static getInstance(): OneHandModeDialogConfig {
    if (OneHandModeDialogConfig.instance === undefined) {
      OneHandModeDialogConfig.instance = new OneHandModeDialogConfig();
    }
    return OneHandModeDialogConfig.instance;
  }
}