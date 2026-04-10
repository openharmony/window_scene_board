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
import fileIo from '@ohos.file.fs';
import { convertxml } from '@kit.ArkTS';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { XmlConstants } from '../common/Constants';

const TAG = 'XmlParseUtil';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

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

export class XmlParseUtil {
  private xmlPath: string = XmlConstants.SOUND_XML_CONFIG_RESOURCE;
  private xmlClass: XmlClass | undefined = undefined;
  private xmlVersion: string = '';
  private logoSupport: boolean = false;
  private vocalCancelSupport: boolean = false;
  private callNoiseReductforceSupport: boolean = false;
  private callReinforceSupport: boolean = false;
  private recordNoiseReductforceSupport: boolean = false;
  private deviceselectSupport: boolean = false;
  private supportHeadsetList: Array<string> = [];
  private options: convertxml.ConvertOptions = {
    trim: false,
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
  }

  constructor() {
    this.initXmlConfig();
  }

  private initXmlConfig(): void {
    try {
      let xml = fileIo.readTextSync(this.xmlPath);
      let conv: convertxml.ConvertXML = new convertxml.ConvertXML();
      let object: object = conv.convertToJSObject(xml, this.options);
      let result = JSON.stringify(object);
      this.xmlClass = JSON.parse(result);
    } catch (e) {
      log.error(`Load product config failed`);
    }
    if (this.xmlClass) {
      this.processXmlClass(this.xmlClass);
    } else {
      log.error(`parse xml config fail`);
    }
  }

  private processXmlClass(xmlClass: XmlClass): void {
    this.xmlVersion = xmlClass.head.values['version'];
    if (xmlClass.children[0].children === undefined) {
      return;
    }
    let xmlSupportConfig: XmlConfig = xmlClass.children[0].children[0];
    let xmlHeadsetListConfig: XmlConfig = xmlClass.children[0].children[1];
    xmlSupportConfig.children?.forEach((item: XmlConfig) => {
      if (item.values) {
        if (item.values['name'] === XmlConstants.SOUND_SUPPORT_LOGO) {
          this.logoSupport = item.values['key'] === XmlConstants.SOUND_SUPPORT_ENABLE;
        } else if (item.values['name'] === XmlConstants.SOUND_SUPPORT_VOCALCANCEL) {
          this.vocalCancelSupport = item.values['key'] === XmlConstants.SOUND_SUPPORT_ENABLE;
        } else if (item.values['name'] === XmlConstants.SOUND_SUPPORT_CALLNOISEREDUCT) {
          this.callNoiseReductforceSupport = item.values['key'] === XmlConstants.SOUND_SUPPORT_ENABLE;
        } else if (item.values['name'] === XmlConstants.SOUND_SUPPORT_CALLREINFORCE) {
          this.callReinforceSupport = item.values['key'] === XmlConstants.SOUND_SUPPORT_ENABLE;
        } else if (item.values['name'] === XmlConstants.SOUND_SUPPORT_RECORDNOISEREDUCT) {
          this.recordNoiseReductforceSupport = item.values['key'] === XmlConstants.SOUND_SUPPORT_ENABLE;
        } else if (item.values['name'] === XmlConstants.SOUND_SUPPORT_DEVICESELECT) {
          this.deviceselectSupport = item.values['key'] === XmlConstants.SOUND_SUPPORT_ENABLE;
        } else {
          log.error(`item fail`);
        }
      }
    })
    xmlHeadsetListConfig.children?.forEach((item: XmlConfig) => {
      if (item.values) {
        this.supportHeadsetList.push(item.values['name']);
      }
    })
  }
  /**
   * 获取配置文件版本
   */
  public getXmlVersion(): string {
    return this.xmlVersion;
  }

  /**
   * 是否支持SOUND品牌
   */
  public getLogSupport(): boolean {
    return this.logoSupport;
  }

  /**
   * 是否支持声音消除功能
   */
  public getVocalCancelSupport(): boolean {
    return this.vocalCancelSupport;
  }

  /**
   * 是否支持通话降噪功能
   */
  public getCallNoiseReductforceSupport(): boolean {
    return this.callNoiseReductforceSupport;
  }

  /**
   * 是否支持通话增强功能
   */
  public getCallReinforceSupport(): boolean {
    return this.callReinforceSupport;
  }

  /**
   * 是否支持录音降噪功能
   */
  public getRecordNoiseReductforceSupport(): boolean {
    return this.recordNoiseReductforceSupport;
  }

  /**
   * 是否支持分应用选择设置功能
   */
  public getDeviceselectSupport(): boolean {
    return this.deviceselectSupport;
  }

  /**
   * 单人静谧空间是否支持此蓝牙耳机
   */
  public getDeviceSupport(deviceName: string): boolean {
    if (!deviceName) {
      return false;
    }
    for (const str of this.supportHeadsetList) {
      if (deviceName.indexOf(str) !== -1) {
        return true;
      }
    }
    return false;
  }
}

let xmlParseUtil = new XmlParseUtil();

export default xmlParseUtil as XmlParseUtil;