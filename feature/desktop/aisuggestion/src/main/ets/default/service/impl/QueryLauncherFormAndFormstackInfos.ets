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
import { CheckEmptyUtils } from '@ohos/basicutils/src/main/ets/utils/CheckEmptyUtils';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';

import {
  CardItemInfo,
  CommonConstants,
  FormLayoutCacheManager,
  GridLayoutItemInfo,
  IExecutor,
} from '@ohos/launchercommon';
import { LauncherFormAndFormStackInfo } from '../../bean/LauncherFormAndFormStackInfo';
import { LauncherScreenFaItem } from '../../bean/LauncherScreenFaItem';
import { LauncherStackInfo } from '../../bean/LauncherStackInfo';

const TAG: string = 'QueryLauncherFormAndFormstackInfos';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);
const SCREEN_TYPE_EXTERNAL: string = 'External';

interface InputParams {
  screenType?: string;
}

/**
 * 查询所在屏幕对应的展示信息
 *
 * @since 2025-01-08
 */
export class QueryLauncherFormAndFormstackInfos implements IExecutor {
  async execute(extra?: object): Promise<string> {
    const params = extra as InputParams;
    log.showInfo('execute');
    const isOuter: boolean = params?.screenType === SCREEN_TYPE_EXTERNAL;
    const itemInfos: GridLayoutItemInfo[] = FormLayoutCacheManager.getInstance().selectAllFormsAndFormStack(isOuter);
    const map: Map<number, LauncherFormAndFormStackInfo> = new Map();
    for (let itemInfo of itemInfos) {
      if (itemInfo.page === undefined) {
        log.showWarn('item page invalid');
        continue;
      }
      let formAndFormStackInfo = map.get(itemInfo.page);
      if (!formAndFormStackInfo) {
        formAndFormStackInfo = new LauncherFormAndFormStackInfo();
        formAndFormStackInfo.screenIndex = itemInfo.page;
        formAndFormStackInfo.forms = [];
        formAndFormStackInfo.stacks = [];
      }
      if (itemInfo.typeId === CommonConstants.TYPE_CARD) {
        const screenFaItem: LauncherScreenFaItem = this.createLauncherScreenFaItem(itemInfo);
        formAndFormStackInfo.forms?.push(screenFaItem);
      }
      if (itemInfo.typeId === CommonConstants.TYPE_FORM_STACK) {
        const stackInfo: LauncherStackInfo = this.createLauncherStackInfo(itemInfo);
        formAndFormStackInfo.stacks?.push(stackInfo);
      }
      map.set(itemInfo.page, formAndFormStackInfo);
    }
    return JSON.stringify(Array.from(map.values()));
  }

  private createLauncherScreenFaItem(itemInfo: GridLayoutItemInfo): LauncherScreenFaItem {
    const screenFaItem: LauncherScreenFaItem = new LauncherScreenFaItem();
    screenFaItem.bundleName = itemInfo.bundleName;
    screenFaItem.moduleName = itemInfo.moduleName ?? '';
    screenFaItem.abilityName = itemInfo.abilityName;
    screenFaItem.dimension = CardItemInfo.getCardDimension(itemInfo.area);
    screenFaItem.cardName = itemInfo.cardName ?? '';
    screenFaItem.cardId = itemInfo.cardId ?? '';
    return screenFaItem;
  }

  private createLauncherStackInfo(itemInfo: GridLayoutItemInfo): LauncherStackInfo {
    const stackInfo: LauncherStackInfo = new LauncherStackInfo();
    if (CheckEmptyUtils.isEmptyArr(itemInfo.layoutInfo?.[0])) {
      log.showWarn('createLauncherStackInfo invalid stackInfo');
      return stackInfo;
    }
    const forms: LauncherScreenFaItem[] = [];
    itemInfo.layoutInfo?.[0].forEach(item => {
      if (item.typeId === CommonConstants.TYPE_CARD) {
        const screenFaItem: LauncherScreenFaItem = this.createLauncherScreenFaItem(item);
        forms.push(screenFaItem);
      }
    });
    stackInfo.stackId = itemInfo.formStackId ?? '';
    stackInfo.faItems = forms;
    return stackInfo;
  }
}