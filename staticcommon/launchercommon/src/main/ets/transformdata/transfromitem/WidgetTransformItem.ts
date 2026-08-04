/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { LogDomain, Logger } from '@ohos/basicutils';
import { AppItemInfo } from '../../bean/AppItemInfo';
import { CardItemInfo } from '../../bean/CardItemInfo';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import { IntentParseUtil } from '../../utils/IntentParseUtil';
import DataConvert from '../DataConvert';
import { BaseTransformItem } from './BaseTransformItem';
import { CardTransformItem } from './CardTransformItem';

const INTENT_COMPONENT_KEY: string = 'component';
const TAG = 'WidgetTransformItem';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);

export class WidgetTransformItem extends CardTransformItem {
  public isSupportInohos(): boolean {
    if (this.backupInfo.container !== CommonConstants.CONTAINER_DESKTOP) {
      return false;
    }
    DataConvert.incWidgetCount();
    return true;
  }

  public async transformBackupInfoToGridInfo(backupTransformItemList: BaseTransformItem [], type: string):
    Promise<GridLayoutItemInfo[]> {
    log.showInfo(TAG, 'transform widget Item');
    this.backupInfo.appWidgetId = String(DataConvert.incCurrentTime());
    let formRelationParamStr: string = this.getFormRelationParamsFromIntent(this.backupInfo.intent);
    let widgetItem: CardItemInfo | null =
      await this.getCardByFormRelation(this.backupInfo, backupTransformItemList, type, formRelationParamStr);
    if (!widgetItem) {
      log.showInfo(TAG, `double widget not match, formRelationParamStr: ${formRelationParamStr}`);
      let map: Map<string, string> = IntentParseUtil.parseIntent(this.backupInfo.intent);
      if (map.has(INTENT_COMPONENT_KEY)) {
        DataConvert.saveMisAppNameArr(map.get(INTENT_COMPONENT_KEY) as string);
      }
      return [];
    }
    let widgetAppInfo: AppItemInfo | undefined =
      DataConvert.getAppItemInfoList().find(item => item.bundleName === widgetItem?.bundleName);
    let item: GridLayoutItemInfo = this.buildCardInfo(this.backupInfo, widgetAppInfo, widgetItem);
    log.showInfo(TAG, `double widget is ${item.cardName}, screen: ${item.page}, ` +
      `container: ${item.container}, point: [${item.row}, ${item.column}]`);
    return [this.setCardSourceType(item, type)];
  }
}