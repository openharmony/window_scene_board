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

import { CheckEmptyUtils, FileUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ICallMethodTask } from '../../../backup/ICallMethodTask';
import { SceneInfo } from '../../../backup/SceneInfo';
import convertXml from '@ohos.convertxml';
import { AiBarSettingsDataMgr } from '../settings/preference/AiBarSettingsDataMgr';
import { SwitchType } from '../settings/preference/PreferenceType';

const TAG = 'AiBarSettingsMethodImpl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * 克隆系统导航Preference开关数据
 */
export class AiBarSettingsMethodImpl implements ICallMethodTask {
  async execute(extra?: object | undefined): Promise<void> {
    if (!extra) {
      log.showInfo('aiBar clone extra is null');
      return;
    }
    try {
      let sceneInfo = extra as SceneInfo;
      log.showInfo('aiBar clone start');
      let aiBarSettingsPath = sceneInfo?.getLauncherAiBarSettingsPath();
      let aiBarSettingsExit: boolean = FileUtils.isExist(aiBarSettingsPath);
      if (!aiBarSettingsPath || !aiBarSettingsExit) {
        log.warn('aiBar clone no file end');
        return;
      }
      let convertXmlObj = new convertXml.ConvertXML();
      let xmlStr = FileUtils.readTextSync(aiBarSettingsPath) as string;
      let resObj: CovertObject = convertXmlObj.convertToJSObject(xmlStr, convertOptions) as CovertObject;
      let preferencesArr = resObj?._elements?.filter((item) => item._name === 'preferences' && item._elements);
      if (CheckEmptyUtils.isEmptyArr(preferencesArr)) {
        log.showInfo(`aiBar clone no preferencesArr empty;`);
        return;
      }
      this.putToSettingData(preferencesArr);
    } catch (err) {
      log.showError(`aiBarCloneSync err : ${err.message}`);
    }
    log.showInfo('aiBar clone end');
  }

  /**
   * 把克隆过来的数据写到settingdata
   *
   * @param preferencesArr preferences数据
   */
  private putToSettingData(preferencesArr: CovertObject[]): void {
    log.showInfo('putToSettingData start');
    preferencesArr?.forEach((item) => {
      item._elements?.forEach((mapItem) => {
        switch (mapItem._attributes?.key) {
          case SwitchType.CLICK_BACK_STATUS:
            let clickBackText: string = mapItem._attributes?.value;
            log.showInfo(`aibarSettingsSync key = ${mapItem._attributes?.key}; value = ${clickBackText}`);
            this.putData(mapItem._attributes?.key, clickBackText);
            break;
          default:
            break;
        }
      });
    });
  }

  private putData(key: string, value: string): void {
    let settingValue = AiBarSettingsDataMgr.getInstance().getValueSync(key, '');
    if (!CheckEmptyUtils.isEmpty(settingValue)) {
      log.showInfo(`settingValue key  ${key} is not empty`);
      return;
    }
    AiBarSettingsDataMgr.getInstance().putValue(key, CheckEmptyUtils.isEmpty(value) ? '' : value);
  }
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

interface AttributesObject {
  key: string,
  value: string
}

interface CovertObject {
  _name: string,
  _text: string,
  _type: string,
  _attributes: AttributesObject,
  _declaration: Object,
  _elements: CovertObject[]
}