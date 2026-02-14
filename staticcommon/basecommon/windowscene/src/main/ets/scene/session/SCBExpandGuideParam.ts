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

import { FileUtils, LogDomain, Logger } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import convertXml from '@ohos.convertxml';
const RESOURCE_PATH: string = '/sys_prod/etc/multiwindow';
const FILE_SEPARATOR: string = '/';
const PC_IN_PHONE: string = 'pcInPhone_config.xml';

const TAG = 'SCBExpandGuideParam';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);

@Observed
export class SCBExpandGuideParam {
  @Track public state: AnimationStatus = AnimationStatus.Running;
  @Track public isShow: boolean = false;
  @Track public width: Length = '100%';
  @Track public padding: Length = 0;

  public static getPcInPhoneList(): string[] {
    log.showInfo(TAG,`initPcInPhoneList begin`);
    let pcInPhoneList: string[] = [];
    if (!DeviceHelper.isUltraScreenProduct()) {
      log.showError(TAG,`not getPcInPhoneList device not ultraScreenProduct`);
      return pcInPhoneList;
    }
    try {
      let convertXmlObj = new convertXml.ConvertXML();
      let xmlStr = FileUtils.readTextSync(RESOURCE_PATH + FILE_SEPARATOR + PC_IN_PHONE) as string;
      let resObj: CovertObject = convertXmlObj.fastConvertToJSObject(xmlStr, convertOptions) as CovertObject;
      pcInPhoneList = SCBExpandGuideParam.parseXml(resObj);
    } catch (e) {
      log.showError(TAG,`parse failed: ${e}`);
    }
    return pcInPhoneList;
  }

  /**
   * 解析pc应用运行在手机上的白名单xml
   */
  public static parseXml(resObj: CovertObject): string[] {
    let pcInPhoneList: string[] = [];
    if (resObj == null || resObj._elements == null || resObj._elements.length === 0) {
      log.showError(TAG,`parse error, resObj is null`);
      return pcInPhoneList;
    }
    let pcInPhoneElement = resObj._elements.find(item => item._name === 'pcInPhone-config');
    if (!pcInPhoneElement || pcInPhoneElement._elements == null) {
      log.showError(TAG,`parse error, pcInPhoneElement is null`);
      return pcInPhoneList;
    }
    let enableElement = pcInPhoneElement._elements.find(item => item._name === 'enable');
    if (!enableElement || enableElement._elements[0]?._text !== 'true') {
      log.showError(TAG,`parse error, enableElement is null or enable is false`);
      return pcInPhoneList;
    }
    let appList = pcInPhoneElement._elements.find(item => item._name === 'app-list');
    if (!appList || appList._elements == null) {
      log.showError(TAG,`parse error, appList is null`);
      return pcInPhoneList;
    }
    let pakElement = appList._elements.filter(item => item._name === 'pkg');
    for (let pak of pakElement) {
      if (pak._attributes?.name && pak._attributes.enable === '1') {
        pcInPhoneList.push(pak._attributes?.name);
      }
    }
    log.showInfo(TAG,`initPcInPhoneList end, pcInPhoneList length is ${pcInPhoneList.length}`);
    return pcInPhoneList;
  }
}

interface CovertObject {
  _name: string,
  _text: string,
  _type: string,
  _attributes: AttributesObject,
  _declaration: Object,
  _elements: CovertObject[]
}

interface AttributesObject {
  name: string,
  enable: string
}

const convertOptions: convertXml.ConvertOptions = {
  trim: false,
  declarationKey: '_declaration',
  instructionKey: '_instruction',
  attributesKey: '_attributes',
  textKey: '_text',
  cdataKey: '_cdata',
  doctypeKey: '_doctype',
  commentKey: '_comment',
  parentKey: '_parent',
  typeKey: '_type',
  nameKey: '_name',
  elementsKey: '_elements'
};