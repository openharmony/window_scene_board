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
import convertxml from '@ohos.convertxml';
import { DataConstants, SettingsKeyConstants } from './CommonUtils';

const TAG = 'TextHelpUtils';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const ELEMENT_KEY: string = '_elements';
const BODY_NODE_NAME: string = 'body';
const NAME_KEY: string = '_name';
const WHITELIST_NODE: string = 'span';
const TYPE_KEY: string = '_type';
const ATTRIBUTES_KEY: string = '_attributes';
const TEXT_KEY: string = '_text';
const STYLE_KEY: string = 'style';
const INDEX_NUMBER_1: number = 1;
const INDEX_NUMBER_2: number = 2;

export default class TextHelpUtils {
  async parseContent(index: number): Promise<Array<SpanInfo>> {
    let contentTag: string;
    try {
      switch (index) {
        case INDEX_NUMBER_1:
          contentTag = getContext().resourceManager.getStringByNameSync(SettingsKeyConstants.SOUND_PERMISSION);
          break;
        case INDEX_NUMBER_2:
          contentTag = getContext().resourceManager.getStringByNameSync(SettingsKeyConstants.SOUND_PERMISSION_DETAIL,
            DataConstants.ONE, DataConstants.TWO, DataConstants.THREE, DataConstants.FOUR, DataConstants.FIVE,
            DataConstants.ONE, DataConstants.TWO, DataConstants.THREE, DataConstants.FOUR);
          break;
        default:
          contentTag = '';
          break;
      }
    } catch (e) {
      log.error(`parseContent fail, error: ${e?.message} - ${e?.code}`);
      contentTag = '';
    }
    let conv: convertxml.ConvertXML = new convertxml.ConvertXML();
    let obj: object = conv.convertToJSObject(contentTag);
    return SpanHelper.parseXmlObject(obj);
  }
}

/**
 * 隐私同意短文本信息实体
 */
export class SpanHelper {
  /**
   * 解析文本
   *
   * @param obj 文本对象
   * @returns SpanInfo对象
   */
  static parseXmlObject(obj: object): Array<SpanInfo> {
    if (!obj) {
      log.warn('parseXmlObject is empty');
      return [];
    }
    let outer: object[] = obj[ELEMENT_KEY];
    if (!outer || outer.length <= 0) {
      log.warn('parseXmlObject outer is empty');
      return [];
    }
    let nodeName: string = outer[0][NAME_KEY];
    if (nodeName !== BODY_NODE_NAME) {
      log.warn('outer node is not body');
      return [];
    }
    let bodyArray: object[] = outer[0][ELEMENT_KEY];
    return SpanHelper.parseBodyArray(bodyArray);
  }

  private static parseBodyArray(bodyArray: object[]): Array<SpanInfo> {
    let result: SpanInfo[] = [];
    if (!bodyArray || bodyArray.length <= 0) {
      log.warn('bodyArray is empty');
      return result;
    }
    for (let item of bodyArray) {
      if (!item) {
        log.warn('item empty, skip parse');
        continue;
      }
      let itemName: string = item[NAME_KEY];
      let itemAttr: object = item[ATTRIBUTES_KEY];
      if (!itemName || !itemAttr) {
        log.warn('itemName or itemAttr empty, skip parse');
        continue;
      }
      if (itemName !== WHITELIST_NODE) {
        continue;
      }
      let elementArray: object[] = item[ELEMENT_KEY];
      if (!elementArray || elementArray.length <= 0) {
        log.warn('elementArray empty, skip parse');
        continue;
      }
      let type: string = elementArray[0][TYPE_KEY];
      let value: string = elementArray[0][TEXT_KEY];
      let style: string = itemAttr[STYLE_KEY];
      if (type === 'text' && value) {
        result.push(new SpanInfo(value, style));
      }
    }
    return result;
  }
}

/**
 * 隐私同意短文本信息实体
 */
export class SpanInfo {
  public text: string;
  public textStyle: string;

  constructor(content: string, style: string) {
    this.text = content;
    this.textStyle = style;
  }
}
