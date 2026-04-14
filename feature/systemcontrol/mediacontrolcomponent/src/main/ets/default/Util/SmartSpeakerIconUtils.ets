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

import { HashMap } from '@kit.ArkTS';
import connection from '@ohos.bluetooth.connection';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';

const TAG = 'SmartSpeakerIconUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

export default class SmartSpeakerIconUtils {
  public static iconMap: HashMap<string, string> = new HashMap();
  public static validModel = ['X', '0070', '000027'];

  static {
    SmartSpeakerIconUtils.iconMap.set('X0A5', 'sys.symbol.soundx_fill');
    SmartSpeakerIconUtils.iconMap.set('X0A4', 'sys.symbol.egretta_fill');
    SmartSpeakerIconUtils.iconMap.set('X0A3', 'sys.symbol.egretta_fill');
    SmartSpeakerIconUtils.iconMap.set('X0A2', 'sys.symbol.skylark_fill');
    SmartSpeakerIconUtils.iconMap.set('X0A0', 'sys.symbol.soundx_fill');
    SmartSpeakerIconUtils.iconMap.set('X007', 'sys.symbol.egretta_fill');
    SmartSpeakerIconUtils.iconMap.set('X006', 'sys.symbol.soundai_fill');
    SmartSpeakerIconUtils.iconMap.set('X005', 'sys.symbol.soundai_fill');
    SmartSpeakerIconUtils.iconMap.set('0070', 'sys.symbol.soundx_fill');
    SmartSpeakerIconUtils.iconMap.set('000027', 'sys.symbol.earphone_16646_fill');
  }

  /**
   * 校验modelId是否合法
   *
   * @param modelId 产品Id
   * @returns
   */
  public static isValidSmartSpeaker(modelId: string) {
    if (!modelId) {
      return false;
    }
    let idx = SmartSpeakerIconUtils.validModel.findIndex((validModelId) => modelId.startsWith(validModelId));
    return idx !== -1;
  }

  /**
   * 通过modelId获取图标名称
   *
   * @param modelId 产品Id
   * @returns 图标名称
   */
  public static getSpeakerIconByModelId(modelId: string) {
    if (!modelId || !SmartSpeakerIconUtils.isValidSmartSpeaker(modelId)) {
      return '';
    }
    let iconId = SmartSpeakerIconUtils.iconMap.get(modelId);
    if (iconId) {
      return iconId;
    }
    return 'sys.symbol.smart_speaker_fill';
  }

  /**
   * 通过mac地址获取modelId
   *
   * @param address mac地址
   * @returns modelId
   */
  public static getRemoteProductId(address: string) {
    let modelId = '';
    try {
      let productInfo = connection.getRemoteProductId(address);
      let infos: string[] = productInfo.split('_');
      if (infos.length > 0) {
        modelId = infos[0];
      }
      log.showInfo(`product info: ${productInfo}`);
    } catch (e) {
      log.showError('get remote product id error.');
    }
    return modelId;
  }
}